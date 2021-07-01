SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_LoyaltyPromotionUpdate](
	@LoyaltyPromotionID Uniqueidentifier,
	@Name nvarchar(50),
	@Code nvarchar(50),
	@Points int,
	@ForDolar decimal(18,0),
	@IncludeSaleItems bit = null,
	@IncludeNoDiscountItems bit = null,
	@InculudeDiscounts bit =null,
	@FromDate datetime,
	@ToDate datetime,
	@Status int = 1,
	@Item int = 0,
	@Department int = 0,
	@Brand int = 0,
	@AutoAssign bit= null,
	@Store int = 0,
	@DateModified datetime,
	@ModifierID uniqueidentifier)
	
AS

BEGIN

Declare @Date dateTime

SELECT @Date = dbo.GetLocalDATE()


UPDATE       LoyaltyPromotion
SET                Name = @Name, Code = @Code, Points = @Points, ForDolar = @ForDolar, IncludeSaleItems = @IncludeSaleItems, IncludeNoDiscountItems = @IncludeNoDiscountItems, 
                         InculudeDiscounts = @InculudeDiscounts, FromDate = @FromDate, ToDate = @ToDate, Status = @Status, Item = @Item, Department = @Department, Brand = @Brand, 
						  AutoAssign=@AutoAssign,Store = @Store, 
                         DateModified = @Date,  UserModified = @ModifierID
WHERE        (LoyaltyPromotionID = @LoyaltyPromotionID)

END
GO