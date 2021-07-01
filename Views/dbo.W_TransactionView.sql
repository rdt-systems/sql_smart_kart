SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[W_TransactionView]
AS
SELECT     dbo.[W_Transaction].TransactionID, dbo.[W_Transaction].TransactionNo, dbo.[W_Transaction].TransactionType, dbo.[W_Transaction].RegisterTransaction, 
                      dbo.[W_Transaction].BatchID, dbo.[W_Transaction].StoreID, dbo.[W_Transaction].CustomerID, dbo.[W_Transaction].Debit, dbo.[W_Transaction].Credit, 
                      dbo.[W_Transaction].StartSaleTime, dbo.[W_Transaction].EndSaleTime, dbo.[W_Transaction].DueDate, dbo.[W_Transaction].LeftDebit, 
                      dbo.[W_Transaction].CurrBalance, dbo.[W_Transaction].Freight, dbo.[W_Transaction].Tax, dbo.[W_Transaction].TaxType, dbo.[W_Transaction].TaxID, 
                      dbo.[W_Transaction].TaxRate, dbo.[W_Transaction].ShipTo, dbo.[W_Transaction].ShipVia, dbo.[W_Transaction].PONo, dbo.[W_Transaction].RepID, 
                      dbo.[W_Transaction].TermsID, dbo.[W_Transaction].PhoneOrder, dbo.[W_Transaction].ToPrint, dbo.[W_Transaction].ToEmail, dbo.[W_Transaction].CustomerMessage, 
                      dbo.[W_Transaction].Note, dbo.[W_Transaction].ResellerID, dbo.[W_Transaction].Status, dbo.[W_Transaction].DateCreated, dbo.[W_Transaction].UserCreated, 
                      dbo.[W_Transaction].DateModified, dbo.[W_Transaction].UserModified, dbo.[W_Transaction].RecieptTxt, dbo.[W_Transaction].RegisterID, 
                      dbo.[W_Transaction].VoidReason, dbo.Resellers.CompanyName AS ResellerName, dbo.CustomerView.CustomerNo, 
                      dbo.CustomerView.Name AS CustomerName, dbo.Store.StoreName, dbo.[W_Transaction].DeliveryDate, dbo.[W_Transaction].TrackNo, 
                      dbo.[W_Transaction].Rounding
FROM         dbo.[W_Transaction] LEFT OUTER JOIN
                      dbo.Store ON dbo.[W_Transaction].StoreID = dbo.Store.StoreID LEFT OUTER JOIN
                      dbo.CustomerView ON dbo.[W_Transaction].CustomerID = dbo.CustomerView.CustomerID LEFT OUTER JOIN
                      dbo.Resellers ON dbo.[W_Transaction].ResellerID = dbo.Resellers.ResellerID
GO