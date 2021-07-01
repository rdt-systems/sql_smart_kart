SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[GiftView]
AS
SELECT     dbo.Gift.GiftID, dbo.Gift.GiftNumber, dbo.Gift.CustomerID, dbo.Gift.Amount, dbo.Gift.GiftType, dbo.Gift.GiftDate, dbo.Gift.Status, dbo.Gift.DateCreated, 
                      dbo.Gift.UserCreated, dbo.Gift.DateModified, dbo.Gift.UserModified, dbo.CustomerView.Name AS CustomerName, dbo.CustomerView.CustomerNo
FROM         dbo.Gift INNER JOIN
                      dbo.CustomerView ON dbo.Gift.CustomerID = dbo.CustomerView.CustomerID AND dbo.CustomerView.Status > 0
GO