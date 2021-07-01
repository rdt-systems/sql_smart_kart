SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetPaymentDetails]
(@TransactionID uniqueidentifier)

AS

  SELECT     dbo.PaymentDetailsView.*
  FROM         dbo.PaymentDetailsView
  WHERE     (Status > - 1) and ((TransactionID=@TransactionID) or(TransactionPayedID=@TransactionID))
GO