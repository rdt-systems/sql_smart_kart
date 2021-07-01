SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CRMCallsView]
AS
SELECT        dbo.CRMCalls.CRMCallID, dbo.CRMCalls.CustomerID, dbo.CRMCalls.CallDate, dbo.CRMCalls.Note, dbo.CRMCalls.Status, dbo.CRMCalls.DateCreated, 
                         dbo.CRMCalls.UserCreated, dbo.CRMCalls.DateModified, dbo.CRMCalls.UserModified, dbo.Users.UserName, dbo.CustomerView.Name, dbo.CustomerView.Address, 
                         dbo.CustomerView.Phone, dbo.CustomerView.Email, dbo.CustomerView.CityStateAndZip, dbo.CustomerView.CustomerNo
FROM            dbo.CRMCalls INNER JOIN
                         dbo.Users ON dbo.CRMCalls.UserCreated = dbo.Users.UserId INNER JOIN
                         dbo.CustomerView ON dbo.CRMCalls.CustomerID = dbo.CustomerView.CustomerID
GO