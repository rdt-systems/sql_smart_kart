SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSpecialUpdate]
           (@ItemSpecialID int
		   ,@ItemStoreID uniqueidentifier
           ,@SaleType int
           ,@SalePrice money
           ,@SaleStartDate datetime
           ,@SaleEndDate datetime
           ,@SaleMin int
           ,@SaleMax int
           ,@MinForSale money
           ,@SpecialBuy int
           ,@SpecialPrice money
           ,@AssignDate bit
           ,@Status smallint=1
		   ,@ModifierID uniqueidentifier)
AS
UPDATE [dbo].[ItemSpecial]
   SET [ItemStoreID] = @ItemStoreID
      ,[SaleType] = @SaleType
      ,[SalePrice] = @SalePrice
      ,[SaleStartDate] = @SaleStartDate
      ,[SaleEndDate] = @SaleEndDate
      ,[SaleMin] = @SaleMin
      ,[SaleMax] = @SaleMax
      ,[MinForSale] = @MinForSale
      ,[SpecialBuy] = @SpecialBuy
      ,[SpecialPrice] = @SpecialPrice
      ,[AssignDate] = @AssignDate
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE ItemSpecialID=@ItemSpecialID
GO