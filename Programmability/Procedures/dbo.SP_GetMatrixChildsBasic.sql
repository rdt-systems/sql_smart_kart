SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetMatrixChildsBasic]
(@ID uniqueidentifier,
 @StoreID as uniqueidentifier = Null)
AS
	IF @StoreID IS NULL BEGIN
		SELECT     ItemMain.ItemID, ItemMain.Name, ItemMain.BarcodeNumber, ItemMain.Matrix1, ItemMain.Matrix2, ItemMain.Matrix3, ItemMain.Matrix4, ItemStore.Price, ItemStore.Cost,
		 0 AS Field,ItemStore.ItemStoreID, ItemMain.ModalNumber, ItemStore.OnHand, ItemMain.StyleNo,ItemStore.NetCost,ItemStore.SpecialCost,ItemStore.Estimatedcost,ItemMain.LinkNo
		FROM         ItemMain LEFT OUTER JOIN ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
		WHERE     (ItemMain.LinkNo = @ID) AND (ItemMain.Status > 0)
		ORDER BY ItemMain.Matrix1, ItemMain.Matrix2, ItemMain.Matrix3
		
		--SELECT     ItemID, Name, ListPrice, SUM(OnHand) AS OnHand, BarcodeNumber, SUM(OnOrder) AS OnOrder, SUM(OnTransferOrder) AS OnTransferOrder, Matrix1, Matrix2, 
		--					  Matrix3, Matrix4
		--FROM         ItemMainAndStoreView
		--WHERE LinkNo=@ID And Status>0 
		--GROUP BY ItemID, Name, ListPrice, BarcodeNumber, Matrix1, Matrix2, Matrix3, Matrix4

		--Order by Name 
	END
	ELSE BEGIN
SELECT        ItemMain.ItemID, ItemMain.Name, ItemMain.BarcodeNumber, ItemMain.Matrix1, ItemMain.Matrix2, ItemMain.Matrix3, ItemMain.Matrix4, 0 AS Field,  ItemStore.Price, ItemStore.Cost,
                         ItemStore.ItemStoreID, ItemMain.ModalNumber, ItemStore.OnHand , ItemMain.StyleNo,IsNull(ItemStore.ReorderPoint,0)As ReorderPoint, Isnull(ItemStore.RestockLevel,0) As RestockLevel,ItemStore.NetCost,ItemStore.SpecialCost,ItemStore.Estimatedcost,ItemMain.LinkNo
FROM            ItemMain LEFT OUTER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
		WHERE     (ItemMain.LinkNo = @ID) AND (ItemMain.Status > 0) AND (ItemStore.Status > 0) AND StoreNo =@StoreID
		ORDER BY ItemMain.Matrix1, ItemMain.Matrix2, ItemMain.Matrix3
		
		--SELECT     ItemID, Name, ListPrice, Price, OnHand,  BarcodeNumber, Cost, OnOrder, OnTransferOrder, BinLocation, [Pc Cost], Matrix1, 
		--			Matrix2,Matrix3, Matrix4, [SP Price],Markup, Margin
		--FROM         ItemMainAndStoreView
		--where LinkNo=@ID And Status>0 AND StoreNo =@StoreID
	END
GO