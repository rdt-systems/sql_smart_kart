SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ReceiveToSaleView]
AS
SELECT     dbo.ReceiveToSale.TransactionEntryID, dbo.ReceiveToSale.ReceiveEntryID, dbo.ReceiveToSale.Qty, dbo.ReceiveEntry.Cost
FROM         dbo.ReceiveEntry INNER JOIN
                      dbo.ReceiveToSale ON dbo.ReceiveEntry.ReceiveEntryID = dbo.ReceiveToSale.ReceiveEntryID
GO