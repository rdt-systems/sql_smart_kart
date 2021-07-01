SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderPrintMatrix](@ID uniqueidentifier)
AS 

SELECT * FROM PurchaseOrderPrintMatrixView    	     
WHERE     (PurchaseOrderPrintMatrixView.PurchaseOrderId = @ID)
GO