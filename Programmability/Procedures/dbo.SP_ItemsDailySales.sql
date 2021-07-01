SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemsDailySales]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @TableName nvarchar(4000))

as
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

set @MySelect= 'Select  sum(Qty) as Qty,
						sum(TotalAfterDiscount) as ExtPrice,
						dbo.GetDay(StartSaleTime) as DayOfYear,
						ItemID as ItemNo,
						[Name] as ItemName,
						DepartmentID,
						BarcodeNumber,
						isnull(Department,''[NO DEPARTMENT]'')as Department
				From dbo.' + @TableName + ' INNER JOIN #ItemSelect ON ' + @TableName + '.ItemStoreID = #ItemSelect.ItemStoreID '

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' group By dbo.GetDay(StartSaleTime),Department,ItemID,[Name],DepartmentID,BarcodeNumber
				Order By dbo.GetDay(StartSaleTime)'
--print (@ItemSelect + @ItemFilter + @MySelect + @TableName + @MyWhere + @Filter + @MyGroupBy)

PRINT (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)

Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)

IF EXISTS(Select * from Sys.tables where name = '#ItemSelect')
drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO