SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE VIEW [dbo].[TransactionEntryProfit]
AS
SELECT        [Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].Debit, [Transaction].Tax, [Transaction].StoreID, [Transaction].CustomerID, ISNULL(LastName,'') + ', ' + ISNULL(FirstName,'') AS CUstomerName, [Transaction].TransactionType, [Transaction].StartSaleTime,[Transaction].EndSaleTime, [Transaction].UserCreated AS UserID, 
                         TransactionEntry.ItemStoreID, TransactionEntry.Total, ISNULL(TransactionEntry.AVGCost, ISNULL(TransactionEntry.Cost,0)) * ISNULL
                             ((SELECT        CASE WHEN BarcodeType <> 0 THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMain.CaseQty END) 
                                                          END AS Expr1), 0) AS ExtCost, ISNULL(TransactionEntry.Cost, 0) * ISNULL(TransactionEntry.UOMQty, 0) AS Cost, TransactionEntry.Total AS ExtPrice, ISNULL(TransactionEntry.Cost, 0) AS RegCost, 
                         ISNULL(TransactionEntry.AVGCost, 0) AS AVGCost, (CASE WHEN TransactionEntry.UOMQty = 0 THEN 0 ELSE ISNULL(dbo.TransactionEntry.UOMPrice, 1) / ISNULL(TransactionEntry.UOMQty, 1) 
                         * ISNULL(TransactionEntry.UOMQty, 1) END) AS Price,
                             (SELECT        CASE WHEN ItemMain.CaseQty IS NULL THEN dbo.TransactionEntry.UOMQty WHEN (ItemMain.CaseQty = 0) 
                                                         THEN dbo.TransactionEntry.UOMQty WHEN ItemMain.BarcodeType = 1 THEN dbo.TransactionEntry.Qty ELSE
                                                             (SELECT        CASE WHEN (TransactionEntry.UOMTYPE IS NULL) 
                                                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.Qty ELSE dbo.TransactionEntry.UOMQty * ItemMain.CaseQty END)
                                                          / ItemMain.CaseQty END AS Expr1) AS QtyCase, ISNULL(TransactionEntry.DiscountOnTotal, 0) AS Discount, 
														  ISNULL(TotalAfterDiscount,dbo.TransactionEntry.Total) - ISNULL(TransactionEntry.AVGCost, 0) * ISNULL
                             ((SELECT        CASE WHEN BarcodeType <> 0 THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMain.CaseQty END) 
                                                          END AS Expr1), 0) AS Profit, 
														  ISNULL(TotalAfterDiscount,dbo.TransactionEntry.Total) AS TotalAfterDiscount, 
                         TransactionEntry.RegUnitPrice, TransactionEntry.UOMPrice,
                             (SELECT        CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMain.CaseQty END AS Qty)
                          AS QTY, TransactionEntry.UOMType, ItemMain.ItemID
FROM            TransactionEntry INNER JOIN
                         [Transaction] ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID   LEFT OUTER JOIN
                         ItemMainAndStoreReportView AS ItemMain ON ItemMain.ItemStoreID = TransactionEntry.ItemStoreID LEFT OUTER JOIN Customer 
						 ON [Transaction].CustomerID = Customer.CustomerID
WHERE        (TransactionEntry.Status > 0) AND (TransactionEntry.TransactionEntryType <> 4) AND (TransactionEntry.TransactionEntryType <> 5) AND ([Transaction].Status > 0)
AND TransactionEntry.ItemStoreID IN (Select ItemStoreID From ItemsRepFilter)
GO