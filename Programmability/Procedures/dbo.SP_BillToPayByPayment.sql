SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_BillToPayByPayment]
@PaymentID uniqueidentifier
as

SELECT     *
FROM   dbo.PayToBill 
where dbo.PayToBill.SuppTenderID =@PaymentID
GO