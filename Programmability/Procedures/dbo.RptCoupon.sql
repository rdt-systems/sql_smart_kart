SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE procedure [dbo].[RptCoupon]
(
	@FILTER nvarchar(4000)
)
as
BEGIN

DECLARE @MySelect nvarchar(4000)
SET @MySelect ='SELECT Coupon.CouponID, CustomerView.Name AS CustomerName, CustomerView.Address AS CustomerAddress, CustomerView.CustomerNo, Coupon.Amount, Coupon.CouponNo, Coupon.ExpDate, Coupon.CouponType, Coupon.CouponDate, 
                  Coupon.Notes, Coupon.Status, Coupon.CouponID, CupnUsd.AmountUsed, ISNULL(Coupon.Amount, 0) - ISNULL(CupnUsd.AmountUsed, 0) AS AmountRemain, 
                  (CASE WHEN IsNull(CouponType,0) = 0 THEN ''Coupon'' WHEN CouponType = 1 THEN ''Gift Certificate'' ELSE ''Store Credit'' END) AS CouponName, Coupon.TransactionID, 
                  [Transaction].TransactionNo,Coupon.VoidReason 
FROM     CustomerView RIGHT OUTER JOIN
                  Coupon ON CustomerView.CustomerID = Coupon.CustomerID LEFT OUTER JOIN
                  [Transaction] ON Coupon.TransactionID = [Transaction].TransactionID AND [Transaction].Status >0 LEFT OUTER JOIN
                      ( SELECT     CouponUsed.CouponID, SUM(CouponUsed.Amount) AS AmountUsed
              FROM          CouponUsed 
left outer join
(SELECT TransactionID 
  FROM            [Transaction] 
WHERE        Status <1
) AS h on h.TransactionID=CouponUsed.TransactionID
WHERE        (Status > 0) 
AND (CouponUsed.TransactionID IS NULL 
OR CouponUsed.TransactionID =''00000000-0000-0000-0000-000000000000''  
OR     (  CouponUsed.TransactionID IS NOT NULL 
and  h.TransactionID IS NULL
))GROUP BY CouponUsed.CouponID) AS CupnUsd ON Coupon.CouponID = CupnUsd.CouponID '


insert into sqlStatmentLog(sqlstring)
values(@MySelect+@FILTER)

--print @MySelect+@Filter
exec(@MySelect +@Filter)
END
GO