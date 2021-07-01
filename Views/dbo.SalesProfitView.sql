SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[SalesProfitView]
AS
SELECT TOP 100 PERCENT dbo.[Transaction].TransactionID, dbo.[Transaction].TransactionNo, dbo.[Transaction].RegisterTransaction, 
                      dbo.[Transaction].EndSaleTime AS Date, dbo.CustomerView.CustomerNo, dbo.CustomerView.Name AS CustomerName, 
                      dbo.UsersStoreView.NAME AS [User], Entry.SubTotal, 
                      ROUND(Discount.TotalDiscount / (CASE WHEN dbo.[Transaction].Debit = 0 or isnull(Debit, 1)  + Discount.TotalDiscount =0 THEN 1 ELSE isnull(Debit, 1) END+Discount.TotalDiscount), 2) AS [Discount %], 
                      Discount.TotalDiscount AS [Discount $], dbo.[Transaction].Tax, dbo.[Transaction].Debit AS Total, Entry.TotalCost AS Cost, 
                      (Entry.SubTotal - ISNULL(Discount.TotalDiscount, 0) - Entry.TotalCost) / CASE WHEN TotalCost = 0 THEN 1 ELSE isnull(TotalCost, 1) 
                      END AS Markup, (Entry.SubTotal - ISNULL(Discount.TotalDiscount, 0) - Entry.TotalCost) 
                      / CASE WHEN SubTotal - isnull(Discount.TotalDiscount, 0) = 0 THEN 1 ELSE isnull(SubTotal - isnull(Discount.TotalDiscount, 0), 1) 
                      END AS Margin, Entry.SubTotal - ISNULL(Discount.TotalDiscount, 0) - Entry.TotalCost AS Profit, dbo.[Transaction].CustomerID, 
                      dbo.[Transaction].StoreID, dbo.[Transaction].BatchID, dbo.[Transaction].Status, dbo.[Transaction].DateCreated, 
                      dbo.[Transaction].UserCreated, dbo.Store.StoreName
FROM      dbo.[Transaction] WITH (NOLOCK) LEFT OUTER JOIN
                      dbo.Store ON dbo.[Transaction].StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                      dbo.CustomerView ON dbo.[Transaction].CustomerID = dbo.CustomerView.CustomerID LEFT OUTER JOIN
                      dbo.UsersStoreView ON dbo.[Transaction].UserCreated = dbo.UsersStoreView.UserID AND 
                      dbo.[Transaction].StoreID = dbo.UsersStoreView.StoreID LEFT OUTER JOIN
                          (SELECT TransactionID, ROUND(ISNULL(SUM(ISNULL(Total, 0)), 0), 2) AS SubTotal, 
                            ISNULL(SUM(ISNULL(AVGCost, 0) * ISNULL(Qty, 0)), 
                                                   0) AS TotalCost
                             FROM      dbo.TransactionEntry  WITH (NOLOCK) 
                             WHERE  (TransactionEntryType <> 4) AND (Status > 0)
                             GROUP BY TransactionID) AS Entry ON dbo.[Transaction].TransactionID = Entry.TransactionID LEFT OUTER JOIN
                          (SELECT TransactionID, ROUND(SUM(ISNULL(UOMPrice, 0)), 2) AS TotalDiscount
                             FROM      dbo.TransactionEntry AS TransactionEntry_1  WITH (NOLOCK) 
                             WHERE  (TransactionEntryType = 4) AND (Status > 0)
                             GROUP BY TransactionID) AS Discount ON dbo.[Transaction].TransactionID = Discount.TransactionID
WHERE  (dbo.[Transaction].TransactionType = 0 OR
                      dbo.[Transaction].TransactionType = 3) AND (dbo.[Transaction].Status > 0)
ORDER BY Date DESC
GO