SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetGiftCards]
(@FromDate datetime,
@ToDate datetime)
AS
Begin
	
	select Store.StoreName,sum(CouponUsed.AmountAdd) as Sold,SUM(CouponUsed.Amount) AS Used from Coupon
	inner join CouponUsed on Coupon.CouponID = CouponUsed.CouponID  
	inner join [transaction] as transaction1 on transaction1.TransactionID = Coupon.TransactionID
	inner join Store on store.StoreID = transaction1.StoreID 
	where 1=1
	--and  CouponType = 2 
	and Transaction1.Status > 0 AND (dbo.GetDay(Transaction1.StartSaleTime) >= @FromDate) 
	AND (dbo.GetDay(Transaction1.StartSaleTime) <= @ToDate)
	group by Store.StoreName
	--select Coupon.CouponID, Coupon.Amount, CouponUsed.Balance as Remaining, Store.StoreName,Store.StoreID, Customer.CustomerNo,Customer.FirstName,
	--customer.LastName, transaction1.TransactionID, transaction1.TransactionNo,transaction1.StartSaleTime as SaleDate
	--from Coupon
	--inner join (select SUM(ISNULL(AmountAdd,0)) - SUM(ISNULL(Amount,0)) AS Balance, CouponID from CouponUsed Group By CouponID) as CouponUsed
	--on Coupon.CouponID = CouponUsed.CouponID 
	--inner join [transaction] as transaction1 on transaction1.TransactionID = Coupon.TransactionID
	--inner join Store on store.StoreID = transaction1.StoreID 
	--inner join Customer on transaction1.CustomerID = Customer.CustomerID 
	--where Transaction1.Status > 0 AND (dbo.GetDay(Transaction1.StartSaleTime) >= @FromDate) 
	--AND (dbo.GetDay(Transaction1.StartSaleTime) <= @ToDate)
	--order by Coupon.CouponID
end
GO