SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerDetails] 
(@CustomerID uniqueidentifier)
AS

SELECT CustomerView.* ,dbo.GetCustomerLastClearBalance(@CustomerID)as LastClear,LastSale,Tra.LastPayment
FROM dbo.CustomerView  ,
     (select max(startsaletime)LastSale from [transaction]
	where transactionType=0 and CustomerID=@CustomerID)tr  ,
     (select max(startsaletime)LastPayment from [transaction]
	where transactionType=1 and CustomerID=@CustomerID)tra 
where CustomerView.CustomerID=@CustomerID
GO