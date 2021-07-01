SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionByAging]

(@CustomerID uniqueidentifier,
 @ByDate datetime,
 @FromDate int=-1,
 @ToDate int=-1)
as 
if @FromDate = -99
	   select * from InvoicesView
		   WHERE  PID = @CustomerID and  Type='Open Balance'
if @FromDate = -1
	begin 
		if @ToDate = -1
		   select * from InvoicesView
		   WHERE   PID = @CustomerID and OpenBalance>0 and Status>0 
		else
		   select * from InvoicesView
		   WHERE   PID = @CustomerID and convert(varchar,isnull(DueDate,DateT),11) > convert(varchar,@ByDate,11) and OpenBalance>0 and Status>0
	end 
else
	if @ToDate=-1
		select * from InvoicesView
		WHERE    convert(varchar, isnull(DueDate,DateT),11) <= convert(varchar,DATEADD(day, @FromDate, @ByDate),11)
	           AND PID = @CustomerID and OpenBalance>0 and Status>0
	else
		select * from InvoicesView
		WHERE     convert(varchar,isnull(DueDate,DateT),11) <= convert(varchar,DATEADD(day, @FromDate, @ByDate),11)
	           AND convert(varchar,isnull(DueDate,DateT),11) > convert(varchar,DATEADD(day, @ToDate, @ByDate),11) 
	           AND PID = @CustomerID and OpenBalance>0 and Status>0
GO