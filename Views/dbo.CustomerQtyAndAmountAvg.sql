SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE         VIEW [dbo].[CustomerQtyAndAmountAvg]
AS

SELECT    customerid ,
(case when (DATEDIFF(week, DateCreated, dbo.GetLocalDATE()))=0 then NULL 
	 else DATEDIFF(week, DateCreated, dbo.GetLocalDATE()) end) as WeekB,

	(case when (DATEDIFF(month, DateCreated, dbo.GetLocalDATE()))=0 then NULL 
	 else DATEDIFF(month, DateCreated, dbo.GetLocalDATE()) end) as MonthB,
	(case when (DATEDIFF(year, DateCreated, dbo.GetLocalDATE()))=0 then NULL 
	 else DATEDIFF(year, DateCreated, dbo.GetLocalDATE())end) as YearB,
	TotalQty,TotalDebit
FROM         dbo.CustomerQtyAndAmount
GO