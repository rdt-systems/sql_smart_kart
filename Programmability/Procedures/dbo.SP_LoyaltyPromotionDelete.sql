SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_LoyaltyPromotionDelete]
	(@LoyaltyPromotionID Uniqueidentifier,
	 @ModifierID Uniqueidentifier)
AS

UPDATE       LoyaltyPromotion
SET                Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE        (LoyaltyPromotionID = @LoyaltyPromotionID)
GO