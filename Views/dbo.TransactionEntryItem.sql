SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[TransactionEntryItem]
AS
SELECT        M.ItemID, ISNULL(ParentInfo.ParentName, '[NOT PARENT]') AS ParentName, M.LinkNo, ISNULL(ISNULL(M.Name, EntryDescription.Description), '[MANUAL ITEM]') AS Name, S.OnOrder, TransactionEntry.TransactionEntryID, 
                         M.BarcodeNumber, M.Matrix1 AS Color, CASE WHEN ISNULL(M.Matrix2,'') <>'' THEN M.Matrix2 ELSE M.Size END AS Size, M.ModalNumber, SysItemTypeView.SystemValueName AS ItemTypeName, Supplier.Name AS Supplier, Supp.SupplierNo AS SupplierID, 
                         Supp.ItemCode AS SupplierCode, CASE WHEN D .Name IS NULL THEN DD.Name ELSE D .Name END AS Department, CASE WHEN D .DepartmentStoreID IS NULL 
                         THEN dbo.TransactionEntry.DepartmentID ELSE D .DepartmentStoreID END AS DepartmentID, M.ItemType, [Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].StoreID, [Transaction].CustomerID, 
                         [Transaction].TransactionType, [Transaction].StartSaleTime, [Transaction].EndSaleTime, [Transaction].UserCreated AS UserID, TransactionEntry.ItemStoreID, TransactionEntry.Total, ISNULL(TransactionEntry.AVGCost, 
                         ISNULL(TransactionEntry.Cost, 0)) * ISNULL
                             ((SELECT        CASE WHEN BARCODETYPE <> 0 THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * M.CaseQty END) END AS Expr1), 0) AS ExtCost, 
                         ISNULL(TransactionEntry.Cost, 0) * ISNULL(TransactionEntry.UOMQty, 0) AS Cost, TransactionEntry.Total AS ExtPrice, ISNULL(TransactionEntry.Cost, 0) AS RegCost, ISNULL(TransactionEntry.AVGCost, 0) AS AVGCost, 
                         (CASE WHEN TransactionEntry.UOMQty = 0 THEN 0 ELSE ISNULL(dbo.TransactionEntry.UOMPrice, 1) / ISNULL(TransactionEntry.UOMQty, 1) * ISNULL(TransactionEntry.UOMQty, 1) END) AS Price,
                             (SELECT        CASE WHEN M.CaseQty IS NULL THEN dbo.TransactionEntry.UOMQty WHEN (M.CaseQty = 0) THEN dbo.TransactionEntry.UOMQty WHEN M.BarcodeType = 1 THEN dbo.TransactionEntry.Qty ELSE
                                                             (SELECT        CASE WHEN (TransactionEntry.UOMTYPE IS NULL) 
                                                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.Qty ELSE dbo.TransactionEntry.UOMQty * M.CaseQty END) / M.CaseQty END AS Expr1) 
                         AS QtyCase, ISNULL(TransactionEntry.DiscountOnTotal, 0) AS Discount, ISNULL(TransactionEntry.TotalAfterDiscount, TransactionEntry.Total) - ISNULL(TransactionEntry.AVGCost, ISNULL(TransactionEntry.Cost, 0)) * ISNULL
                             ((SELECT        CASE WHEN BARCODETYPE <> 0 THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * M.CaseQty END) END AS Expr1), 0) AS Profit, 
                         ISNULL(TransactionEntry.TotalAfterDiscount, TransactionEntry.Total) AS TotalAfterDiscount, TransactionEntry.RegUnitPrice, TransactionEntry.UOMPrice, Store.StoreName, TransactionEntry.ReturnReason, S.OnHand,
                             (SELECT        CASE WHEN TransactionEntry.UOMTYPE IS NULL 
                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * M.CaseQty END AS Qty) AS QTY, 
                         B.ManufacturerName AS Brand, M.CustomerCode, ParentInfo.ParentCode, ParentInfo.SupplierName AS ParentSupplerName, TransactionEntry.Taxable, TransactionEntry.TaxRate, ISNULL(Main.Sub3, MainTra.Sub3) 
                         AS MainDepartment, ISNULL(Main.Sub1, MainTra.Sub1) AS SubDepartment, ISNULL(Main.Sub2, MainTra.Sub2) AS SubSubDepartment, TransactionEntry.UOMType, S.LastReceivedDate, S.LastReceivedQty, M.StyleNo, 
                         M.ManufacturerPartNo, CASE WHEN M.extName IS NOT NULL THEN [dbo].GetLookupValues(M.extName) ELSE '' END AS extName, CASE WHEN M.CustomField1 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField1) 
                         ELSE '' END AS CustomField1, CASE WHEN M.CustomField2 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField2) ELSE '' END AS CustomField2, CASE WHEN M.CustomField3 IS NOT NULL 
                         THEN [dbo].GetLookupValues(M.CustomField3) ELSE '' END AS CustomField3, CASE WHEN M.CustomField4 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField4) ELSE '' END AS CustomField4, 
                         CASE WHEN M.CustomField5 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField5) ELSE '' END AS CustomField5, CASE WHEN M.CustomField6 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField6) 
                         ELSE '' END AS CustomField6, CASE WHEN M.CustomField7 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField7) ELSE '' END AS CustomField7, CASE WHEN M.CustomField8 IS NOT NULL 
                         THEN [dbo].GetLookupValues(M.CustomField8) ELSE '' END AS CustomField8, CASE WHEN M.CustomField9 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField9) ELSE '' END AS CustomField9, 
                         CASE WHEN M.CustomField10 IS NOT NULL THEN [dbo].GetLookupValues(M.CustomField10) ELSE '' END AS CustomField10,	TransactionEntry.TransactionEntryType,					 						 CONVERT(nvarchar(500),
	                STUFF((SELECT DISTINCT ',' + ig.ItemGroupName
                              FROM         dbo.ItemToGroup AS itg INNER JOIN
                                                    dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                              WHERE     itg.ItemStoreID = S.ItemStoreID AND itg.Status > 0
							FOR xml PATH ('')), 1, 1, '')) AS Groups
