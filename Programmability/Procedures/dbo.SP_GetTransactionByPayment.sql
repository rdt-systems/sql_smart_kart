SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionByPayment]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT DISTINCT dbo.TransactionWithLeftDebitView.*
FROM         dbo.TransactionWithLeftDebitView INNER JOIN
                      dbo.PaymentDetailsView ON dbo.TransactionWithLeftDebitView.TransactionID = dbo.PaymentDetailsView.TransactionPayedID INNER JOIN
                      dbo.TransactionView ON dbo.PaymentDetailsView.TransactionID = dbo.TransactionView.TransactionID
WHERE     (dbo.TransactionView.TransactionType = 1)'
Execute (@MySelect + @Filter )
GO