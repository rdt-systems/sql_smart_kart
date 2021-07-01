SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetComparisonDates]
(@Filter Nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))
AS 

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
		SET @MyWhere=	' AND exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryItem.ItemStoreID) And  exists (Select 1 From #CustomerSelect where CustomerID=TransactionEntryItem.CustomerID ) '
	end 
 
ELSE
	SET @MyWhere=	' AND  exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryItem.ItemStoreID) '

--*********************************************


declare @MySelect Nvarchar(4000)
SET @MySelect='SELECT DepartmentStore.Name,
					  DepartmentStore.DepartmentStoreID,
	                  ISNULL(SUM(Total),0) as ExtPrice,
					  ISNULL(SUM(ExtCost),0) AS ExtCost, 
					  ISNULL(SUM(Qty), 0) AS Qty,
                      ROUND(ISNULL(SUM(QtyCase), 0),2,1) AS CaseQty
	         
			   FROM DepartmentStore LEFT OUTER JOIN 
                       TransactionEntryItem on TransactionEntryItem.departmentID=DepartmentStore.departmentStoreID ' 

declare @MyUnion Nvarchar(4000)

SET @MyUnion='GROUP BY DepartmentStore.Name,
					   DepartmentStore.DepartmentStoreID
UNION ALL
	          SELECT   ''[NO DEPARTMENT]'', 
						NULL as DepartmentStoreID,
						ISNULL(SUM(Total),0) AS ExtPrice, 
						ISNULL(SUM(ExtCost),0) AS ExtCost, 
						ISNULL(SUM(Qty),0) AS Qty,
						ROUND(ISNULL(SUM(QtyCase), 0),2,1) AS CaseQty
             
			  FROM     dbo.TransactionEntryItem 
			  
			  WHERE     (DepartmentID is null) '

exec (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyUnion + @MyWhere + @Filter)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO