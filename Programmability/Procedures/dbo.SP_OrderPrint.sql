SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderPrint](@ID uniqueidentifier)
AS 

SELECT * FROM PurchaseOrderPrintView    	     
WHERE     (PurchaseOrderPrintView.PurchaseOrderId = @ID)
GO