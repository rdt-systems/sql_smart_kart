SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOpenCommissions]
(@FromDate datetime=null,
 @ToDate datetime=null)
AS 

SELECT      TransactionView.TransactionID, 
			TransactionNo, 
			CustomerNo, 
			CustomerName,
			EndSaleTime AS Date, 
			IsNull(Debit,0) AS Amount, 
			isnull(TotalAmount,0)as AmountPaid,
			(IsNull(Debit,0) -isnull(TotalAmount,0)) * (SELECT IsNull(CommissionPercents,0) from Resellers where ResellerID =TransactionView.ResellerID)/100 AS Commission,
			resellerID,ResellerName
FROM         dbo.TransactionView Left outer JOIN
		(SELECT TransactionID, isnull(SUM(Amount),0) AS TotalAmount
         FROM	dbo.CommissionDetails
		 where  (Status>0) 
		 GROUP BY TransactionID) details 
	ON dbo.TransactionView.TransactionID = details.TransactionID 
WHERE     TransactionView.Status>0   
			and IsNull(Debit,0) -isnull(TotalAmount,0)>0 and 
			EndSaleTime >= Isnull(@FromDate,'1753-1-1') and EndSaleTime <= Isnull(@ToDate,dateadd(year,50,dbo.GetLocalDATE()))
			and ResellerID is not null
GO