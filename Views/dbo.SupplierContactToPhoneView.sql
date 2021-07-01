SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SupplierContactToPhoneView]
AS
SELECT     dbo.SupplierContactToPhone.SupplierContactToPhoneID, dbo.SupplierContactToPhone.ContactID, dbo.Phone.PhoneType, dbo.Phone.PhoneNumber, 
                      dbo.Phone.SortOrder, dbo.SupplierContactToPhone.Status, dbo.SupplierContactToPhone.DateModified
FROM         dbo.Phone INNER JOIN
                      dbo.SupplierContactToPhone ON dbo.Phone.PhoneID = dbo.SupplierContactToPhone.PhoneID
GO