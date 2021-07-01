SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sp_GetItemsList_new]
(@StoreID nvarchar(50)=null,
 @OnlyDiffPrice bit=0,
 @Date Datetime =null )
AS 

if @Date is null 
begin 
set @Date =dbo.GetLocalDATE()
end

	IF @OnlyDiffPrice=0  
	BEGIN

	select 

	 ta.ItemID, ta.Name, ta.ModalNumber, ta.BarcodeNumber, ta.OnOrder, ta.OnHandCalc as OnHand, ta.Department, 

		 (SELECT        CASE WHEN (ta.CaseQty IS NULL) THEN ta.OnHandCalc
		  WHEN (CaseQty = 0) 
		 THEN ta.OnHandCalc ELSE ta.OnHandCalc / CaseQty END AS Expr1) AS OnHandCase,
								 ta.Cost, ta.Price, ta.Cost * ta.OnHandCalc AS ExtCost, ta.Price * ta.OnHandCalc AS ExtPrice, 
								 ta.StoreName, ta.StoreID, ta.SupplierName, ta.OnTransfer, ta.ParentCode, 
								 ta.SupplierCode, Brand
	from (
		SELECT        ItemPiece.ItemID, ItemPiece.Name, ItemPiece.ModalNumber, ItemPiece.BarcodeNumber, ItemPiece.OnOrder, dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date) as OnHand, ItemPiece.Department,ItemPiece.Cost, ItemPiece.Price, 
								 Store.StoreName, Store.StoreID, ItemPiece.SupplierName, ItemPiece.OnTransfer, ParentInfo.[Supplier Item Code] AS ParentCode, 
								 ItemPiece.[Supplier Item Code] As SupplierCode, Brand,
								 dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date) as OnHandCalc,CaseQty
		FROM            ItemPiece INNER JOIN
								 Store ON Store.StoreID = ItemPiece.StoreNo LEFT OUTER JOIN
									 (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code]
									   FROM            ItemMainAndStoreView AS ItemMainAndStoreView_1) AS ParentInfo ON ItemPiece.StoreNo = ParentInfo.StoreNo AND 
								 ItemPiece.LinkNo = ParentInfo.ItemID
        WHERE ItemPiece.ItemType <> 2 AND (ItemPiece.StoreNo =@StoreID  or @StoreID is null) AND ISNULL(OnHand,0) <> 0
		) as ta
	END 
	ELSE
	BEGIN

	SELECT     ta.ItemID,
 					ta.Name, 
					ta.ModalNumber,
					ta.BarcodeNumber, 
					ta.OnOrder, 
					ta.OnHandCalc as OnHand ,  
					ta.Department,
					(SELECT        CASE WHEN (ta.CaseQty IS NULL) THEN ta.OnHandCalc
		  WHEN (ta.CaseQty = 0) 
		 THEN ta.OnHandCalc ELSE ta.OnHandCalc / ta.CaseQty END AS Expr1)  OnHandCase, 
					ta.Cost,
					ta.Price, 
					ta.Cost * ta.OnHandCalc AS ExtCost, 
					ta.Price * ta.OnHandCalc AS ExtPrice,
					ta.StoreName,
					ta.SupplierName,
					ta.StoreID

					from (
		SELECT     dbo.ItemPiece.ItemID,
 					Name, 
					ModalNumber,
					BarcodeNumber, 
					OnOrder, 
					dbo.GetItemOnHand(ItemPiece.itemStoreId,@Date) as OnHandCalc,  
					Department,
					Cost,
					Price, 
					Store.StoreName,
					ItemPiece.SupplierName,
					Store.StoreID,
					CaseQty
		FROM       dbo.ItemPiece inner join 
					(SELECT ItemID FROM (SELECT ItemID FROM dbo.ItemPiece
					GROUP BY ItemID,Price) AS Items 
					GROUP BY ItemID HAVING count(*)>1) AS AllItems
					ON AllItems.ItemID=dbo.ItemPiece.ItemID inner join 
					Store ON Store.StoreID=dbo.ItemPiece.StoreNo
		WHERE   ItemPiece.ItemType <> 2 AND  (StoreNo = @StoreID Or @StoreID is null) AND ISNULL(OnHand,0) <> 0) as ta
	END
GO