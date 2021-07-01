SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaveCost]
(   
    @ItemID uniqueidentifier =NULL,
    @ItemStoreID uniqueidentifier,
	@CaseCost money,
	@PCCost money,
	@NetCaseCost money=null ,
	@NetPCCost money=null,
	@CaseQty int =0,
	@SupplierID uniqueidentifier = null,
	@PrefOrderBy int = null
)
AS
    IF @CaseCost =0
      Return
	IF @PrefOrderBy IS NULL
	BEGIN
		if (Select IsNull(PrefOrderBy,2) From ItemStore WHERE ItemStoreID = @ItemStoreID) = 2
		BEGIN
			IF @ITEMID IS not NULL
			BEGIN
				UPDATE ItemStore Set Cost = isNull(@NetCaseCost,@CaseCost) ,RegCost = @CaseCost,DateModified =dbo.GetLocalDATE() WHERE ItemNo = @ItemID
			END
			ELSE
			BEGIN 
				UPDATE ItemStore Set Cost = isNull(@NetCaseCost,@CaseCost) ,RegCost = @CaseCost,DateModified =dbo.GetLocalDATE() WHERE ItemStoreID  = @ItemStoreID 
			END
		END
		ELSE BEGIN
			IF @ITEMID IS not NULL
			BEGIN
				UPDATE ItemStore Set Cost = IsNull(@NetPcCost,@PcCost),RegCost =@PcCost ,DateModified =dbo.GetLocalDATE() WHERE ItemNo = @ItemID
			END
			ELSE 
			BEGIN
				UPDATE ItemStore Set Cost = IsNull(@NetPcCost,@PcCost),RegCost =@PcCost ,DateModified =dbo.GetLocalDATE() WHERE ItemStoreID  = @ItemStoreID
			END
		END 
	END
	ELSE
	BEGIN
		if @PrefOrderBy = 2
		BEGIN
			IF @ITEMID IS not NULL
			BEGIN
				UPDATE ItemStore Set Cost = isNull(@NetCaseCost,@CaseCost) ,RegCost = @CaseCost,DateModified =dbo.GetLocalDATE(),PrefOrderBy =@PrefOrderBy  WHERE ItemNo = @ItemID
			END
			ELSE
			BEGIN 
				UPDATE ItemStore Set Cost = isNull(@NetCaseCost,@CaseCost) ,RegCost = @CaseCost,DateModified =dbo.GetLocalDATE(),PrefOrderBy =@PrefOrderBy WHERE ItemStoreID  = @ItemStoreID 
			END
		END
		ELSE BEGIN
			IF @ITEMID IS not NULL
			BEGIN
				UPDATE ItemStore Set Cost = IsNull(@NetPcCost,@PcCost),RegCost =@PcCost ,DateModified =dbo.GetLocalDATE(),PrefOrderBy =@PrefOrderBy WHERE ItemNo = @ItemID
			END
			ELSE 
			BEGIN
				UPDATE ItemStore Set Cost = IsNull(@NetPcCost,@PcCost),RegCost =@PcCost ,DateModified =dbo.GetLocalDATE(),PrefOrderBy =@PrefOrderBy WHERE ItemStoreID  = @ItemStoreID
			END
		END 
	END

	Declare @IsCase bit
	if  @PrefOrderBy = 2
	  SET  @IsCase = 1
	ELSE
	  SET @IsCase = 0

	if @CaseQty > 0
	BEGIN
		UPDATE ItemMain SET CaseQty =@CaseQty,CostByCase =@IsCase  WHERE ItemID =@ItemID
	END
	
	IF @SupplierID is not null 
	BEGIN
		UPDATE ItemSupply Set GrossCost = @CaseCost,DateModified =dbo.GetLocalDATE() WHERE ItemStoreNo =@ItemStoreID and SupplierNo =@SupplierID
	END

	--if (Select IsNull(PrefOrderBy,2) From ItemStore WHERE ItemStoreID = @ItemStoreID) = 2
	--BEGIN
	--	IF @ITEMID IS not NULL
	--	BEGIN
	--		UPDATE ItemStore Set Cost = @CaseCost ,RegCost = @CaseCost,DateModified =dbo.GetLocalDATE() WHERE ItemNo = @ItemID
	--		PRINT 'FF'
	--	END
	--	ELSE
	--	BEGIN 
	--		UPDATE ItemStore Set Cost = @CaseCost ,RegCost = @CaseCost,DateModified =dbo.GetLocalDATE() WHERE ItemStoreID  = @ItemStoreID 
	--		print 'CC'
	--	END
	--END
	--ELSE BEGIN
	--	IF @ITEMID IS not NULL
	--	BEGIN
	--		UPDATE ItemStore Set Cost = @PcCost ,DateModified =dbo.GetLocalDATE() WHERE ItemNo = @ItemID
	--		PRINT 'BB'
	--    END
	--    ELSE 
	--    BEGIN
	--		UPDATE ItemStore Set Cost = @PcCost,RegCost =@PcCost ,DateModified =dbo.GetLocalDATE() WHERE ItemStoreID  = @ItemStoreID
	--			PRINT 'AA'
	--	END
	--END 
	
	--if @CaseQty > 0
	--BEGIN
	--  UPDATE ItemMain SET CaseQty =@CaseQty WHERE ItemID =@ItemID
	--END
	
	--IF @SupplierID is not null 
	--BEGIN
	--	UPDATE ItemSupply Set GrossCost = @CaseCost,DateModified =dbo.GetLocalDATE() WHERE ItemStoreNo =@ItemStoreID and SupplierNo =@SupplierID
	--END
GO