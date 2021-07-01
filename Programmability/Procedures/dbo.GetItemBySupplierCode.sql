SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetItemBySupplierCode]
(
	@Code nvarchar(4000),
	@StoreID uniqueidentifier,
	@SupplierID uniqueidentifier = NULL,
	@IsFashion bit =0,
	@SearchFromOrder bit =0
)
AS
DECLARE @RowCount int
if @IsFashion =0 or @SearchFromOrder =0
begin 

 --1. Search for single exact match BarcodeNumber or ModelNumber result
 IF @SupplierID IS NULL 
 BEGIN
	SELECT @RowCount = count(*) 
	FROM      ItemSearchView AS IMS INNER JOIN
						  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
	WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
			AND (ISUP.Status > 0)		
			AND StoreNo = @StoreID
			AND (ISUP.ItemCode = @Code)
	IF @RowCount >0 
	BEGIN
		SELECT distinct ISUP.ItemCode, IMS.*
		FROM      ItemSearchView AS IMS INNER JOIN
							  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)		
				AND StoreNo = @StoreID
				AND (ISUP.ItemCode = @Code)
	END
	ELSE
	BEGIN
		SELECT distinct ISUP.ItemCode, IMS.*
		FROM      ItemSearchView AS IMS INNER JOIN
							  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)		
				AND StoreNo = @StoreID
				AND (ISUP.ItemCode LIKE '%'+@Code+'%')
	END 
 END

 ELSE BEGIN
	select @RowCount = count(*) 
	FROM      ItemSearchView AS IMS INNER JOIN
						  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
	WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
			AND (ISUP.Status > 0)		
			AND StoreNo = @StoreID
			AND (SupplierNo = @SupplierID)
			AND (ISUP.ItemCode = @Code)
	IF @RowCount = 1 
	BEGIN
		SELECT DISTINCT 
                         ISUP.ItemCode, IMS.*, ISUP.MaxQty AS SuppMaxQty, ISUP.MinQty AS SuppMinQty, ISUP.OnSpecialReq AS SuppOnSpecialReq, ISUP.ToDate AS SuppToDate, 
                         ISUP.FromDate AS SuppFromDate, ISUP.AssignDate AS SuppAssignDate, ISUP.CaseQty AS SuppCaseQty, ISUP.SalePrice AS SuppSalePrice
FROM            ItemSearchView AS IMS INNER JOIN
                         ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)		
				AND StoreNo = @StoreID
				AND (SupplierNo = @SupplierID)
				AND (ISUP.ItemCode = @Code)
	END
	ELSE
	BEGIN
				SELECT DISTINCT 
                         ISUP.ItemCode, IMS.*, ISUP.MaxQty AS SuppMaxQty, ISUP.MinQty AS SuppMinQty, ISUP.OnSpecialReq AS SuppOnSpecialReq, ISUP.ToDate AS SuppToDate, 
                         ISUP.FromDate AS SuppFromDate, ISUP.AssignDate AS SuppAssignDate, ISUP.CaseQty AS SuppCaseQty, ISUP.SalePrice AS SuppSalePrice
		FROM      ItemSearchView AS IMS INNER JOIN
							  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)		
				AND StoreNo = @StoreID
				AND (SupplierNo = @SupplierID)
				AND (ISUP.ItemCode LIKE '%'+@Code+'%')
	END
END
END

else --fashion
begin 

 --1. Search for single exact match BarcodeNumber or ModelNumber result
 IF @SupplierID IS NULL 
 BEGIN
	SELECT @RowCount = count(*) 
	FROM      ItemSearchView AS IMS INNER JOIN
						  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
	WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
			AND (ISUP.Status > 0)		
			and itemtype=2
			AND StoreNo = @StoreID
			AND (ISUP.ItemCode = @Code)
	IF @RowCount >0 
	BEGIN
		SELECT distinct ISUP.ItemCode, IMS.*
		FROM      ItemSearchView AS IMS INNER JOIN
							  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)
				and itemtype=2		
				AND StoreNo = @StoreID
				AND (ISUP.ItemCode = @Code)
	END
	ELSE
	BEGIN
		SELECT distinct ISUP.ItemCode, IMS.*
		FROM      ItemSearchView AS IMS INNER JOIN
							  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)	
				and itemtype=2	
				AND StoreNo = @StoreID
				AND (ISUP.ItemCode =  @Code)
	END 
 END

 ELSE BEGIN
	select @RowCount = count(*) 
	FROM      ItemSearchView AS IMS INNER JOIN
						  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
	WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
			AND (ISUP.Status > 0)		
			AND StoreNo = @StoreID
			AND (SupplierNo = @SupplierID)
			and itemtype=2
			AND (ISUP.ItemCode = @Code)
	IF @RowCount = 1 
	BEGIN
		SELECT DISTINCT 
                         ISUP.ItemCode, IMS.*, ISUP.MaxQty AS SuppMaxQty, ISUP.MinQty AS SuppMinQty, ISUP.OnSpecialReq AS SuppOnSpecialReq, ISUP.ToDate AS SuppToDate, 
                         ISUP.FromDate AS SuppFromDate, ISUP.AssignDate AS SuppAssignDate, ISUP.CaseQty AS SuppCaseQty, ISUP.SalePrice AS SuppSalePrice
FROM            ItemSearchView AS IMS INNER JOIN
                         ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)		
				AND StoreNo = @StoreID
				and itemtype=2
				AND (SupplierNo = @SupplierID)
				AND (ISUP.ItemCode = @Code)
	END
	ELSE
	BEGIN
				SELECT DISTINCT 
                         ISUP.ItemCode, IMS.*, ISUP.MaxQty AS SuppMaxQty, ISUP.MinQty AS SuppMinQty, ISUP.OnSpecialReq AS SuppOnSpecialReq, ISUP.ToDate AS SuppToDate, 
                         ISUP.FromDate AS SuppFromDate, ISUP.AssignDate AS SuppAssignDate, ISUP.CaseQty AS SuppCaseQty, ISUP.SalePrice AS SuppSalePrice
		FROM      ItemSearchView AS IMS INNER JOIN
							  ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE  (IMS.Status > 0)  and IMS.ItemType <> 1
				AND (ISUP.Status > 0)		
				AND StoreNo = @StoreID
				and itemtype=2
				AND (SupplierNo = @SupplierID)
				AND (ISUP.ItemCode = @Code)
	END
END
END
GO