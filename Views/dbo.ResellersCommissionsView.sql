SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ResellersCommissionsView]
AS
SELECT     dbo.ResellersCommissions.CommissionID, dbo.ResellersCommissions.ResellerID, dbo.ResellersCommissions.Amount, 
                      dbo.ResellersCommissions.SentDate, dbo.ResellersCommissions.CheckDate, dbo.ResellersCommissions.CheckNo, 
                      dbo.ResellersCommissions.CheckBank, dbo.ResellersCommissions.CheckSubsidiary, dbo.ResellersCommissions.Status, 
                      dbo.ResellersCommissions.DateCreated, dbo.ResellersCommissions.UserCreated, dbo.ResellersCommissions.DateModified, 
                      dbo.ResellersCommissions.UserModified, dbo.ResellersView.name AS Name, dbo.ResellersView.CompanyName, dbo.ResellersView.Email, 
                      dbo.ResellersView.Phone, dbo.ResellersView.Address1
FROM         dbo.ResellersCommissions INNER JOIN
                      dbo.ResellersView ON dbo.ResellersCommissions.ResellerID = dbo.ResellersView.ResellerID
GO