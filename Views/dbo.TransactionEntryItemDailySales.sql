SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE VIEW [dbo].[TransactionEntryItemDailySales]

AS
	SELECT 
		TransactionEntryID,
		(SELECT CASE
				WHEN TransactionEntry.UOMTYPE IS NULL THEN dbo.TransactionEntry.UOMQty 
				WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMainAndStoreGridItemsDailySales.CaseQty END AS Qty)
		AS QTY,
		TransactionEntry.ItemStoreID,
		TransactionEntry.Total,
		StartSaleTime,
		ItemMainAndStoreGridItemsDailySales.ItemID, 
		ISNULL(ItemMainAndStoreGridItemsDailySales.Name, '[MANUAL ITEM]') AS Name,
		CASE 
			WHEN ItemMainAndStoreGridItemsDailySales.DepartmentID IS NULL THEN dbo.TransactionEntry.DepartmentID ELSE ItemMainAndStoreGridItemsDailySales.DepartmentID END AS DepartmentID,
	--TransactionEntry.DepartmentID,
	ItemMainAndStoreGridItemsDailySales.BarcodeNumber,
	CASE WHEN ItemMainAndStoreGridItemsDailySales.Department IS NULL THEN ItemsRepFilterDept.Name ELSE ItemMainAndStoreGridItemsDailySales.Department END AS Department
	-- dbo.DepartmentStore.Name AS Department
	--  ItemMainAndStoreGrid_RM.ItemID, 
	--ISNULL(ParentInfo.ParentName, '[NOT PARENT]') AS ParentName, 
	--ISNULL(ItemMainAndStoreGrid_RM.Name, '[MANUAL ITEM]') AS Name,
	-- ItemMainAndStoreGrid_RM.OnOrder, 
	--                         TransactionEntry.TransactionEntryID, ItemMainAndStoreGrid_RM.BarcodeNumber, ItemMainAndStoreGrid_RM.Matrix1 AS Color, ItemMainAndStoreGrid_RM.Matrix2 AS Size, ItemMainAndStoreGrid_RM.ModalNumber, 
	--                         ItemMainAndStoreGrid_RM.ItemTypeName, ItemMainAndStoreGrid_RM.SupplierName AS Supplier, ItemMainAndStoreGrid_RM.MainSupplierID AS SupplierID, ItemMainAndStoreGrid_RM.[Supplier Item Code] AS SupplierCode, 
	--                         CASE WHEN ItemMainAndStoreGrid_RM.Department IS NULL THEN dbo.DepartmentStore.Name ELSE ItemMainAndStoreGrid_RM.Department END AS Department, 
	--                         CASE WHEN ItemMainAndStoreGrid_RM.DepartmentID IS NULL THEN dbo.TransactionEntry.DepartmentID ELSE ItemMainAndStoreGrid_RM.DepartmentID END AS DepartmentID, ItemMainAndStoreGrid_RM.ItemType, 
	--                         [Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].StoreID, [Transaction].CustomerID, [Transaction].TransactionType, [Transaction].StartSaleTime, [Transaction].UserCreated AS UserID, 
	--                         TransactionEntry.ItemStoreID, TransactionEntry.Total, ISNULL(TransactionEntry.AVGCost, ISNULL(TransactionEntry.Cost,0)) * ISNULL
	--                             ((SELECT        CASE WHEN BARCODETYPE <> 'Standard' THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
	--                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMainAndStoreGrid_RM.CaseQty END) 
	--                                                          END AS Expr1), 0) AS ExtCost, ISNULL(TransactionEntry.Cost, 0) * ISNULL(TransactionEntry.UOMQty, 0) AS Cost, TransactionEntry.Total AS ExtPrice, ISNULL(TransactionEntry.Cost, 0) AS RegCost, 
	--                         ISNULL(TransactionEntry.AVGCost, 0) AS AVGCost, (CASE WHEN TransactionEntry.UOMQty = 0 THEN 0 ELSE ISNULL(dbo.TransactionEntry.UOMPrice, 1) / ISNULL(TransactionEntry.UOMQty, 1) 
	--                         * ISNULL(TransactionEntry.UOMQty, 1) END) AS Price,
	--                             (SELECT        CASE WHEN ItemMainAndStoreGrid_RM.CaseQty IS NULL THEN dbo.TransactionEntry.UOMQty WHEN (ItemMainAndStoreGrid_RM.CaseQty = 0) 
	--                                                         THEN dbo.TransactionEntry.UOMQty WHEN ItemMainAndStoreGrid_RM.BarcodeType = 'With Weight' THEN dbo.TransactionEntry.Qty ELSE
	--                                                             (SELECT        CASE WHEN (TransactionEntry.UOMTYPE IS NULL) 
	--                                                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.Qty ELSE dbo.TransactionEntry.UOMQty * ItemMainAndStoreGrid_RM.CaseQty END)
	--                                                          / ItemMainAndStoreGrid_RM.CaseQty END AS Expr1) AS QtyCase, ISNULL(TransactionEntry.DiscountOnTotal, 0) AS Discount, (CASE WHEN ISNULL(TotalAfterDiscount, 0) 
	--                         = 0 THEN dbo.TransactionEntry.Total ELSE dbo.TransactionEntry.TotalAfterDiscount END) - ISNULL(TransactionEntry.AVGCost, 0) * ISNULL
	--                             ((SELECT        CASE WHEN BARCODETYPE <> 'Standard' THEN dbo.TransactionEntry.Qty ELSE (CASE WHEN TransactionEntry.UOMTYPE IS NULL 
	--                                                          THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMainAndStoreGrid_RM.CaseQty END) 
	--                                                          END AS Expr1), 0) AS Profit, (CASE WHEN ISNULL(TotalAfterDiscount, 0) = 0 THEN dbo.TransactionEntry.Total ELSE dbo.TransactionEntry.TotalAfterDiscount END) AS TotalAfterDiscount, 
	--                         TransactionEntry.RegUnitPrice, TransactionEntry.UOMPrice, Store.StoreName, TransactionEntry.ReturnReason, ItemMainAndStoreGrid_RM.OnHand,
	--                             (SELECT        CASE WHEN TransactionEntry.UOMTYPE IS NULL 
	--                                                         THEN dbo.TransactionEntry.UOMQty WHEN TransactionEntry.UOMTYPE = 0 THEN dbo.TransactionEntry.UOMQty ELSE dbo.TransactionEntry.UOMQty * ItemMainAndStoreGrid_RM.CaseQty END AS Qty)
	--                          AS QTY,
						  
						  
	--						   ItemMainAndStoreGrid_RM.Brand, ItemMainAndStoreGrid_RM.CustomerCode, ParentInfo.[Supplier Item Code] AS ParentCode, ParentInfo.SupplierName AS ParentSupplerName, TransactionEntry.Taxable, 
	--                         TransactionEntry.TaxRate, ISNULL(ItemMainAndStoreGrid_RM.MainDepartment, Main.Sub3) AS MainDepartment, ISNULL(ItemMainAndStoreGrid_RM.SubDepartment, Main.Sub1) AS SubDepartment, 
						  --  ISNULL(ItemMainAndStoreGrid_RM.SubSubDepartment, Main.Sub2) AS SubSubDepartment, ItemMainAndStoreGrid_RM.Groups
	FROM       
		dbo.TransactionEntry 
		INNER JOIN dbo.[Transaction] 
			ON [Transaction].TransactionID = TransactionEntry.TransactionID 
		LEFT OUTER JOIN dbo.ItemsRepFilterDept       
			ON ItemsRepFilterDept.itemstoreid = TransactionEntry.ItemStoreID 
		LEFT OUTER JOIN dbo.ItemMainAndStoreGridItemsDailySales
			ON ItemMainAndStoreGridItemsDailySales.ItemStoreID = TransactionEntry.ItemStoreID AND ItemMainAndStoreGridItemsDailySales.Status > - 1
							 --LEFT OUTER JOIN
							 --dbo.DepartmentStore ON TransactionEntry.DepartmentID = DepartmentStore.DepartmentStoreID
						
							 --LEFT OUTER JOIN
		   --                      (SELECT        DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName, CASE WHEN (tDepartment_3.Name IS NOT NULL) 
		   --                                                  THEN tDepartment_2.Name WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name ELSE DepartmentStore.Name END AS Sub1, 
		   --                                                  CASE WHEN (tDepartment_3.Name IS NULL AND tDepartment_2.Name IS NOT NULL) THEN DepartmentStore.Name WHEN (tDepartment_3.Name IS NOT NULL AND 
		   --                                                  tDepartment_2.Name IS NOT NULL) THEN tDepartment_1.Name END AS Sub2, COALESCE (tDepartment_3.Name, tDepartment_2.Name, tDepartment_1.Name, DepartmentStore.Name) 
		   --                                                  AS Sub3
		   --                        FROM            dbo.DepartmentStore LEFT OUTER JOIN
		   --                                                  dbo.DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
		   --                                                  dbo.DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT OUTER JOIN
		   --                                                  dbo.DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON 
		   --                                                  dbo.DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
		   --                        WHERE        (DepartmentStore.Status > 0)) AS Main ON DepartmentStore.DepartmentStoreID = Main.DepartmentStoreID 
							 --LEFT OUTER JOIN
		   --                  dbo.Store ON [Transaction].StoreID = Store.StoreID 
						 
							 ---- LEFT OUTER JOIN
							 --    (SELECT DISTINCT ItemID, Name AS ParentName, SupplierName, StoreNo, [Supplier Item Code]
							 --      FROM            dbo.ItemMainAndStoreGrid_RM AS ItemMainAndStoreGrid_RM_1) AS ParentInfo ON ItemMainAndStoreGrid_RM.StoreNo = ParentInfo.StoreNo AND ItemMainAndStoreGrid_RM.LinkNo = ParentInfo.ItemID

	WHERE        (TransactionEntry.Status > 0) AND (TransactionEntry.TransactionEntryType <> 4) AND (TransactionEntry.TransactionEntryType <> 5) AND ([Transaction].Status > 0)
GO