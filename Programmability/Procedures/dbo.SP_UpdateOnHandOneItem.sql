SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_UpdateOnHandOneItem](@ItemStoreID uniqueidentifier)
as

declare @string varchar(max)
set @string ='updateOnhand '  + convert(varchar(500),@ItemStoreID)
exec toLog  @string = @string

IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            dbo.ItemStore WITH (NOLOCK) INNER JOIN
                         dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreID)) IN (3,5,7,9,2)
Begin
Update ItemStore Set OnHand = 0, DateModified = dbo.GetLocalDATE() where ItemStoreID = @ItemStoreID
End
Else Begin	
Update ItemStore Set OnHand =
isnull(
(select sum(qty)
from dbo.ReceiveEntry WITH (NOLOCK) 
inner join dbo.ReceiveOrder WITH (NOLOCK) on ReceiveEntry.ReceiveNo=ReceiveOrder.ReceiveID
where ItemStoreNo=ItemStore.ItemStoreID and ReceiveEntry.Status>0 and ReceiveOrder.ReceiveOrderDate<=dbo.GetLocalDATE() and ReceiveOrder.Status>0) 
,0)
-
isnull(
(select sum(qty)
from dbo.TransactionEntry WITH (NOLOCK) 
inner join dbo.[Transaction] WITH (NOLOCK) on TransactionEntry.TransactionID=[Transaction].TransactionID
where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and [Transaction].StartSaleTime<=dbo.GetLocalDATE() and [Transaction].Status>0 and TransactionEntryType<>2 AND TransactionEntryType<>11 ) 
,0)

+
isnull(
(select sum(qty)
from dbo.DamageItem WITH (NOLOCK) 
where ItemStoreID=ItemStore.ItemStoreID and 
DamageItem.Status>0 and [DamageItem].[Date]<=dbo.GetLocalDATE() and DamageStatus=1 ) 
,0)

+
isnull(
(select sum(Qty)
from dbo.AdjustInventory WITH (NOLOCK)
where ItemStoreNo=ItemStore.ItemStoreID AND DateCreated<=dbo.GetLocalDATE() AND Status >0)
,0)
-
isnull(
(select sum(isnull(Qty,0))
from dbo.ReturntovenderEntry WITH (NOLOCK)
inner join dbo.ReturnToVender WITH (NOLOCK) on ReturntovenderEntry.ReturnToVenderID=ReturnToVender.ReturnToVenderID
where ItemStoreNo=ItemStore.ItemStoreID and ReturntovenderEntry.Status>0 and ReturnToVender.ReturnToVenderDate<=dbo.GetLocalDATE() and ReturnToVender.Status>0) 
,0)

-
isnull(
(Select
    SUM(CASE WHEN IsNull(Transfer.Qty,0) > RTE.Qty THEN 0 ELSE RTE.Qty-IsNull(Transfer.Qty,0) END) As TransferQty
From
    ItemStore As Its Inner Join
    RequestTransferEntry AS RTE  On Its.ItemNo = RTE.ItemId Inner Join
    RequestTransfer On RequestTransfer.RequestTransferID = RTE.RequestTransferID
            And Its.StoreNo = RequestTransfer.FromStoreID Left Join
    (Select
         TransferEntry.RequestTransferEntryID,
         TransferEntry.Qty
     From
         TransferItems Inner Join
         TransferEntry On TransferEntry.TransferID = TransferItems.TransferID
     Where
         TransferEntry.RequestTransferEntryID Is Not Null And
         TransferItems.Status > 0 And
         TransferEntry.Status > 0) Transfer On Transfer.RequestTransferEntryID = RTE.RequestTransferEntryID
Where
    RTE.Status > 0 And
    RequestTransfer.Status > 0 AND
    Its.ItemStoreID=ItemStore.ItemStoreID)
,0)

-
isnull(
(select sum(isnull(Qty,0))
from dbo.Layaway WITH (NOLOCK) join dbo.[Transaction] T WITH (NOLOCK) on Layaway.TransactionID = T.TransactionID
where ItemStoreID = ItemStore.ItemStoreID and Layaway.Status>0 and Layaway.LayawayStatus =1 AND T.Status >0) 
,0)
+
IsNull((SELECT SUM(Qty)FROM  dbo.ReceiveTransferEntry WITH (NOLOCK) where 
ItemStoreID=ItemStore.ItemStoreID AND 
DateCreate<=dbo.GetLocalDATE() AND Status >0),0)
--isnull(
--(select sum(isnull(Qty,0))
-- from TransferEntry inner join
--      TransferItems on TransferItems.TransferID=TransferEntry.TransferID
--where (SELECT ItemStoreID
--	   FROM ItemMainAndStoreView
--	   WHERE  ItemID = TransferEntry.ItemStoreNo And StoreNo= (SELECT ToStoreID 
--															  FROM   TransferItems
--															  WHERE  TransferID=TransferEntry.TransferID)) = ItemStore.ItemStoreID and TransferEntry.Status>0 and TransferItems.TransferDate <= dbo.GetLocalDATE() and TransferItems.Status>0) 
--,0)

-
--isnull(
--(select sum(isnull(Qty,0))
-- from TransferEntry inner join
--      TransferItems on TransferItems.TransferID=TransferEntry.TransferID
-- where (SELECT ItemStoreID
--	    FROM ItemMainAndStoreView
--	    WHERE TransferEntry.ItemStoreNo = ItemID And StoreNo= (SELECT FromStoreID 
--														   FROM   TransferItems
--															   WHERE  TransferID=TransferEntry.TransferID)) = ItemStore.ItemStoreID and TransferEntry.Status>0 and TransferItems.TransferDate <= dbo.GetLocalDATE() and TransferItems.Status>0) 
--,0)
isnull(
(select sum(isnull(Qty,0))
 from dbo.TransferEntry WITH (NOLOCK) inner join
      dbo.TransferItems WITH (NOLOCK) on TransferItems.TransferID=TransferEntry.TransferID
where ItemStoreNo = ItemStore.ItemStoreID and TransferEntry.Status>0 And TransferEntry.Status <25 and TransferItems.TransferDate <= dbo.GetLocalDATE() and TransferItems.Status>0) 
,0),datemodified=dbo.GetLocalDATE() 
Where ItemStoreID = @ItemStoreID

End
Update ItemMain Set DateModified = dbo.GetLocalDATE() Where ItemID in (Select ItemNo from ItemStore Where ItemStoreID = @ItemStoreID)

 select Top(1)IsNull(OnHand,0) from dbo.ItemStore WITH (NOLOCK) Where  ItemStoreID = @ItemStoreID
GO