SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[RequestTransferView]

AS

SELECT        RequestTransfer.RequestTransferID, RequestTransfer.RequestNo, FStore.StoreName AS FromStore, ToStore.StoreName AS ToStore, 
                         (CASE WHEN RequestTransfer.requestStatus = 2 THEN 'CLOSE' WHEN RequestTransfer.requestStatus = 1 THEN 'PARTIAL' ELSE 'OPEN' END) AS RequestTransferStatusDec, RequestTransfer.Status, 
                         RequestTransfer.Note, Users.UserName, RequestTransfer.DateCreated, RequestTransfer.FromStoreID, RequestTransfer.ToStoreID, RequestTransfer.RequestDate, RequestTransfer.RequestStatus, 
                         CASE WHEN deficit.Requasted > deficit.Transfered THEN deficit.Requasted - deficit.Transfered ELSE 0 END AS openItems
FROM            RequestTransfer INNER JOIN
                         Store AS FStore ON RequestTransfer.FromStoreID = FStore.StoreID INNER JOIN
                         Store AS ToStore ON RequestTransfer.ToStoreID = ToStore.StoreID LEFT OUTER JOIN
                             (SELECT        RequestTransfer.RequestTransferID, SUM(ISNULL(RequestTransferEntry.Qty, 0)) AS Requasted, SUM(ISNULL(TransferEntry.Qty, 0)) AS Transfered
                               FROM            TransferItems INNER JOIN
                                                         TransferEntry ON TransferItems.TransferID = TransferEntry.TransferID AND TransferEntry.Status > 0 AND TransferItems.Status > 0 RIGHT OUTER JOIN
                                                         RequestTransferEntry INNER JOIN
                                                         RequestTransfer ON RequestTransferEntry.RequestTransferID = RequestTransfer.RequestTransferID ON 
                                                         TransferEntry.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID
                               GROUP BY RequestTransfer.RequestTransferID) AS deficit ON RequestTransfer.RequestTransferID = deficit.RequestTransferID LEFT OUTER JOIN
                         Users ON RequestTransfer.UserCreated = Users.UserId
GO