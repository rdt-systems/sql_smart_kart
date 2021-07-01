SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_ReOpenTransfer](@ID Uniqueidentifier)

AS
Declare @Status Int
BEGIN

SELECT @Status = CASE WHEN SUM(ISNULL(ReceiveQty,0)) <> 0 AND SUM(ISNULL(ReceiveQty,0)) < SUM(ISNULL(Qty,0)) THEN 2 ELSE  1 END 
FROM            TransferEntryView
WHERE        (TransferID = @ID)

UPDATE  TransferItems set TransferStatus = @Status, DateModified = dbo.GetLocalDATE() Where TransferID = @ID

UPDATE       ItemStore
SET                OnTransferOrder = SumTransfer.Qty
FROM            ItemStore INNER JOIN
                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
                               FROM            TransferEntryView Where Status >0 
							   AND Status <25
							   and   TransferStatus<3
                               GROUP BY ItemID, ToStoreID) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID 
							   AND ItemStore.ItemNo = SumTransfer.ItemID
							   Where ItemStore.ItemNo IN (SELECT ItemID From ItemMain Where ItemType <> 3 AND ItemType <> 5 AND ItemType <> 7 AND ItemType <> 9)

END
GO