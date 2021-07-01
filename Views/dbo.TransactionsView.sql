SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransactionsView]
AS
SELECT     dbo.[Transaction].TransactionID, dbo.[Transaction].TransactionNo, dbo.[Transaction].TransactionType, dbo.[Transaction].RegisterTransaction, 
                      dbo.[Transaction].BatchID, dbo.[Transaction].StoreID, dbo.[Transaction].CustomerID, dbo.[Transaction].Debit, dbo.[Transaction].Credit, 
                      dbo.[Transaction].StartSaleTime, dbo.[Transaction].EndSaleTime, dbo.[Transaction].DueDate, dbo.[Transaction].CurrBalance, 
                      dbo.[Transaction].LeftDebit, dbo.[Transaction].Freight, dbo.[Transaction].Tax, dbo.[Transaction].TaxType, dbo.[Transaction].TaxRate, 
                      dbo.[Transaction].TaxID, dbo.[Transaction].Rounding, dbo.[Transaction].ShipTo, dbo.[Transaction].ShipVia, dbo.[Transaction].PONo, 
                      dbo.[Transaction].RepID, dbo.[Transaction].TermsID, dbo.[Transaction].PhoneOrder, dbo.[Transaction].ToPrint, dbo.[Transaction].ToEmail, 
                      dbo.[Transaction].CustomerMessage, dbo.[Transaction].RegisterID, dbo.[Transaction].RecieptTxt, dbo.[Transaction].Note, 
                      dbo.[Transaction].VoidReason, dbo.[Transaction].ResellerID, dbo.[Transaction].DeliveryDate, dbo.[Transaction].TrackNo, dbo.[Transaction].Status, 
                      dbo.[Transaction].DateCreated, dbo.[Transaction].UserCreated, dbo.[Transaction].DateModified, dbo.[Transaction].UserModified, 
                      dbo.[Transaction].TransferedToBookkeeping, Entry.TotalEntry
FROM         dbo.[Transaction] LEFT OUTER JOIN
                          (SELECT     TransactionID, SUM(Total) AS TotalEntry
                            FROM          dbo.TransactionEntry
                            WHERE      (TransactionEntryType <> 4)
                            GROUP BY TransactionID) AS Entry ON dbo.[Transaction].TransactionID = Entry.TransactionID
GO