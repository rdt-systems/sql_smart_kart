SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransByPayment]
(@PaymentID uniqueidentifier,
@CustomerID uniqueidentifier=null,
@PaymentDate dateTime)
as
if @CustomerID is null 
	SET @CustomerID=(SELECT CustomerID FROM [transaction] WHERE transactionID=@PaymentID)
	SELECT
DISTINCT
		dbo.TransactionsView.TransactionID,  
		dbo.TransactionsView.TransactionNo,

		dbo.TransactionsView.Debit +
		 Case when DateDiff(Day,dbo.TransactionsView.EndSaleTime,@PaymentDate) <= dbo.Credit.Days and TransactionsView.Debit=ISNULL(Payments.TotalAmount, 0)+ round(isnull(PaymentDetails.Amount,0),2) then
		round(ISNULL(InterestRate,0)*(TotalEntry+Tax)/100,2) else 0 end as debit,

		ISNULL(Payments.TotalAmount, 0) as PayedAmount,

		round(dbo.TransactionsView.Debit - ISNULL(Payments.TotalAmount, 0)- 
		 Case when DateDiff(Day,dbo.TransactionsView.EndSaleTime,@PaymentDate) <= dbo.Credit.Days and TransactionsView.Debit<>ISNULL(Payments.TotalAmount, 0)+ round(isnull(PaymentDetails.Amount,0),2) then
		 round(isnull(InterestRate,0)*round(TotalEntry+Tax,2)/100,2) else 0 end ,2) AS LeftDebit, 

		dbo.TransactionsView.StartSaleTime,

		Case when DateDiff(Day,dbo.TransactionsView.EndSaleTime,@PaymentDate) <= dbo.Credit.Days then
		   isnull(InterestRate,0)  else 0.00 end 
		as [Terms Discount(%)],

		isnull(PaymentDetails.Amount,0) as ApplyAmount,

		case When PaymentDetails.Amount>0 then 1 else 0 end as Apply
FROM	dbo.TransactionsView Left outer JOIN
	(SELECT TransactionPayedID, SUM(Amount) AS TotalAmount
        		 FROM	dbo.PaymentDetails join [Transaction] on [Transaction].transactionid =PaymentDetails.transactionid
		 where  (dbo.PaymentDetails.Status>0) and dbo.PaymentDetails.TransactionID<>@PaymentID and (dbo.[Transaction].Status>0)
       		GROUP BY TransactionPayedID) Payments 
	ON dbo.TransactionsView.TransactionID = Payments.TransactionPayedID 
	left outer join PaymentDetails
	on (PaymentDetails.TransactionID=@PaymentID) and 
	(PaymentDetails.TransactionPayedID=dbo.TransactionsView.TransactionID)
	and (PaymentDetails.Status>0)		Left Outer join
		dbo.Credit On dbo.Credit.CreditID=TransactionsView.TermsID and dbo.Credit.Status>0
WHERE   (TransactionsView.Status>0)  and (transactionType=0 or transactionType=2 or transactionType=4) and Debit>0
	and ((dbo.TransactionsView.CustomerID=@CustomerID) or @CustomerID is null)
	and (dbo.TransactionsView.Debit > ISNULL(Payments.TotalAmount, 0)Or PaymentDetails.Amount>0) And StartSaleTime>=dbo.GetCustomerDateStartBalance(@CustomerID)
		and dbo.TransactionsView.Credit <> dbo.TransactionsView.Debit
	--and (dbo.TransactionsView.Debit <> ISNULL(Payments.TotalAmount, 0)Or PaymentDetails.Amount>0) And StartSaleTime>=dbo.GetCustomerDateStartBalance(@CustomerID)
GO