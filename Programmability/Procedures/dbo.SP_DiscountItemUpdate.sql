SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountItemUpdate]
(           @ItemDiscountID uniqueidentifier
           ,@DiscountID uniqueidentifier
           ,@ItemID uniqueidentifier
           ,@Status smallint,
		    @DateModified datetime,
		    @ModifierID uniqueidentifier
)
AS
UPDATE [dbo].[DiscountItem]
    SET[DiscountID] = @DiscountID
      ,[ItemID] = @ItemID
      ,[Status] = @Status
      ,[DateModified] = dbo.GetLocalDATE()
      ,[UserModified] = @ModifierID
 WHERE [ItemDiscountID] = @ItemDiscountID
GO