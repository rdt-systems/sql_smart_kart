SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveTransferEntryDelete]
	@ReceiveTranferEntryID uniqueidentifier,
	@ModifierID uniqueidentifier
AS

	update dbo.ReceiveTransferEntry
	set Status = -1, DateModified = dbo.GetLocalDATE(),
		UserModified = @ModifierID
	where [ReceiveTranferEntryID] = @ReceiveTranferEntryID


UPDATE       ItemStore
SET                OnTransferOrder = SumTransfer.Qty
FROM            ItemStore INNER JOIN
                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
                               FROM            TransferEntryView
                               GROUP BY ItemID, ToStoreID) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID AND ItemStore.ItemNo = SumTransfer.ItemID
GO