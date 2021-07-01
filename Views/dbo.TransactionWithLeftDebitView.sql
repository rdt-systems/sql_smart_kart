SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransactionWithLeftDebitView]
AS
SELECT     dbo.TransactionView.TransactionID, dbo.TransactionView.TransactionNo, dbo.TransactionView.TransactionType, 
                      dbo.TransactionView.RegisterTransaction, dbo.TransactionView.BatchID, dbo.TransactionView.StoreID, dbo.TransactionView.CustomerID, 
                      dbo.TransactionView.Debit, dbo.TransactionView.Credit, dbo.TransactionView.StartSaleTime, dbo.TransactionView.EndSaleTime, 
                      dbo.TransactionView.DueDate, dbo.TransactionView.LeftDebit, dbo.TransactionView.CurrBalance, dbo.TransactionView.Freight, 
                      dbo.TransactionView.Tax, dbo.TransactionView.TaxType, dbo.TransactionView.TaxID, dbo.TransactionView.TaxRate, dbo.TransactionView.ShipTo, 
                      dbo.TransactionView.ShipVia, dbo.TransactionView.PONo, dbo.TransactionView.RepID, dbo.TransactionView.TermsID, 
                      dbo.TransactionView.PhoneOrder, dbo.TransactionView.ToPrint, dbo.TransactionView.ToEmail, dbo.TransactionView.CustomerMessage, 
                      dbo.TransactionView.Note, dbo.TransactionView.Status, dbo.TransactionView.DateCreated, dbo.TransactionView.UserCreated, 
                      dbo.TransactionView.DateModified, dbo.TransactionView.UserModified, dbo.TransactionView.RecieptTxt, dbo.TransactionView.RegisterID, 
                      dbo.TransactionView.VoidReason , CONVERT(varchar, dbo.TransactionView.EndSaleTime, 108) AS EndTime, CONVERT(varchar, 
                      dbo.TransactionView.StartSaleTime, 108) AS StartTime, CustomerView.Name ,CustomerView.CustomerNo,
                          (SELECT     SUM(Amount) AS AppliedAmount
                            FROM          dbo.PaymentDetails
                            WHERE      (Status > 0) AND (TransactionID = dbo.TransactionView.TransactionID)
                            GROUP BY TransactionID) AS AppliedAmount,StoreName--,CustomerType,CustomerGroupID,PriceLevelID,Zip,DiscountID,TaxExempt
FROM         dbo.TransactionView LEFT OUTER JOIN
                      CustomerView ON dbo.TransactionView.CustomerID = CustomerView.CustomerID LEFT OUTER JOIN
                      dbo.LeftDebitsView ON dbo.TransactionView.TransactionID = dbo.LeftDebitsView.TransactionID
WHERE     (dbo.TransactionView.Status > - 1)
GO