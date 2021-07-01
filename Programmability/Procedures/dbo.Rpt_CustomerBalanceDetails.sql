SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerBalanceDetails] 
(@FromDate datetime,
@ToDate datetime,
@OnlyOpen bit,
@CustomerID uniqueidentifier = null)
AS

SELECT     case when TransactionType=0 then 'Sale' 
		when TransactionType=1 then 'Payment' 
		when TransactionType=2 then 'Open Balance' 
		when TransactionType=3 then 'Return' 
		when TransactionType=4 then 'Charge' 
	       end AS Type, TransactionType,
	      StartSaleTime AS DateT, TransactionNo AS Num, DueDate, ISNULL(LeftDebit, 0) AS OpenBalance, Debit - ISNULL(LeftDebit, 0) 
                      AS AmountPay, TransactionID AS IDc, TransactionWithLeftDebitView.CustomerID AS PID,debit-TransactionWithLeftDebitView.credit as Amount,TransactionWithLeftDebitView.Name,TransactionWithLeftDebitView.CustomerNo,TransactionWithLeftDebitView.Credit,Debit,
			case when TransactionType=1 then -TransactionWithLeftDebitView.credit+isnull(appliedamount,0) 
			when TransactionType=3 then debit-TransactionWithLeftDebitView.credit+isnull(appliedamount,0)
			when TransactionType=2 or TransactionType=4 then 
				case when debit>0 then leftdebit else debit-TransactionWithLeftDebitView.credit+isnull(appliedamount,0) end
			when TransactionType=0 then leftdebit-TransactionWithLeftDebitView.credit+isnull(appliedamount,0)
			else leftdebit end OpenAmount
INTO #Temp
FROM         dbo.TransactionWithLeftDebitView LEFT OUTER JOIN
             dbo.CustomerView ON dbo.TransactionWithLeftDebitView.CustomerID = dbo.CustomerView.CustomerID
where StartSaleTime>=@FromDate and StartSaleTime<=@ToDate and CustomerView.Status>0 and TransactionWithLeftDebitView.Status>0 and --debit-TransactionWithLeftDebitView.credit<>0 and 
StartSaleTime>=dbo.GetCustomerDateStartBalance(TransactionWithLeftDebitView.CustomerID)
And (dbo.TransactionWithLeftDebitView.CustomerID=@CustomerID Or @CustomerID is null)

IF @OnlyOpen=0
	SELECT * FROM #Temp
ELSE
	SELECT * FROM #Temp
	WHERE OpenAmount<>0

Drop Table #Temp
GO