SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- IF (exact UPC rows) = 1
--	Return row
-- ELSEIF (exact ItemCode rows) = 1
--	Return row
-- ELSEIF (like UPC rows) = 1
--	Return row
-- ELSEIF (like ItemCode rows) = 1
--  Return row

-- ELSE
--  Return set of all like UPCs and like ItemCodes for this supplier

CREATE procedure [dbo].[GetItemByCodeAndSupplier]
(
	@Code nvarchar(4000),
	@StoreID uniqueidentifier,
	@SupplierID uniqueidentifier = NULL,
	@IsFashion bit =0,
	@SearchFromOrder bit = 0
)
AS
BEGIN
	If (Select Count(*) From Store Where StoreID = 'CECE2869-DEC8-4B9E-BE8B-D74CC24661A6') >0
	Begin
		IF (SELECT COUNT(*) from ItemSearchView IMS
		INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo where IMS.Status > 0 AND ISUP.Status >-1 and IMS.ItemType <> 1
		 AND StoreNo = @StoreID AND ISUP.SupplierNo = @SupplierID AND (BarcodeNumber like @Code OR ModalNumber Like @Code+'%'))>0 
		BEGIN

		SELECT * FROM            ItemSearchView AS IMS INNER JOIN
								 ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
		WHERE        (IMS.Status > 0) AND (ISUP.Status > - 1) and IMS.ItemType <> 1 AND (IMS.StoreNo = @StoreID) AND (ISUP.SupplierNo = @SupplierID) AND (BarcodeNumber like @Code OR ModalNumber Like @Code+'%' and IMS.Status is not null) 
		END

		ELSE BEGIN
			SELECT * FROM            ItemSearchView AS IMS INNER JOIN
									 ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo INNER JOIN
									 ItemAlias ON IMS.ItemID = ItemAlias.ItemNo
			WHERE        (IMS.Status > 0) AND (ISUP.Status > - 1) and IMS.ItemType <> 1 AND (IMS.StoreNo = @StoreID) AND (ISUP.SupplierNo = @SupplierID) AND (ItemAlias.BarcodeNumber Like @Code+'%' and IMS.Status is not null)
		END
	END

	ELSE 
	if @IsFashion=0  or @SearchFromOrder=0
	BEGIN

		IF (SELECT COUNT(*) from ItemSearchView IMS
			INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo where IMS.Status > 0 AND ISUP.Status >-1 and IMS.ItemType <> 1
			AND StoreNo = @StoreID AND ISUP.SupplierNo = @SupplierID AND (BarcodeNumber Like @Code+'%'))>0 
		BEGIN

			SELECT * FROM            ItemSearchView AS IMS INNER JOIN
									 ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
			WHERE        (IMS.Status > 0) AND (ISUP.Status > - 1) and IMS.ItemType <> 1 AND (IMS.StoreNo = @StoreID) AND (ISUP.SupplierNo = @SupplierID) AND (BarcodeNumber Like @Code+'%' and IMS.Status is not null)
		END

		ELSE BEGIN
			SELECT * FROM            ItemSearchView AS IMS INNER JOIN
									 ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo INNER JOIN
									 ItemAlias ON IMS.ItemID = ItemAlias.ItemNo
			WHERE        (IMS.Status > 0) AND (ISUP.Status > - 1) and IMS.ItemType <> 1 AND (IMS.StoreNo = @StoreID) AND (ISUP.SupplierNo = @SupplierID) AND  (ItemAlias.BarcodeNumber Like @Code+'%' and IMS.Status is not null)  
		END
	END
	else
	BEGIN

		IF (SELECT COUNT(*) from ItemSearchView IMS
			INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo where IMS.Status > 0 AND ISUP.Status >-1
			and ItemType=2 AND StoreNo = @StoreID AND ISUP.SupplierNo = @SupplierID AND (BarcodeNumber = @Code))>0 
		BEGIN

			SELECT * FROM            ItemSearchView AS IMS INNER JOIN
									 ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo
			WHERE        (IMS.Status > 0) AND (ISUP.Status > - 1) and IMS.ItemType <> 1 AND (IMS.StoreNo = @StoreID) AND (ISUP.SupplierNo = @SupplierID) AND (BarcodeNumber = @Code and ItemType=2 and IMS.Status is not null)
		END

		ELSE BEGIN
			SELECT * FROM            ItemSearchView AS IMS INNER JOIN
									 ItemSupply AS ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo INNER JOIN
									 ItemAlias ON IMS.ItemID = ItemAlias.ItemNo
			WHERE        (IMS.Status > 0) AND (ISUP.Status > - 1) and IMS.ItemType <> 1 AND (IMS.StoreNo = @StoreID) AND (ISUP.SupplierNo = @SupplierID) AND  (ItemAlias.BarcodeNumber = @Code and ItemType=2 and IMS.Status is not null)  
		END
	END
