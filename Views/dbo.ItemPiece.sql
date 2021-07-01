SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemPiece]
AS
SELECT        ItemID, Name, ModalNumber, BarcodeNumber, ISNULL(OnOrder, 0) AS OnOrder, OnHand, ISNULL(AVGCost, 0) AS AVGCost, Department,
                             (SELECT        CASE WHEN (CaseQty IS NULL) THEN OnHand WHEN (CaseQty = 0) THEN OnHand ELSE OnHand / CaseQty END AS Expr1) AS OnHandCase,
                             (SELECT        CASE WHEN (CostByCase = 1 AND CaseQty IS NULL) THEN Cost WHEN (CostByCase = 1 AND CaseQty = 0) THEN Cost WHEN CostByCase = 1 THEN Cost / CaseQty ELSE Cost END AS Expr1) 
                          AS Cost,
                             (SELECT        CASE WHEN (PriceByCase = 1 AND CaseQty IS NULL) THEN Price WHEN (PriceByCase = 1 AND CaseQty = 0) THEN Price WHEN PriceByCase = 1 THEN Price / CaseQty ELSE Price END AS Expr1) 
                         AS Price, DepartmentID, StoreNo, SupplierName, ISNULL(OnTransferOrder, 0) AS OnTransfer, LinkNo, [Supplier Item Code], ItemType, Brand,CaseQty,ItemStoreID,MainDepartment
FROM            ItemMainAndStoreView
WHERE        (Status > 0)
GO