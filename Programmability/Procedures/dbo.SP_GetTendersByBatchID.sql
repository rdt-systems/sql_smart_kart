SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTendersByBatchID] @BatchID uniqueidentifier
AS
SELECT tendertotals.*,tender.* FROM tender
INNER JOIN
(
SELECT        TenderEntry.TenderID AS Tender, SUM(TenderEntry.Amount) AS Amount, [Transaction].BatchID
FROM            TenderEntry INNER JOIN
                         Tender ON TenderEntry.TenderID = Tender.TenderID INNER JOIN
                         [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID
WHERE        ([Transaction].BatchID = @BatchID) AND ([Transaction].Status > 0)
GROUP BY [Transaction].BatchID, TenderEntry.TenderID
) AS tendertotals
ON tendertotals.Tender = tender.TenderID
GO