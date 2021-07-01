SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemsMonthlySales]
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
		SET @MyWhere=	' where (1=1) And exists (Select 1 From #ItemSelect where ItemStoreID=transactionEntryItem.ItemStoreID) And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where (1=1) And exists (Select 1 From #ItemSelect where ItemStoreID=transactionEntryItem.ItemStoreID) '


set @MySelect= 'Select	Sum(Qty) as Qty,
						Sum(TotalAfterDiscount) as ExtPrice,
						[Name] as ItemName,
						ItemID as ItemNo,
						BarcodeNumber As UPC,
						cast(CONVERT(CHAR(10), StartSaleTime, 23) as datetime) as MonthName,
				 		isnull(Department,''[NO DEPARTMENT]'')as Department,
                        DepartmentID
				 From ' 

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' Group By [Name],Department,CONVERT(CHAR(10), StartSaleTime, 23),ItemID,DepartmentID,BarcodeNumber
				 Order By CONVERT(CHAR(10), StartSaleTime, 23)'
PRINT (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @TableName + @MyWhere + @Filter + @MyGroupBy)
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @TableName + @MyWhere + @Filter + @MyGroupBy)

If Exists (Select * from sys.tables where Name = '#ItemSelect')
drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO