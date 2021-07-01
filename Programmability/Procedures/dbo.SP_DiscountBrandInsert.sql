SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountBrandInsert]
(           @DiscountBrandID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@BrandID uniqueidentifier
           ,@Status smallint,
		  --  @DateModified datetime,
		    @ModifierID uniqueidentifier
)
AS
Insert Into [dbo].[DiscountBrand]([DiscountBrandID],[DiscountID],[BrandID] ,[Status] ,[DateCreated],[UserCreated])
Values
(@DiscountBrandID, @DiscountID, @BrandID, @Status, dbo.GetLocalDATE(), @ModifierID)
GO