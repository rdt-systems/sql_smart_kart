SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SalesView]
AS
SELECT     SaleID, SaleNo, SaleName, FromDate, ToDate, BuyQty, GetQty, MaxQty, MinTotalAmount, MinTotalQty, SaleType, Price, Percentage, AmountLess, 
                      NoTax, Priority, AllowMultiSales, IsGeneral, IsCoupon, AllItemsPoints, IncludeNotDiscountable, IncludePhoneOrder, PointsSum, PointsAmount,PointsPerCoin, Status, 
                      DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.Sales
GO