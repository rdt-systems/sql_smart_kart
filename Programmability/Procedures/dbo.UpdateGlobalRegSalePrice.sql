SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateGlobalRegSalePrice]
(@AllStores bit,
 @ModifierID UniqueIdentifier,
 @RegSalePrice money = NULL,
 @RegPkgQtyQty int = NULL,
 @RegPkgPrice money = NULL,
 @CasePrice money = NULL,
 @SPIsSpecial bit = NULL,
 @PkgIsSpecial bit = NULL,
 @CSIsSpecial bit = NULL)
as


IF @AllStores = 1 BEGIN
	IF @RegSalePrice IS NOT NULL
Begin
	UPDATE ItemStore SET RegSalePrice =@RegSalePrice ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @RegPkgQtyQty  IS NOT NULL
Begin
	UPDATE ItemStore SET PkgQty =@RegPkgQtyQty  ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @RegPkgPrice  IS NOT NULL
Begin
	UPDATE ItemStore SET PkgPrice =@RegPkgPrice  ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @CasePrice  IS NOT NULL
Begin
	UPDATE ItemStore SET CasePrice =@CasePrice  ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @SPIsSpecial  IS NOT NULL
Begin
	UPDATE ItemStore SET IsPkgDiscount =@SPIsSpecial  ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @PkgIsSpecial   IS NOT NULL
Begin
	UPDATE ItemStore SET IsPkgDiscount =@PkgIsSpecial  ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @CSIsSpecial   IS NOT NULL
Begin
	UPDATE ItemStore SET IsCaseDiscount =@PkgIsSpecial   ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
END
ELSE IF @AllStores = 0 BEGIN
	IF @RegSalePrice IS NOT NULL
Begin
	UPDATE ItemStore SET RegSalePrice =@RegSalePrice ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @RegPkgQtyQty  IS NOT NULL
Begin
	UPDATE ItemStore SET PkgQty =@RegPkgQtyQty  ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @RegPkgPrice  IS NOT NULL
Begin
	UPDATE ItemStore SET PkgPrice =@RegPkgPrice  ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @CasePrice  IS NOT NULL
Begin
	UPDATE ItemStore SET CasePrice =@CasePrice  ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @SPIsSpecial  IS NOT NULL
Begin
	UPDATE ItemStore SET IsPkgDiscount =@SPIsSpecial  ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @PkgIsSpecial   IS NOT NULL
Begin
	UPDATE ItemStore SET IsPkgDiscount =@PkgIsSpecial  ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
IF @CSIsSpecial   IS NOT NULL
Begin
	UPDATE ItemStore SET IsCaseDiscount =@PkgIsSpecial   ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
End
GO