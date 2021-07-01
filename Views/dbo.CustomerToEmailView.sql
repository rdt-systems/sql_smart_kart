SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerToEmailView]
AS
SELECT     dbo.CustomerToEmail.CustomerToEmailID, dbo.CustomerToEmail.CustomerID, dbo.Email.EmailAddress, dbo.Email.OnlyText, 
                      dbo.Email.EmailSizeLimit, dbo.Email.DefaultEmail, dbo.Email.SortOrder, dbo.CustomerToEmail.Status, dbo.CustomerToEmail.DateModified
FROM         dbo.CustomerToEmail INNER JOIN
                      dbo.Email ON dbo.CustomerToEmail.EmailID = dbo.Email.EmailID
GO