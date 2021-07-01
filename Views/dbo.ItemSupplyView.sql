SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemSupplyView]
 with schemabinding
AS
SELECT        ItemSupply.ItemSupplyID, ItemSupply.ItemStoreNo, ItemSupply.SupplierNo, ItemSupply.TotalCost, ItemSupply.GrossCost, ItemSupply.MinimumQty, ItemSupply.QtyPerCase, ItemSupply.IsOrderedOnlyInCase, 
                         ItemSupply.AverageDeliveryDelay, ItemSupply.ItemCode, ItemSupply.IsMainSupplier, ItemSupply.SortOrder, ItemSupply.Status, ItemSupply.DateCreated, ItemSupply.UserCreated, ItemSupply.DateModified, 
                         ItemSupply.UserModified, ItemStore.StoreNo AS StoreID, ItemMain.CaseQty, (CASE WHEN (ISNULL(dbo.ItemMain.CaseQty, 1) > 0 AND ISNULL(dbo.ItemSupply.GrossCost, 0) > 0) 
                         THEN dbo.ItemSupply.GrossCost / dbo.ItemMain.CaseQty ELSE 0 END) AS PCCost, ItemSupply.MaxQty, ItemSupply.MinQty, ItemSupply.OnSpecialReq, ItemSupply.ToDate, ItemSupply.FromDate, 
                         ItemSupply.AssignDate, ItemSupply.SalePrice, ItemSupply.CaseQty AS Expr1, ItemStore.PrefOrderBy, Supplier.Name, ItemSupply.ColorName
FROM            dbo.ItemSupply INNER JOIN
                         dbo.ItemStore ON dbo.ItemStore.ItemStoreID = dbo.ItemSupply.ItemStoreNo INNER JOIN
                         dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID INNER JOIN
                         dbo.Supplier ON dbo.ItemSupply.SupplierNo = dbo.Supplier.SupplierID
GO