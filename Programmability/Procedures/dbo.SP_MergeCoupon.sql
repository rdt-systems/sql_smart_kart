SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MergeCoupon]
	(@FromCouponID Uniqueidentifier,
	 @ToCouponID Uniqueidentifier,
	 @ModifierID Uniqueidentifier)


AS

IF NOT @FromCouponID = @ToCouponID

BEGIN

Update CouponUsed Set CouponID = @ToCouponID, DateModified = dbo.GetLocalDATE() Where CouponID = @FromCouponID

Update Coupon Set Amount = (SELECT SUM(ISNULL(AmountAdd,0)) FROM CouponUsed Where Status >0 AND (CouponID = @FromCouponID OR CouponID = @ToCouponID)),
DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID WHERE CouponID = @ToCouponID

Update Coupon Set Status = - 2, Notes = Notes + ', Merged Into CouponID ' + CONVERT(nvarchar(50), @ToCouponID), UserModified = @ModifierID, DateModified = dbo.GetLocalDATE()

END
GO