SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_TransactionAgingDetails] 
@ByDate datetime,
@StoreID uniqueidentifier=null
AS

SELECT *,
     (case  when convert(varchar,isnull(DueDate,DateT),111) > convert(varchar,@ByDate,111) then 0
            when convert(varchar,isnull(DueDate,DateT),111) <= convert(varchar,@ByDate,111) and convert(varchar,isnull(DueDate,DateT),111) > convert(varchar,DATEADD(day, - 30, @ByDate),111) then 1
            when convert(varchar,isnull(DueDate,DateT),111) <= convert(varchar,DATEADD(day, - 30, @ByDate),111) AND convert(varchar,isnull(DueDate,DateT),111) > convert(varchar,DATEADD(day, - 60, @ByDate),111) then 2
            when convert(varchar,isnull(DueDate,DateT),111) <= convert(varchar,DATEADD(day, - 60, @ByDate),111) AND convert(varchar,isnull(DueDate,DateT),111) > convert(varchar,DATEADD(day, - 90, @ByDate),111) then 3
            when convert(varchar,isnull(DueDate,DateT),111) <= convert(varchar,DATEADD(day, - 90, @ByDate),111) AND convert(varchar,isnull(DueDate,DateT),111) > convert(varchar,DATEADD(day, - 120, @ByDate),111) then 4
            when convert(varchar,isnull(DueDate,DateT),111) <= convert(varchar,DATEADD(day, - 120, @ByDate),111) then 5
end) as Aging 
FROM InvoicesView
Where Status>0 and openBalance>0 and (Select Status from Customer WHERE CustomerID=InvoicesView.PID)>0
and (@StoreID=StoreID or @StoreID is null)
GO