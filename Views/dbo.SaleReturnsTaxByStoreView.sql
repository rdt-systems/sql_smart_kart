SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SaleReturnsTaxByStoreView]

AS
SELECT        TOP (100) PERCENT Store.StoreName, dbo.GetDay([Transaction].StartSaleTime) AS SaleDate, ISNULL(SUM([Transaction].Tax), 0) AS Tax, ISNULL(SUM(Sale.Sale), 0) AS Sale, ISNULL(SUM([Returns].Returns), 0) 
                         AS [Returns], ISNULL(SUM(Discounts.Discount), 0) AS Discount, SUM(ISNULL(GiftCardPurchase.GiftCardPurchase, 0)) AS GiftCardPurchase, Store.StoreNumber, SUM(Isnull(Cost.AvgCost,0)) AS AVGCost
FROM            [Transaction] INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID LEFT OUTER JOIN
                             (SELECT        SUM(ISNULL(AVGCost, ISNULL(Cost, 0)) * Qty) AS AvgCost, TransactionID
                               FROM            TransactionEntry AS TransactionEntry_3
                               WHERE        (Status > 0) AND (TransactionEntryType = 0)
                               GROUP BY TransactionID) AS Cost ON [Transaction].TransactionID = Cost.TransactionID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS Discount, TransactionID
                               FROM            TransactionEntry AS TransactionEntry_2
                               WHERE        (Status > 0) AND (TransactionEntryType = 4)
                               GROUP BY TransactionID) AS Discounts ON [Transaction].TransactionID = Discounts.TransactionID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS GiftCardPurchase, TransactionID
                               FROM            TransactionEntry AS TransactionEntry_1
                               WHERE        (Status > 0) AND (TransactionEntryType = 5)
                               GROUP BY TransactionID) AS GiftCardPurchase ON [Transaction].TransactionID = GiftCardPurchase.TransactionID LEFT OUTER JOIN
                             (SELECT        - SUM(Total) AS Returns, TransactionID
                               FROM            TransactionEntry AS TransactionEntry_1
                               WHERE        (Qty < 0) AND (Status > 0) AND (Total < 0) AND (TransactionEntryType = 0 OR
                                                         TransactionEntryType = 2)
                               GROUP BY TransactionID) AS [Returns] ON [Transaction].TransactionID = [Returns].TransactionID LEFT OUTER JOIN
                             (SELECT        SUM(Total) AS Sale, TransactionID
                               FROM            TransactionEntry
                               WHERE        (Qty > 0) AND (Status > 0) AND (TransactionEntryType = 0)
                               GROUP BY TransactionID) AS Sale ON [Transaction].TransactionID = Sale.TransactionID
WHERE        ([Transaction].Status > 0) 
GROUP BY dbo.GetDay([Transaction].StartSaleTime), Store.StoreName, Store.StoreNumber
ORDER BY SaleDate
GO