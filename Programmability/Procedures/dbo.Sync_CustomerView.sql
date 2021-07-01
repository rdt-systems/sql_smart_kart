SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_CustomerView]
(@FromDate DateTime)
AS

SELECT Customer.CustomerID,
	   CustomerNo,
	   ISNULL(FirstName,'') as FirstName,
	   ISNULL(LastName,'') as LastName,
	   (CASE WHEN PriceLevelID=0 THEN '' ELSE PriceLevelID END) as PriceLevel,
	   ISNULL(BalanceDoe,0) as Balance,
	   ISNULL(FaxNumber,'') as FaxNumber,
	   ISNULL(Street1,'') as Address,
	   ISNULL(Street2,'') as Address2,
	   ISNULL(City,'') as City,
	   ISNULL(CustomerAddresses.State,'') as State,
	   ISNULL(Zip,'') as Zip,
	   ISNULL(PhoneNumber1,'') as PhoneNumber,
	   0 as DsRowState
FROM   Customer 
LEFT OUTER JOIN
 CustomerAddresses ON dbo.Customer.MainAddressID = dbo.CustomerAddresses.CustomerAddressID
Where Customer.Status >-1 And
	  (Customer.DateCreated>@FromDate Or Customer.DateModified>@FromDate Or CustomerAddresses.DateCreated>@FromDate Or CustomerAddresses.DateModified>@FromDate)
GO