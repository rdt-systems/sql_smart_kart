SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TransferStatusUpdate]
AS

Update TransferItems Set TransferStatus = Case WHEN Received = 0 and Transfered > 0 Then 1 WHEN Received > 0 and Received < Transfered THEN 2 WHEN Received >=Transfered Then 3 END
, DateModified = dbo.GetLocalDate()
from TransferItems T INNER JOIN (
Select E.TransferID, SUM(E.Qty) AS Transfered, SUM(ISNULL(R.Qty,0)) AS Received from TransferEntry E LEFT OUTER JOIN ReceiveTransferEntry R ON E.TransferEntryID = R.TransferEntryID and R.Status >0
Where E.Status > 0
GROUP BY E.TransferID) AS Res ON T.TransferID = Res.TransferID
Where T.TransferStatus <> Case WHEN Received = 0 and Transfered > 0 Then 1 WHEN Received > 0 and Received < Transfered THEN 2 WHEN Received >=Transfered Then 3 END
GO