SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAllTransactionForSupplier]
(@Filter nvarchar(4000))

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

declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     IDc,SupplierNo,SystemValueName as Type ,Datet,Num,Amount,StoreNo,Status 
                FROM       dbo.AllTransactionForSupplier Inner Join
                           #CurrSystemValues On #CurrSystemValues.SystemValueNo=[Type] and #CurrSystemValues.SystemTableNo = 34 
	            WHERE     (Status > - 1)'
Execute (@MySelect + @Filter )
GO