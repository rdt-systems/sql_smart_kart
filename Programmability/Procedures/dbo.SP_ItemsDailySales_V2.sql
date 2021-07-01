SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[SP_ItemsDailySales_V2]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @TableName nvarchar(4000))

as
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

--declare @ItemSelect nvarchar(4000)
declare @CustomerSelect nvarchar(4000)

set @CustomerSelect=''


--Set  @ItemSelect=''

if @CustomerFilter<>''

	begin 
		Set  @CustomerSelect='Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1) ' --And exists (Select 1 From #ItemSelect where ItemStoreID=transactionEntryItem_rm.ItemStoreID) And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where (1=1) ' --And exists (Select 1 From #ItemSelect where ItemStoreID=transactionEntryItem_rm.ItemStoreID) '

set @MySelect= 'Select  sum(Qty) as Qty,
						sum(Total) as ExtPrice,
						--dbo.GetDay(StartSaleTime) as DayOfYear,
						cast(Cast(year(StartSaleTime)as nvarchar)+''-''
				+Cast(Month(StartSaleTime)as nvarchar)+''-''
				+Cast(Day(StartSaleTime)as nvarchar) as DateTime) as StartSaleTime,
						ItemID as ItemNo,
						[Name] as ItemName,
						DepartmentID,
						BarcodeNumber,
						isnull(Department,''[NO DEPARTMENT]'')as Department
				From '

Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' group By 


cast(Cast(year(StartSaleTime)as nvarchar)+''-''
				+Cast(Month(StartSaleTime)as nvarchar)+''-''
				+Cast(Day(StartSaleTime)as nvarchar) as DateTime),-- as StartSaleTime,
Department,
ItemID,[Name],  
DepartmentID,
BarcodeNumber
				Order By StartSaleTime'
print (@ItemFilter + @MySelect + @TableName + @MyWhere + @Filter + @MyGroupBy)

Execute (--@ItemSelect +

 @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @TableName + @MyWhere + @Filter + @MyGroupBy)

--drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO