SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[RepBatchView]
AS
SELECT     dbo.Batch.BatchID, dbo.Batch.RegisterID, dbo.Users.UserId, dbo.Batch.StoreID, dbo.Batch.BatchNumber, 
                      CASE WHEN BatchStatus = 1 THEN 'In Use' WHEN BatchStatus = 2 THEN 'Close' ELSE 'Open' END AS StatusOfBatch, dbo.Batch.BatchStatus, 
                      dbo.Batch.OpeningDateTime, dbo.Batch.ClosingDateTime, dbo.Users.UserName, dbo.Store.StoreName, dbo.Batch.OpeningAmount, ISNULL
                          ((SELECT     SUM(ISNULL(Credit, 0) - ISNULL(Debit, 0)) AS Expr1
                              FROM         dbo.[Transaction]
                              WHERE     (Status > 0) AND (BatchID = dbo.Batch.BatchID) AND (TransactionType = 0 OR
                                                    TransactionType = 1) AND (Credit > Debit)), 0) AS PayBalance, ISNULL
                          ((SELECT     SUM(ISNULL(Debit, 0) - ISNULL(Credit, 0)) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_12
                              WHERE     (Status > 0) AND (BatchID = dbo.Batch.BatchID) AND (TransactionType = 0) AND (Credit < Debit)), 0) AS SaleOnAccount, ISNULL
                          ((SELECT     COUNT(Debit) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_11
                              WHERE     (Status > 0) AND (BatchID = dbo.Batch.BatchID) AND (TransactionType = 0) AND (Credit < Debit)), 0) AS CountOnAccount, ISNULL
                          ((SELECT     SUM(ISNULL(Debit-tax, 0)) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_10
                              WHERE     (Status > 0) AND (BatchID = dbo.Batch.BatchID) AND (TransactionType = 0)), 0) AS TotalSales, ABS(ISNULL
                          ((SELECT     SUM(dbo.TransactionEntry.Total) AS Expr1
                              FROM         dbo.TransactionEntry INNER JOIN
                                                    dbo.[Transaction] AS Transaction_8 ON Transaction_8.TransactionID = dbo.TransactionEntry.TransactionID
                              WHERE     (dbo.TransactionEntry.Status > 0) AND (dbo.TransactionEntry.TransactionEntryType = 2) AND (dbo.TransactionEntry.Total < 0) AND 
                                                    (Transaction_8.BatchID = dbo.Batch.BatchID)), 0)) AS TotalReturn, ISNULL(PayOut.PayOut, 0) AS PayOut, dbo.Batch.ClosingAmount, ABS(ISNULL
                          ((SELECT     SUM(TransactionEntry_3.Total) AS Expr1
                              FROM         dbo.TransactionEntry AS TransactionEntry_3 INNER JOIN
                                                    dbo.[Transaction] AS Transaction_8 ON Transaction_8.TransactionID = TransactionEntry_3.TransactionID
                              WHERE     (TransactionEntry_3.Status > 0) AND (Transaction_8.TransactionType = 0) AND (TransactionEntry_3.TransactionEntryType = 2) AND 
                                                    (TransactionEntry_3.Total < 0) AND (Transaction_8.BatchID = dbo.Batch.BatchID)), 0)) AS ReturnInSale, ISNULL(Manual.ManualItem, 0) AS ManualItem, 
                      ISNULL
                          ((SELECT     SUM(ISNULL(Tax, 0)) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_7
                              WHERE     (Status > 0) AND (BatchID = dbo.Batch.BatchID)), 0) AS Tax, ISNULL
                          ((SELECT     SUM(UOMPrice * ISNULL(Qty, 1)) AS Expr1
                              FROM         dbo.TransactionEntry AS TransactionEntry_2
                              WHERE     (Status > 0) AND (TransactionEntryType = 4) AND
                                                        ((SELECT     BatchID
                                                            FROM         dbo.[Transaction] AS Transaction_6
                                                            WHERE     (Status > 0) AND (TransactionID = TransactionEntry_2.TransactionID)) = dbo.Batch.BatchID)), 0) AS Discounts, ISNULL
                          ((SELECT     MAX(Debit) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_5
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0)), 0) AS MaxSale, ISNULL
                          ((SELECT     MIN(Debit) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_4
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0)), 0) AS MinSale, ISNULL
                          ((SELECT     AVG(Debit) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_3
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0)), 0) AS AvrgSale, ISNULL
                          ((SELECT     COUNT(*) AS Expr1
                              FROM         dbo.[Transaction] AS Transaction_2
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0)), 0) AS TotalTransactions, ISNULL
                          ((SELECT     COUNT(*) AS Expr1
                              FROM         dbo.Actions
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0) AND (ActionType = 3)), 0) AS OpenDrawer, ISNULL
                          ((SELECT     COUNT(*) AS Expr1
                              FROM         dbo.Actions AS Actions_2
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0) AND (ActionType = 2)), 0) AS VoidItem, ISNULL
                          ((SELECT     COUNT(*) AS Expr1
                              FROM         dbo.Actions AS Actions_1
                              WHERE     (BatchID = dbo.Batch.BatchID) AND (Status > 0) AND (ActionType = 1)), 0) AS CancelSale, ISNULL(CashBack.SumCashBack, 0) AS CashBack
FROM         dbo.Batch LEFT OUTER JOIN
                          (SELECT     Transaction_1.BatchID, SUM(- TransactionEntry_1.Total) AS SumCashBack
                            FROM          dbo.TransactionEntry AS TransactionEntry_1 RIGHT OUTER JOIN
                                                   dbo.ItemMainAndStoreView ON TransactionEntry_1.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID LEFT OUTER JOIN
                                                   dbo.[Transaction] AS Transaction_1 ON TransactionEntry_1.TransactionID = Transaction_1.TransactionID
                            WHERE      (Transaction_1.Status > 0) AND (TransactionEntry_1.Status > 0) AND (dbo.ItemMainAndStoreView.ItemType = 7)
                            GROUP BY Transaction_1.BatchID) AS CashBack ON dbo.Batch.BatchID = CashBack.BatchID LEFT OUTER JOIN
                      dbo.Registers ON dbo.Batch.RegisterID = dbo.Registers.RegisterID LEFT OUTER JOIN
                      dbo.Users ON dbo.Batch.CashierID = dbo.Users.UserId LEFT OUTER JOIN
                      dbo.Store ON dbo.Batch.StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                          (SELECT     BatchID, ISNULL(SUM(Amount), 0) AS PayOut
                            FROM          dbo.PayOut AS PayOut_1
                            GROUP BY BatchID) AS PayOut ON dbo.Batch.BatchID = PayOut.BatchID LEFT OUTER JOIN
                          (SELECT     Transaction_1.BatchID, ISNULL(COUNT(*), 0) AS ManualItem
                            FROM          dbo.TransactionEntry AS TransactionEntry_1 LEFT OUTER JOIN
                                                   dbo.[Transaction] AS Transaction_1 ON TransactionEntry_1.TransactionID = Transaction_1.TransactionID
                            WHERE      (Transaction_1.Status > 0) AND (TransactionEntry_1.Status > 0) AND (TransactionEntry_1.ItemStoreID = '00000000-0000-0000-0000-000000000000')
                            GROUP BY Transaction_1.BatchID) AS Manual ON dbo.Batch.BatchID = Manual.BatchID
GO