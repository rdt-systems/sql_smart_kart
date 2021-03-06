SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateOnlyOnhand]
as

Update ItemStore
Set OnHand=
isnull(
(select sum(qty)
from ReceiveEntry 
inner join ReceiveOrderView on ReceiveEntry.ReceiveNo=ReceiveOrderView.ReceiveID
where ItemStoreNo=ItemStore.ItemStoreID and ReceiveEntry.Status>0 and ReceiveOrderView.ReceiveOrderDate<=dbo.GetLocalDATE() and ReceiveOrderView.Status>0) 
,0)
-
isnull(
(select sum(qty)
from TransactionEntry 
inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and [Transaction].StartSaleTime<=dbo.GetLocalDATE() and [Transaction].Status>0 and  TransactionEntryType<>2and  TransactionEntryType<>11) 
,0)
+
isnull(
(select sum(qty)
from DamageItem 
where ItemStoreID=ItemStore.ItemStoreID and 
DamageItem.Status>0 and [DamageItem].[Date]<=dbo.GetLocalDATE() and DamageStatus=1 ) 
,0)

+
isnull(
(select sum(Qty)
from AdjustInventory
where ItemStoreNo=ItemStore.ItemStoreID AND DateCreated<=dbo.GetLocalDATE() AND Status >0)
,0)
-
isnull(
(select sum(isnull(Qty,0))
from ReturntovenderEntry
inner join ReturnToVender on ReturntovenderEntry.ReturnToVenderID=ReturnToVender.ReturnToVenderID
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
from Layaway join [Transaction] T on Layaway.TransactionID = T.TransactionID
where ItemStoreID = ItemStore.ItemStoreID and Layaway.Status>0 and Layaway.LayawayStatus =1 AND T.Status >0) 
,0)
+
IsNull((SELECT SUM(Qty)FROM  ReceiveTransferEntry where 
ItemStoreID=ItemStore.ItemStoreID AND 
DateCreate<=dbo.GetLocalDATE() AND Status >0),0)

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
isnull(
(select sum(isnull(Qty,0))
 from TransferEntry inner join
      TransferItems on TransferItems.TransferID=TransferEntry.TransferID
where ItemStoreNo = ItemStore.ItemStoreID and TransferEntry.Status>0 and TransferEntry.Status<25 and TransferItems.TransferDate <= (dbo.GetLocalDATE() +1 )
and TransferItems.Status>0) 
,0)

Where ItemNo IN (SELECT ItemID From ItemMain Where ItemType <> 3 AND ItemType <> 5 AND ItemType <> 7 AND ItemType <> 2 AND ItemType <> 9)
GO