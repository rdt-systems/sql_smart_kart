SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DiscountsDelete]
(@DiscountID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.Discounts
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE  DiscountID = @DiscountID
GO