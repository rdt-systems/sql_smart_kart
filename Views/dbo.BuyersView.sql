SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[BuyersView]
AS
Select BuyerID, UserID, SupplierID, Status, DateCreated, DateModified, UserCreated, UserModified from Buyers


GO