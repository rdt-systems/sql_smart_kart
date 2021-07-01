SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ProfitDaily]
(@FromDate dateTime,
 @ToDate dateTime)
 as SELECT     dbo.Supplier.Name, 0.00 AS Amount, ISNULL(SUM(dbo.TransactionEntryView.Cost), 0) - ISNULL(SUM(dbo.SupplierTenderEntryView.Amount), 0) 
                      AS Balance
FROM         dbo.TransactionEntryView INNER JOIN
                      dbo.ItemSupplyView ON dbo.TransactionEntryView.ItemStoreID = dbo.ItemSupplyView.ItemStoreNo INNER JOIN
                      dbo.Supplier ON dbo.ItemSupplyView.SupplierNo = dbo.Supplier.SupplierID INNER JOIN
                      dbo.[Transaction] ON dbo.TransactionEntryView.TransactionID = dbo.[Transaction].TransactionID LEFT OUTER JOIN
                      dbo.SupplierTenderEntryView ON dbo.Supplier.SupplierID = dbo.SupplierTenderEntryView.SupplierID
WHERE     (dbo.[Transaction].StartSaleTime >= @FromDate and dbo.[Transaction].StartSaleTime <= @ToDate)
GROUP BY  dbo.ItemSupplyView.SupplierNo, dbo.Supplier.Name
GO