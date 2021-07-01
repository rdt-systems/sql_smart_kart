SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CRMView]
AS
SELECT        ISNULL(YTDSales.Sale, 0) AS Sale, ISNULL(YTDSales.Payments, 0) AS Payments, CustomerFilter.CustomerID, CustomerFilter.CustomerNo, 
                         CustomerFilter.FirstName, CustomerFilter.LastName, CustomerFilter.ClubID, CustomerFilter.MainAddressID, CustomerFilter.SalesPersonID, CustomerFilter.SortOrder,
                          CustomerFilter.BirthDay, CustomerFilter.CustomerType, CustomerFilter.TaxID, CustomerFilter.Over0, CustomerFilter.Over30, CustomerFilter.Over60, 
                         CustomerFilter.Over90, CustomerFilter.Over120, CustomerFilter.Credit, CustomerFilter.CreditLevel1, CustomerFilter.CreditLevel2, CustomerFilter.CreditLevel3, 
                         CustomerFilter.CreditOnDelivery, CustomerFilter.TermDays, CustomerFilter.TermDiscount, CustomerFilter.CreditCardID, CustomerFilter.CreditCardNO, 
                         CustomerFilter.CSV, CustomerFilter.CCExpDate, CustomerFilter.DriverLicenseNo, CustomerFilter.State, CustomerFilter.SocialSecurytyNO, CustomerFilter.Password, 
                         CustomerFilter.Statment, CustomerFilter.CheckAccept, CustomerFilter.EnforceCreditLimit, CustomerFilter.EnforceCheckSign, CustomerFilter.OnMailingList, 
                         CustomerFilter.FaxNumber, CustomerFilter.Contact1, CustomerFilter.Contact2, CustomerFilter.DiscountID, CustomerFilter.Status, CustomerFilter.BalanceDoe, 
                         CustomerFilter.StartBalance, CustomerFilter.StartBalanceDate, CustomerFilter.PriceLevelID, CustomerFilter.DefaultTerms, CustomerFilter.TaxExempt, 
                         CustomerFilter.FoodStampNo, CustomerFilter.FoodStampCode, CustomerFilter.EnforceSignOnAccount, CustomerFilter.[Current], CustomerFilter.LockAccount, 
                         CustomerFilter.LockOutDays, CustomerFilter.CreditNameOn, CustomerFilter.CreditZip, CustomerFilter.DateCreated, CustomerFilter.UserCreated, 
                         CustomerFilter.DateModified, CustomerFilter.UserModified, ISNULL(CustomerFilter.Name, '') AS Name, CustomerFilter.AllMainDetails, 
                         ISNULL(CustomerFilter.Address, '') AS Address, CustomerFilter.Phone, ISNULL(CustomerFilter.CityStateAndZip, '') AS CityStateAndZip, 
                         CustomerFilter.InActiveReason, CustomerFilter.AssignCreditLevel, CustomerFilter.ResellerID, CustomerFilter.SOTerms, CustomerFilter.Discount, 
                         CustomerFilter.LoyaltyMembertype, CustomerFilter.Email, CustomerFilter.NoBalance, CustomerFilter.TaxNumber, CustomerFilter.ExpDiscount, 
                         CustomerFilter.Points, Customer.DayOfMounth, Tender.TenderName, YTDSales.Payments AS Expr1, YTDSales.Sale AS Expr2, CustomerFilter.LastClear, 
                         CustomerFilter.LastPayment, CustomerFilter.LastSale, CustomerFilter.MonthB, CustomerFilter.YearB, CustomerFilter.TotalQty, CustomerFilter.TotalDebit, 
                         CustomerFilter.WeekB, LastTask.LastTask, LastCall.LastCall, Notes.NoteValue As Notes
FROM            Tender RIGHT OUTER JOIN
                             (select *  FROM 
(SELECT ROW_NUMBER() OVER (PARTITION BY CustomerID
      ORDER BY CustomerID ) AS DupeCount,CustomerID,NoteValue
  FROM CustomerNotes Where Status>0) AS f WHERE DupeCount = 1) AS Notes RIGHT OUTER JOIN
                         CustomerFilter INNER JOIN
                         Customer ON CustomerFilter.CustomerID = Customer.CustomerID ON Notes.CustomerID = Customer.CustomerID LEFT OUTER JOIN
                             (SELECT        CustomerID, MAX(TaskDate) AS LastTask
                               FROM            CustomerTasks
                               WHERE        (Status > 0) AND (TaskDate < dbo.GetLocalDATE()) AND (TaskStatus = 1)
                               GROUP BY CustomerID) AS LastTask ON CustomerFilter.CustomerID = LastTask.CustomerID ON 
                         Tender.TenderID = Customer.RegularPaymentType LEFT OUTER JOIN
                             (SELECT        CustomerID, MAX(CallDate) AS LastCall
                               FROM            CRMCalls
                               WHERE        (Status > 0) AND (CallDate < dbo.GetLocalDATE())
                               GROUP BY CustomerID) AS LastCall ON CustomerFilter.CustomerID = LastCall.CustomerID LEFT OUTER JOIN
                             (SELECT        CustomerID, SUM(Debit) AS Sale, SUM(Credit) AS Payments
                               FROM            [Transaction]
                               WHERE        (Status > 0) AND (StartSaleTime >= DATEADD(year, - 1, dbo.GetLocalDATE()))
                               GROUP BY CustomerID) AS YTDSales ON CustomerFilter.CustomerID = YTDSales.CustomerID
GO