SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetDepartmentSummaryWithReturn] 
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @TableName nvarchar(40)='TransactionEntryItem')


as

Declare @Sel1 nvarchar(4000)
Declare @Sel2 nvarchar(4000)
declare @MyWhere nvarchar(4000)


declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
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
		SET @MyWhere=	' where  exists (Select 1 From #CustomerSelect where CustomerID= '+@TableName+'CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where  1 = 1  '

IF (Select COUNT(*) from SetUpValues where OptionID = 100 and ((OptionValue = '1') or(OptionValue = 'True')) And StoreID <> '00000000-0000-0000-0000-000000000000') >0
set @Sel1='SELECT         DepartmentID,
						ISNULL(  Department,''[NO DEPARTMENT]'') as Department,
						MainDepartment,
						SubDepartment,
						SubSubDepartment,
                        SUM( case when  Qty >0 then Qty else 0 end) AS Qty,
						SUM( case when  Qty <0 then Qty else 0 end) AS ReturnQty,  
						SUM(  QtyCase) AS QtyCase,
						SUM(  ExtCost) as ExtCost,
						SUM(  Total) as ExtPrice, 


						(CASE WHEN SUM(  TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0
							  ELSE ((SUM(  Profit))/ 
					               (SUM(  TotalAfterDiscount)/100))/100
                         END)
						 as MarginPrice,

						(CASE WHEN SUM(  ExtCost) <> 0 then
						           SUM(  Profit)/ SUM(  ExtCost)
							ELSE 0
						 END) as MarkupPrice,

						SUM(  Profit)as Profit,
						SUM(  TotalAfterDiscount) as TotalAfterDiscount,

						SUM(  Discount) as Discount,
						SUM(  OnHand) as OnHand,
						SUM(  OnOrder) as OnOrder,
						  StoreName,
						  StoreID,
						(CASE WHEN (IsNull(SUM(Qty),0)+(Sum(OnHand)))>0 THEN (100 / (Sum(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru
		  FROM dbo.' +@TableName +' INNER JOIN #ItemSelect ON '+@TableName+'.ItemStoreID = #ItemSelect.ItemStoreID '

Else

set @Sel1='SELECT         DepartmentID,
						ISNULL(  Department,''[NO DEPARTMENT]'') as Department,
						'''' AS MainDepartment,
						'''' AS SubDepartment,
						'''' AS SubSubDepartment,
                       SUM( case when  Qty >0 then Qty else 0 end) AS Qty,
						SUM( case when  Qty <0 then Qty else 0 end) AS ReturnQty,  
						SUM(  QtyCase) AS QtyCase,
						SUM(  ExtCost) as ExtCost,
						SUM(  Total) as ExtPrice, 


						(CASE WHEN SUM(  TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0
							  ELSE ((SUM(  Profit))/ 
					               (SUM(  TotalAfterDiscount)/100))/100
                         END)
						 as MarginPrice,

						(CASE WHEN SUM(  ExtCost) <> 0 then
						           SUM(  Profit)/ SUM(  ExtCost)
							ELSE 0
						 END) as MarkupPrice,

						SUM(  Profit)as Profit,
						SUM(  TotalAfterDiscount) as TotalAfterDiscount,

						SUM(  Discount) as Discount,
						SUM(  OnHand) as OnHand,
						SUM(  OnOrder) as OnOrder,
						  StoreName,
						  StoreID,
						(CASE WHEN (IsNull(SUM(Qty),0)+(Sum(OnHand)))>0 THEN (100 / (Sum(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru
		  FROM ' +@TableName      
						 
IF (Select COUNT(*) from SetUpValues where OptionID = 100 and ((OptionValue = '1') or(OptionValue = 'True')) And StoreID <> '00000000-0000-0000-0000-000000000000') >0
set @Sel2='   
 GROUP BY		  DepartmentID,
						  Department,
						  MainDepartment,
						SubDepartment,
						SubSubDepartment,
						  StoreName,
						  StoreID '

else

set @Sel2='   
 GROUP BY		  DepartmentID,
						  Department,
						  StoreName,
						  StoreID '


print (@ItemSelect + @ItemFilter   + @Sel1 + @MyWhere + @Filter + @Sel2)
execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @Sel1 + @MyWhere + @Filter + @Sel2)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO