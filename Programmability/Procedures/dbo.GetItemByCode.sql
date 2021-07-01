SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemByCode] (@Code nvarchar(4000),
@StoreID uniqueidentifier,
@IsFashion bit = 0,
@SearchFromOrder bit = 0)
AS

  IF (SELECT
      COUNT(*)
    FROM Store
    WHERE StoreID = 'CECE2869-DEC8-4B9E-BE8B-D74CC24661A6')
    > 0

  BEGIN
    IF (SELECT
        COUNT(*)
      FROM ItemSearchView IMS
      WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
      AND StoreNo = @StoreID
      AND (BarcodeNumber LIKE @Code
      OR ModalNumber LIKE @Code + '%'))
      > 0
    BEGIN
      SELECT DISTINCT
        ImS.*
      FROM ItemSearchView IMS

      WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
      AND StoreNo = @StoreID
      AND (BarcodeNumber LIKE @Code
      OR ModalNumber LIKE @Code + '%'
      AND Status IS NOT NULL)
    END
    ELSE
    BEGIN

      SELECT DISTINCT
        IMS.*
      FROM ItemSearchView AS IMS
      INNER JOIN ItemAlias
        ON IMS.ItemID = ItemAlias.ItemNo
      WHERE (IMS.Status > 0)
      AND (IMS.StoreNo = @StoreID)
      AND (ItemAlias.BarcodeNumber LIKE @Code + '%'
      AND IMS.Status IS NOT NULL)

    END

  END

  ELSE
  IF @IsFashion = 0 or @SearchFromOrder=0
  BEGIN

    IF (SELECT
        COUNT(*)
      FROM ItemSearchView IMS
      WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
      AND StoreNo = @StoreID
      AND (BarcodeNumber LIKE @Code + '%'))
      > 0

    BEGIN
      SELECT
        *
      FROM ItemSearchView IMS
      WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
      AND StoreNo = @StoreID
      AND (BarcodeNumber LIKE @Code + '%'
      AND IMS.Status IS NOT NULL)

    END

    ELSE
    IF (LEN(@Code)) = 12
      AND ((SELECT
        COUNT(*)
      FROM ItemSearchView IMS
      WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
      AND IMS.Status IS NOT NULL
      AND StoreNo = @StoreID
      AND (BarcodeNumber LIKE SUBSTRING(@Code, 2, 10) + '%'))
      > 0)
    BEGIN
      SELECT
        *
      FROM ItemSearchView IMS
      WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
      AND StoreNo = @StoreID
      AND (BarcodeNumber LIKE SUBSTRING(@Code, 2, 10) + '%'
      AND IMS.Status IS NOT NULL)
    END
    ELSE
    IF (SELECT
        COUNT(*)
      FROM ItemAlias
      INNER JOIN ItemSearchView AS IMS
        ON ItemAlias.ItemNo = IMS.ItemID
      WHERE (IMS.Status > 0)
      AND (IMS.StoreNo = @StoreID)
      AND (ISNULL(ItemAlias.Status, 0) > 0
      AND ItemAlias.BarcodeNumber LIKE @Code + '%'
      AND IMS.Status IS NOT NULL))
      > 0
    BEGIN
      SELECT DISTINCT
        IMS.*
      FROM ItemSearchView AS IMS
      INNER JOIN ItemAlias
        ON IMS.ItemID = ItemAlias.ItemNo
      WHERE (IMS.Status > 0)
      AND (IMS.StoreNo = @StoreID)
      AND (ISNULL(ItemAlias.Status, 0) > 0
      AND ItemAlias.BarcodeNumber LIKE @Code + '%'
      AND IMS.Status IS NOT NULL)
    END
end 
	---
	ELSE  -- @IsFashion =1
    BEGIN
	  print 0
      IF (SELECT
          COUNT(*)
        FROM ItemSearchView IMS
        WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
        AND StoreNo = @StoreID
        --     AND itemtype = 2
        AND (BarcodeNumber = @Code))
        > 0

      BEGIN
	  print 11
        SELECT
          *
        FROM ItemSearchView IMS
        WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
        AND StoreNo = @StoreID
        AND (BarcodeNumber = @Code 
		  --     AND itemtype = 2
        AND IMS.Status IS NOT NULL)

      END
	 
      ELSE
	   print 33
      IF (LEN(@Code)) = 12
        AND ((SELECT
          COUNT(*)
        FROM ItemSearchView IMS
        WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
        AND IMS.Status IS NOT NULL
        AND StoreNo = @StoreID
		  --     AND itemtype = 2
        AND (BarcodeNumber LIKE SUBSTRING(@Code, 2, 10) + '%'))
        > 0)
      BEGIN
        SELECT
          *
        FROM ItemSearchView IMS
        WHERE IMS.Status > 0-- AND IMS.ItemType <> 1
        AND StoreNo = @StoreID
		  --     AND itemtype = 2
        AND (BarcodeNumber LIKE SUBSTRING(@Code, 2, 10) + '%'
        AND IMS.Status IS NOT NULL)
      END
      ELSE
      IF (SELECT
          COUNT(*)
        FROM ItemAlias
        INNER JOIN ItemSearchView AS IMS
          ON ItemAlias.ItemNo = IMS.ItemID
        WHERE (IMS.Status > 0)
        AND (IMS.StoreNo = @StoreID)
		  --     AND itemtype = 2
        AND (ISNULL(ItemAlias.Status, 0) > 0
        AND ItemAlias.BarcodeNumber LIKE @Code + '%'
        AND IMS.Status IS NOT NULL))
        > 0
      BEGIN
        SELECT DISTINCT
          IMS.*
        FROM ItemSearchView AS IMS
        INNER JOIN ItemAlias
          ON IMS.ItemID = ItemAlias.ItemNo
        WHERE (IMS.Status > 0)
		  --     AND itemtype = 2
        AND (IMS.StoreNo = @StoreID)
        AND (ISNULL(ItemAlias.Status, 0) > 0
        AND ItemAlias.BarcodeNumber LIKE @Code + '%'
        AND IMS.Status IS NOT NULL)
      END

    END


	----
GO