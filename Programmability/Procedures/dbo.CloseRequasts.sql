SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[CloseRequasts]
AS
BEGIN
UPDATE       RequestTransfer
SET                RequestStatus = Stat.Status, DateModified = dbo.GetLocalDATE()
FROM            RequestTransfer INNER JOIN
                             (SELECT        CASE WHEN Transfered = 0 AND Requasted > 0 THEN 0 WHEN Transfered >= Requasted THEN 2 WHEN Transfered > 0 AND Transfered < Requasted THEN 1 ELSE 0 END AS Status, 
                                                         RequestTransferID
                               FROM            (SELECT        RequestTransfer.RequestTransferID, SUM(ISNULL(RequestTransferEntry.Qty, 0)) AS Requasted, SUM(ISNULL(TransferEntry.Qty, 0)) AS Transfered
                                                         FROM            TransferItems INNER JOIN
                                                                                   TransferEntry ON TransferItems.TransferID = TransferEntry.TransferID AND TransferEntry.Status > 0 AND TransferItems.Status > 0 RIGHT OUTER JOIN
                                                                                   RequestTransferEntry INNER JOIN
                                                                                   RequestTransfer ON RequestTransferEntry.RequestTransferID = RequestTransfer.RequestTransferID ON 
                                                                                   TransferEntry.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID
                                                         GROUP BY RequestTransfer.RequestTransferID) AS T) AS Stat ON RequestTransfer.RequestTransferID = Stat.RequestTransferID AND RequestTransfer.RequestStatus <> Stat.Status
WHERE        (RequestTransfer.RequestStatus <> 2)

END
GO