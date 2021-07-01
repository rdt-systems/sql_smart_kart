SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetSupplierSalesSummary] 
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @TableName nvarchar(40)='TransactionEntryItem')


as

Declare @Sel1 nvarchar(4000)
Declare @Sel2 nvarchar(4000)
declare @MyWhere nvarchar(4000)

Declare @MyIndex nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

Set @MyIndex = 'CREATE NONCLUSTERED INDEX [#Tem_Index_Temp_Table]
ON [dbo].[#ItemSelect] ([ItemStoreID])'


if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where  exists (Select 1 From #CustomerSelect where CustomerID= CustomerID ) '
	end 
 
ELSE
    SET @MyWhere=	' where 1=1 '

set @Sel1='SELECT         SupplierID,
						ISNULL(Supplier,''[No Supplier]'') AS Supplier,
                        SUM(  Qty) AS Qty, 
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
		  FROM TransactionEntryItem INNER JOIN #ItemSelect ON TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID '      
						 

set @Sel2='   
 GROUP BY		  SupplierID,
						  Supplier,
						  StoreName,
						  StoreID '


print (@ItemSelect + @ItemFilter   + @Sel1 + @MyWhere + @Filter + @Sel2)
execute (@ItemSelect + @ItemFilter + @MyIndex + @CustomerSelect + @CustomerFilter + @Sel1 + @MyWhere + @Filter + @Sel2)

if OBJECT_ID('tempdb..#ItemSelect') is not null 
drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO