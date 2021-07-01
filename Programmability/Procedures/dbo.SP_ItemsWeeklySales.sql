SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemsWeeklySales]
(@Filter nvarchar(4000),
 @StoreID uniqueidentifier,
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @TableName nvarchar(4000))

as

declare @FirstDayOfWeek nvarchar(4000)
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect=' Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
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
                  Select  Sum(Qty) as Qty,
						  Sum(TotalAfterDiscount) as ExtPrice,
						[Name] as ItemName,
						ItemID as ItemNo,
						BarcodeNumber,
						dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek) as WeekNumber,
				 		isnull(Department,''[NO DEPARTMENT]'')as Department,
						DepartmentID
				  From dbo.' + @TableName + ' INNER JOIN #ItemSelect ON ' + @TableName + '.ItemStoreID = #ItemSelect.ItemStoreID ' 

--set @MySelect= '''and OptionID=''131'')
--                  Select  0 as Qty,
--						  Sum(Total) as ExtPrice,
--						''[Name]'' as ItemName,
--						''ItemID'' as ItemNo,
--						dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek) as WeekNumber,
--				 		''Department'' as Department,
--						''DepartmentID'' AS DepartmentID
--				  From ' 
Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' Group By [Name],dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek),Department,ItemID,DepartmentID,BarcodeNumber
                 Order By dbo.GetFirstDayOfWeek(StartSaleTime,@FirstDayOfWeek)'


print (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @FirstDayOfWeek + CONVERT(nvarchar(50),@StoreID) + @MySelect + @MyWhere + @Filter + @MyGroupBy)


Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @FirstDayOfWeek + @StoreID + @MySelect + @MyWhere + @Filter + @MyGroupBy)

--declare @S as nvarchar(4000)
--set @S = '06d-524f-42e5-a539-1f63b0af64f4'
--print @ItemSelect + @ItemFilter 
----+ @CustomerSelect + @CustomerFilter 
--+ @FirstDayOfWeek + @S 
----@StoreID + 
--+@MySelect + @TableName + @MyWhere + @Filter + @MyGroupBy
IF EXISTS(Select * from sys.tables Where Name = '#ItemSelect')
drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO