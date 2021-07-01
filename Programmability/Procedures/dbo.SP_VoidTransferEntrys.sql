SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <12/24/2014>
-- Description:	<Void TransferEntrys>
-- =============================================
CREATE PROCEDURE [dbo].[SP_VoidTransferEntrys] (
@ItemStoreNo Uniqueidentifier,
@TransferEntryID Uniqueidentifier,
@ModifierID Uniqueidentifier = NULL,
@BackToInventory bit)
AS
BEGIN


UPDATE       TransferEntry
SET                Qty = TransferEntry.Qty - (TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0)), DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
FROM            ReceiveTransferEntry RIGHT OUTER JOIN
                         TransferItemsView INNER JOIN
                         TransferEntry ON TransferItemsView.TransferID = TransferEntry.TransferID ON ReceiveTransferEntry.TransferEntryID = TransferEntry.TransferEntryID
WHERE        (TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0) > 0) AND (TransferItemsView.TransferStatusDec <> 'CLOSE') AND (TransferEntry.ItemStoreNo = @ItemStoreNo) AND 
                         (TransferEntry.TransferEntryID = @TransferEntryID)

Update TransferEntry Set UOMQty = Qty Where TransferEntryID = @TransferEntryID


IF @BackToInventory =0
Begin

INSERT INTO AdjustInventory
                         (AdjustInventoryId, ItemStoreNo, AdjustType, Qty, OldQty, AdjustReason, AccountNo, Cost, Status, DateCreated, UserCreated, DateModified, UserModified)
SELECT        NEWID() AS AdjustInventoryId, TransferEntry.ItemStoreNo, 0 AS AdjustType, TransferEntry.Qty - (TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0)) AS Expr1, ItemStore.OnHand, 
                         'Voided Transfer' AS AdjustReason, 0 AS AccountNo, ItemStore.Cost, 1 AS Status, dbo.GetLocalDATE() AS DateCreated, @ModifierID AS UserCreated, dbo.GetLocalDATE() AS DateModified, @ModifierID AS UserModified
FROM            ReceiveTransferEntry RIGHT OUTER JOIN
                         TransferItemsView INNER JOIN
                         TransferEntry ON TransferItemsView.TransferID = TransferEntry.TransferID ON ReceiveTransferEntry.TransferEntryID = TransferEntry.TransferEntryID LEFT OUTER JOIN
                         ItemStore ON ItemStore.ItemStoreID = TransferEntry.ItemStoreNo
WHERE        (TransferEntry.Qty - ISNULL(ReceiveTransferEntry.Qty, 0) > 0) AND (TransferItemsView.TransferStatusDec <> 'CLOSE') AND (TransferEntry.ItemStoreNo = @ItemStoreNo) AND 
                         (TransferEntry.TransferEntryID = @TransferEntryID)

End

UPDATE       TransferItems
SET                TransferStatus = 3, DateModified = dbo.GetLocalDATE()
FROM            TransferItems INNER JOIN
                         TransferEntryView ON TransferItems.TransferID = TransferEntryView.TransferID
WHERE        (TransferEntryView.Qty = TransferEntryView.ReceiveQty) AND (ISNULL(TransferItems.TransferStatus, 1) <> 3) AND (TransferEntryView.TransferEntryID = @TransferEntryID)


Exec [SP_UpdateOnHandOneItem] @ItemStoreID = @ItemStoreNo

END

UPDATE       ItemStore
SET                OnTransferOrder = SumTransfer.Qty
FROM            ItemStore INNER JOIN
                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
                               FROM            TransferEntryView
                               GROUP BY ItemID, ToStoreID) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID AND ItemStore.ItemNo = SumTransfer.ItemID
GO