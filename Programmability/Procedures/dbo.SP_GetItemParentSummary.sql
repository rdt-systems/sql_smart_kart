SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetItemParentSummary]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))

AS 

DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)
DECLARE @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1)'

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1) And  exists (Select 1 From #CustomerSelect where CustomerID=CustomerID ) '
	end 
 
ELSE
	SET @MyWhere=	' where (1=1) '

--*********************************************

set @MySelect='
    SELECT 	ParentItemStoreID As ItemStoreID,
			ParentItemID,
		    Name, 
			BarcodeNumber, 
		    ItemTypeName, 
            Department,
			DepartmentID,
			Supplier,
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
            ParentCode,
            max(Price) as Price,
            max(OnHand) as OnHand,
			(CASE WHEN (IsNull(SUM(Qty),0)+(max(OnHand)))>0 THEN (100 / (max(OnHand) + SUM(QTY)) * SUM(QTY))/100 ELSE 0 END) AS SellThru

	FROM   dbo.TransactionEntryParentItem INNER JOIN #ItemSelect ON TransactionEntryParentItem.ItemStoreID = #ItemSelect.ItemStoreID' 

set @MyGroup = '

	GROUP BY    ParentItemStoreID,
				ParentItemID,
		        Name,
		        BarcodeNumber,
  		        ItemTypeName, 
                Department,
				DepartmentID,
		        Supplier,
		        StoreName,
				StoreID,
				ParentCode'			
Print   (@ItemSelect + @ItemFilter +@MySelect  + @MyWhere + @Filter +@MyGroup)
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect  + @MyWhere + @Filter +@MyGroup )


drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO