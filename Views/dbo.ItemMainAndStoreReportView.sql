SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[ItemMainAndStoreReportView]
WITH SCHEMABINDING
AS

SELECT        ItemMain.ItemID, ItemStore.ItemStoreID, ItemMain.LinkNo, ItemStore.MainSupplierID, ItemMain.Name, ItemMain.Description, ItemMain.BarcodeNumber, ItemMain.ModalNumber, ItemMain.Size, ItemMain.Matrix1, ItemMain.Matrix2, 
                         ItemMain.Matrix3, SysItemTypeView.SystemValueName AS ItemTypeName, DepartmentStore.Name AS Department, ItemStore.DepartmentID, ItemMain.ItemType, ItemMain.BarcodeType, ItemMain.CaseQty, ItemStore.OnHand, 
                         ItemStore.OnOrder, Manufacturers.ManufacturerName AS Brand, ItemMain.CustomerCode, Main.Sub3 AS MainDepartment, Main.Sub1 AS SubDepartment, Main.Sub2 AS SubSubDepartment, Supplier.Name AS SupplierName, 
                         ItemHeadSupplierView.ItemCode AS [Supplier Item Code], ItemMain.ManufacturerPartNo, ItemMain.StyleNo, ItemMain.CustomInteger1, ItemStore.LastReceivedDate, ItemStore.LastReceivedQty, 
                         CASE WHEN ItemMain.extName IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.extName) ELSE '' END AS extName, CASE WHEN ItemMain.CustomField1 IS NOT NULL 
                         THEN [dbo].GetLookupValues(ItemMain.CustomField1) ELSE '' END AS CustomField1, CASE WHEN ItemMain.CustomField2 IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.CustomField2) ELSE '' END AS CustomField2, 
                         CASE WHEN ItemMain.CustomField3 IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.CustomField3) ELSE '' END AS CustomField3, CASE WHEN ItemMain.CustomField4 IS NOT NULL 
                         THEN [dbo].GetLookupValues(ItemMain.CustomField4) ELSE '' END AS CustomField4, CASE WHEN ItemMain.CustomField5 IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.CustomField5) ELSE '' END AS CustomField5, 
                         CASE WHEN ItemMain.CustomField6 IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.CustomField6) ELSE '' END AS CustomField6, CASE WHEN ItemMain.CustomField7 IS NOT NULL 
                         THEN [dbo].GetLookupValues(ItemMain.CustomField7) ELSE '' END AS CustomField7, CASE WHEN ItemMain.CustomField8 IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.CustomField8) ELSE '' END AS CustomField8, 
                         CASE WHEN ItemMain.CustomField9 IS NOT NULL THEN [dbo].GetLookupValues(ItemMain.CustomField9) ELSE '' END AS CustomField9, CASE WHEN ItemMain.CustomField10 IS NOT NULL 
                         THEN [dbo].GetLookupValues(ItemMain.CustomField10) ELSE '' END AS CustomField10, ItemStore.Status, ItemStore.StoreNo, ItemStore.Price,
						 (CASE WHEN IsNull(ParentInfo.[Supplier Item Code], '') = '' THEN dbo.ItemHeadSupplierView.ItemCode ELSE ParentInfo.[Supplier Item Code] END) AS ParentCode,
						 ParentInfo.SupplierName AS ParentSupplerName,
						 CONVERT(nvarchar(500),
	                STUFF((SELECT DISTINCT ',' + ig.ItemGroupName
                              FROM         dbo.ItemToGroup AS itg INNER JOIN
                                                    dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                              WHERE     itg.ItemStoreID = ItemStore.ItemStoreID AND itg.Status > 0
							FOR xml PATH ('')), 1, 1, '')) AS Groups
FROM            dbo.DepartmentStore RIGHT OUTER JOIN
                         dbo.Supplier INNER JOIN
                         dbo.ItemHeadSupplierView ON Supplier.SupplierID = ItemHeadSupplierView.SupplierNo RIGHT OUTER JOIN
                         dbo.ItemStore INNER JOIN
                         dbo.ItemMain ON ItemStore.ItemNo = ItemMain.ItemID LEFT OUTER JOIN
                         dbo.Manufacturers ON ItemMain.ManufacturerID = Manufacturers.ManufacturerID ON ItemHeadSupplierView.ItemSupplyID = ItemStore.MainSupplierID ON DepartmentStore.DepartmentStoreID = ItemStore.DepartmentID AND 
                         dbo.DepartmentStore.Status > 0 LEFT OUTER JOIN
                             (SELECT        DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName, CASE WHEN (tDepartment_3.Name IS NOT NULL) THEN tDepartment_2.Name WHEN (tDepartment_3.Name IS NULL AND 
                                                         tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name ELSE dbo.DepartmentStore.Name END AS Sub1, CASE WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) 
                                                         THEN dbo.DepartmentStore.Name WHEN (tDepartment_3.Name IS NOT NULL AND tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name END AS Sub2, COALESCE (tDepartment_3.Name, 
                                                         tDepartment_2.Name, tDepartment_1.Name, DepartmentStore.Name) AS Sub3
                               FROM            dbo.DepartmentStore LEFT OUTER JOIN
                                                         dbo.DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
                                                         dbo.DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT OUTER JOIN
                                                         dbo.DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
                               WHERE        (DepartmentStore.Status > 0)) AS Main ON ItemStore.DepartmentID = Main.DepartmentStoreID LEFT OUTER JOIN
                         dbo.SysItemTypeView ON ItemMain.ItemType = SysItemTypeView.SystemValueNo LEFT OUTER JOIN
                          (SELECT DISTINCT ItemStore.ItemNo AS ItemID, Supplier.Name AS SupplierName, ItemStore.StoreNo, ItemSupply.ItemCode AS [Supplier Item Code]
                            FROM          dbo.ItemStore INNER JOIN
                                                   dbo.ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo AND ItemStore.MainSupplierID = ItemSupply.ItemSupplyID INNER JOIN
                                                   dbo.Supplier ON ItemSupply.SupplierNo = Supplier.SupplierID
                            WHERE      (ItemSupply.Status > 0)) AS ParentInfo ON dbo.ItemStore.StoreNo = ParentInfo.StoreNo AND 
                      dbo.ItemMain.LinkNo = ParentInfo.ItemID 
GO