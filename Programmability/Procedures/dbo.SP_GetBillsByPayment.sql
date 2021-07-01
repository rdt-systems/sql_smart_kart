SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetBillsByPayment]
(
@PaymentID uniqueidentifier
)
AS 

SELECT     dbo.Bill.BillNo, dbo.Bill.BillDate, dbo.PayToBillView.Amount
FROM         dbo.PayToBillView INNER JOIN
                      dbo.Bill ON dbo.PayToBillView.BillID = dbo.Bill.BillID
WHERE     (dbo.PayToBillView.Status > 0) AND (dbo.PayToBillView.SuppTenderID = @PaymentID)
GO