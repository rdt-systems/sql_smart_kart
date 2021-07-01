SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSalesIncentiveSummery]
(@Filter nvarchar(4000))
AS 
 DECLARE @MySelect nvarchar(4000) 
 SET @MySelect='SELECT        UserName, SUM(IncentiveAmount) AS SumAmount, SUM(SalesValue) AS SumSale, ISNULL(SUM(IncentiveAmount), 0) / (ISNULL(SUM(SalesValue), 0) * .01) 
                         AS SumPercent, StoreName FROM  SalesIncentiveEntryView  WHERE 1=1'
DECLARE @MyGroup nvarchar(500)
SET @MyGroup ='GROUP BY UserName, StoreName'
 exec(@MySelect +@Filter+@MyGroup)
GO