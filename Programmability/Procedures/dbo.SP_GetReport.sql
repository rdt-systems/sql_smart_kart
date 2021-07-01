SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetReport] (
		@FromDate datetime = null,
		@ToDate datetime = null
		)

AS
--print (CONVERT(VARCHAR(10),ISNULL(@FromDate,dbo.getlocaldate()),101) + '     ' + CONVERT(VARCHAR(10),ISNULL(@ToDate,dbo.getlocaldate()),101) )
IF @FromDate is null or @ToDate is null
SELECT @FromDate = cast(dbo.getlocaldate()  as date), @ToDate = cast(dbo.getlocaldate()  as date)

--print (CONVERT(VARCHAR(10),ISNULL(@FromDate,dbo.getlocaldate()),101)  + '     ' + CONVERT(VARCHAR(10),ISNULL(@ToDate,dbo.getlocaldate()),101) )

--Select CONVERT(VARCHAR(10),SaleDate,101) AS Date, Total, FORMAT(CAST(ROUND(Amount,2) as money),'C') AS Amount From (


SELECT        CONVERT(VARCHAR(10),S.SaleDate,101) AS Date, FORMAT(CAST(ROUND(Sale.Sales,2) as money),'C') AS [Total Sales], FORMAT(CAST(ROUND(Paid.Paid,2) as money),'C') AS [Total Paid], 
FORMAT(CAST(ROUND(Paid.Tax,2) as money),'C') AS [Sales Tax], FORMAT(CAST(ROUND(S.AVGCost,2) as money),'C') AS [Cost Of Goods Sold]
FROM            SaleReturnsTaxByStoreView AS S LEFT OUTER JOIN
                             (SELECT        CAST(EndSaleTime AS Date) AS SaleDate, SUM(TotalAfterDiscount) AS Sales
                               FROM            TransactionEntryProfit
                               WHERE        (EndSaleTime >= @FromDate) AND (EndSaleTime < @ToDate + 1)
                               GROUP BY CAST(EndSaleTime AS Date)) AS Sale ON S.SaleDate = Sale.SaleDate LEFT OUTER JOIN
                             (SELECT        CAST(EndSaleTime AS Date) AS SaleDate, CAST(SUM(Credit) AS money) AS Paid, CAST(SUM(Tax) AS money) AS Tax
                               FROM            [Transaction]
                               WHERE        (Status > 0) AND (TransactionType IN (0, 1)) AND (EndSaleTime >= @FromDate) AND (EndSaleTime < @ToDate + 1)
                               GROUP BY CAST(EndSaleTime AS Date)) AS Paid ON S.SaleDate = Paid.SaleDate
WHERE        (S.SaleDate >= @FromDate) AND (S.SaleDate < @ToDate + 1)
Order By Date

--Sales
--Select CAST(EndSaleTime AS Date) AS SaleDate, 'Total Sales' AS Total, SUM(TotalAfterDiscount)  AS Amount, 0 AS Sort
--FROM            TransactionEntryProfit
--WHERE        (EndSaleTime >= @FromDate) AND (EndSaleTime < @ToDate + 1)
--GROUP BY CAST(EndSaleTime AS Date)

--UNION 
----Discounts
--Select SaleDate, 'Total Discounts' AS Total, 0- Discount AS Amount, 1 AS Sort
--FROM            SaleReturnsTaxByStoreView
--WHERE        (SaleDate >= @FromDate) AND (SaleDate < @ToDate + 1)

--UNION 
----Returns
--Select SaleDate, 'Total Returns' AS Total, 0- Returns AS Amount, 2 AS Sort
--FROM            SaleReturnsTaxByStoreView
--WHERE        (SaleDate >= @FromDate) AND (SaleDate < @ToDate + 1)

--UNION 
----Gift Cards
--Select SaleDate, 'Total Gift Cards Sold' AS Total, GiftCardPurchase AS Amount, 3 AS Sort
--FROM            SaleReturnsTaxByStoreView
--WHERE        (SaleDate >= @FromDate) AND (SaleDate < @ToDate + 1)

--UNION
----Paid
--Select CAST(EndSaleTime AS Date) AS SaleDate, 'Actual Cash Value Paid' AS Total, CAST(SUM(Credit) as money) AS Amount, 4 AS Sort from [Transaction]
--Where Status >  0  and TransactionType IN (0,1) and EndSaleTime > = @FromDate and EndSaleTime < @ToDate +1
--GROUP BY CAST(EndSaleTime AS Date)


--UNION 
----COGS
--Select SaleDate, 'Cost of Goods Sold' AS Total, AVGCost AS Amount, 5 AS Sort
--FROM            SaleReturnsTaxByStoreView
--WHERE        (SaleDate >= @FromDate) AND (SaleDate < @ToDate + 1)

--UNION 
----Sales Tax
--Select CAST(EndSaleTime AS Date) AS SaleDate, 'Sales Tax' AS Total, CAST(SUM(Tax) as money) AS Amount, 6 AS Sort from [Transaction]
--Where Status >  0  and TransactionType IN (0,1) and EndSaleTime > = @FromDate and EndSaleTime < @ToDate +1
--GROUP BY CAST(EndSaleTime AS Date)
--)
--A

--Order By SaleDate, Sort
GO