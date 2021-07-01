SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ReceiveWithAging]
@ByDate datetime


as


Declare @IsHeb as bit
Set @IsHeb= (Select OptionValue from SetupValues where OptionName='Language' And  StoreID ='00000000-0000-0000-0000-000000000000')

CREATE TABLE #CurrSystemValues(
	[SystemTableNo] [bigint] NOT NULL,
	[SystemValueNo] [int] NOT NULL,
	[SystemValueName] [nvarchar](50) COLLATE HEBREW_CI_AS)

INSERT INTO #CurrSystemValues(systemtableno,systemvalueno,SystemValueName)
Select SystemTableNo,SystemValueNo,(case when @IsHeb = 0 then SystemValueName else SystemValueNameHe end ) as SystemValueName
from SystemValues

---------------------------------
select SystemValueName as [Type],DateT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,Amount,SupplierNo,SupplierStatus,
(select case when convert(nvarchar,DueDate,101) > @ByDate then 0
             when convert(nvarchar,DueDate,101) <= @ByDate and DueDate > DATEADD(day, - 30, @ByDate) then 1
             when convert(nvarchar,DueDate,101) <= DATEADD(day, - 30, @ByDate) AND convert(nvarchar,DueDate,101) > DATEADD(day, - 60, @ByDate) then 2
             when convert(nvarchar,DueDate,101) <= DATEADD(day, - 60, @ByDate) AND convert(nvarchar,DueDate,101) > DATEADD(day, - 90, @ByDate) then 3
             when convert(nvarchar,DueDate,101) <= DATEADD(day, - 90, @ByDate) AND convert(nvarchar,DueDate,101) > DATEADD(day, - 120, @ByDate) then 4
             when convert(nvarchar,DueDate,101) <= DATEADD(day, - 120, @ByDate) then 5
end) as Aging
into #temp1
from ReceiveWithBill Inner Join
     #CurrSystemValues On #CurrSystemValues.SystemValueNo=[Type] and #CurrSystemValues.SystemTableNo = 34 

where SupplierStatus>0

select [Type],DateT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,Amount,SupplierNo,SupplierStatus,SystemValueName as Aging
from #temp1 Inner Join
     #CurrSystemValues On #CurrSystemValues.SystemValueNo=Aging and #CurrSystemValues.SystemTableNo = 38 

drop table #temp1
GO