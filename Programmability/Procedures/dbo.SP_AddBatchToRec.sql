SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_AddBatchToRec]
(@BatchID uniqueidentifier
)
as


update RegShift set OpeningAmount = 0 where RegShiftID = @BatchID and OpeningAmount is null --make sure no null's:

select BatchID from batchrec where BatchID = @BatchID -- check if exists

if @@Rowcount = 0 

begin

Insert Into BatchRec (ExpectedAmount, BatchID ,TenderID , TenderName ,SortOrder, ExpectedCount , PickUpAmount , PickUpCount)

SELECT T.TotalExp  - ISNULL(PayOuts.Total,0), T.RegShiftID, T.TenderGroup, T.TenderName , T.SortOrder, T.Cont, 0 , 0 
FROM 
(SELECT SUM(TenderEntry.Amount) AS TotalExp, [Transaction].RegShiftID, Tender.TenderGroup, Tender.TenderName , TenderEntry.TenderID, Tender.SortOrder,  count(TenderEntry.Amount) AS Cont
FROM [Transaction] AS [Transaction]
INNER JOIN TenderEntry ON [Transaction].TransactionID = TenderEntry.TransactionID 
INNER JOIN Tender ON TenderEntry.TenderID = Tender.TenderID 
WHERE ([Transaction].Status > 0) AND (TenderEntry.Status > 0) AND (Tender.TenderGroup <> 6 AND
Tender.TenderGroup <> 7) and [Transaction].RegShiftID = @BatchID
GROUP BY [Transaction].RegShiftID, Tender.TenderName, Tender.TenderGroup, TenderEntry.TenderID, Tender.SortOrder) AS T LEFT OUTER JOIN
(SELECT        PayOut.RegShiftID, TenderEntry.TenderID, Tender.TenderName, SUM(ISNULL(PayOut.Amount, 0)) AS Total
                               FROM            PayOut INNER JOIN
                                                         TenderEntry ON PayOut.PayOutID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        (PayOut.Status > 0)
GROUP BY PayOut.RegShiftID, TenderEntry.TenderID, Tender.TenderName) AS PayOuts ON T.RegShiftID = PayOuts.RegShiftID AND T.TenderID = PayOuts.TenderID

--make sure there's a cash line.
IF (SELECT Count(*) From BatchRec Where TenderName = 'CASH'
AND BatchID = @BatchID) = 0 
BEGIN
Insert Into BatchRec (ExpectedAmount, BatchID ,TenderID , TenderName ,SortOrder, ExpectedCount , PickUpAmount , PickUpCount)
Values (0, @BatchID, 1, 'CASH', 1, 0, 0,0)
END --end adding cash

Update BatchRec Set ExpectedAmount = ExpectedAmount + ISNULL(S.OpeningAmount,0), PickUpAmount = PickUpAmount + ISNULL(S.ClosingAmount,0)
from BatchRec R INNER JOIN RegShift S ON R.BatchID = S.RegShiftID
Where R.BatchID = @BatchID and R.TenderName = 'CASH'

END
GO