SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_SuppliersBalance]
(@asDate  datetime)

as

SELECT   PID,
	dbo.GetAgingDiff(IsNull(DueDate,DateT),@asDate) AS MonthDif,
  	SUM(isnull(Amount,0)-isnull(AmountPay,0)) AS DebitByDays
INTO #MyTemp
FROM  ReceiveWithBill
where   Amount<>AmountPay 
group by PID,dbo.GetAgingDiff(IsNull(DueDate,DateT),@asDate) having SUM(isnull(Amount,0)-isnull(AmountPay,0))>0

select SupplierID,[Name],Status
		,ISNULL
                          ((SELECT     SUM(SupplierLeftDebit.LeftDebit)
                              FROM         SupplierLeftDebit
                              WHERE     SupplierLeftDebit.SupplierNo = Supplier.SupplierID), 0) AS Balance,

		isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=-1 AND PID= dbo.Supplier.SupplierID),0) as [No Payable]
		,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=0 AND PID= dbo.Supplier.SupplierID),0) as [Current]
		,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=1 AND PID= dbo.Supplier.SupplierID),0) as Over30
		,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=2 AND PID= dbo.Supplier.SupplierID),0) as Over60
		,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=3 AND PID= dbo.Supplier.SupplierID),0) as Over90
		,isnull((SELECT DebitByDays FROM #MyTemp  WHERE MonthDif=4 AND PID= dbo.Supplier.SupplierID),0) as Over120
FROM         dbo.Supplier
WHERE     (Status > 0)
              
drop TABLE #MyTemp
GO