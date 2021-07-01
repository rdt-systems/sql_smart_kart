SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemsMonthlySalesDetails]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))

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
where  SystemTableNo = 16

---------------------------------

declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)

Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
        declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect='Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1)  And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where (1=1)  '


declare @MySelect nvarchar(4000)

set @MySelect= 'Select
	                    TransactionID,
						TransactionNo,
						SystemValueName AS Type,
						ExtCost,
						AVGCost,
						QtyCase,
						Discount,
						TotalAfterDiscount,
						StartSaleTime,
						RegCost as Cost ,
						Price,	
						Qty as Qty,
						Total as ExtPrice,
						[Name] as ItemName,
						cast(CONVERT(CHAR(10), StartSaleTime, 23) as datetime) as MonthName,				
					 	isnull(Department,''[NO DEPARTMENT]'')as Department,
						StoreName
				From   dbo.TransactionEntryItem INNER JOIN #ItemSelect ON TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID Left Outer Join
                       #CurrSystemValues On TransactionType=#CurrSystemValues.SystemValueNo' 


Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' Order By CONVERT(CHAR(10), StartSaleTime, 23)'

print @ItemSelect 

print @ItemFilter 
print @CustomerSelect 
print @CustomerFilter 
print @MySelect
 print @MyWhere 
 print @Filter 
 print @MyGroupBy
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO