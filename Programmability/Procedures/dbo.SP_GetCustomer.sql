SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomer]

As 

SELECT     dbo.CustomerView.*, dbo.CustomerAddressesView.Street1, dbo.CustomerAddressesView.Street2, dbo.CustomerAddressesView.City, 
                      dbo.CustomerAddressesView.Zip, dbo.CustomerToPhoneView.PhoneNumber
FROM         dbo.CustomerView INNER JOIN
                      dbo.CustomerAddressesView ON dbo.CustomerView.CustomerID = dbo.CustomerAddressesView.CustomerID INNER JOIN
                      dbo.CustomerToPhoneView ON dbo.CustomerView.CustomerID = dbo.CustomerToPhoneView.CostumerID
GO