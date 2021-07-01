SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_PaymentToInvoiceInsert]
(
@PaymentToInvoiceID uniqueidentifier,
@PaymentID uniqueidentifier,
@InvoiceID uniqueidentifier,
@Amount decimal(19,3),
@ModifierID uniqueidentifier)

as 
if (SELECT COUNT(*)
	FROM dbo.PaymentDetails
	WHERE PaymentID=@PaymentToInvoiceID)>0 RETURN

if (SELECT Top 1 Balance
	FROM dbo.TransactionWithPaidView
	WHERE TransactionID=@InvoiceID)=0 RETURN

Exec [SP_PaymentDetailsInsert] @PaymentToInvoiceID,@PaymentID,@InvoiceID,@Amount,'',1,@ModifierID
GO