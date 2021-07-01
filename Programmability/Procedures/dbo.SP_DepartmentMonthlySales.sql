﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_DepartmentMonthlySales]
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
						cast(CONVERT(CHAR(10), StartSaleTime, 23) as datetime)  as MonthName,
						isnull(Department,''[NO DEPARTMENT]'')as Department,DepartmentID, StoreName
                       
				From dbo.' + @TableName + ' INNER JOIN #ItemSelect ON '+@TableName + '.ItemStoreID = #ItemSelect.ItemStoreID '

 
Declare @MyGroupBy nvarchar(4000)
set @MyGroupBy=' group By CONVERT(CHAR(10), StartSaleTime, 23), StoreName ,Department ,DepartmentID
				Order By CONVERT(CHAR(10), StartSaleTime, 23) '

Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO