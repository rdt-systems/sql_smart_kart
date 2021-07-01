SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[RequestStatusPointView]
WITH SCHEMABINDING
AS


SELECT        RequestTransfer.RequestTransferID, SUM(ISNULL(RequestTransferEntry.Qty, 0)) AS Requasted, SUM(ISNULL(TransferEntry.Qty, 0)) AS Transfered
                               FROM            dbo.TransferItems WITH (NOLOCK) INNER JOIN
                                                         dbo.TransferEntry WITH (NOLOCK)  ON TransferItems.TransferID = TransferEntry.TransferID AND TransferEntry.Status > 0 AND TransferItems.Status > 0 RIGHT OUTER JOIN
                                                         dbo.RequestTransferEntry WITH (NOLOCK)  INNER JOIN
                                                         dbo.RequestTransfer WITH (NOLOCK)  ON RequestTransferEntry.RequestTransferID = RequestTransfer.RequestTransferID ON 
                                                         TransferEntry.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID
                               GROUP BY RequestTransfer.RequestTransferID

GO