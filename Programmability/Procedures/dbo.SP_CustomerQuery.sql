SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerQuery]
(
@DateModified datetime=null
)
AS 


SELECT        Customer.CustomerID, Customer.CustomerNo, ISNULL(Customer.LastName, '') + ISNULL(', ' + CASE WHEN dbo.Customer.FirstName = '' THEN NULL 
                         ELSE dbo.Customer.FirstName END, ' ') AS FullName, CASE WHEN (SELECT TOP(1) 1 FROM Store Where StoreID = 'BB4499C1-C573-4746-8DE3-4730CED4C6D2') = 1 
						 THEN N'????"? ' +  Customer.FirstName ELSE Customer.FirstName END AS FirstName, Customer.LastName, Customer.ClubID, Customer.MainAddressID, 
                         Customer.SalesPersonID, Customer.SortOrder, Customer.BirthDay, Customer.CustomerType, Customer.TaxID, Customer.Credit, Customer.[Current], Customer.Over0, 
                         Customer.Over30, Customer.Over60, Customer.Over90, Customer.Over120, Customer.CreditLevel1, Customer.CreditLevel2, Customer.CreditLevel3, 
                         Customer.TermDays, Customer.TermDiscount, Customer.CreditCardID, Customer.CreditCardNO, Customer.CSV, Customer.CCExpDate, Customer.DriverLicenseNo, 
                         Customer.State As DlState, Customer.SocialSecurytyNO, Customer.Password, Customer.Statment, Customer.CheckAccept, Customer.EnforceCreditLimit, 
                         Customer.EnforceCheckSign, Customer.OnMailingList, Customer.FaxNumber, Customer.Contact1, Customer.Contact2, Customer.DiscountID, Customer.Status, 
                         Customer.BalanceDoe, Customer.StartBalance, Customer.StartBalanceDate, Customer.PriceLevelID, Customer.DefaultTerms, Customer.TaxExempt, 
                         Customer.FoodStampNo, Customer.FoodStampCode, Customer.EnforceSignOnAccount, Customer.LockAccount, Customer.LockOutDays, Customer.DateCreated, 
                         Customer.UserCreated, Customer.DateModified, Customer.UserModified, Customer.LastPayment, Customer.LastPaymentDate, Customer.CreditNameOn, UseSMS,
                         Customer.CreditOnDelivery, Customer.CreditZip, Customer.InActiveReason, CustomerAddresses.Name, CustomerAddresses.Street1, CustomerAddresses.Street2, 
                         CustomerAddresses.City, CustomerAddresses.State , CustomerAddresses.Zip, CustomerAddresses.Country, CustomerAddresses.PhoneNumber1,CustomerAddresses.IsTextable,
                         CustomerAddresses.PhoneNumber2, Customer.LoyaltyMembertype, Customer.CCTrack,TransInfo.Visit,TransInfo.LastVisit,TransInfo.AverageAmount,TransInfo.TotalSpent,ISNULL(SumPoints.Points, 0) As SumPoints ,
(CASE WHEN BalanceDoe<0.001 THEN dbo.GetLocalDATE() WHEN LastClearBalance.Days IS NULL THEN dbo.GetLocalDATE() ELSE LastClearBalance.Days END)As Days, Customer.Email, Customer.NoBalance, 
                         Customer.ExpDiscount, Customer.TaxNumber, Customer.RPNBalance, Customer.RPNCardNumber AS RPN, Customer.OldCustNo, Coupon.CouponID,Customer.HideInPOS,RegularPaymentType,
						 (CASE WHEN DaysTrans.T90>0 THEN 1 WHEN DaysTrans.T12>0 THEN 2 ELSE 0 END) AS LightStatus,
						 STUFF((
SELECT        CHAR(9) +convert(nvarchar(50),CG.CustomerGroupID)
FROM            dbo.CustomerToGroup as Cg  WHERE  CG.Status > 0 AND CG.CustomerID = Customer.CustomerID
FOR XML PATH(''), TYPE ).value('.', 'varchar(4000)'), 1, 1, '') AS CustomerGroup 
FROM            dbo.Customer WITH (NOLOCK) LEFT OUTER JOIN
                             (SELECT        DupeCount, CouponID, CustomerID
                               FROM            (SELECT ROW_NUMBER() OVER (PARTITION BY CustomerID
      ORDER BY CustomerID ) AS DupeCount, CouponID, CustomerID
                                                         FROM            dbo.Coupon AS Coupon_1 WITH (NOLOCK)
                                                         WHERE        (Status > 0)) AS f
                               WHERE        (DupeCount = 1)) AS Coupon ON Customer.CustomerID = Coupon.CustomerID LEFT OUTER JOIN
                             (SELECT        CustomerID, SUM(AvailPoints) AS Points
                               FROM            dbo.Loyalty WITH (NOLOCK)
                               WHERE        (Status > 0)
                               GROUP BY CustomerID) AS SumPoints ON Customer.CustomerID = SumPoints.CustomerID LEFT OUTER JOIN
                             (SELECT        Trans.CustomerID, MIN(Trans.StartSaleTime) AS Days
FROM            dbo.[Transaction] AS Trans WITH (NOLOCK) LEFT OUTER JOIN
                             (SELECT        MAX(StartSaleTime) AS LastDate, CustomerID
                               FROM            dbo.[Transaction] WITH (NOLOCK)
                               WHERE        (Status > 0) and CurrBalance <0.01
                               GROUP BY CustomerID
                               HAVING         (CustomerID IS NOT NULL)) AS LastZeroBalance ON Trans.CustomerID = LastZeroBalance.CustomerID
WHERE        (Trans.Status > 0) AND (Trans.StartSaleTime > LastZeroBalance.LastDate)
GROUP BY Trans.CustomerID) AS LastClearBalance ON Customer.CustomerID = LastClearBalance.CustomerID LEFT OUTER JOIN 
(SELECT        CustomerID, 
SUM(CASE WHEN (StartSaleTime> dbo.GetLocalDate()-90) THEN 1 ELSE 0 END) AS T90,
SUM(CASE WHEN (StartSaleTime> dbo.GetLocalDate()-365) THEN 1 ELSE 0 END) AS T12
FROM            dbo.[Transaction] WITH (NOLOCK)
WHERE        (Status > 0) AND CustomerID IS NOT NULL
GROUP BY CustomerID) as DaysTrans ON Customer.CustomerID = DaysTrans.CustomerID  LEFT OUTER JOIN
(SELECT        COUNT(TransactionID) AS Visit, MAX(StartSaleTime) AS LastVisit, CustomerID, AVG(Debit) AS AverageAmount,Sum(Debit) as TotalSpent
FROM            dbo.[Transaction] WITH (NOLOCK)
WHERE        (Status > 0)
GROUP BY CustomerID)As TransInfo ON Customer.CustomerID = TransInfo.CustomerID
LEFT OUTER JOIN   dbo.CustomerAddresses WITH (NOLOCK) ON Customer.MainAddressID = CustomerAddresses.CustomerAddressID AND CustomerAddresses.Status > 0 and CustomerAddresses.AddressType = 6 
WHERE        (Customer.Status > 0) AND (Customer.DateModified > @DateModified OR @DateModified IS NULL)

--SELECT [CustomerQuery].*  FROM [CustomerQuery]  WHERE (DateModified > @DateModified) AND Status>0
GO