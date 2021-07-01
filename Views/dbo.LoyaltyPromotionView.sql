SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[LoyaltyPromotionView]
AS
SELECT        UserModified, UserCreated, DateModified, DateCreated, Status, InculudeDiscounts, IncludeNoDiscountItems, IncludeSaleItems, ForDolar, Points, LoyaltyPromotionID, dbo.getday(FromDate) As FromDate, dbo.getday(ToDate+1) as ToDate, Code, Name, Item, 
                         Department, Brand, Store,AutoAssign
FROM            LoyaltyPromotion
WHERE        (Status > 0)
GO