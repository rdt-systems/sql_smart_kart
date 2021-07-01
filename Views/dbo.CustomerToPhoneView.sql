SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerToPhoneView]
AS
SELECT     dbo.CustomerToPhone.CostumerToPhoneID, dbo.CustomerToPhone.CostumerID, dbo.Phone.PhoneType, dbo.Phone.PhoneNumber, 
                      dbo.Phone.SortOrder, dbo.CustomerToPhone.Status, dbo.CustomerToPhone.DateModified
FROM         dbo.CustomerToPhone INNER JOIN
                      dbo.Phone ON dbo.CustomerToPhone.PhoneID = dbo.Phone.PhoneID
GO