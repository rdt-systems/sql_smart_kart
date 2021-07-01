SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetGiftCardDetailsReport](@FromDate DateTime,
@ToDate DateTime)

AS


SELECT  
                         Coupon.CouponNo, Customer.CustomerNo AS CustomerNoActivated, Customer.LastName + ', ' + Customer.FirstName AS CustomerActivated, Coupon.CouponIssueDate AS DateActivated, 
                         [Transaction].TransactionNo AS TransactionActivated, CASE WHEN ISNULL(CouponUsed.AmountAdd, 0) <> 0 THEN CouponUsed.AmountAdd END AS AmountActivated, CASE WHEN ISNULL(CouponUsed.Amount, 0) 
                         <> 0 THEN CouponUsed.Amount END AS AmountUsed, CASE WHEN ISNULL(CouponUsed.Amount, 0) <> 0 THEN Customer_1.CustomerNo END AS CustomerNoUsed, CASE WHEN ISNULL(CouponUsed.Amount, 0) 
                         <> 0 THEN Transaction_1.TransactionNo END AS TransactionNoUsed, CASE WHEN ISNULL(CouponUsed.Amount, 0) <> 0 THEN Customer_1.LastName + ', ' + Customer_1.FirstName END AS CustomerUsed, 
                         CASE WHEN ISNULL(CouponUsed.Amount, 0) <> 0 THEN CouponUsed.UsedDate END AS DateUsed
FROM            Coupon INNER JOIN
                         CouponUsed ON Coupon.CouponID = CouponUsed.CouponID LEFT OUTER JOIN
                         Customer ON Coupon.CustomerID = Customer.CustomerID LEFT OUTER JOIN
                         [Transaction] AS Transaction_1 ON CouponUsed.TransactionID = Transaction_1.TransactionID  LEFT OUTER JOIN
                         [Transaction] ON Coupon.TransactionID = [Transaction].TransactionID   LEFT OUTER JOIN
                         Customer AS Customer_1 ON Transaction_1.CustomerID = Customer_1.CustomerID
WHERE        ((Coupon.CouponIssueDate >= @FromDate) AND (Coupon.CouponIssueDate <= @ToDate + 1) OR
                         (CouponUsed.UsedDate >= @FromDate) AND (CouponUsed.UsedDate <= @ToDate + 1))
						 and  isnull([Transaction].Status,1)>0
					--	  and  isnull(Transaction_1.Status,1)>0
GO