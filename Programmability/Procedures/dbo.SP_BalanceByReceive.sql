SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BalanceByReceive]

(@SupplierID uniqueidentifier,
 @ByDate datetime,
 @FromDate int=-2)

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
-------------------------------------------

		if @FromDate = -2
		   select systemValueName as [Type],DateT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,Amount,SupplierNo,SupplierStatus
           from ReceiveWithBill Inner Join
                #CurrSystemValues On #CurrSystemValues.SystemValueNo=[Type] and #CurrSystemValues.SystemTableNo = 34 

		   WHERE   PID = @SupplierID and OpenBalance > 0 and SupplierStatus>0
		else
		   select systemValueName as [Type],DateT,Num,DueDate,OpenBalance,AmountPay,IDc,PID,SuppName,Amount,SupplierNo,SupplierStatus
           from ReceiveWithBill Inner Join
                #CurrSystemValues On #CurrSystemValues.SystemValueNo=[Type] and #CurrSystemValues.SystemTableNo = 34 

	           WHERE   PID = @SupplierID and dbo.GetAgingDiff(DueDate,@ByDate)=@FromDate and OpenBalance > 0 and SupplierStatus>0
GO