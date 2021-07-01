SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_AcountReceivableTotals] 
(@FromDate datetime,
@ToDate datetime,
@StoreID uniqueidentifier =null)
AS

SELECT *,
	(Select isnull( Sum(isNull(Debit,0)-isNull(Credit,0)) ,0)
	from [transaction]
	where transactionType<>2 and TransactionType<>4 and Debit>Credit and Debit>=0 and CustomerID=CustomerView.CustomerID
	and EndSaleTime>=@FromDate and EndSaleTime <= @ToDate And Status>0 and (@StoreID=StoreID or @StoreID is null)
	)as AmountSales,
	
 	(Select isnull( Sum(isNull(Credit,0)-isNull(Debit,0)) ,0)
	from [transaction]
	where transactionType<>2 and TransactionType<>4 and Credit>Debit and CustomerID=CustomerView.CustomerID
	and EndSaleTime>=@FromDate and EndSaleTime <= @ToDate And Status>0 and (@StoreID=StoreID or @StoreID is null)
	) as AmountPayments 
FROM CustomerView
Where Status>0
GO