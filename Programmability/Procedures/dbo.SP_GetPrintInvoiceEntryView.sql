SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPrintInvoiceEntryView](@TransactionID uniqueidentifier)
AS SELECT     *
FROM         dbo.PrintInvoiceEntryView
WHERE     (TransactionID = @TransactionID)
order by sort
GO