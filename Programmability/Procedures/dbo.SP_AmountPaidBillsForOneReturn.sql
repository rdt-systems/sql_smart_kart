SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AmountPaidBillsForOneReturn]
@ID uniqueidentifier
AS
SELECT    isnull(Sum(dbo.PayToBill.Amount),0)as Amount
FROM                  dbo.PayToBill INNER JOIN
                      dbo.ReturnToVender ON dbo.PayToBill.SuppTenderID = dbo.ReturnToVender.ReturnToVenderID
where dbo.ReturnToVender.ReturnToVenderID=@ID
GO