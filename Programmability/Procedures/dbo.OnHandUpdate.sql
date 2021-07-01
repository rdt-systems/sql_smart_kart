SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OnHandUpdate]
as

	
Update ItemStore
Set OnHand=
isnull(
(select sum(qty)
from dbo.ReceiveEntry  WITH (NOLOCK)
inner join dbo.ReceiveOrder WITH (NOLOCK) on ReceiveEntry.ReceiveNo=ReceiveOrder.ReceiveID
where ItemStoreNo=ItemStore.ItemStoreID and ReceiveEntry.Status>0 and ReceiveOrder.ReceiveOrderDate<=dbo.GetLocalDATE() and ReceiveOrder.Status>0) 
,0)
-
isnull(
(select sum(qty)
from dbo.TransactionEntry  WITH (NOLOCK)
inner join dbo.[Transaction] WITH (NOLOCK) on TransactionEntry.TransactionID=[Transaction].TransactionID
where ItemStoreID=ItemStore.ItemStoreID and TransactionEntry.Status>0 and [Transaction].StartSaleTime<=dbo.GetLocalDATE() and [Transaction].Status>0 and  TransactionEntryType<>2and  TransactionEntryType<>11) 
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
    dbo.ItemStore As Its WITH (NOLOCK) Inner Join
    dbo.RequestTransferEntry AS RTE WITH (NOLOCK)  On Its.ItemNo = RTE.ItemId Inner Join
    dbo.RequestTransfer WITH (NOLOCK) On RequestTransfer.RequestTransferID = RTE.RequestTransferID
            And Its.StoreNo = RequestTransfer.FromStoreID Left Join
    (Select
         TransferEntry.RequestTransferEntryID,
         TransferEntry.Qty
     From
         dbo.TransferItems WITH (NOLOCK) Inner Join
         dbo.TransferEntry WITH (NOLOCK) On TransferEntry.TransferID = TransferItems.TransferID
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
 from dbo.TransferEntry WITH (NOLOCK) inner join
      dbo.TransferItems WITH (NOLOCK) on TransferItems.TransferID=TransferEntry.TransferID
where ItemStoreNo = ItemStore.ItemStoreID and TransferEntry.Status>0 and TransferEntry.Status<25 and TransferItems.TransferDate <= (dbo.GetLocalDATE() +1 )
and TransferItems.Status>0) 
,0)

Where ItemNo IN (SELECT ItemID From ItemMain Where ItemType <> 3 AND ItemType <> 5 AND ItemType <> 7 AND ItemType <> 2 AND ItemType <> 9)

--Update ItemStore
--Set 
--OnHand= (select SUM(ISNULL(OnHand,0))
--		 from ItemMainAndStoreView
--		 Where LinkNo=ItemStore.ItemNo And Status>0)
--          ,DateModified=dbo.GetLocalDATE()

--Where (select ItemMain.ItemType from ItemMain where ItemStore.ItemNo=ItemMain.ItemID)=2 --Matrix
Update ItemStore Set OnTransferOrder = 0

UPDATE       ItemStore
SET                OnTransferOrder = SumTransfer.Qty
FROM            dbo.ItemStore WITH (NOLOCK) INNER JOIN
                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
                               FROM            dbo.TransferEntryView WITH (NOLOCK) Where Status >0 
							   AND Status <25
							   and   TransferStatus<3
                               GROUP BY ItemID, ToStoreID) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID 
							   AND ItemStore.ItemNo = SumTransfer.ItemID
							   Where ItemStore.ItemNo IN (SELECT ItemID From dbo.ItemMain WITH (NOLOCK) Where ItemType <> 3 AND ItemType <> 5 AND ItemType <> 7 AND ItemType <> 9)
Exec SP_ZeroParentItems

Exec SP_OnOrderUpdate

Exec SP_ZeroNonInventoryItems

EXEC ReservedUpdate

Exec OnRequestUpdate
GO