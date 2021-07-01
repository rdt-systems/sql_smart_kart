SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetWorkOrderItem]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 
   'SELECT     WONo, 
			   WorkOrderID, 
			   StartSaleTime, 
	       
               ItemStoreID,
			   Qty, 
			   1 as Status,
               Total,
	           Total as Price, 
	           QtyCase AS QtyCase
		
    FROM      WorkOrderEntryItem

	WHERE   1=1 '

Execute (@MySelect + @Filter )
GO