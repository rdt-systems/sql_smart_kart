SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ComputersView]
AS
SELECT     ComputerID, ComputerName, ComputerNo, StoreID, LabelPrinter, ShelfPrinter, InvoicePrinter, StatementPrinter, Status, DateCreated, UserCreated, 
                      DateModified, UserModified
FROM         dbo.Computers
GO