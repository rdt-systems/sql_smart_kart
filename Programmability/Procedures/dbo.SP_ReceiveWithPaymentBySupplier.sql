SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveWithPaymentBySupplier]
@Supplier uniqueidentifier,@FromDate datetime,
@ToDate datetime

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

select Type,DAteT as DateT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,Amount,SupplierStatus
into #temp1
from ReceiveWithBill
where PID=@Supplier and SupplierStatus > 0 and DateT>=@FromDate and DateT<@ToDate

union

select  Type,DAteT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,(-Amount) as Amount,SupplierStatus
from PaymentToVentors
where PID=@Supplier and SupplierStatus > 0 and DateT>=@FromDate and DateT<@ToDate

union

select Type,DAteT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,(-Amount) as Amount ,SupplierStatus
from ReturnForRep
where PID=@Supplier and SupplierStatus > 0 and DateT>=@FromDate and DateT<@ToDate

---------------------------------

select SystemValueName as Type,Num,DateT,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,Amount,SupplierStatus
from #temp1 Inner Join 
     #CurrSystemValues On SystemValueNo=Type And SystemTableNo=34
GO