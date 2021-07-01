SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[RepBatchView1]
AS
SELECT     Batch.BatchNumber, Batch.OpeningDateTime, Batch.OpeningAmount, Batch.BatchID, ISNULL(PayOut.PayOut, 0) AS PayOut, ISNULL(TotalSale.Sale, 0) 
                      - ISNULL(TotalSale.Tax, 0) AS TotalSales, ISNULL(TotalSale.Tax, 0) AS Tax, - ISNULL(Returen.Returen, - 0) AS TotalReturn, ISNULL(PayBalance.PayBalance, 0) 
                      AS PayBalance, ISNULL(OnAccount.OnAccount, 0) AS SaleOnAccount,  isnull(CashBack.SumCashBack,0) AS CashBack
FROM         Batch LEFT OUTER JOIN
                          (SELECT     Transaction_1.BatchID, SUM(- TransactionEntry_1.Total) AS SumCashBack
                            FROM          TransactionEntry AS TransactionEntry_1 RIGHT OUTER JOIN
                                                   ItemMainAndStoreView ON TransactionEntry_1.ItemStoreID = ItemMainAndStoreView.ItemStoreID LEFT OUTER JOIN
                                                   [Transaction] AS Transaction_1 ON TransactionEntry_1.TransactionID = Transaction_1.TransactionID
                            WHERE      (Transaction_1.Status > 0) AND (TransactionEntry_1.Status > 0) AND (ItemMainAndStoreView.ItemType = 7)
                            GROUP BY Transaction_1.BatchID) AS CashBack ON Batch.BatchID = CashBack.BatchID LEFT OUTER JOIN
                          (SELECT     BatchID, SUM(Debit - Credit) AS OnAccount
                            FROM          [Transaction] AS Transaction_3
                            WHERE      (Status > 0) AND (Debit > 0)
                            GROUP BY BatchID) AS OnAccount ON Batch.BatchID = OnAccount.BatchID LEFT OUTER JOIN
                          (SELECT     BatchID, SUM(Credit - Debit) AS PayBalance
                            FROM          [Transaction] AS Transaction_2
                            WHERE      (Status > 0) AND (Credit > Debit)
                            GROUP BY BatchID) AS PayBalance ON Batch.BatchID = PayBalance.BatchID LEFT OUTER JOIN
                          (SELECT     SUM(TransactionEntry.Total) AS Returen, Transaction_1.BatchID
                            FROM          [Transaction] AS Transaction_1 INNER JOIN
                                                   TransactionEntry ON Transaction_1.TransactionID = TransactionEntry.TransactionID
                            WHERE      (Transaction_1.Status > 0) AND (TransactionEntry.Status > 0) AND (TransactionEntry.Qty < 0)
                            GROUP BY Transaction_1.BatchID) AS Returen ON Batch.BatchID = Returen.BatchID LEFT OUTER JOIN
                          (SELECT     BatchID, SUM(Amount) AS PayOut
                            FROM          PayOut AS PayOut_1
                            WHERE      (Status > 0)
                            GROUP BY BatchID) AS PayOut ON Batch.BatchID = PayOut.BatchID LEFT OUTER JOIN
                          (SELECT     BatchID, SUM(Debit) AS Sale, SUM(Tax) AS Tax
                            FROM          [Transaction]
                            WHERE      (Status > 0)
                            GROUP BY BatchID) AS TotalSale ON Batch.BatchID = TotalSale.BatchID
GO