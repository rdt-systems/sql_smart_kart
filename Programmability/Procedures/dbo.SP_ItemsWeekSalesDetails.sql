SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemsWeekSalesDetails]
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

---------------------------------

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

declare @MyWhere nvarchar(4000)

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

set @MySelect= 'Select  TransactionID,
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
					    [dbo].[GetDay](StartSaleTime)as DayWeek, -- datename(dw,StartSaleTime) 
						datepart(hour,StartSaleTime) as SortHours,
       					dbo.GetHourFromToFormat(StartSaleTime,1) AS Hours,
                        isnull(Department,''[NO DEPARTMENT]'')as Department,
                        StoreName
                       
				From dbo.TransactionEntryItem Inner Join #ItemSelect ON TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID INNER JOIN
                      #CurrSystemValues On #CurrSystemValues.SystemValueNo=TransactionType and #CurrSystemValues.SystemTableNo = 16 '

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' Order By datepart(hour,StartSaleTime) '


Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO