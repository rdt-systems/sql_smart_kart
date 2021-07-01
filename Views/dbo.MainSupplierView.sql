SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[MainSupplierView]
AS
SELECT     ItemStoreNo, SupplierNo, SortOrder
FROM         dbo.ItemSupply
GO