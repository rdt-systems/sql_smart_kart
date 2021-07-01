SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetLeftDebits]
(@CustomerID uniqueidentifier,
--@PaymentID uniqueidentifier,
@PaymentDate dateTime)

as

SELECT DISTINCT	dbo.TransactionsView.TransactionID,
	dbo.TransactionsView.TransactionNo, 
	dbo.TransactionsView.Debit,
	ISNULL(Payments.TotalAmount, 0) as PayedAmount,
	round(dbo.TransactionsView.Debit - ISNULL(Payments.TotalAmount, 0)- 
     Case when DateDiff(Day,dbo.TransactionsView.EndSaleTime,@PaymentDate) <= dbo.Credit.Days then
	 isnull(InterestRate,0)*(TotalEntry+Tax)/100 else 0 end ,2) AS LeftDebit, 
	dbo.TransactionsView.StartSaleTime,
    Case when DateDiff(Day,dbo.TransactionsView.EndSaleTime,@PaymentDate) <= dbo.Credit.Days then
       isnull(InterestRate,0)  else 0.00 end 
	as [Terms Discount(%)],
	--isnull(PaymentDetails.Amount,0) as ApplyAmount,
	--isnull(PaymentDetails.Amount,0) as Apply
	0 as ApplyAmount,
	0 as Apply

FROM dbo.TransactionsView					LEFT OUTER JOIN
		(SELECT TransactionPayedID, SUM(Amount) AS TotalAmount
        FROM	dbo.PaymentDetails join [Transaction] on [Transaction].transactionid =PaymentDetails.transactionid
		where  (PaymentDetails.Status>0)
		and [Transaction].Status>0
		 GROUP BY TransactionPayedID) Payments 
		ON dbo.TransactionsView.TransactionID = Payments.TransactionPayedID
											Left Outer join
		dbo.Credit On dbo.Credit.CreditID=TransactionsView.TermsID and dbo.Credit.Status>0
	--Left outer join PaymentDetails
	--on (PaymentDetails.TransactionID=@PaymentID) 
	--and (PaymentDetails.TransactionPayedID=dbo.TransactionsView.TransactionID)
	--and (PaymentDetails.Status<>-1)
WHERE  (dbo.TransactionsView.Credit <> dbo.TransactionsView.Debit) AND  (dbo.TransactionsView.Debit - ISNULL(Payments.TotalAmount, 0) > 0) 
	and (dbo.TransactionsView.CustomerID=@CustomerID)
	and (TransactionsView.Status>0)  And StartSaleTime>=dbo.GetCustomerDateStartBalance(TransactionsView.CustomerID)
GO