SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CustomerFilter]
AS
SELECT        dbo.CustomerView.CustomerID, dbo.CustomerView.CustomerNo, dbo.CustomerView.FirstName, dbo.CustomerView.LastName, dbo.CustomerView.ClubID, 
                         dbo.CustomerView.MainAddressID, dbo.CustomerView.SalesPersonID, dbo.CustomerView.SortOrder, dbo.CustomerView.BirthDay, dbo.CustomerView.CustomerType, 
                         dbo.CustomerView.TaxID, dbo.CustomerView.[Current], dbo.CustomerView.Over0, dbo.CustomerView.Over30, dbo.CustomerView.Over60, dbo.CustomerView.Over90, 
                         dbo.CustomerView.Over120, dbo.CustomerView.Credit, dbo.CustomerView.CreditLevel1, dbo.CustomerView.CreditLevel2, dbo.CustomerView.CreditLevel3, 
                         dbo.CustomerView.CreditOnDelivery, dbo.CustomerView.TermDays, dbo.CustomerView.TermDiscount, dbo.CustomerView.CreditCardID, 
                         dbo.CustomerView.CreditCardNO, dbo.CustomerView.CSV, dbo.CustomerView.CCExpDate, dbo.CustomerView.DriverLicenseNo, dbo.CustomerView.State, 
                         dbo.CustomerView.SocialSecurytyNO, dbo.CustomerView.Password, dbo.CustomerView.Statment, dbo.CustomerView.CheckAccept, 
                         dbo.CustomerView.EnforceCreditLimit, dbo.CustomerView.EnforceCheckSign, dbo.CustomerView.OnMailingList, dbo.CustomerView.FaxNumber, 
                         dbo.CustomerView.Contact1, dbo.CustomerView.Contact2, dbo.CustomerView.DiscountID, dbo.CustomerView.Status,  ISNULL(dbo.CustomerView.BalanceDoe,0) as BalanceDoe, 
                         dbo.CustomerView.StartBalance, dbo.CustomerView.StartBalanceDate, dbo.CustomerView.PriceLevelID, dbo.CustomerView.DefaultTerms, 
                         dbo.CustomerView.TaxExempt, dbo.CustomerView.FoodStampNo, dbo.CustomerView.FoodStampCode, dbo.CustomerView.EnforceSignOnAccount, 
                         dbo.CustomerView.LockAccount, dbo.CustomerView.LockOutDays, dbo.CustomerView.CreditNameOn, dbo.CustomerView.CreditZip, dbo.CustomerView.DateCreated, 
                         dbo.CustomerView.UserCreated, dbo.CustomerView.DateModified, dbo.CustomerView.UserModified, dbo.CustomerView.Name, dbo.CustomerView.AllMainDetails, 
                         dbo.CustomerView.Address, dbo.CustomerView.Phone, dbo.CustomerView.CityStateAndZip, dbo.CustomerView.InActiveReason, 
                         dbo.CustomerQtyAndAmountAvg.TotalDebit, dbo.CustomerQtyAndAmountAvg.TotalQty, dbo.CustomerQtyAndAmountAvg.YearB, 
                         dbo.CustomerQtyAndAmountAvg.WeekB, dbo.CustomerQtyAndAmountAvg.MonthB, dbo.CustomerLastDetailsView.LastSale, 
                         dbo.CustomerView.LastPayment,dbo.CustomerView.LastPaymentDate, ISNULL(dbo.CustomerLastClearBalanceView.LastClear, '1900-01-01') AS LastClear, 
                         dbo.CustomerView.AssignCreditLevel, dbo.CustomerView.ResellerID, dbo.CustomerView.Email, dbo.CustomerView.TaxNumber, dbo.CustomerView.Discount, 
                         dbo.CustomerView.Points, dbo.CustomerView.SOTerms, dbo.CustomerView.LoyaltyMembertype, dbo.CustomerView.NoBalance, 
                         dbo.CustomerView.ExpDiscount,customerview.SState, customerview.AccountNo, customerview.Email_old, customerview.DayOfMounth, customerview.RegularPaymentType, customerview.StoreOpen,customerview.StoreCreated,customerview.HouseNo,customerview.StreetName,customerview.LastVisit,customerview.LastDateCleared,customerview.City,customerview.Zip,customerview.note,customerview.Cell
FROM            dbo.CustomerView LEFT OUTER JOIN
                         dbo.CustomerLastDetailsView ON dbo.CustomerView.CustomerID = dbo.CustomerLastDetailsView.CustomerID LEFT OUTER JOIN
                         dbo.CustomerQtyAndAmountAvg ON dbo.CustomerView.CustomerID = dbo.CustomerQtyAndAmountAvg.customerid LEFT OUTER JOIN
                         dbo.CustomerLastClearBalanceView ON dbo.CustomerView.CustomerID = dbo.CustomerLastClearBalanceView.CustomerID
WHERE        (1 = 1) AND (dbo.CustomerView.Status > 0)
GO