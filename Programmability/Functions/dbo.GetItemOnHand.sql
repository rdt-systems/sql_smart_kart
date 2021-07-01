SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE function [dbo].[GetItemOnHand](@ItemStoreID uniqueidentifier,@Date datetime)
returns decimal
begin


Declare @TotalQty decimal

set       @TotalQty =
isnull(
(select sum(qty)
from ReceiveEntry 
inner join ReceiveOrder on ReceiveEntry.ReceiveNo=ReceiveOrder.ReceiveID
where ItemStoreNo=@ItemStoreID and ReceiveEntry.Status>0 and ReceiveOrder.ReceiveOrderDate<@Date and ReceiveOrder.Status>0) 
,0)
-
isnull(
(select sum(qty)
from TransactionEntry 
inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
where ItemStoreID=@ItemStoreID and TransactionEntry.Status>0 and [Transaction].StartSaleTime<@Date and [Transaction].Status>0) 
,0)
+
isnull(
(select sum(qty)
from DamageItem 
where ItemStoreID=@ItemStoreID and 
DamageItem.Status>0 and [DamageItem].[Date]<=@Date and DamageStatus=1 ) 
,0)
+
isnull(
(select sum(Qty)
from AdjustInventory
where ItemStoreNo=@ItemStoreID AND DateCreated<@Date)
,0)
-
isnull(
(select sum(isnull(Qty,0))
from ReturntovenderEntry
inner join ReturnToVender on ReturntovenderEntry.ReturnToVenderID=ReturnToVender.ReturnToVenderID
where ItemStoreNo=@ItemStoreID and ReturntovenderEntry.Status>0 and ReturnToVender.ReturnToVenderDate<@Date and ReturnToVender.Status>0) 
,0)

-
isnull(
(select sum(isnull(Qty,0))
from Layaway join [Transaction] T on Layaway.TransactionID = T.TransactionID
where ItemStoreID = @ItemStoreID and Layaway.Status>0 and Layaway.LayawayStatus =1 AND T.Status >0) 
,0)
+
IsNull((SELECT SUM(Qty)FROM  ReceiveTransferEntry where 
ItemStoreID=@ItemStoreID AND 
DateCreate<=@Date AND Status >0),0)
-
isnull(
(select sum(isnull(Qty,0))
 from TransferEntry inner join
      TransferItems on TransferItems.TransferID=TransferEntry.TransferID
where ItemStoreNo = @ItemStoreID and TransferEntry.Status>0 and TransferEntry.Status<25 and TransferItems.TransferDate <= @Date
and TransferItems.Status>0) 
,0)

return  @TotalQty

end
GO