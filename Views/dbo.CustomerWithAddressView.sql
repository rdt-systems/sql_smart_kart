SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[CustomerWithAddressView]
AS
SELECT        dbo.CustomerView.Name, dbo.CustomerView.CustomerID, dbo.CustomerAddressesView.PhoneNumber1, dbo.CustomerAddressesView.PhoneNumber2, dbo.CustomerView.CustomerNo, dbo.CustomerView.Credit, 
                         dbo.CustomerView.Contact1, dbo.CustomerView.Contact2, dbo.CustomerView.BalanceDoe, dbo.CustomerView.FirstName, dbo.CustomerView.LastName, dbo.CustomerView.AllMainDetails, 
                         dbo.CustomerView.Status, dbo.CustomerView.DateCreated, dbo.CustomerView.UserCreated, dbo.CustomerView.DateModified, dbo.CustomerView.UserModified, dbo.CustomerView.ResellerID, 
                         dbo.CustomerView.Zip, dbo.CustomerView.State, dbo.CustomerView.City, ISNULL(dbo.CustomerAddressesView.Street1, '') + ' ' + ISNULL(dbo.CustomerAddressesView.Street2, '') 
                         AS Address, dbo.CustomerView.BirthDay, dbo.CustomerView.Email, dbo.CustomerView.Points, dbo.CustomerView.StoreOpen, dbo.CustomerView.Over0, dbo.CustomerView.Over30, dbo.CustomerView.Over60, 
                         dbo.CustomerView.Over90, dbo.CustomerView.Over120
FROM            dbo.CustomerView LEFT OUTER JOIN
                         dbo.CustomerAddressesView ON dbo.CustomerView.MainAddressID = dbo.CustomerAddressesView.CustomerAddressID
GO