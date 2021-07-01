SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ChartMonthlyPerItemSales]
(@Filter nvarchar(4000),
 @TableName nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
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
		SET @MyWhere=	' where (1=1) And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where (1=1) '

set @MySelect= 'Select  sum(Qty) as Qty,
						sum(Total) as ExtPrice,
						[Name] as ItemName,
						convert(nvarchar,dbo.GetFirstDayOfMonth(StartSaleTime),101) as MonthName
				From dbo.' + @TableName + ' INNER JOIN #ItemSelect ON '+ @TableName+ '.ItemStoreID = #ItemSelect.ItemStoreID ' 

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' group By dbo.GetFirstDayOfMonth(StartSaleTime),[Name]
				Order By dbo.GetFirstDayOfMonth(StartSaleTime)'

Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO