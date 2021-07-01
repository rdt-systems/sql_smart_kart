SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetItemByStyleNo]
(
	@StyleNo nvarchar(4000),
	@StoreID uniqueidentifier,
	@SupplierID uniqueidentifier = null,
	@ShowMatrix bit = 1,
	@IsFashion bit =0,
	@SearchFromOrder bit =0
)
as
BEGIN

	DECLARE @RowCount int

	If (Select Count(*) From Store Where StoreID = 'CECE2869-DEC8-4B9E-BE8B-D74CC24661A6') >0
	BEGIN
		-- 2. Search for single ItemCode result
		if @SupplierID is null 
		BEGIN
			select @RowCount = count(*) FROM ItemSearchView IMS
			where IMS.Status > 0 and IMS.ItemType <> 1 AND StoreNo = @StoreID AND (StyleNo = @StyleNo)

			IF @RowCount > 0 
			BEGIN
				SELECT * from ItemSearchView IMS
				where IMS.Status > 0  and IMS.ItemType <> 1
				AND StoreNo = @StoreID
				AND (StyleNo = @StyleNo)
				SET @RowCount = 0
			END
		END
		ELSE BEGIN
			select @RowCount = count(*) 
			from ItemSearchView IMS
			where IMS.Status > 0  and IMS.ItemType <> 1
			AND StoreNo = @StoreID
			AND (StyleNo = @StyleNo)
			AND itemStoreid IN(SELECT ItemStoreNo FROM itemsupply WHERE SupplierNo=@SupplierID)

			IF @RowCount > 0 
			BEGIN
				SELECT * from ItemSearchView IMS
				where IMS.Status > 0  and IMS.ItemType <> 1
				AND StoreNo = @StoreID
				AND (StyleNo = @StyleNo)
				AND itemStoreid IN(SELECT ItemStoreNo FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
				SET @RowCount = 0
			END
		END
	END
	ELSE
	if @IsFashion =0 or @SearchFromOrder=0
	begin
	BEGIN
		if @SupplierID is null 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE IMS.Status > 0  and IMS.ItemType <> 1 AND StoreNo = @StoreID	AND (StyleNo like'%'+ @StyleNo+'%')
			END
			ELSE
			BEGIN
			  SELECT * from ItemSearchView IMS
			  WHERE IMS.Status > 0 	 AND StoreNo = @StoreID AND (StyleNo like '%'+@StyleNo+'%')
			  AND IMS.ItemType<>1
			END
		END
		ELSE 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
									where IMS.Status > 0  and IMS.ItemType <> 1
										AND StoreNo = @StoreID
										AND (StyleNo like '%'+@StyleNo+'%')
										
										AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
			END
			ELSE
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE  IMS.Status > 0 AND StoreNo = @StoreID AND (StyleNo like  '%'+@StyleNo+'%') 
				       AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
					   AND IMS.ItemType<>1
			END
		END
	END
	end 
	else
	BEGIN
		if @SupplierID is null 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE IMS.Status > 0 and ItemType=2 AND StoreNo = @StoreID	AND (StyleNo = @StyleNo)
			END
			ELSE
			BEGIN
			  SELECT * from ItemSearchView IMS
			  WHERE IMS.Status > 0 	and ItemType=2 AND StoreNo = @StoreID AND (StyleNo =@StyleNo)
			  AND IMS.ItemType<>1
			END
		END
		ELSE 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
									where IMS.Status > 0  and IMS.ItemType <> 1
										AND StoreNo = @StoreID
										AND (StyleNo =@StyleNo)
										and ItemType=2
										AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
			END
			ELSE
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE  IMS.Status > 0  and IMS.ItemType <> 1 AND StoreNo = @StoreID AND (StyleNo= @StyleNo) and ItemType=2
				       AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
					   AND IMS.ItemType<>1
			END
		END
	END
END
GO