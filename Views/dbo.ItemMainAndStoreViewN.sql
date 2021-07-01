SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemMainAndStoreViewN]
AS
SELECT     ItemMainView.ItemID, ItemMainView.Name, ItemMainView.Description, ItemMainView.ModalNumber, ItemMainView.LinkNo, ItemMainView.BarcodeNumber, 
                      ItemMainView.ItemType, ItemStoreView.StoreNo, ItemStoreView.IsDiscount, ItemStoreView.Price, ItemMainView.CaseQty, ItemStoreView.OnOrder, 
                      ItemStoreView.OnHand, ItemStoreView.Status, ItemMainView.DateModified AS MainDateModified, 
                      (CASE WHEN ItemMainView.CostByCase = 1 THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) AS [Cs Cost], 
                      (CASE WHEN ItemMainView.CostByCase = 1 AND ItemMainView.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMainView.CaseQty ELSE ItemStoreView.Cost END) 
                      AS [Pc Cost], ItemMainView.Status AS MainStatus, ItemStoreView.ItemStoreID, DepartmentStore.Name AS Department, 
                      DepartmentStore.DateModified AS DepartmentDateModified, ItemStoreView.DepartmentID, ItemMainView.Matrix1, ItemMainView.Matrix2, ItemMainView.Matrix3
FROM         DepartmentStore RIGHT OUTER JOIN
                      ItemStoreView INNER JOIN
                      ItemMainView ON ItemStoreView.ItemNo = ItemMainView.ItemID LEFT OUTER JOIN
                      Manufacturers ON ItemMainView.ManufacturerID = Manufacturers.ManufacturerID ON 
                      DepartmentStore.DepartmentStoreID = ItemStoreView.DepartmentID LEFT OUTER JOIN
                      SysItemTypeView ON ItemMainView.ItemType = SysItemTypeView.SystemValueNo
GO