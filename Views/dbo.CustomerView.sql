SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[CustomerView]
AS
SELECT DISTINCT 
                         Customer.CustomerID, Customer.CustomerNo, ISNULL(Customer.FirstName, '') AS FirstName, ISNULL(Customer.LastName, '') AS LastName, Customer.ClubID, Customer.MainAddressID, Customer.SalesPersonID, 
                         Customer.SortOrder, Customer.BirthDay, Customer.CustomerType, Customer.TaxID, Customer.Over0, Customer.Over30, Customer.Over60, Customer.Over90, Customer.Over120, Customer.Credit, 
                         Customer.CreditLevel1, Customer.CreditLevel2, Customer.CreditLevel3, Customer.CreditOnDelivery, Customer.TermDays, Customer.TermDiscount, Customer.CreditCardID, Customer.CreditCardNO, Customer.CSV,
                          Customer.CCExpDate, Customer.DriverLicenseNo, Customer.State AS SState, Customer.SocialSecurytyNO, Customer.Password, Customer.Statment, Customer.CheckAccept, Customer.EnforceCreditLimit, 
                         Customer.EnforceCheckSign, Customer.OnMailingList, Customer.FaxNumber, Customer.Contact1, Customer.Contact2, Customer.DiscountID, Customer.AccountNo, Customer.Status, isnull(Customer.BalanceDoe,0)as BalanceDoe , 
                         Customer.StartBalance, Customer.StartBalanceDate, Customer.PriceLevelID, Customer.DefaultTerms, Customer.TaxExempt, Customer.FoodStampNo, Customer.FoodStampCode, Customer.EnforceSignOnAccount, 
                         Customer.[Current], Customer.LockAccount, Customer.LockOutDays, Customer.CreditNameOn, Customer.CreditZip, Customer.DateCreated, Customer.UserCreated, Customer.DateModified, Customer.UserModified, 
                         ISNULL(Customer.LastName, '') + ISNULL(', ' + CASE WHEN dbo.Customer.FirstName = '' THEN NULL ELSE dbo.Customer.FirstName END, ' ') AS Name, ISNULL(AddressDetails.AllDetails, ' ') AS AllMainDetails, 
                         AddressDetails.Street1 AS Address, AddressDetails.Street2 AS Address2, AddressDetails.PhoneNumber1 AS Phone,AddressDetails.PhoneNumber2 AS Cell, AddressDetails.CityStateAndZip, Customer.InActiveReason, Customer.AssignCreditLevel, Customer.ResellerID, Customer.SOTerms, 
                         DiscountsView.Name AS Discount,
                             (SELECT        TOP (1) EmailAddress
                               FROM            Email
                               WHERE        (Status > 0) AND EXISTS
                                                             (SELECT        1 AS Expr1
                                                               FROM            CustomerToEmail
                                                               WHERE        (Status > 0) AND (CustomerID = Customer.CustomerID) AND (EmailID = Email.EmailID))) AS Email_old, Customer.LoyaltyMembertype, Customer.Email, Customer.NoBalance, 
                         Customer.TaxNumber, Customer.ExpDiscount, ISNULL(SumPoints.Points, 0) AS Points, Customer.DayOfMounth, Customer.RegularPaymentType, Store.StoreName AS StoreOpen, Customer.StoreCreated, 
                         CASE WHEN ISNUMERIC(SUBSTRING(Street1, 1, (CHARINDEX(' ', Street1 + ' ') - 1))) = 1 THEN SUBSTRING(Street1, 1, (CHARINDEX(' ', Street1 + ' ') - 1)) ELSE '' END AS HouseNo, 
                         SUBSTRING(AddressDetails.Street1, CHARINDEX(' ', AddressDetails.Street1 + ' ', 1) + 1, LEN(AddressDetails.Street1)) AS StreetName, LastSale.LastVisit, Cleared.LastDateCleared, Customer.LastPayment, Customer.LastPaymentDate,
                         AddressDetails.City, AddressDetails.State, AddressDetails.Zip,
                             (SELECT        TOP (1) CONVERT(Nvarchar(4000), ISNULL(NoteValue,'')) AS NoteValue
                               FROM            CustomerNotes
                               WHERE   Status > 0 and (CustomerID = Customer.CustomerID)
							        ORDER BY DateCreated DESC) AS note,


	 CONVERT(nvarchar(500),
	                STUFF((
	Select ','+ cast(g.CustomerGroupName as varchar(30)) 
			 from CustomerToGroup cg inner join dbo.CustomerGroup g on cg.CustomerGroupID = g.CustomerGroupID where cg.CustomerID = Customer.CustomerID and cg.Status>0 
							FOR xml PATH ('')), 1, 1, '')) AS GroupName
							,Customer.CountSales,Customer.SumSales,Customer.LastSaleDate
FROM            dbo.Customer WITH (NOLOCK) LEFT OUTER JOIN
                             (SELECT DISTINCT CustomerID, MAX(StartSaleTime) AS LastVisit
                               FROM            dbo.CustomerSalesAndClearInfo WITH (NOLOCK)
                               WHERE       (TransactionType = 0)
                               GROUP BY CustomerID) AS LastSale ON Customer.CustomerID = LastSale.CustomerID LEFT OUTER JOIN
                             (SELECT DISTINCT CustomerID, MAX(StartSaleTime) AS LastDateCleared
                               FROM            dbo.CustomerSalesAndClearInfo AS T WITH (NOLOCK)
                               WHERE        (CurrBalance <= 0)
                               GROUP BY CustomerID) AS Cleared ON Customer.CustomerID = Cleared.CustomerID LEFT OUTER JOIN
                         Store ON Customer.StoreCreated = Store.StoreID LEFT OUTER JOIN
                             (SELECT        CustomerID, SUM(AvailPoints) AS Points
                               FROM            dbo.Loyalty WITH (NOLOCK)
                               WHERE        (Status > 0)
                               GROUP BY CustomerID) AS SumPoints ON Customer.CustomerID = SumPoints.CustomerID LEFT OUTER JOIN
                         dbo.AddressDetails WITH (NOLOCK) ON Customer.CustomerID = AddressDetails.CustomerID LEFT OUTER JOIN
                         dbo.DiscountsView WITH (NOLOCK) ON Customer.DiscountID = DiscountsView.DiscountID
WHERE        (Customer.Status > - 1)
GO