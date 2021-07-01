SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[AgingSummaryGroupByAging]
AS
SELECT  isnull((CASE WHEN dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())=-1 THEN 'Current'
WHEN dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())=0 THEN '0-30'
WHEN dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())=1 THEN '30'
WHEN dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())=2 THEN '60'
WHEN dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())=3 THEN '90'
WHEN dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())=4 THEN '120' end),0)
AS Aging,  SUM(isnull(Amount,0)-isnull(AmountPay,0)) AS OpenBalance
FROM  dbo.ReceiveWithBill
where Amount<>AmountPay 
group by dbo.GetAgingDiff(IsNull(DueDate,DateT),dbo.GetLocalDATE())
having SUM(isnull(Amount,0)-isnull(AmountPay,0))>0
GO