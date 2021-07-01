SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE View [dbo].[HistoryView]
-- WITH SCHEMABINDING
AS
SELECT     T.TransactionNo, IT.TransactionEntryType AS TransactionType, IT.TransactionID, T.StartSaleTime, T.StartSaleTime AS SaleTime, 
                      CASE WHEN IT.TransactionEntryType <> 0 AND IT.Total < 0 AND IT.Qty > 0 THEN 0 - IT.Qty ELSE IT.Qty END AS Qty, CASE WHEN IT.TransactionEntryType <> 0 AND 
                      IT.Total < 0 AND IT.UOMQty > 0 THEN 0 - IT.UOMQty ELSE IT.UOMQty END AS UOMQty, CAST(IT.Total / IT.Qty AS decimal(16, 2)) AS Price, IT.Total AS ExtPrice, 
                      IT.ItemStoreID, IM.ItemID, T.StoreID, S.StoreName, T.CustomerID, 
                      CASE WHEN TransactionType = 0 THEN 'Sale' WHEN TransactionType = 3 THEN 'Return' END AS [Type],
                          (SELECT     CASE WHEN IM.CaseQty IS NULL AND Qty > 0 THEN IT.UOMQty WHEN (IM.CaseQty = 0) THEN IT.UOMQty WHEN IM.BarcodeType = 1 OR
                                                   Qty < 0 THEN IT.Qty ELSE
                                                       (SELECT     CASE WHEN (IT.UOMTYPE IS NULL) THEN IT.UOMQty WHEN IT.UOMTYPE = 0 THEN IT.Qty ELSE IT.UOMQty * IM.CaseQty END) 
                                                   / IM.CaseQty END AS Expr1) AS QtyCase, C.LastName + ' ' + C.FirstName AS [Customer Name], C.CustomerNo, IT.TotalAfterDiscount
FROM         dbo.TransactionEntry AS IT INNER JOIN
                      dbo.[Transaction] AS T ON IT.TransactionID = T.TransactionID INNER JOIN
                      dbo.Store AS S ON T.StoreID = S.StoreID INNER JOIN
                      dbo.ItemStore AS ITS ON IT.ItemStoreID = ITS.ItemStoreID INNER JOIN
                      dbo.ItemMain AS IM ON IM.ItemID = ITS.ItemNo LEFT OUTER JOIN
                      dbo.Customer AS C ON T.CustomerID = C.CustomerID
WHERE     (IT.Status > 0) AND (T.Status > 0) AND (IT.Qty <> 0)
GO