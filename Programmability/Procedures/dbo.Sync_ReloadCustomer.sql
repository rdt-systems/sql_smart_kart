SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_ReloadCustomer]
(@FromDate DateTime)
as

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

		
FROM dbo.[Transaction]
INNER JOIN Customer On [Transaction].CustomerID=Customer.CustomerID
LEFT OUTER JOIN
CustomerAddresses ON dbo.Customer.MainAddressID = dbo.CustomerAddresses.CustomerAddressID
WHERE ([Transaction].DateModified>= @FromDate or [Transaction].DateCreated>=@FromDate ) AND (Customer.Status>-1)
GROUP BY Customer.CustomerID,
		 CustomerNo,
		 FirstName,
	     LastName,
	     PriceLevelID,
	     BalanceDoe,
	     FaxNumber,
	     Street1,
	     Street2,
	     City,
	     CustomerAddresses.State,
	     Zip,
	     PhoneNumber1
GO