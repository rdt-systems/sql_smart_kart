SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MergeItems]
       (@FromItemID uniqueidentifier
	    ,@ToItemID uniqueidentifier
	    ,@ModifierID uniqueidentifier
		,@FItemMainID uniqueidentifier= null
		,@ToItemMainID uniqueidentifier= null
		,@AddAlias bit = 1
		)
As 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
declare @vFItemMainID uniqueidentifier
declare @vToItemMainID uniqueidentifier



 declare @oldItemName nvarchar(500)
 select  @oldItemName =isnull(ItemMain.BarcodeNumber,'')+' '+isnull(Name,'')
 from ItemMain 
 where ItemMain.ItemId=@FromItemID


exec SP_SaveRecentActivity 4,'ItemMain',1,@ToItemID,1,'ItemID',@ModifierID,@oldItemName



if @FItemMainID is null
  set @vFItemMainID =(select top(1)ItemNo from Itemstore where ItemstoreID = @FromItemID)
ELSE
  set @vFItemMainID =@FItemMainID

if @ToItemMainID is null 
  set @vToItemMainID  =(select top(1)ItemNo from Itemstore where ItemstoreID = @ToItemID)
else
  set @vToItemMainID  = @ToItemMainID


IF NOT @vFItemMainID = @vToItemMainID 
BEGIN


--*****************************************************************
-- Added Code to Add original Upc to Alias
-- Added by Moshe freund
--*****************************************************************
If @AddAlias =1 Begin
declare @UPC nvarchar(50)
SELECT @UPC = BarcodeNumber from ItemMain Where ItemID = @vFItemMainID

IF (SELECT        COUNT(1) AS Expr1
FROM            ItemMain LEFT OUTER JOIN
                         ItemAlias ON ItemMain.ItemID = ItemAlias.ItemNo
WHERE        (ItemMain.ItemID <> @vFItemMainID) AND (ISNULL(ItemMain.Status, - 1) > - 1) AND (ISNULL(ItemAlias.Status, 0) > 0) AND (ItemMain.BarcodeNumber = @UPC) OR
                         (ItemMain.ItemID <> @vFItemMainID) AND (ISNULL(ItemMain.Status, - 1) > - 1) AND (ISNULL(ItemAlias.Status, 0) > 0) AND (ItemAlias.BarcodeNumber = @UPC)) <1

Begin
Insert Into ItemAlias (AliasId,ItemNo,BarcodeNumber,Status,DateCreated,UserCreated,DateModified,UserModified)
VALUES (NEWID(), @vToItemMainID, @UPC, 1 , dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
End

End
--*******************************************************************

SELECT        ToStore.ItemStoreID AS ToStore, FromStore.ItemStoreID AS FromStore, FromStore.OnHand, FromStore.OnOrder
INTO              [#TempItemStore]
FROM            (SELECT        ItemStoreID, StoreNo
                          FROM            ItemStore AS ItemStore_1
                          WHERE        (ItemNo = @vToItemMainID)) AS ToStore INNER JOIN
                         Store ON ToStore.StoreNo = Store.StoreID INNER JOIN
                             (SELECT        ItemStoreID, StoreNo, OnHand, OnOrder
                               FROM            ItemStore AS ItemStore_2
                               WHERE        (ItemNo = @vFItemMainID)) AS FromStore ON Store.StoreID = FromStore.StoreNo

--Alex Abreu
--Changed this line to keep the both alias from and To Item
Update ItemAlias Set ItemNo = @vToItemMainID, DateModified = dbo.GetLocalDATE() Where ItemNo = @vFItemMainID


UPDATE  PurchaseOrderEntry
SET ItemNo = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  PurchaseOrderEntry ON #TempItemStore.FromStore = PurchaseOrderEntry.ItemNo

UPDATE  ReceiveEntry
SET ItemStoreNo = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  ReceiveEntry ON #TempItemStore.FromStore = ReceiveEntry.ItemStoreNo


UPDATE  ReturnToVenderEntry
SET ItemStoreNo = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  ReturnToVenderEntry ON #TempItemStore.FromStore = ReturnToVenderEntry.ItemStoreNo

UPDATE  TransactionEntry
SET ItemStoreID = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  TransactionEntry ON #TempItemStore.FromStore = TransactionEntry.ItemStoreID

UPDATE  WorkOrderEntry
SET ItemStoreID = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  WorkOrderEntry ON #TempItemStore.FromStore = WorkOrderEntry.ItemStoreID

UPDATE  TransferEntry 
SET ItemStoreNo = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  TransferEntry ON #TempItemStore.FromStore = TransferEntry.ItemStoreNo

UPDATE  ReceiveTransferEntry 
SET ItemStoreID = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  ReceiveTransferEntry ON #TempItemStore.FromStore = ReceiveTransferEntry.ItemStoreID



UPDATE  AdjustInventory
SET ItemStoreNo = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID 
FROM  #TempItemStore INNER JOIN  AdjustInventory ON #TempItemStore.FromStore = AdjustInventory.ItemStoreNo

UPDATE  ItemSupply
SET ItemStoreNo = #TempItemStore.ToStore,    DateModified = @UpdateTime,UserModified=@ModifierID ,
IsMainSupplier =  case when (select count(* ) from ItemSupply ip where ip.ItemStoreNo=#TempItemStore.ToStore  and ip.IsMainSupplier=1 
and ip.Status>-1 )>0 then 0 else ItemSupply.IsMainSupplier end 
FROM  #TempItemStore INNER JOIN  ItemSupply ON #TempItemStore.FromStore = ItemSupply.ItemStoreNo
Where  not exists(select 1  from dbo.ItemSupply as ItS  where ItS.ItemStoreNo=#TempItemStore.ToStore and ItS.SupplierNo=ItemSupply.SupplierNo )



UPDATE  ItemStore
SET   DateModified = @UpdateTime,UserModified=@ModifierID,OnHand= ItemStore.OnHand+ #TempItemStore.OnHand,OnOrder=ItemStore.OnOrder+ #TempItemStore.OnOrder 
FROM  #TempItemStore INNER JOIN  ItemStore ON #TempItemStore.ToStore   = ItemStore.ItemStoreID

update Itemmain set status=-2,DateModified = @UpdateTime,UserModified=@ModifierID where ItemID = @vFItemMainID
update ItemStore set status=-2,DateModified = @UpdateTime,UserModified=@ModifierID where ItemNo= @vFItemMainID

drop table #TempItemStore

END
GO