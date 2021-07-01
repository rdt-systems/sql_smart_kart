SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPrintInvoiceView](@TransactionID uniqueidentifier)
AS SELECT     *
FROM         dbo.PrintInvoiceView
WHERE     (TransactionID = @TransactionID)
GO