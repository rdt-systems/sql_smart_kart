SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSaleOrderItem]
(@Filter nvarchar(4000))
AS
declare @MySelect nvarchar(4000)
set @MySelect= '
 	SELECT      dbo.WorkOrder.WorkOrderID,
		    dbo.WorkOrder.StartSaleTime,
		    dbo.WorkOrder.WONo, 
		    dbo.WorkOrderEntryView.Qty, 
                    dbo.WorkOrderEntryView.Price,
		    dbo.WorkOrderEntryView.Total
	FROM        dbo.WorkOrder 
		    INNER JOIN
                    dbo.WorkOrderEntryView ON dbo.WorkOrder.WorkOrderID = dbo.WorkOrderEntryView.WorkOrderID
	WHERE    '

Execute (@MySelect + @Filter )
GO