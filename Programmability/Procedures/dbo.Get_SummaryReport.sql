SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Get_SummaryReport](
	@From datetime, 
	@To datetime, 
	@Store uniqueidentifier = NULL)

AS
 DECLARE @Sale decimal(10,3)
 DECLARE @Tax decimal(9,3)
 DECLARE @Gift decimal(9,3)
 DECLARE @TagAlong decimal(9,3)
 DECLARE @Tender decimal(10,3)
 DECLARE @AR decimal(9,3)
 DECLARE @Payout decimal(9,3)
 DECLARE @Payments decimal(9,3)

IF @Store = '00000000-0000-0000-0000-000000000000'
SET @Store = NULL

SET @Sale =(Select (ISNULL(SUM(TotalAfterDiscount),0)) AS Total from TransactionEntryItem WHere EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL))
SET @Tax =(Select SUM(ROUND(ISNULL(Tax,0),2)) AS Total from [Transaction] T WHere TransactionType <> 4 AND Status > 0 and EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL))
SET @Gift =(Select ISNULL(SUM(ISNULL(Total,0)),0) From dbo.TransactionEntry AS E WITH (NOLOCK) INNER JOIN dbo.[Transaction] AS T WITH (NOLOCK) on E.TransactionID = T.TransactionID INNER JOIN dbo.Store S ON T.StoreID = S.StoreID
            WHERE  (E.Status > 0) AND (T.Status > 0) AND (TransactionEntryType = 5) AND TransactionType <> 4 AND EndSaleTime > = @From and EndSaleTime < @To and (T.StoreID = @Store OR @Store IS NULL))
SET @TagAlong =(SELECT ISNULL(SUM(ISNULL(TotalAfterDiscount,0)),0)
	 From TransactionEntryItem Where ItemType = 5 and EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL))
SET @Tender =(SELECT  ISNULL(SUM(Amount),0)  From TenderEntry E INNER JOIN [Transaction] T ON E.TransactionID = T.TransactionID INNER JOIN Tender R ON E.TenderID = R.TenderID Where E.Status > 0 
	and T.Status > 0 and R.TenderType <> 1 and T.TransactionType <> 4 AND EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL))
SET @Payout = (SELECT ISNULL(SUM(P.Amount),0)   from PayOutView P Where P.Status > 0
	and P.PayOutDate > = @From and P.PayOutDate < @To and (StoreID = @Store OR @Store IS NULL))
SET @AR=(Select (CASE WHEN ISNULL(SUM(ISNULL(T.Debit,0)) -SUM(ISNULL(T.Credit,0)),0) > 0 THEN ISNULL(SUM(ISNULL(T.Debit,0)) -SUM(ISNULL(T.Credit,0)),0) ELSE 0 END)
	from [Transaction] T WHere Status > 0 and TransactionType<>4 and TransactionType<>2 and ISNULL(Debit,0) - ISNULL(Credit,0) > 0 and  EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL))
SET @Payments =(Select SUM(IsNull(Credit,0) - IsNull(Debit,0))  from [Transaction] T WHere Status > 0 
	and TransactionType<>4 and TransactionType<>2 and ISNULL(Credit,0) - ISNULL(Debit,0) >0 and EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL))



SELECT Description, Total  FROM (
Select 'No. of Sales' AS Description, FORMAT(ISNULL(COUNT(DISTINCT TransactionID),0),N'N0') AS Total,
 
 0  AS Sort from TransactionEntryProfit T WHERE EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)

UNION ALL

Select 'Sales' AS Description, FORMAT(ISNULL(@Sale,0),N'c') AS Total,
 
  1  AS Sort 

UNION ALL

Select  'Sales Tax' AS Description, FORMAT(ISNULL(@Tax,0),N'c') AS Total,
 
  2  AS Sort 

UNION ALL

Select 'Gift Cards Sold' AS Description, FORMAT(ISNULL(SUM(ISNULL(Total,0)),0),N'c') AS Total,
 
  3  AS Sort From dbo.TransactionEntry AS E WITH (NOLOCK) INNER JOIN dbo.[Transaction] AS T WITH (NOLOCK) on E.TransactionID = T.TransactionID INNER JOIN dbo.Store S ON T.StoreID = S.StoreID
WHERE        (E.Status > 0) AND (T.Status > 0) AND (TransactionEntryType = 5) AND TransactionType <> 4 AND EndSaleTime > = @From and EndSaleTime < @To and (T.StoreID = @Store OR @Store IS NULL)

UNION ALL

