SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_LoyaltyPromotionInsert](
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
	@AutoAssign bit =null,
	@Store int = 0,
	@ModifierID Uniqueidentifier = NULL)
	
AS

BEGIN

Declare @Date datetime

SELECT @Date = dbo.GetLocalDATE()


INSERT INTO LoyaltyPromotion
                         (LoyaltyPromotionID, Name, Code, Points, ForDolar, IncludeSaleItems, IncludeNoDiscountItems, InculudeDiscounts, FromDate, ToDate, Status, Item, Department, Brand,AutoAssign, Store, DateCreated, DateModified, 
                         UserCreated, UserModified)
VALUES        (@LoyaltyPromotionID,@Name,@Code,@Points,@ForDolar,@IncludeSaleItems,@IncludeNoDiscountItems,@InculudeDiscounts,@FromDate,@ToDate,@Status,@Item,@Department,@Brand,@AutoAssign,@Store,@Date,@Date,@ModifierID,@ModifierID)

END
GO