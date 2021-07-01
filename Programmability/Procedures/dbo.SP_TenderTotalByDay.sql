SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_TenderTotalByDay]
(@Day Datetime)
As 
SELECT        SumTender.SortOrder, SumTender.Amount, SumTender.TenderName, SumSale.SumTax, SumSale.SumSale, SumSale.SumPay, SumTender.TenderGroup, SumPayOut.SumPayOut, 
                         ISNULL(SumTender.CountTender, 0) AS CountTender, SumSale.TransCount, SumCustomer.CountCustomer, SumItemsQty.SumItemQty, TransDay.Day, ISNULL(OpenCredits.Amount, 0) AS OpenCredits
FROM            (SELECT        COUNT(CustomerID) AS CountCustomer, dbo.GetDay(EndSaleTime) AS Day
                          FROM            [Transaction] AS Transaction_2
                          WHERE        (Status > 0)
                          GROUP BY dbo.GetDay(EndSaleTime)) AS SumCustomer LEFT OUTER JOIN
                             (SELECT        dbo.GetDay(@Day) AS Day, SUM(Coupon.Amount) - SUM(CouponUsed.AmoountUsed) AS Amount
                               FROM            Coupon INNER JOIN
                                                             (SELECT        SUM(Amount) AS AmoountUsed, CouponID
                                                               FROM            CouponUsed AS CouponUsed_1
                                                               WHERE        (Status > 0)
                                                               GROUP BY CouponID) AS CouponUsed ON Coupon.CouponID = CouponUsed.CouponID
                               WHERE        (Coupon.Status > 0)) AS OpenCredits ON SumCustomer.Day = OpenCredits.Day RIGHT OUTER JOIN
                             (SELECT        dbo.GetDay(EndSaleTime) AS Day, SUM(Debit) AS Sale
                               FROM            [Transaction] AS Transaction_4
                               WHERE        (Status > 0)
                               GROUP BY dbo.GetDay(EndSaleTime)) AS TransDay ON SumCustomer.Day = TransDay.Day LEFT OUTER JOIN
                             (SELECT        dbo.GetDay(Transaction_1.EndSaleTime) AS Day, SUM(Transaction_1.Tax) AS SumTax, SUM(TransEntry.TotalAfterDiscount) AS SumSale, SUM(Transaction_1.Credit) AS SumPay, 
                                                         COUNT(Transaction_1.TransactionID) AS TransCount
                               FROM            [Transaction] AS Transaction_1 INNER JOIN
                                                             (SELECT        TransactionID, SUM(TotalAfterDiscount) AS TotalAfterDiscount
                                                               FROM            TransactionEntryItem
                                                               GROUP BY TransactionID) AS TransEntry ON Transaction_1.TransactionID = TransEntry.TransactionID
                               WHERE        (Transaction_1.Status > 0)
                               GROUP BY dbo.GetDay(Transaction_1.EndSaleTime)) AS SumSale ON TransDay.Day = SumSale.Day LEFT OUTER JOIN
                             (SELECT        SUM(Amount) AS SumPayOut, dbo.GetDay(PayOutDate) AS Day
                               FROM            PayOut
                               WHERE        (Status > 0)
                               GROUP BY dbo.GetDay(PayOutDate)) AS SumPayOut ON TransDay.Day = SumPayOut.Day LEFT OUTER JOIN
                             (SELECT        SUM(TransactionEntry.Qty) AS SumItemQty, dbo.GetDay(Transaction_3.EndSaleTime) AS Day
                               FROM            TransactionEntry INNER JOIN
                                                         [Transaction] AS Transaction_3 ON TransactionEntry.TransactionID = Transaction_3.TransactionID
                               WHERE        (Transaction_3.Status > 0) AND (TransactionEntry.TransactionEntryType = 0) AND (TransactionEntry.Status > 0)
                               GROUP BY dbo.GetDay(Transaction_3.EndSaleTime)) AS SumItemsQty ON TransDay.Day = SumItemsQty.Day LEFT OUTER JOIN
                             (SELECT        Tender.TenderName, SUM(TenderEntry.Amount) AS Amount, Tender.SortOrder, Tender.TenderGroup, COUNT(TenderEntry.TenderEntryID) AS CountTender, dbo.GetDay([Transaction].EndSaleTime) 
                                                         AS Day
                               FROM            [Transaction] INNER JOIN
                                                         TenderEntry ON [Transaction].TransactionID = TenderEntry.TransactionID INNER JOIN
                                                         Tender ON TenderEntry.TenderID = Tender.TenderID
                               WHERE        ([Transaction].Status > 0)
                               GROUP BY Tender.SortOrder, Tender.TenderName, Tender.TenderGroup, dbo.GetDay([Transaction].EndSaleTime)) AS SumTender ON TransDay.Day = SumTender.Day
WHERE        (TransDay.Day = @Day)
GO