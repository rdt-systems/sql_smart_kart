SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE      view [dbo].[FullItemNames]
as

SELECT  cast ( dbo.ItemStore.ItemStoreID as varchar(50))ItemStoreID, dbo.ItemMain.ItemType,
          RTRIM (dbo.ItemMain.Name 
	/*	+ ' ' + ISNULL(
	          ( SELECT TOP 1 ISNULL(MatrixVaiueAndItemView.DisplayValue,'') + ' ' + 
	            ISNULL(MatrixVaiueAndItemView_1.DisplayValue,'') AS DispalyBoth
	            FROM         MatrixVaiueAndItemView
	            CROSS JOIN 
	            dbo.MatrixVaiueAndItemView AS MatrixVaiueAndItemView_1
	            WHERE   MatrixVaiueAndItemView.DisplayValue <> MatrixVaiueAndItemView_1.DisplayValue AND 
	            MatrixVaiueAndItemView.itemno = dbo.ItemMain.ItemID
	            AND MatrixVaiueAndItemView_1.itemno = dbo.ItemMain.ItemID 
		    ORDER BY DispalyBoth DESC)
              	, '')  */
           )AS FullName,
           dbo.ItemMain.BarcodeNumber, dbo.ItemMain.ModalNumber, 
           dbo.ItemStore.StoreNo, dbo.ItemMain.Status AS MainStatus, dbo.ItemStore.Status AS StoreStatus,ItemMain.ItemID

FROM       dbo.ItemMain INNER JOIN
           dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo

WHERE dbo.ItemMain.ItemType<>2 --Do not display Matrix Father
GO