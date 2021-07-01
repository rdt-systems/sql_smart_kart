SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemMainAndStoreGridItemSummary]
 
    with schemabinding
AS 

	SELECT  
		dbo.ItemMainView.ItemID,
		dbo.ItemMainView.LinkNo,
		dbo.ItemStoreView.StoreNo, 
		dbo.ItemStoreView.ItemStoreID, 
		dbo.ItemMainView.MatrixTableNo, 
		dbo.ItemMainView.CaseQty,
		dbo.ItemMainView.ModalNumber,
		dbo.ItemMainView.BarcodeNumber,
		DepartmentID, 
		dbo.DepartmentStore.[Status], 
		dbo.ItemMainView.Name,
		dbo.DepartmentStore.Name AS Department,
	
	Matrix1, Matrix2,Cast('' as nvarchar(50)) as ItemTypeName, Cast('' as nvarchar(50)) as BarcodeType,dbo.Supplier.Name AS SupplierName,
	dbo.ItemHeadSupplierView.ItemCode AS [Supplier Item Code],isnull(ItemStoreView.OnHand,0) OnHand,dbo.Manufacturers.ManufacturerName AS Brand,dbo.ItemMainView.CustomerCode,
	Cast(0.0 as decimal(20,2)) as CsOnHand, ISNULL(dbo.ItemStoreView.MTDQty, 0) AS [MTD Pc Qty], Cast(0.0 as decimal(29,11)) as [MTD Cs Qty], Cast(0.0 as decimal(18,0)) as [YTD Pc Qty], Cast(0.0 as decimal(29,11)) as [YTD Cs Qty], Cast(0.0 as decimal(18,0)) as [PTD Pc Qty], Cast(0.0 as decimal(29,11)) as [PTD Cs Qty], ISNULL(dbo.ItemStoreView.OnOrder, 0) AS OnOrder, dbo.ItemStoreView.ReorderPoint, dbo.ItemStoreView.RestockLevel, Cast(0.0 as decimal(19,3)) as OnTransferOrder, 					  STUFF ((SELECT DISTINCT ',' + ig.ItemGroupName
                              FROM         dbo.ItemToGroup AS itg INNER JOIN
                                                    dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                              WHERE     itg.ItemStoreID = ItemStoreView.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Groups




	FROM 
		dbo.DepartmentStore 
		RIGHT OUTER JOIN dbo.ItemStoreView
			ON dbo.DepartmentStore.DepartmentStoreID = dbo.ItemStoreView.DepartmentID AND dbo.DepartmentStore.Status >0 
		INNER JOIN dbo.ItemMainView 
			ON dbo.ItemStoreView.ItemNo = dbo.ItemMainView.ItemID 
		 left OUTER JOIN dbo.ItemHeadSupplierView ON dbo.ItemHeadSupplierView.ItemSupplyID = dbo.ItemStoreView.MainSupplierID
		 --LEFT OUTER JOIN dbo.MixAndMatchView ON dbo.MixAndMatchView.MixAndMatchID = dbo.ItemStoreView.MixAndMatchID
		 LEFT OUTER JOIN dbo.Manufacturers ON dbo.ItemMainView.ManufacturerID = dbo.Manufacturers.ManufacturerID
		 LEFT OUTER JOIN dbo.Supplier ON dbo.Supplier.SupplierID = dbo.ItemHeadSupplierView.SupplierNo
GO