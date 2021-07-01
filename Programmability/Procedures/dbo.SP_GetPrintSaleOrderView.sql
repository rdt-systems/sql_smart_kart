SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPrintSaleOrderView]
(@WorkOrderID uniqueidentifier)
AS SELECT     *
FROM         dbo.PrintSaleOrderView
WHERE     (WorkOrderID = @WorkOrderID)
GO