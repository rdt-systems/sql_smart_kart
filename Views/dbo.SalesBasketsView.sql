SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SalesBasketsView]

AS
SELECT DISTINCT dbo.SalesBaskets.BasketID, dbo.SalesBaskets.SaleID, dbo.SalesBaskets.BaskItemID, dbo.SalesBaskets.BaskActionType, dbo.SalesBaskets.BaskItemType,dbo.SalesBaskets.SupplierID, 
		QtyBasket,MinQty,
        dbo.SalesBaskets.Status,
       ISNULL(dbo.ItemMain.Name, ISNULL(dbo.Supplier.Name,dbo.DepartmentStore.Name)) AS Name, dbo.ItemMain.BarcodeNumber, dbo.ItemMain.ModalNumber, 
        case when PriceByCase =0 then dbo.ItemStore.Price when CaseQty<>0  then ItemStore.Price/isnull(CaseQty,1) else ItemStore.Price end as Price, 
		case when CostByCase =0 then dbo.ItemStore.Cost when CaseQty<>0  then ItemStore.Cost/isnull(CaseQty,1) else ItemStore.Cost end as Cost,
		dbo.SalesBaskets.DateCreated, dbo.SalesBaskets.UserCreated, dbo.SalesBaskets.DateModified, 
        dbo.SalesBaskets.UserModified
FROM		dbo.SalesBaskets  LEFT OUTER JOIN
		  dbo.ItemMain ON dbo.ItemMain.ItemID = dbo.SalesBaskets.BaskItemID LEFT OUTER JOIN
		  dbo.Supplier ON dbo.SalesBaskets.BaskItemID = dbo.Supplier.SupplierID LEFT OUTER JOIN
		  dbo.DepartmentStore ON dbo.SalesBaskets.BaskItemID = dbo.DepartmentStore.DepartmentStoreID LEFT OUTER JOIN
		  dbo.ItemStore ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID
GO