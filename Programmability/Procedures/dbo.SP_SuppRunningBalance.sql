SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SuppRunningBalance]
(@FromDate datetime,@Todate dateTime ,@SuppID uniqueidentifier)
as

--Declare @IsHeb as bit
--Set @IsHeb= (Select OptionValue from SetupValues where OptionName='Language' And  StoreID ='00000000-0000-0000-0000-000000000000')

CREATE TABLE #CurrSystemValues(
[SystemTableNo] [bigint] NOT NULL,
[SystemValueNo] [int] NOT NULL,
[SystemValueName] [nvarchar](50) COLLATE HEBREW_CI_AS)

insert into #CurrSystemValues(systemtableno,systemvalueno,SystemValueName)
Select SystemTableNo,SystemValueNo,
--(case when @IsHeb = 0 then SystemValueName else SystemValueNameHe end ) 
SystemValueName as SystemValueName
from SystemValues

---------------------------
select ReceiveOrderDate as Date,Total,SupplierNo as SupplierID
Into #Temp1
FROM       dbo.ReceiveForCenter
where status<>0 
 
union

select ReturnToVenderDate,-Total,SupplierID
from ReturnForCenter
where IsVoid<>0 

union

select Date,-Amount,SupplierID
from dbo.PaymentsForCenter
where  IsVoid<>0 


select ReceiveID as  ID,BillNo as TransNo,1 as IntType,BillDate as Date,SupplierNo,
		(select Case 
		when isnull(AmountPay,0)=0 then 0
		when Amount=AmountPay then 2 
		else 3
		end) As Paid
		,Amount,0 as AmountPay,
		(SELECT     SUM(Total) AS Balance
         FROM  #Temp1 
		 where SupplierID = dbo.ReceiveOrderView.SupplierNo and Date<=ReceiveOrderView.BillDate)
         AS Balance
into #Temp2
from ReceiveOrderView  inner join 
              #CurrSystemValues as PaidStatus On SystemValueNo=(select Case 
		when isnull(AmountPay,0)=0 then 0
		when Amount=AmountPay then 2 
		else 3
		end) And SystemTableNo=37   
where Status>0

union 

select SuppTenderEntryID,SuppTenderNo,3 as Type,Date,SupplierID,
		(case when status = 0 then 0 When status=Amount then 2 else  1 end) As Paid
		,0 as Amount, Amount as AmountPay,
		(SELECT     SUM(Total) AS Balance
         FROM  #Temp1 
		 where SupplierID = dbo.PaymentsForCenter.SupplierID and Date<=PaymentsForCenter.Date)
         AS Balance
from dbo.PaymentsForCenter inner join 
              #CurrSystemValues as ApppliedStatus On SystemValueNo=(case when status = 0 then 0 When status=Amount then 2 else  1 end) And SystemTableNo=36
where  IsVoid<>0

union 

select ReturnToVenderID,ReturnToVenderNo,2 as Type,ReturnToVenderDate,SupplierID,
		(case when status = 0 then 0 When status=Total then 2 else 1 end ) As Paid
		,0 as Amount ,Total as AmountPay,
		(SELECT     SUM(Total) AS Balance
         FROM  #Temp1 
		 where SupplierID = dbo.ReturnForCenter.SupplierID and Date<=ReturnForCenter.ReturnToVenderDate)
         AS Balance

from dbo.ReturnForCenter inner join 
     #CurrSystemValues as ApppliedStatus On SystemValueNo=(case when status = 0 then 0 When status=Total then 2 else 1 end ) And SystemTableNo=36 
where IsVoid>0

select ID, TransNo, SystemValueName as Type,Date,SupplierNo,Paid,Amount,AmountPay,Balance
from #Temp2 inner Join 
              #CurrSystemValues as APType On SystemValueNo=IntType And SystemTableNo=34 
where SupplierNo=@SuppID and Date>@FromDate and Date<=@ToDate
order by Date

drop table #Temp1
drop table #Temp2
drop table #CurrSystemValues
GO