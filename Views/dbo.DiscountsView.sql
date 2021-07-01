SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO







CREATE VIEW [dbo].[DiscountsView]
AS
SELECT        DiscountID, Name, StartDate, EndDate, PercentsDiscount, AmountDiscount, MinTotalSale, UPCDiscount, Status, DateCreated, UserCreated, DateModified, 
                         UserModified, ClearBalance, ClearDays, ReqPaswrd, DiscountForCC, DiscountItems, PercentsDiscountWithCC, SalesItem, MinTotalSale2, PercentsDiscount2, 
                         AmountDiscount2, MinTotalSale3, PercentsDiscount3, AmountDiscount3, DiscountType, ISNULL(IncludeGiftCard, 0) AS IncludeGiftCard, DiscountItem, 
                         DiscountDepartment, DiscountBrand, DiscountStore, BogoQty, BogoAmount, BogoType, SelectedItem, ISNULL(MaxAmount,0.00) AS MaxAmount,AutoAssign, MinQty
FROM            dbo.Discounts
GO