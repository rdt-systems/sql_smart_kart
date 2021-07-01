SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemListBySupplier]
(
	@StoreID uniqueidentifier,
	@SupplierID uniqueidentifier = null
)
AS
	SELECT DISTINCT ISUP.ItemCode, IMS.Name, IMS.BarcodeNumber, IMS.ModalNumber, IMS.ItemStoreID
	FROM         ItemMainAndStoreView AS IMS INNER JOIN
						  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
	WHERE     (IMS.Status > 0) AND (ISUP.Status > - 1)	
					AND (StoreNo = @StoreID) AND (SupplierNo = @SupplierID)
GO