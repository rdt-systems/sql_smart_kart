SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetItemByModelNo]
(
	@ModelNo nvarchar(4000),
	@StoreID uniqueidentifier,
	@SupplierID uniqueidentifier = null,
	@ShowMatrix bit = 1,
	@IsFashion bit =0,
	@SearchFromOrder bit = 0
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
			where IMS.Status > 0 and IMS.ItemType <> 1 AND StoreNo = @StoreID AND (ModalNumber LIKE @ModelNo+'%')

			IF @RowCount > 0 
			BEGIN
				SELECT * from ItemSearchView IMS
				where IMS.Status > 0  and IMS.ItemType <> 1
				AND StoreNo = @StoreID
				AND (ModalNumber LIKE @ModelNo+'%')
				SET @RowCount = 0
			END
		END
		ELSE BEGIN
			select @RowCount = count(*) 
			from ItemSearchView IMS
			where IMS.Status > 0  and IMS.ItemType <> 1
			AND StoreNo = @StoreID
			AND (ModalNumber LIKE @ModelNo+'%')
			AND itemStoreid IN(SELECT ItemStoreNo FROM itemsupply WHERE SupplierNo=@SupplierID)

			IF @RowCount > 0 
			BEGIN
				SELECT * from ItemSearchView IMS
				where IMS.Status > 0  and IMS.ItemType <> 1
				AND StoreNo = @StoreID
				AND (ModalNumber LIKE @ModelNo+'%')
				AND itemStoreid IN(SELECT ItemStoreNo FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
				SET @RowCount = 0
			END
		END
	END
	ELSE
	if @IsFashion=0 or @SearchFromOrder=0
	BEGIN
		if @SupplierID is null 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE IMS.Status > 0 and IMS.ItemType <> 1 AND StoreNo = @StoreID	AND (ModalNumber LIKE '%'+@ModelNo+'%')
			END
			ELSE
			BEGIN
			  SELECT * from ItemSearchView IMS
			  WHERE IMS.Status > 0 and IMS.ItemType <> 1 	AND StoreNo = @StoreID AND (ModalNumber LIKE '%'+@ModelNo+'%')
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
										AND (ModalNumber LIKE '%'+@ModelNo+'%')
										AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
			END
			ELSE
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE  IMS.Status > 0  and IMS.ItemType <> 1 AND StoreNo = @StoreID AND (ModalNumber LIKE '%'+@ModelNo+'%')
				       AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
					   AND IMS.ItemType<>1
			END
		END
	END
	else
	
	BEGIN
		if @SupplierID is null 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE IMS.Status > 0
				 AND StoreNo = @StoreID	
				 and ItemType=2
				 AND (ModalNumber  =@ModelNo)
			END
			ELSE
			BEGIN
			  SELECT * from ItemSearchView IMS
			  WHERE IMS.Status > 0  and ItemType=2	AND StoreNo = @StoreID AND (ModalNumber = @ModelNo)
			  AND IMS.ItemType<>1
			END
		END
		ELSE 
		BEGIN
			IF @ShowMatrix =1 
			BEGIN
				SELECT * from ItemSearchView IMS
									where IMS.Status > 0 
										AND StoreNo = @StoreID
										AND (ModalNumber = @ModelNo)
										 and ItemType=2
										AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
			END
			ELSE
			BEGIN
				SELECT * from ItemSearchView IMS
				WHERE  IMS.Status > 0 AND StoreNo = @StoreID  and ItemType=2
				AND (ModalNumber = @ModelNo)
				       AND itemStoreid IN(SELECT ItemStoreNo  FROM itemsupply WHERE SupplierNo=@SupplierID and Status>0)
					   AND IMS.ItemType<>1
			END
		END
	END
END
GO