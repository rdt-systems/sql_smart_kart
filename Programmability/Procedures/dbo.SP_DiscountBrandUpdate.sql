SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountBrandUpdate]
(           @DiscountBrandID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@BrandID uniqueidentifier
           ,@Status smallint,
		    @DateModified datetime,
		    @ModifierID uniqueidentifier
)
AS
UPDATE [dbo].[DiscountBrand]
    SET[DiscountID] = @DiscountID
      ,[BrandID] = @BrandID   
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE [DiscountBrandID] = @DiscountBrandID
GO