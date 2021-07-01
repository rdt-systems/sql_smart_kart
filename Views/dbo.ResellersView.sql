SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ResellersView]
AS
SELECT     dbo.State.StateName AS State, dbo.Resellers.ResellerID, dbo.Resellers.ResellerLName, dbo.Resellers.ResellerFName, dbo.Resellers.CompanyName,
                       dbo.Resellers.Email, dbo.Resellers.Phone, dbo.Resellers.Address1, dbo.Resellers.Address2, dbo.Resellers.City, dbo.Resellers.StateID, 
                      dbo.Resellers.ZipCode, dbo.Resellers.UserName, dbo.Resellers.Password, dbo.Resellers.SecurityQ, dbo.Resellers.SecurityA, 
                      dbo.Resellers.DomainName, dbo.Resellers.DomainIP, dbo.Resellers.DesignID, dbo.Resellers.CreditCard4Dig, dbo.Resellers.CreditCardType, 
                      dbo.Resellers.CCExpire, dbo.Resellers.BankRoutingNum, dbo.Resellers.BankAccountNum, dbo.Resellers.BankAccountFullName, 
                      dbo.Resellers.DriverLicenseStateID, dbo.Resellers.BillFullName, dbo.Resellers.BillAddress1, dbo.Resellers.BillAddress2, dbo.Resellers.BillState, 
                      dbo.Resellers.BillZip, dbo.Resellers.BillCountry, dbo.Resellers.BillPhone, dbo.Resellers.BillUse, State_1.StateName AS DriverState, 
                      dbo.Resellers.CommissionPercents, dbo.Resellers.Status, dbo.Resellers.DateCreated, dbo.Resellers.UserCreated, dbo.Resellers.DateModified, 
                      dbo.Resellers.UserModified, ISNULL(dbo.Resellers.ResellerLName, N'') 
                      + ISNULL(CASE WHEN ResellerFName = '' THEN ' ' ELSE ', ' + ResellerFName END, N'') AS Name, dbo.Resellers.LastRegisteredDate, 
                      dbo.Resellers.OnlyText, dbo.State.StateName AS ResellerState , 

					isnull((SELECT Sum(isnull(debit,0)) From [Transaction] Where Status>0 and ResellerID=Resellers.ResellerID),0)*
					ISNULL(CommissionPercents,0)/100-
					isnull((select sum(isnull(Amount,0)) from resellerscommissions where status>0 and resellerid=Resellers.ResellerID),0)as Balance

FROM         dbo.Resellers LEFT OUTER JOIN
                      dbo.State ON dbo.Resellers.StateID = dbo.State.StateCode LEFT OUTER JOIN
                      dbo.State AS State_1 ON dbo.Resellers.DriverLicenseStateID = State_1.StateCode
GO