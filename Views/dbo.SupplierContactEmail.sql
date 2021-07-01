SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SupplierContactEmail]
AS
SELECT     dbo.SupplierContactToEmail.SupplierContactToEmaillID, dbo.SupplierContactToEmail.ContactID, dbo.Email.EmailAddress, dbo.Email.OnlyText, 
                      dbo.Email.EmailSizeLimit, dbo.Email.DefaultEmail, dbo.Email.SortOrder, dbo.SupplierContactToEmail.Status, 
                      dbo.SupplierContactToEmail.DateModified
FROM         dbo.Email INNER JOIN
                      dbo.SupplierContactToEmail ON dbo.Email.EmailID = dbo.SupplierContactToEmail.EmailID
GO