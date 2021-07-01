SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TenderByStoreView]
AS
SELECT       ID, TenderName, Total, StoreName, SaleDate, StoreID,TenderGroup
 From 
(Select ROW_NUMBER() OVER (ORDER BY TenderName)AS ID,  StoreName,  TenderName, CAST(SUM(ISNULL(Total,0)) as Money) AS Total, SaleDate, StoreID,TenderGroup
FROM            (SELECT        TOP (100) PERCENT Store.StoreNumber AS StoreName, 
                         CASE WHEN dbo.Tender.TenderName = 'CASH' THEN 'CASH' WHEN dbo.Tender.TenderName = 'CHECK' THEN 'CHECK' WHEN (TenderEntry.Common3 = 4) 
                         THEN 'AMEX' ELSE dbo.Tender.TenderName END AS TenderName, cast(SUM(ISNULL(TenderEntry.Amount,0)) as money) AS Total, dbo.GetDay([Transaction].EndSaleTime) 
                         AS SaleDate, Store.StoreID,Tender.TenderGroup 
FROM            Tender INNER JOIN
                         TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
                         [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        (TenderEntry.Status > 0) AND ([Transaction].Status > 0 and Tender.TenderGroup <>6 and Tender.TenderGroup <>7 AND dbo.Tender.TenderName <> 'CHECK'
)
                          GROUP BY dbo.Store.StoreNumber, dbo.Tender.TenderName,Tender.TenderGroup , dbo.GetDay(dbo.[Transaction].EndSaleTime), dbo.Store.StoreID, 
                                                    dbo.TenderEntry.Common3
                          ORDER BY SaleDate, StoreName, TenderName
						  UNION SELECT   TOP (100) PERCENT      Store.StoreNumber As StoreName,'ON ACCOUNT' AS TenderName, cast(SUM(ISNULL([Transaction].Debit,0)- ISNULL([Transaction].Credit,0)) as money) AS Total,  dbo.GetDay([Transaction].EndSaleTime) AS SaleDate, [Transaction].StoreID, 6 AS TenderGroup
FROM            [Transaction] INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        ([Transaction].Status > 0) AND ([Transaction].Debit>  [Transaction].Credit)
GROUP BY Store.StoreNumber, dbo.GetDay([Transaction].EndSaleTime), [Transaction].StoreID
						  
UNION SELECT   TOP (100) PERCENT      Store.StoreNumber As StoreName,'Apply To Account ' AS TenderName, cast(SUM(ISNULL([Transaction].Credit,0)- ISNULL([Transaction].Debit,0)) as money) AS Total,  dbo.GetDay([Transaction].EndSaleTime) AS SaleDate, [Transaction].StoreID, 7 AS TenderGroup
FROM            [Transaction] INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        ([Transaction].Status > 0) AND ([Transaction].Credit>  [Transaction].Debit)
GROUP BY Store.StoreNumber, dbo.GetDay([Transaction].EndSaleTime), [Transaction].StoreID) AS tbl 
GROUP BY TenderName, StoreName, tbl.SaleDate, tbl.StoreID,TenderGroup
UNION 
						  SELECT  TOP (100) PERCENT ROW_NUMBER() OVER (ORDER BY TenderName)AS ID,      Store.StoreNumber AS StoreName, 
                        'CHECK'  AS TenderName, Cast(ISNULL(TenderEntry.Amount,0) as money) AS Total, dbo.GetDay([Transaction].EndSaleTime) 
                         AS SaleDate, Store.StoreID,Tender.TenderGroup 
FROM            Tender INNER JOIN
                         TenderEntry ON Tender.TenderID = TenderEntry.TenderID INNER JOIN
                         [Transaction] ON TenderEntry.TransactionID = [Transaction].TransactionID INNER JOIN
                         Store ON [Transaction].StoreID = Store.StoreID
WHERE        (TenderEntry.Status > 0) AND ([Transaction].Status > 0 and Tender.TenderGroup <>6 and Tender.TenderGroup <>7 AND dbo.Tender.TenderName = 'CHECK'
)
ORDER BY SaleDate, StoreName, TenderName
) AS tbll
GO