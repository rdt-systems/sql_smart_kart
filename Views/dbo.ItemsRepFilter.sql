SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE View [dbo].[ItemsRepFilter]
as
SELECT       DISTINCT ItemStore.ItemStoreID, ItemStore.ItemNo, ActiveItemToGroup.ItemGroupID, ItemSupply.SupplierNo, ItemStore.IsDiscount, ItemStore.IsTaxable, ItemStore.IsFoodStampable,
                          ItemStore.IsWIC, ItemMain.ItemType, ItemStore.DepartmentID, ItemMain.ManufacturerID, ItemMain.LinkNo
FROM         dbo.ItemMain INNER JOIN
                      dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo LEFT OUTER JOIN
                          (SELECT     ItemStoreID, ItemGroupID
                            FROM          dbo.ItemToGroup
                            WHERE      (Status > 0)) AS ActiveItemToGroup ON ItemStore.ItemStoreID = ActiveItemToGroup.ItemStoreID LEFT OUTER JOIN
                      dbo.ItemHeadSupplierView AS ItemSupply ON ItemStore.MainSupplierID = ItemSupply.ItemSupplyID
--WHERE     (ItemStore.Status > - 1)
union all
	select convert(uniqueidentifier,'00000000-0000-0000-0000-000000000000'),convert(uniqueidentifier,'00000000-0000-0000-0000-000000000000'),null,null,null,null,null,null,0,null,NULL,NULL
GO