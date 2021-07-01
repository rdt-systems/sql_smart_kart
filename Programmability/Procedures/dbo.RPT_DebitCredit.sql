SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[RPT_DebitCredit]
(@FromDate datetime,
 @ToDate datetime)
AS
SELECT        StartSaleTime AS Date, COUNT(Debit) AS TransCount, SUM(Debit) / COUNT(Debit) AS AVGSale, SUM(Debit) AS Debit, SUM(Credit) AS Credit, SUM(Debit) - SUM(Credit) AS Balance
FROM            [Transaction]
WHERE        (Status > 0) AND (dbo.GetDay(StartSaleTime) >= @FromDate) AND (dbo.GetDay(StartSaleTime) <= @ToDate)
GROUP BY StartSaleTime
ORDER BY StartSaleTime
GO