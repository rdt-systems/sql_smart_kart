SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionAllCustomer]
(@Filter nvarchar(4000)
)
 AS


declare @MySelect nvarchar(4000)
SET @MySelect= 'select (case when t.TransactionType = 0 then ''Invoice''
 when t.TransactionType=2 then  ''Opening Balance''
	     when t.TransactionType=1 then  ''Payment''
  	     when t.TransactionType=3 then  ''Return''
when t.TransactionType=4 then ''Add Charge'' end)as Type,
		 CONVERT(decimal(19, 2),  ISNULL(t.AppliedAmount, ISNULL(T.Credit,0)))  AS Paid,
       (CONVERT(decimal(19,2),t.debit-t.credit))as Amount,t.Debit,t.Credit,t.EndTime as SaleTime,
   	
CONVERT(decimal(19,2),[Transaction].currbalance)as Balance,
        t.TransactionNo,  t.StartSaleTime  as  StartSaleTime, t.DueDate as  DueDate,t.CustomerID
	,t.StartSaleTime as DateT,t.TransactionID,t.Note ,T.tax

from transactionwithpaidview t 
	inner join [Transaction] on [Transaction].transactionid=t.transactionid  and [Transaction].status>0
	inner join customerview on t.CustomerID = customerview.CustomerID and customerview.Status>0
where
t.status>0
and t.startsaletime>=IsNull(
		(select Max(EndSaleTime) From [Transaction] 
			Where Status>0 and customerID=t.customerid and transactionType=2)
			,''1753/1/1'')'
--and t.startsaletime>=dbo.GetCustomerDateStartBalance(t.customerid)'

exec(@MySelect+@Filter+' order by DateT')
GO