SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[Customer_CRMOld]
AS
SELECT     C.CustomerID, C.CustomerNo, C.FirstName, C.LastName, C.ClubID, COALESCE (A.Street1, '') AS Street, C.CustomerType, C.TaxID, C.[Current], C.Over0, 
                      C.Over30, C.Over60, C.Over90, C.Over120, C.Credit, C.AssignCreditLevel, C.CreditLevel1, C.CreditLevel2, C.CreditLevel3, C.CreditOnDelivery, 
                      C.TermDays, C.TermDiscount, C.CreditCardID, C.CreditCardNO, C.CSV, C.CCExpDate, C.DriverLicenseNo, A.State, C.SocialSecurytyNO, C.Password, 
                      C.Statment, C.CheckAccept, C.EnforceCreditLimit, C.EnforceCheckSign, C.OnMailingList, C.FaxNumber, C.Contact1, C.Contact2, C.DiscountID, 
                      C.ResellerID, C.PriceLevelID, C.DefaultTerms, C.TaxExempt, C.FoodStampNo, C.FoodStampCode, C.EnforceSignOnAccount, C.LockAccount, 
                      C.LockOutDays, C.CreditNameOn, C.CreditZip, C.InActiveReason, C.AccountNo, C.SOTerms, C.Status, C.DateCreated, UC.UserName AS UserCreated, 
                      C.DateModified, UM.UserName AS UserModified, C.LastPayment, C.LastPaymentDate, C.BalanceDoe, C.StartBalance, C.StartBalanceDate, 
                      C.LoyaltyMembertype, G.GroupName, A.PhoneNumber1,
                          (SELECT     SUM(Credit) AS Expr1
                            FROM          dbo.[Transaction] AS T
                            WHERE      (CustomerID = C.CustomerID)
                            GROUP BY CustomerID) AS Sale
FROM         dbo.Customer AS C LEFT OUTER JOIN
                      dbo.CustomerAddresses AS A ON A.CustomerAddressID = C.MainAddressID LEFT OUTER JOIN
                      dbo.Users AS UC ON UC.UserId = C.UserCreated LEFT OUTER JOIN
                      dbo.Users AS UM ON UM.UserId = C.UserModified LEFT OUTER JOIN
                      dbo.CustomerToGroup AS CG ON CG.CustomerID = C.CustomerID LEFT OUTER JOIN
                      dbo.Groups AS G ON G.GroupID = CG.CustomerGroupID
GO