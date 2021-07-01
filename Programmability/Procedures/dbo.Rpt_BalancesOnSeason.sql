SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <06/11/2014>
-- Description:	<Rpt_BalancesOnSeason>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_BalancesOnSeason]
(
@FromDate DateTime,
@ToDate DateTime
)

AS
----Select all customers who have balance currrent and Purched on Season more than the Payments-----

SELECT        CUS.CustomerNo, CUS.LastName, CUS.FirstName, CUS.Name, CUS.PhoneNumber1 AS [Home Phone], CUS.PhoneNumber2 AS [Cell Phone], CUS.Address, CUS.City, CUS.State, CUS.Zip, CUS.BirthDay, 
                         CUS.Email, BEF.[Balance Before Season], TR.[Total Paid], TR.[Total Sales], CUS.BalanceDoe AS BalanceDue, TR.[Total Sales] - TR.[Total Paid] AS [Balance On Season], AF.[After Season Sales], 
                         AF.[After Season Payments]
FROM            CustomerWithAddressView AS CUS LEFT OUTER JOIN
                             (SELECT        CustomerID, SUM(Credit) AS [Total Paid], SUM(Debit) AS [Total Sales]
                               FROM            [Transaction]
                               WHERE        (Status > 0) AND (dbo.GetDay(StartSaleTime) >= @FromDate) AND (dbo.GetDay(StartSaleTime) <= @ToDate)
                               GROUP BY CustomerID) AS TR ON CUS.CustomerID = TR.CustomerID LEFT OUTER JOIN
                             (SELECT        CustomerID, SUM(Debit) AS [After Season Sales], SUM(Credit) AS [After Season Payments]
                               FROM            [Transaction] AS Transaction_1
                               WHERE        (dbo.GetDay(StartSaleTime) > @ToDate) AND (Status > 0)
                               GROUP BY CustomerID) AS AF ON CUS.CustomerID = AF.CustomerID LEFT OUTER JOIN
                             (SELECT        CustomerID, SUM(Debit) - SUM(Credit) AS [Balance Before Season]
                               FROM            [Transaction] AS Transaction_3
                               WHERE        (dbo.GetDay(StartSaleTime) < @FromDate) AND (Status > 0)
                               GROUP BY CustomerID) AS BEF ON CUS.CustomerID = BEF.CustomerID
WHERE        (CUS.BalanceDoe >= '0.01')
GO