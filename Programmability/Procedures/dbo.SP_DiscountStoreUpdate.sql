SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountStoreUpdate]
(           @DiscountStoreID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@StoreID uniqueidentifier
           ,@Status smallint,
		    @DateModified datetime,
		    @ModifierID uniqueidentifier
)
AS
UPDATE [dbo].[DiscountStore]
    SET[DiscountID] = @DiscountID
      ,[StoreID] = @StoreID   
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE [DiscountStoreID] = @DiscountStoreID
GO