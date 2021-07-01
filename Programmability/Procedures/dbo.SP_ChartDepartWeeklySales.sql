SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ChartDepartWeeklySales]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @StoreID uniqueidentifier,
 @TableName nvarchar(4000))

as
declare @FirstDayOfWeek nvarchar(4000)
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
declare @CustomerSelect nvarchar(4000)

set @CustomerSelect=''

Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
		Set  @CustomerSelect='Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1)  And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where (1=1)  '

set @FirstDayOfWeek='declare @FirstDayOfWeek Smallint
				     set @FirstDayOfWeek =(Select Top 1 OptionValue From SetupValues Where StoreID='''

set @MySelect= '''and OptionID=''131'')
				Select  sum(Qty) as Qty,
						sum(Total) as ExtPrice,
						isnull(Department,''[NO DEPARTMENT]'')as Department,
						convert(nvarchar,dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek),101) as Week
				From dbo.' + @TableName + ' INNER JOIN #ItemSelect ON '+ @TableName+ '.ItemStoreID = #ItemSelect.ItemStoreID ' 

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' group By dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek),Department
				Order By dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek)'
Print   (@ItemSelect +@FirstDayOfWeek +@MySelect + @TableName + @MyWhere + @Filter +@MyGroupBy)
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter +@FirstDayOfWeek + @StoreID + @MySelect + @MyWhere  + @Filter + @MyGroupBy)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO