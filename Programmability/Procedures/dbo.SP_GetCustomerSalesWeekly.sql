SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerSalesWeekly] 
(
@startDate  datetime,
@endDate  datetime,
@CustomerID uniqueidentifier)
 AS

   SELECT   DATEPART(wk,dbo.[Transaction].StartSaleTime) AS weekNo,
			--MONTH(dbo.[Transaction].StartSaleTime) as saleMonth,
			YEAR(dbo.[Transaction].StartSaleTime) as saleYear,
			SUM([Transaction].[Debit])AS Sale , 
			AVG([Transaction].[Debit]) AS avgSale,
			COUNT(*) AS visit,
			AVG ([Transaction].CurrBalance)     AS avgBalance
			--isnull(SUM(UOMQty*AVGCost),0) Cost
   
   FROM     Customer 
            INNER JOIN 
            [Transaction] ON Customer.CustomerID = [Transaction].CustomerID

   WHERE    (dbo.[Transaction].StartSaleTime BETWEEN @startDate AND @endDate) AND
			dbo.[Transaction].Status>0 and [Transaction].CustomerID = @customerID
			AND dbo.[Transaction].TransactionType <2
	        --ItemStoreID=@ItemStoreID and
			--dbo.TransactionEntry.Status>0

		   GROUP BY DATEPART(wk,dbo.[Transaction].StartSaleTime),YEAR(dbo.[Transaction].StartSaleTime)  ORDER BY DATEPART(wk,dbo.[Transaction].StartSaleTime) ASC
   
   RETURN
GO