SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCommissionDetails]
(@ToDate datetime,
 @ResellerID uniqueidentifier ,
 @CommissionID uniqueidentifier = null )

AS 

Declare @Per decimal(19,3)
SET @Per=(SELECT IsNull(CommissionPercents,0) from Resellers where ResellerID =@ResellerID)/100

SELECT      TransactionView.TransactionID, 
			TransactionNo, 
			CustomerNo, 
			CustomerName,
			EndSaleTime AS Date, 
			IsNull(Debit,0) -isnull(TotalAmount,0) AS Amount, 
			(IsNull(Debit,0) -isnull(TotalAmount,0)) * @Per AS Commission
FROM         dbo.TransactionView Left outer JOIN
		(SELECT TransactionID, isnull(SUM(Amount),0) AS TotalAmount
         FROM	dbo.CommissionDetails
		 where  (Status>0) and commissionID <> (case when @CommissionID is null then newid() else @CommissionID end)
		 GROUP BY TransactionID) details 
	ON dbo.TransactionView.TransactionID = details.TransactionID 
WHERE     TransactionView.Status>0 And ResellerID =@ResellerID And EndSaleTime<=@ToDate  
			and IsNull(Debit,0) -isnull(TotalAmount,0)>0
GO