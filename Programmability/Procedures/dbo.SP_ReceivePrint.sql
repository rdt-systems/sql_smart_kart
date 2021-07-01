SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceivePrint](@ID uniqueidentifier)
AS 

SELECT * FROM ReceiveOrderPrintView    	     
WHERE     (ReceiveOrderPrintView.ReceiveID = @ID)
GO