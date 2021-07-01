SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[CustomerItemFilterView]
AS
SELECT     dbo.[Transaction].CustomerID, dbo.TransactionEntry.ItemStoreID, dbo.Supplier.Name AS SupplierName, dbo.ItemMain.[Name], 
                      dbo.Manufacturers.ManufacturerName
FROM         dbo.ItemStore INNER JOIN
                      dbo.TransactionEntry ON dbo.ItemStore.ItemStoreID = dbo.TransactionEntry.ItemStoreID INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID LEFT OUTER JOIN
                      dbo.Manufacturers ON dbo.ItemMain.ManufacturerID = dbo.Manufacturers.ManufacturerID LEFT OUTER JOIN
                      dbo.Supplier INNER JOIN
                      dbo.ItemSupply ON dbo.Supplier.SupplierID = dbo.ItemSupply.SupplierNo ON 
                      dbo.TransactionEntry.ItemStoreID = dbo.ItemSupply.ItemStoreNo LEFT OUTER JOIN
                      dbo.[Transaction] ON dbo.TransactionEntry.TransactionID = dbo.[Transaction].TransactionID
WHERE     (dbo.[Transaction].CustomerID IS NOT NULL)
GO