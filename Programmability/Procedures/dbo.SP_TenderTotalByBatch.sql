SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderTotalByBatch]
(@BatchID uniqueidentifier)
As 
SELECT        SumTender.SortOrder, SumTender.BatchID, SumTender.Amount, SumTender.TenderName, Batch.BatchNumber, Batch.OpeningDateTime, Batch.ClosingDateTime, 
                         SumSale.SumTax, SumSale.SumSale, SumSale.SumPay, SumTender.TenderGroup, Users.UserName, SumPayOut.SumPayOut, ISNULL(SumTender.CountTender, 0) 
                         AS CountTender, SumSale.TransCount
FROM            Batch INNER JOIN
                             (SELECT        Tender.TenderName, SUM(TenderEntry.Amount) AS Amount, Tender.SortOrder, Tender.TenderGroup, COUNT(TenderEntry.TenderEntryID) 
                                                         AS CountTender, [Transaction].BatchID
                               FROM            [Transaction] INNER JOIN
                                                         TenderEntry ON [Transaction].TransactionID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        ([Transaction].Status > 0)
                               GROUP BY Tender.SortOrder, Tender.TenderName, Tender.TenderGroup, [Transaction].BatchID) AS SumTender ON 
                         Batch.BatchID = SumTender.BatchID INNER JOIN
                             (SELECT        BatchID, SUM(Tax) AS SumTax, SUM(Debit) AS SumSale, SUM(Credit) AS SumPay, COUNT(TransactionID) AS TransCount
                               FROM            [Transaction] AS Transaction_1
                               WHERE        (Status > 0)
                               GROUP BY BatchID) AS SumSale ON Batch.BatchID = SumSale.BatchID LEFT OUTER JOIN
                         Users ON Batch.CashierID = Users.UserId LEFT OUTER JOIN
                             (SELECT        SUM(Amount) AS SumPayOut, BatchID
                               FROM            PayOut
                               WHERE        (Status > 0)
                               GROUP BY BatchID) AS SumPayOut ON Batch.BatchID = SumPayOut.BatchID
WHERE     (SumTender.BatchID  = @BatchID )
GO