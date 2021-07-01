SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateOnOrderByOrder]
(@ItemStoreID uniqueidentifier,
@ModifierID uniqueidentifier)

as

IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreID)) NOT IN (3,5,7,9)
BEGIN
SELECT   ItemNo ,(CASE  when dbo.PurchaseOrders.POStatus =2 then 0 else (Case WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN 
QtyOrdered - isnull(ReceivedQty, 0) 
ELSE
 0 
END)end) AS OrderDeficit  into #MyTemp1
FROM       dbo.PurchaseOrderEntry LEFT OUTER JOIN
                            (SELECT     SUM(Qty) AS ReceivedQty, PurchaseOrderEntryNo
                            FROM          dbo.ReceiveEntry
			    where Status>0
                            GROUP BY PurchaseOrderEntryNo) Receives
           ON Receives.PurchaseOrderEntryNo = dbo.PurchaseOrderEntry.PurchaseOrderEntryId
LEFT OUTER JOIN 
dbo.PurchaseOrders On PurchaseOrders.PurchaseOrderId=PurchaseOrderEntry.PurchaseOrderNo
where PurchaseOrderEntry.Status>0 And PurchaseOrderEntry.ItemNo=@ItemStoreID

update itemstore
set 	onorder= (select sum(OrderDeficit) from #MyTemp1 where ItemNo=@ItemStoreID),
	    DateModified=dbo.GetLocalDATE(),
	    UserModified=@ModifierID
where itemstore.itemstoreid=@ItemStoreID

drop TABLE #MyTemp1

EXEC UpdateAPParent @ItemStoreID,@ModifierID,0,0,1,0
END
GO