SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[AmountSaleByDates](@Date1 datetime,
@Date2 datetime,
@StoreID uniqueidentifier)
AS
SELECT      SUM(dbo.TransactionView.Debit)as Total ,dateadd(Week,-(DATEDIFF(week, dbo.TransactionView.StartSaleTime, @Date2)),@Date2) as StartDateWeek
FROM       dbo.TransactionView
WHERE     (dbo.TransactionView.StartSaleTime >= @Date1) AND (dbo.TransactionView.StartSaleTime <= @Date2) AND 
                      (dbo.TransactionView.StoreID = @StoreID) and (dbo.TransactionView.Status > 0)
GROUP BY dateadd(Week,-(DATEDIFF(week, dbo.TransactionView.StartSaleTime, @Date2)),@Date2)
GO