END
-- 1. Search for single exact match BarcodeNumber or ModelNumber result
--select @RowCount = count(*) 
--from ItemSearchView IMS
--	INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--where IMS.Status > 0 AND ISUP.Status > -1
--	AND StoreNo = @StoreID
--	AND SupplierNo = @SupplierID
--	AND (BarcodeNumber = @Code OR ModalNumber = @Code)
--IF @RowCount = 1 
--BEGIN
--	SELECT * from ItemSearchView IMS
--		INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--	where IMS.Status > 0 AND ISUP.Status > -1
--		AND StoreNo = @StoreID
--		AND SupplierNo = @SupplierID
--		AND (BarcodeNumber = @Code OR ModalNumber = @Code)
--	SET @RowCount = 0
--END
--ELSE
--BEGIN
--
---- 2. Search for single ItemCode result
--select @RowCount = count(*) 
--from ItemSearchView IMS
--	INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--where IMS.Status > 0 AND ISUP.Status > -1
--	AND StoreNo = @StoreID
--	AND SupplierNo = @SupplierID
--	AND (ISUP.ItemCode = @Code)
--IF @RowCount = 1 
--BEGIN
--	SELECT * from ItemSearchView IMS
--		INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--	where IMS.Status > 0 AND ISUP.Status > -1
--		AND StoreNo = @StoreID
--		AND SupplierNo = @SupplierID
--		AND (ISUP.ItemCode = @Code)
--	SET @RowCount = 0
--END
--ELSE
--BEGIN
---- 3. Search for single matching BarcodeNumber or ModelNumber result
--select @RowCount = count(*) 
--from ItemSearchView IMS
--	INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--where IMS.Status > 0 AND ISUP.Status > -1
--AND StoreNo = @StoreID
--AND SupplierNo = @SupplierID
--AND (BarcodeNumber like @Code + '%' OR ModalNumber like @Code + '%')
--IF @RowCount = 1 
--BEGIN
--	SELECT * from ItemSearchView IMS
--		INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--	where IMS.Status > 0 AND ISUP.Status > -1
--		AND StoreNo = @StoreID
--		AND SupplierNo = @SupplierID
--		AND (BarcodeNumber like @Code + '%' OR ModalNumber like @Code + '%')
--	SET @RowCount = 0
--END
--ELSE
--BEGIN
---- 4. Search for single matching ItemCode
--select @RowCount = count(*) 
--from ItemSearchView IMS
--	INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--where IMS.Status > 0 AND ISUP.Status > -1
--	AND StoreNo = @StoreID
--	AND SupplierNo = @SupplierID
--	AND (ISUP.ItemCode like @Code + '%')
--IF @RowCount = 1 
--BEGIN
--	SELECT * from ItemSearchView IMS
--		INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--	where IMS.Status > 0 AND ISUP.Status > -1
--		AND StoreNo = @StoreID
--		AND SupplierNo = @SupplierID
--		AND (ISUP.ItemCode like @Code + '%')
--	SET @RowCount = 0
--END
--ELSE
--BEGIN
---- 5. Return set of all like UPCs and like ItemCodes for this supplier
--SELECT * from ItemSearchView IMS
--	INNER JOIN ItemSupply ISUP ON IMS.ItemStoreID = ISUP.ItemStoreNo 
--where IMS.Status > 0 AND ISUP.Status > -1
--	AND StoreNo = @StoreID
--	AND SupplierNo = @SupplierID
--	AND (BarcodeNumber like @Code + '%' OR ModalNumber like @Code + '%' OR ISUP.ItemCode like @Code + '%')
--
--
--END
--END
--END
--END
--
--END
GO