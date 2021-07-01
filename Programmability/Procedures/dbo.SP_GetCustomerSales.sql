SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetCustomerSales]   
(@CustomerID uniqueidentifier)  
 AS  
  
SELECT     MONTH(StartSaleTime) AS SaleMonth,YEAR(StartSaleTime)As SaleYear, SUM(Debit) AS Sale, AVG(Debit) AS avgSale, COUNT(*) AS visit, AVG(CurrBalance) AS avgBalance  
FROM         [Transaction]  
WHERE     (YEAR(StartSaleTime) > (YEAR(dbo.GetLocalDATE())-3))   
AND (Status > 0)  
AND CustomerID = @CustomerID  
AND dbo.[Transaction].TransactionType <2  
GROUP BY MONTH(StartSaleTime),YEAR(StartSaleTime)  
     
RETURN  
  
  
  
Select (YEAR(dbo.GetLocalDATE())-3)
GO