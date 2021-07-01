SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[AgingSummaryGroupByAgingAR]
AS

SELECT     (CASE WHEN dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())=-1 THEN 'Current'
            WHEN dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())=0 THEN '0-30'
            WHEN dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())=1 THEN '30'
            WHEN dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())=2 THEN '60'
            WHEN dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())=3 THEN '90'
            WHEN dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())=4 THEN '120' end) AS Aging,
       SUM(isnull(LeftDebit,debit)) AS OpenBalance

FROM  [transaction]

where (transactionType=0 or TransactionType=2 or TransactionType=4) 
       and LeftDebit>0 
       and status>0 
       and StartSaleTime>=dbo.GetCustomerDateStartBalance([Transaction].CustomerID)and (Select Status from Customer WHERE CustomerID=[Transaction].CustomerID)>0

group by dbo.GetAgingDiff(IsNull(duedate,StartSaleTime),dbo.GetLocalDATE())

having SUM(isnull(LeftDebit,debit))>0
GO