SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- exec SP_GetItemsOnSaleOrder null
-- exec SP_GetItemSummary null


CREATE PROCEDURE [dbo].[SP_GetItemsOnSaleOrder]
(@Filter nvarchar(4000))
AS 
DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)

set @MySelect='
    SELECT 	ItemStoreID,
		    Name, 
			ModalNumber,
		    BarcodeNumber, 
            Department,
			DepartmentID,
			SUM(Qty) AS Qty,
	       	SUM(QtyCase) AS QtyCase,
			SUM(Total) as ExtPrice,--, 

	        --sum(Discount) as Discount,
               		
			--SUM(TotalAfterDiscount) as TotalAfterDiscount

	FROM    dbo.WorkOrderEntryItem 

    WHERE   
	
		    1=1 '

set @MyGroup = '

	GROUP BY    ItemStoreID,
		        Name,
		        ModalNumber, 
		        BarcodeNumber,
                Department,
				DepartmentID '

     

print (@MySelect + @Filter +@MyGroup )
Execute (@MySelect + @Filter +@MyGroup )
GO