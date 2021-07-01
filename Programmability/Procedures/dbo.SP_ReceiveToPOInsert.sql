SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveToPOInsert]
(@ReceiveToPOID uniqueidentifier,
@ReceiveID uniqueidentifier,
@POID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)


AS 
INSERT INTO dbo.ReceiveToPO
                      (ReceiveToPOID, ReceiveID, POID, Status, DateCreated, UserCreated, DateModified, UserModified)

VALUES     (@ReceiveToPOID, @ReceiveID, @POID, 1, dbo.GetLocalDATE(), @ModifierID,dbo.GetLocalDATE(), @ModifierID)



---- Update LastReceivedDate
--UPDATE       ItemStore
--SET                LastReceivedDate =
--                             (SELECT        TOP (1) ReceiveOrder.ReceiveOrderDate
--                               FROM            ReceiveEntry INNER JOIN
--                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
--                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
--                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC)

---- Update LastReceivedQty
--UPDATE       ItemStore
--SET                LastReceivedQty = ISNULL(
--                             (SELECT        TOP (1) ReceiveEntry.UOMQty
--                               FROM            ReceiveEntry INNER JOIN
--                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
--                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
--                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC),0)
GO