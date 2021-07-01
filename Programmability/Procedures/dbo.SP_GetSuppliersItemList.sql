SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetSuppliersItemList]
(@StoreID uniqueidentifier,
 @SupplierID uniqueidentifier=null)
as

if @supplierID is not null 
SELECT    DISTINCT    ITMS.ItemID, ITMS.ItemStoreID, ITMS.Name, ITMS.BarcodeNumber, ITMS.ModalNumber, ITMS.Cost, ITMS.ItemType, ITMS.LinkNo, 0 AS QtyToOrder, ITMS.Status, 
                         ItemSupply.ItemCode AS [Supplier Code], 0 AS ChildOrderd, CASE WHEN ISNULL(ITMS.CaseQty, 1) > 0 THEN ITMS.CaseQty ELSE 1 END AS CaseQty, ITMS.Brand, ITMS.Size, ITMS.Department, 
                          ITMS.poBy AS PrefOrderBy, ITMS.ItemAlias, ITMS.OnHand, ITMS.StyleNo, ITMS.OnOrder
FROM            ItemMainAndStoreList AS ITMS INNER JOIN
                        ItemSupply ON ITMS.ItemStoreID = ItemSupply.ItemStoreNo AND ItemSupply.SupplierNo = @SupplierID AND ItemSupply.Status > - 1
WHERE        (ITMS.Status > 0) AND (ITMS.StoreNo = @StoreID)
else
	SELECT DISTINCT 
						  ITMS.ItemID, ITMS.ItemStoreID, ITMS.Name, ITMS.BarcodeNumber, ITMS.ModalNumber, ITMS.Cost, ITMS.ItemType, ITMS.LinkNo, 0 AS QtyToOrder, 
						  ITMS.Status, ItemSupply.ItemCode AS [Supplier Code], 0 AS ChildOrderd, CASE WHEN ISNULL(ITMS.CaseQty, 1) 
						  > 0 THEN ITMS.CaseQty ELSE 1 END AS CaseQty, ITMS.Brand, ITMS.Size, ITMS.Department, ITMS.poBy AS PrefOrderBy, ITMS.ItemAlias, ITMS.OnHand, ITMS.StyleNo, ITMS.OnOrder
	FROM         ItemMainAndStoreList AS ITMS   LEFT OUTER JOIN
						  ItemSupply ON ITMS.ItemStoreID = ItemSupply.ItemStoreNo
	WHERE     (ITMS.Status > 0) AND (ITMS.StoreNo = @StoreID)
GO