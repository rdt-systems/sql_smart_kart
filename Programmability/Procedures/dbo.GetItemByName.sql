SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetItemByName]
(
	@Name nvarchar(4000),
	@StoreID uniqueidentifier,
	@SupplierID uniqueidentifier =null,
	@IsFashion bit =0,
	@SearchFromOrder bit =0 
)
as 
BEGIN

DECLARE @RowCount int

-- 1. Search for single exact match BarcodeNumber or ModelNumber result
--select @RowCount = count(*) 
--from ItemSearchView IMS
--where IMS.Status > 0 
--	AND StoreNo = @StoreID
--	AND (Name = @Name)
--IF @RowCount = 1 
--BEGIN
--	SELECT * from ItemSearchView IMS
--	where IMS.Status > 0 
--		AND StoreNo = @StoreID
--		AND (Name = @Name)
--	SET @RowCount = 0
--END
--ELSE
--BEGIN

-- 2. Search for single ItemCode result
	--select @RowCount = count(*) 
	--from ItemSearchView IMS
	--where IMS.Status > 0 
	--AND StoreNo = @StoreID
	--AND (Name LIKE '%'+@Name+'%')
	--IF @RowCount > 0 
	--BEGIN
	if @IsFashion=0 or @SearchFromOrder=0
	begin  

	  IF @SupplierID IS NULL
	  BEGIN
		SELECT * from ItemSearchView IMS
		where IMS.Status > 0 
			AND StoreNo = @StoreID
			AND (Name LIKE '%'+@Name+'%')
	  END
	  ELSE BEGIN
	    SELECT * from ItemSearchView IMS
		where IMS.Status > 0 
			AND StoreNo = @StoreID
			AND (Name LIKE '%'+@Name+'%')
			and itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID)
	  END
	  end 
	  
else
	  begin
	  IF @SupplierID IS NULL
	  BEGIN
		SELECT * from ItemSearchView IMS
		where IMS.Status > 0 
			AND StoreNo = @StoreID
			--and IMS.ItemType=2
			AND (Name = @Name)
	  END
	  ELSE BEGIN
	    SELECT * from ItemSearchView IMS
		where IMS.Status > 0 
			AND StoreNo = @StoreID
				--and IMS.ItemType=2
				AND (Name = @Name)
			and itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID)
	  END
	  end
	  
END
GO