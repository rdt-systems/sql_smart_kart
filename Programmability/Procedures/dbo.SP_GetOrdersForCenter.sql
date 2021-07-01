SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOrdersForCenter]
(@Filter nvarchar(4000))

as
Declare @IsHeb as bit
Set @IsHeb= (Select OptionValue from SetupValues where OptionName='Language' And  StoreID ='00000000-0000-0000-0000-000000000000')

CREATE TABLE #CurrSystemValues(
	[SystemValueNo] [int] NOT NULL,
	[SystemValueName] [nvarchar](50) COLLATE HEBREW_CI_AS)

INSERT INTO #CurrSystemValues(systemvalueno,SystemValueName)
Select SystemValueNo,(case when @IsHeb = 0 then SystemValueName else SystemValueNameHe end ) as SystemValueName
from SystemValues
where SystemTableNo='35'

declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     PurchaseOrderId, PoNo, Type, PurchaseOrderDate, GrandTotal,
                           SystemValueName AS Status,SupplierNo, StoreNo,IsVoid

                FROM       dbo.OrderForCenter inner join
                           #CurrSystemValues On SystemValueNo=Postatus
	            WHERE     '
Execute (@MySelect + @Filter )
GO