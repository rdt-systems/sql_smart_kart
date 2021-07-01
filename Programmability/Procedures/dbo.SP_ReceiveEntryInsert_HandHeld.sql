SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveEntryInsert_HandHeld]

(@ReceiveEntryID uniqueidentifier,
@ReceiveNo uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@Cost Money, 
@Qty decimal,
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.ReceiveEntry
       (ReceiveEntryID, ReceiveNo, ItemStoreNo, Cost,Qty,UserModified)
VALUES     (@ReceiveEntryID, @ReceiveNo, @ItemStoreNo, @Cost, @Qty, @ModifierID)


-- Update LastReceivedDate
UPDATE       ItemStore
SET                LastReceivedDate =
                             (SELECT        TOP (1) ReceiveOrder.ReceiveOrderDate
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC)

-- Update LastReceivedQty
UPDATE       ItemStore
SET                LastReceivedQty = ISNULL(
                             (SELECT        TOP (1) ReceiveEntry.UOMQty
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC),0)
GO