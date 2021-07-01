SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CloseTransfers]
AS

BEGIN

UPDATE       TransferItems
SET                TransferStatus = 3, DateModified = dbo.GetLocalDATE()
FROM            TransferItems INNER JOIN
                             (SELECT        TransferID, SUM(ISNULL(Qty, 0)) - SUM(ISNULL(ReceiveQty, 0)) AS Def
                               FROM            TransferEntryView
                               GROUP BY TransferID) AS Detail ON TransferItems.TransferID = Detail.TransferID
WHERE        (ISNULL(Detail.Def, 0) = 0) AND TransferStatus <> 3

END
GO