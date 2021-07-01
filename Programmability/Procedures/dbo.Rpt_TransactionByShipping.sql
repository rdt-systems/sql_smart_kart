SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


---Sp Created to show records for Customer Transcation By shipping report

CREATE PROCEDURE [dbo].[Rpt_TransactionByShipping]  
(
 @Filter nvarchar(4000) = ''
)
AS
 DECLARE @Query  nvarchar(2000)
 SET @Query = 'SELECT ISNULL(Customer.LastName,'' '') + ISNULL(Customer.FirstName,'' '') AS CustomerName ,
				Customer.CustomerNo AS AccountNo,
				[CustomerAddresses].[Name] as ShipName,
				ISNULL(CustomerAddresses.Street1,'' '') + ISNULL(CustomerAddresses.Street2,'' '') as ShipAdress, 
				[Transaction].[EndSaleTime] as SaleDate,
				[Transaction].[TransactionNo] as TransactionNo,
				[Transaction].[Debit] as SaleAmount,[Transaction].[Credit] As Payment,TransactionID
FROM        Customer RIGHT OUTER JOIN
            [Transaction] ON Customer.CustomerID = [Transaction].CustomerID LEFT OUTER JOIN
            CustomerAddresses ON [Transaction].ShipTo = CustomerAddresses.CustomerAddressID	'
	
IF(@Filter = '') 
      BEGIN
       EXEC (@Query + ' WHERE [Transaction].Status>0' )
      END
ELSE
      BEGIN
       EXEC (@Query + @Filter +' AND [Transaction].Status>0' )
      END
--BEGIN 
--   IF(@Filter = '') 
--	BEGIN
--		SELECT	ISNULL(Customer.LastName,' ') + ISNULL(Customer.FirstName,' ') AS CustomerName ,
--				Customer.CustomerNo AS AccountNo,
--				[CustomerAddresses].[Name] as ShipName,
--				ISNULL(CustomerAddresses.Street1,' ') + ISNULL(CustomerAddresses.Street2,' ') as ShipAdress, 
--				[Transaction].EndSaleTime as SaleDate,
--				[Transaction].TransactionNo as TransactionNo,
--				[Transaction].Debit as SaleAmount
--		FROM    Customer INNER JOIN
--			    CustomerAddresses ON Customer.CustomerID = CustomerAddresses.CustomerID INNER JOIN
--				[Transaction] ON Customer.CustomerID = [Transaction].CustomerID
--   END
--
--ELSE
--	BEGIN
--	SELECT		ISNULL(Customer.LastName,' ') + ISNULL(Customer.FirstName,' ') AS CustomerName ,
--				Customer.CustomerNo AS AccountNo,
--				[CustomerAddresses].[Name] as ShipName,
--				ISNULL(CustomerAddresses.Street1,' ') + ISNULL(CustomerAddresses.Street2,' ') as ShipAdress, 
--				[Transaction].EndSaleTime as SaleDate,
--				[Transaction].TransactionNo as TransactionNo,
--				[Transaction].Debit as SaleAmount
--	    FROM	Customer INNER JOIN
--				CustomerAddresses ON Customer.CustomerID = CustomerAddresses.CustomerID INNER JOIN
--				[Transaction] ON Customer.CustomerID = [Transaction].CustomerID
--				WHERE [Transaction].EndSaleTime >= '2008-05-08' AND [Transaction].EndSaleTime <= '2009-05-28';
  
--	END
--END
--My last query
-- SET @Query = 'SELECT ISNULL(Customer.LastName,'' '') + ISNULL(Customer.FirstName,'' '') AS CustomerName ,
--				Customer.CustomerNo AS AccountNo,
--				[CustomerAddresses].[Name] as ShipName,
--				ISNULL(CustomerAddresses.Street1,'' '') + ISNULL(CustomerAddresses.Street2,'' '') as ShipAdress, 
--				[Transaction].[EndSaleTime] as SaleDate,
--				[Transaction].[TransactionNo] as TransactionNo,
--				[Transaction].[Debit] as SaleAmount
--	    FROM	Customer INNER JOIN
--				CustomerAddresses ON Customer.CustomerID = CustomerAddresses.CustomerID INNER JOIN
--				[Transaction] ON Customer.CustomerID = [Transaction].CustomerID	'
GO