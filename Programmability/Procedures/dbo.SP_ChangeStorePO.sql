SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ChangeStorePO](@ID Uniqueidentifier,@NewStore Uniqueidentifier,@ModifierID Uniqueidentifier)

AS

BEGIN

update PurchaseOrders 
set StoreNo =@NewStore
where PurchaseOrderId=@ID


DECLARE @ItemNo uniqueidentifier
DECLARE @ItemStoreID uniqueidentifier

DECLARE c10 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
select PurchaseOrderEntry.ItemNo , newItemStore.ItemStoreID 
from PurchaseOrderEntry  
inner join  ItemStore on PurchaseOrderEntry.ItemNo =ItemStore.ItemStoreID 
inner join  ItemMain on ItemStore.ItemNo = ItemMain.ItemID
inner join  ItemStore as newItemStore on newItemStore.ItemNo =ItemMain.ItemID
where PurchaseOrderNo =@ID 
and newItemStore.StoreNo=@NewStore

OPEN c10

FETCH NEXT FROM c10
INTO @ItemNo,@ItemStoreID

WHILE @@FETCH_STATUS = 0

		Begin

		update PurchaseOrderEntry 
		set  PurchaseOrderEntry.ItemNo = @ItemStoreID,
		PurchaseOrderEntry.UserModified=@ModifierID ,PurchaseOrderEntry.DateModified=dbo.GetLocalDATE()
        where PurchaseOrderNo =@ID 
		and ItemNo=@ItemNo

        EXEC  SP_OnOrderUpdateOneItem @ItemNo
		EXEC  SP_OnOrderUpdateOneItem @ItemStoreID

				FETCH NEXT FROM c10
				INTO @ItemNo,@ItemStoreID
		END

CLOSE c10
DEALLOCATE c10



END
GO