SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemDetailsFilterView]
AS
SELECT     dbo.SupplierView.SupplierID, dbo.SupplierView.Name AS SupplierName, dbo.ItemMainAndStoreView.ItemID, 
                      dbo.ItemMainAndStoreView.Name AS ItemName, dbo.ManufacturersView.ManufacturerID, dbo.ManufacturersView.ManufacturerName
FROM         dbo.SupplierView CROSS JOIN
                      dbo.ItemMainAndStoreView CROSS JOIN
                      dbo.ManufacturersView
GO