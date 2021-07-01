SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BillsForOnePayment]
@ID uniqueidentifier
AS SELECT     dbo.Bill.BillNo, dbo.Bill.Amount, dbo.Bill.AmountPay, ISNULL(dbo.Bill.Amount - dbo.Bill.AmountPay, 0) AS Balance, 
                      dbo.SupplierTenderEntry.Amount AS ApplyAmount, dbo.Bill.BillDate,1 as Apply
FROM         dbo.Bill INNER JOIN
                      dbo.PayToBill ON dbo.Bill.BillID = dbo.PayToBill.BillID INNER JOIN
                      dbo.SupplierTenderEntry ON dbo.PayToBill.SuppTenderID = dbo.SupplierTenderEntry.SuppTenderEntryID
where SuppTenderEntryID=@ID
GO