SELECT 'Tag Along' AS  Description, FORMAT(IsNull(@TagAlong,0),N'c') AS Total,
 
  3.1 AS Sort  

UNION ALL

Select 'Total' AS Description,  FORMAT(@Sale+@tax+@Gift+@TagAlong,N'c') AS Total,
 
  3.2  AS Sort 

UNION ALL


SELECT '' AS  Description, '' AS Total,
 
  4 AS Sort  

UNION ALL


SELECT 'Tender - Payout' AS  Description,  FORMAT(ISNULL(@Tender,0)-IsNull(@Payout,0),N'c') AS Total,
 
  6 AS Sort 

UNION ALL

Select  'AR' AS Description,  FORMAT(IsNull(@AR,0),N'c') AS Total,  7  AS Sort 

UNION ALL

Select  'AR PAYMENTS' AS Description, FORMAT(IsNull(@Payments,0),N'c') AS Total,  8  AS Sort 

UNION ALL

Select 'Payout' AS Description, FORMAT(ISNULL(@Payout,0),N'c') AS Total,   9 AS Sort 

UNION ALL

Select 'Total ' AS Description, FORMAT((ISNULL(@Tender,0)+IsNull(@AR,0))-(IsNull(@Payments,0)),N'c') AS Total,   9.1 AS Sort 

UNION ALL


SELECT '' AS  Description, '' AS Total,
 
  11 AS Sort  

UNION ALL

SELECT IsNull(S.SystemValueName, R.TenderName) As Description, Format(IsNull(Sum(E.Amount), 0), N'c') As Total,  12 As Sort
FROM    TenderEntry E Inner Join    [Transaction] T On E.TransactionID = T.TransactionID Inner Join   Tender R On E.TenderID = R.TenderID Left Outer Join
		SystemValues S On Cast(S.SystemValueNo As nvarchar) = E.Common3    And S.SystemTableNo = 5	
WHERE LOWER(R.TenderName) <> 'check'	and 	
	E.Status > 0 and T.Status > 0 AND (R.TenderGroup <> 6) AND (R.TenderGroup <> 7) and EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)
GROUP BY R.TenderName, R.SortOrder,S.SystemValueName

UNION ALL

SELECT TenderName COLLATE SQL_Latin1_General_CP1_CI_AS + '    # ' + E.Common1 COLLATE SQL_Latin1_General_CP1_CI_AS  AS  Description,  FORMAT(ISNULL(Amount,0),N'c') AS Total,
 
  12.5 AS Sort From TenderEntry E INNER JOIN [Transaction] T ON E.TransactionID = T.TransactionID INNER JOIN Tender R ON E.TenderID = R.TenderID 
Where LOWER(R.TenderName) = 'check' and E.Status > 0 
and T.Status > 0 and EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)
UNION ALL

SELECT 'Total Tender' AS  Description,  FORMAT(ISNULL(SUM(Amount),0),N'c') AS Total,
 
  13 AS Sort From TenderEntry E INNER JOIN [Transaction] T ON E.TransactionID = T.TransactionID INNER JOIN Tender R ON E.TenderID = R.TenderID Where E.Status > 0 
and T.Status > 0 AND (R.TenderGroup <> 6) AND (R.TenderGroup <> 7) and EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)

UNION ALL

SELECT '' AS  Description, '' AS Total,
 
  14 AS Sort  

UNION ALL

SELECT 'Over/Short' AS  Description, '' AS Total,
 
  15 AS Sort  

UNION ALL

SELECT '' AS  Description, '' AS Total,
 
  16 AS Sort  

UNION ALL

Select 'Sales' AS Description, FORMAT(ISNULL(SUM(TotalAfterDiscount),0),N'c') AS Total,
 
  17  AS Sort from TransactionEntryProfit WHere EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)

UNION ALL

Select 'Cost' AS Description, FORMAT(ISNULL(SUM(ISNULL(ExtCost,0)),0),N'c') AS Total,
 
  18  AS Sort from TransactionEntryProfit WHere EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)

UNION ALL

Select 'Gross Porfit' AS Description, FORMAT(ISNULL((((SUM(TotalAfterDiscount)-SUM(ISNULL(ExtCost,0))) /SUM(TotalAfterDiscount)) ),0),'P2') + '     '  + FORMAT(ISNULL(SUM(TotalAfterDiscount)-SUM(ISNULL(ExtCost,0)),0),N'c')  AS Total,
 
  19  AS Sort from TransactionEntryProfit WHere EndSaleTime > = @From and EndSaleTime < @To and (StoreID = @Store OR @Store IS NULL)

)		AS D
ORDER BY Sort
GO