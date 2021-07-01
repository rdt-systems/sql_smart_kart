SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[TransactionView]
AS
SELECT        [Transaction].TransactionID, [Transaction].TransactionNo, [Transaction].TransactionType, [Transaction].RegisterTransaction, [Transaction].BatchID, [Transaction].StoreID, [Transaction].CustomerID, 
                         [Transaction].Debit, [Transaction].Credit, [Transaction].StartSaleTime, [Transaction].EndSaleTime, [Transaction].DueDate, [Transaction].LeftDebit, [Transaction].CurrBalance, [Transaction].Freight, [Transaction].Tax,
                          [Transaction].TaxType, [Transaction].TaxID, [Transaction].TaxRate, [Transaction].ShipTo, [Transaction].ShipVia, [Transaction].PONo AS PONo, [Transaction].RepID, [Transaction].TermsID, [Transaction].PhoneOrder, [Transaction].ToPrint, [Transaction].ToEmail, 
                         [Transaction].CustomerMessage, [Transaction].Note, [Transaction].ResellerID, [Transaction].Status, [Transaction].DateCreated, [Transaction].UserCreated, [Transaction].DateModified, [Transaction].UserModified, 
                         [Transaction].RecieptTxt, [Transaction].RegisterID, [Transaction].VoidReason, '0' AS ResellerName, Customer.CustomerNo,
						    ISNULL(Customer.LastName, '') + ISNULL(', ' + CASE WHEN dbo.Customer.FirstName = '' THEN NULL ELSE dbo.Customer.FirstName END, ' ')  AS CustomerName, Store.StoreName, 
                         [Transaction].DeliveryDate, [Transaction].TrackNo, [Transaction].Rounding, [Transaction].RegShiftID,   ISNULL(Customer.LastName, '') + ISNULL(', ' + CASE WHEN dbo.Customer.FirstName = '' THEN NULL ELSE dbo.Customer.FirstName END, ' ')  AS Name, [Transaction].EndSaleTime AS EndTime
FROM            dbo.[Transaction] WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.Store ON [Transaction].StoreID = Store.StoreID LEFT OUTER JOIN
                         dbo.Customer ON [Transaction].CustomerID = Customer.CustomerID
GO