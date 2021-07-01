SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetCustomerItemSummary]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000),
 @CustomerId nvarchar(4000) =null )

AS 

DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)
DECLARE @MyJoin nvarchar(4000)
DECLARE @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
				  Into #ItemSelect 
                  From dbo.ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1)  And  exists (Select * From #CustomerSelect where CustomerID = T.CustomerID ) '
	end 
 
ELSE
	SET @MyWhere=	' where (1=1)  '

if @CustomerId <>''
begin 
SET @MyWhere= ' where T.CustomerID = '''+@CustomerId+''''
end 
--*********************************************

set @MySelect='
    SELECT 	C.CustomerID,
			C.Name AS CustomerName,
			C.CustomerNo,
			C.Address,
			C.CityStateAndZip,
	        T.ItemStoreID,
		    T.Name, 
			ParentName,
			Color,
			Size,
			ModalNumber,
		    BarcodeNumber, 
		    ItemTypeName, 
            Department,
			DepartmentID,
			MainDepartment,
			SubDepartment,
			SubSubDepartment,
			(CASE WHEN IsNull(Supplier,'''')='''' THEN ParentSupplerName  ELSE Supplier END)As Supplier,
			SupplierCode as ItemCodeSupplier,
			Brand,
			CustomerCode,
			SUM(Qty) AS Qty,
	       	SUM(QtyCase) AS QtyCase,
	       	SUM(ExtCost) as ExtCost,
	       	SUM(Total) as ExtPrice, 

	   --    	(CASE WHEN SUM(TotalAfterDiscount)=0 then 0 
				--  ELSE SUM(Profit)/ 
				--	       SUM(TotalAfterDiscount)
			 --END) as MarginPrice,
			(CASE WHEN SUM(TotalAfterDiscount)=0 OR SUM(Profit)<=0 then 0
				 ELSE ((SUM(Profit))/ 
			 (SUM(TotalAfterDiscount)/100))/100
             END)
		     as MarginPrice,

	       	 (CASE 	WHEN SUM(ExtCost) <> 0 
				         THEN SUM(Profit)/
					          SUM(ExtCost)
				     ELSE 0			
			 END) as MarkupPrice,

	       	SUM(Profit) as Profit,

	        (SUM(Total) - SUM(TotalAfterDiscount))  as Discount,
               		
			SUM(TotalAfterDiscount) as TotalAfterDiscount,
			StoreName,
			StoreID,
            ItemID,
			(CASE WHEN IsNull(SupplierCode,'''')='''' THEN ParentCode  ELSE SupplierCode END)As ParentCode,
            max(Price) as Price,
            max(OnHand) as OnHand,
			(CASE WHEN (IsNull(SUM(Qty),0)+(max(OnHand)))>0 THEN (100 / (max(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru,
			c.GroupName
	FROM   dbo.TransactionEntryItem AS T INNER JOIN #ItemSelect ON T.ItemStoreID= #ItemSelect.ItemStoreID 
	INNER JOIN  dbo.CustomerView AS C on T.CustomerID = C.CustomerID ' 

 


set @MyGroup = '

	GROUP BY    C.CustomerID,
				C.Name,
				C.CustomerNo,
				C.Address, 
				C.CityStateAndZip,
				T.ItemStoreID,
		        T.Name,
				ParentName,
				Color,
				Size,
		        ModalNumber, 
		        BarcodeNumber,
  		        ItemTypeName, 
                Department,
				DepartmentID,
				MainDepartment,
				SubDepartment,
				SubSubDepartment,
		        Supplier,
		        SupplierCode,
				Brand,
				CustomerCode,
			    StoreName,
				StoreID,
				ParentCode,
                ItemID,
				ParentSupplerName,
				c.GroupName'


--@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @TableName + @MyWhere + @Filter +@MyGroup 

Print   (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect +  @MyWhere + @Filter +@MyGroup)
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect +  @MyWhere + @Filter +@MyGroup )


if object_id ('tempdb..#ItemSelect') is not null drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO