SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[PrintInvoiceView]
AS
SELECT        [Transaction].TransactionNo, [Transaction].ShipVia, CASE WHEN ISNULL(dbo.[Transaction].PONo, '') = '' THEN dbo.[Transaction].Note ELSE dbo.[Transaction].PONo END AS PONo, [Transaction].TransactionID, 
                         [Transaction].Tax, [Transaction].TaxType, [Transaction].Debit, CustomerAddresses.PhoneNumber1, Credit.Name AS aName, Store.StoreName, CONVERT(varchar, [Transaction].StartSaleTime, 103) 
                         AS StartSaleTime, CustomerView.FaxNumber, CustomerView.Name, ISNULL(CustomerAddresses.Street1 + ' ', '') + ISNULL(CustomerAddresses.Street2 + ' ', '') + ISNULL(CHAR(13) + CustomerAddresses.City + ' ', 
                         '') + ISNULL(CustomerAddresses.State + ' ', '') + ISNULL(CHAR(13) + CustomerAddresses.Country + ' ', '') + ISNULL(CustomerAddresses.Zip + ' ', '') AS AllDetails, [Transaction].Note
FROM            CustomerAddresses RIGHT OUTER JOIN
                         CustomerView ON CustomerAddresses.CustomerAddressID = CustomerView.MainAddressID RIGHT OUTER JOIN
                         Store INNER JOIN
                         [Transaction] ON Store.StoreID = [Transaction].StoreID ON CustomerView.CustomerID = [Transaction].CustomerID LEFT OUTER JOIN
                         Credit ON [Transaction].TermsID = Credit.CreditID
GO