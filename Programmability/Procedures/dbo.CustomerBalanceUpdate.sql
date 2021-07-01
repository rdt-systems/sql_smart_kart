SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[CustomerBalanceUpdate] 
(@CustomerID uniqueidentifier)
AS

--SELECT   customerID ,dbo.GetAgingDiff(isnull(duedate,StartSaleTime),dbo.GetLocalDATE()) AS MonthDif,  SUM(isnull(LeftDebit,debit)) AS DebitByDays
--INTO #MyTemp
--FROM  [Transaction]
--where CustomerID=@CustomerID And (transactionType=0 or TransactionType=2 or TransactionType=4) and status>0 
--And StartSaleTime>=IsNull((select Max(EndSaleTime) From [Transaction]  Where Status>0 and customerID=@CustomerID and transactionType=2),'1753/1/1')
--group by CustomerID,dbo.GetAgingDiff(isnull(duedate,StartSaleTime),dbo.GetLocalDATE()) having SUM(isnull(LeftDebit,debit))>0

update Customer
set
BalanceDoe=isnull((select sum(debit-credit) from [transaction] where status>0 and CustomerID=Customer.CustomerID),0),
--And StartSaleTime>=dbo.GetCustomerDateStartBalance(Customer.CustomerID) ),0), 
--[Current]=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=-1 AND CustomerID=Customer.CustomerID),0) ,
--Over0=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=0 AND CustomerID=Customer.CustomerID),0) ,
--Over30=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=1 AND CustomerID=Customer.CustomerID),0) ,
--Over60=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=2 AND CustomerID=Customer.CustomerID),0) ,
--Over90=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=3 AND CustomerID=Customer.CustomerID),0) ,
--Over120=isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=4 AND CustomerID=Customer.CustomerID),0) ,
DateModified=dbo.GetLocalDATE()
WHERE CustomerID=@CustomerID
                             
--drop TABLE #MyTemp
GO