FROM            dbo.ItemMain AS M INNER JOIN
                         dbo.ItemStore AS S ON M.ItemID = S.ItemNo INNER JOIN
                         dbo.SysItemTypeView ON M.ItemType = SysItemTypeView.SystemValueNo RIGHT OUTER JOIN
                         dbo.TransactionEntry WITH (NOLOCK) INNER JOIN
                         dbo.[Transaction]  WITH (NOLOCK) ON [Transaction].TransactionID = TransactionEntry.TransactionID INNER JOIN
                         dbo.Store ON [Transaction].StoreID = Store.StoreID ON S.ItemStoreID = TransactionEntry.ItemStoreID LEFT OUTER JOIN
                         dbo.DepartmentStore AS DD ON TransactionEntry.DepartmentID = DD.DepartmentStoreID LEFT OUTER JOIN
                             (SELECT        DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName, CASE WHEN (tDepartment_3.Name IS NOT NULL) THEN tDepartment_2.Name WHEN (tDepartment_3.Name IS NULL AND 
                                                         tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name ELSE DepartmentStore.Name END AS Sub1, CASE WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) 
                                                         THEN DepartmentStore.Name WHEN (tDepartment_3.Name IS NOT NULL AND tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name END AS Sub2, COALESCE (tDepartment_3.Name, 
                                                         tDepartment_2.Name, tDepartment_1.Name, DepartmentStore.Name) AS Sub3
                               FROM            DepartmentStore LEFT OUTER JOIN
                                                         DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
                                                         DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT OUTER JOIN
                                                         DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
                               WHERE        (DepartmentStore.Status > 0)) AS MainTra ON DD.DepartmentStoreID = MainTra.DepartmentStoreID LEFT OUTER JOIN
                         dbo.Manufacturers AS B ON M.ManufacturerID = B.ManufacturerID LEFT OUTER JOIN
                             ((SELECT     DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName,
									Case When(tDepartment_3.Name Is Not Null ) 
									Then tDepartment_2.Name When (tDepartment_3.Name Is Null And tDepartment_2.Name is NOt null) Then tDepartment_1.Name 
									Else dbo.DepartmentStore.Name END As Sub1 ,

									Case When(tDepartment_3.Name Is Null AND tDepartment_2.Name Is Not Null) Then dbo.DepartmentStore.Name  
									When  (tDepartment_3.Name Is Not Null AND tDepartment_2.Name Is Not Null) Then tDepartment_1.Name  
									END As Sub2,
								  /*return the first non null value.*/	COALESCE(tDepartment_3.Name, tDepartment_2.Name, tDepartment_1.Name, dbo.DepartmentStore.Name) AS Sub3
                                                   
                            FROM          dbo.DepartmentStore LEFT OUTER JOIN
                                                   dbo.DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
                                                   dbo.DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT JOIN
                                                   dbo.DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON 
                                                   dbo.DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
												   Where dbo.DepartmentStore.Status >0 )) AS Main RIGHT OUTER JOIN
                         dbo.DepartmentStore AS D ON Main.DepartmentStoreID = D.DepartmentStoreID ON S.DepartmentID = D.DepartmentStoreID LEFT OUTER JOIN
                         dbo.Supplier INNER JOIN
                         dbo.ItemHeadSupplierView AS Supp ON Supplier.SupplierID = Supp.SupplierNo ON S.MainSupplierID = Supp.ItemSupplyID LEFT OUTER JOIN
                             (SELECT DISTINCT ItemStore.ItemNo AS ItemID, Supplier_1.Name AS SupplierName, ItemStore.StoreNo, ItemSupply.ItemCode AS ParentCode, ItemMain.Name AS ParentName
                               FROM            ItemStore INNER JOIN
                                                         dbo.ItemMain ON ItemStore.ItemNo = ItemMain.ItemID INNER JOIN
                                                         dbo.ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo AND ItemStore.MainSupplierID = ItemSupply.ItemSupplyID INNER JOIN
                                                         dbo.Supplier AS Supplier_1 ON ItemSupply.SupplierNo = Supplier_1.SupplierID
                               WHERE        (ItemSupply.Status > 0)) AS ParentInfo ON S.StoreNo = ParentInfo.StoreNo AND M.LinkNo = ParentInfo.ItemID LEFT OUTER JOIN
                         dbo.EntryDescription ON EntryDescription.TransactionEntryID = TransactionEntry.TransactionEntryID
WHERE        (TransactionEntry.Status > 0) AND (TransactionEntry.TransactionEntryType <> 4) AND (TransactionEntry.TransactionEntryType <> 5)
--Removed Becuase Totals didn't match 'Moshe
--AND (TransactionEntry.TransactionEntryType <> 11)
 AND ([Transaction].Status > 0)
GO