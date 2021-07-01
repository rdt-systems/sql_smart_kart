SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TenderTotalRec]
AS
SELECT     SumTender.SortOrder, SumTender.RegShiftID, SumTender.Amount, SumTender.TenderName, dbo.RegShift.ShiftNO, dbo.RegShift.ShiftOpenDate, 
                      dbo.RegShift.ShiftCloseDate, SumSale.SumTax, SumSale.SumSale, SumSale.SumPay, SumTender.TenderGroup, dbo.Users.UserName, SumPayOut.SumPayOut, 
                      ISNULL(SumTender.CountTender, 0) AS CountTender, SumSale.TransCount
FROM         dbo.RegShift INNER JOIN
                          (SELECT     dbo.Tender.TenderName, SUM(dbo.TenderEntry.Amount) AS Amount, dbo.[Transaction].RegShiftID, dbo.Tender.SortOrder, dbo.Tender.TenderGroup, 
                                                   COUNT(dbo.TenderEntry.TenderEntryID) AS CountTender
                            FROM          dbo.[Transaction] INNER JOIN
                                                   dbo.TenderEntry ON dbo.[Transaction].TransactionID = dbo.TenderEntry.TransactionID INNER JOIN
                                                   dbo.Tender ON dbo.TenderEntry.TenderID = dbo.Tender.TenderID
                            WHERE      (dbo.[Transaction].Status > 0)
                            GROUP BY dbo.Tender.SortOrder, dbo.Tender.TenderName, dbo.[Transaction].RegShiftID, dbo.Tender.TenderGroup) AS SumTender ON 
                      dbo.RegShift.RegShiftID = SumTender.RegShiftID INNER JOIN
                          (SELECT     RegShiftID, SUM(Tax) AS SumTax, SUM(Debit) AS SumSale, SUM(Credit) AS SumPay, COUNT(TransactionID) AS TransCount
                            FROM          dbo.[Transaction] AS Transaction_1
                            WHERE      (Status > 0)
                            GROUP BY RegShiftID) AS SumSale ON dbo.RegShift.RegShiftID = SumSale.RegShiftID LEFT OUTER JOIN
                          (SELECT     SUM(Amount) AS SumPayOut, RegShiftID
                            FROM          dbo.PayOut
                            WHERE      (Status > 0)
                            GROUP BY RegShiftID) AS SumPayOut ON dbo.RegShift.RegShiftID = SumPayOut.RegShiftID LEFT OUTER JOIN
                      dbo.Users ON dbo.RegShift.CloseBy = dbo.Users.UserId
GO