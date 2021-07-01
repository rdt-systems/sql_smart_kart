SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[DepartmentAmountSaleByDates](@Date1 datetime,
@Date2 datetime,
@StoreID uniqueidentifier)
AS
SELECT     SUM(dbo.TransactionEntryView.Total)as Total ,
           dateadd(Week,-(DATEDIFF(week, dbo.TransactionView.StartSaleTime, @Date2)),@Date2) as StartDateWeek,
           dbo.DepartmentStore.Name
FROM       dbo.TransactionView Left outer join
           dbo.TransactionEntryView on dbo.TransactionView.TransactionID=dbo.TransactionEntryView.TransactionID and dbo.TransactionEntryView.Status>0 And dbo.TransactionEntryView.TransactionEntryType=0 Left outer join
           dbo.ItemStore On dbo.TransactionEntryView.ItemStoreID=dbo.ItemStore.ItemStoreID And dbo.ItemStore.Status>0 Left outer join
           dbo.DepartmentStore  On  dbo.ItemStore.DepartmentID = dbo.DepartmentStore.DepartmentStoreID and dbo.DepartmentStore.Status>-1
WHERE     (dbo.TransactionView.StartSaleTime >= @Date1) AND (dbo.TransactionView.StartSaleTime <= @Date2) AND 
          (dbo.TransactionView.StoreID = @StoreID) and (dbo.TransactionView.Status > 0)
GROUP BY dateadd(Week,-(DATEDIFF(week, dbo.TransactionView.StartSaleTime, @Date2)),@Date2),dbo.DepartmentStore.Name
GO