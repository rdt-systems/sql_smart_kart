SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE VIEW [dbo].[TransactionWithPaidView]
AS
SELECT        TransactionView.TransactionID, TransactionView.TransactionNo, TransactionView.TransactionType, TransactionView.RegisterTransaction, TransactionView.BatchID, TransactionView.StoreID, 
                         TransactionView.CustomerID, TransactionView.Debit, TransactionView.Credit, TransactionView.StartSaleTime, TransactionView.EndSaleTime, TransactionView.DueDate, TransactionView.Tax, 
                         TransactionView.TaxType, TransactionView.TaxID, TransactionView.TaxRate, TransactionView.ShipTo, TransactionView.ShipVia, TransactionView.PONo, TransactionView.RepID, TransactionView.TermsID, 
                         TransactionView.PhoneOrder, TransactionView.ToPrint, TransactionView.ToEmail, TransactionView.CustomerMessage, TransactionView.Note, TransactionView.Status, TransactionView.DateCreated, 
                         TransactionView.UserCreated, TransactionView.DateModified, TransactionView.UserModified, (CASE WHEN (DEBIT - LeftDebit) = 0 OR
                         (transactiontype <> 0 AND transactiontype <> 2 AND transactiontype <> 4) THEN NULL ELSE (DEBIT - LeftDebit) END) AS LeftDebit, (CASE WHEN transactiontype = 1 OR
                         transactiontype = 3 THEN NULL ELSE leftDebit END) AS Balance, dbo.FormatDateTime(TransactionView.EndSaleTime, 'HH:MM:SS 12') AS EndTime, dbo.FormatDateTime(TransactionView.StartSaleTime, 
                         'HH:MM:SS 12') AS StartTime, TransactionView.CustomerName,
                             (SELECT        SUM(Amount) AS AppliedAmount
                               FROM            PaymentDetails
                               WHERE        (Status > 0) AND (TransactionID = TransactionView.TransactionID)
                               GROUP BY TransactionID) AS AppliedAmount, TransactionView.Freight, TransactionView.CustomerNo, TransactionView.RegisterID, TransactionView.VoidReason, TransactionView.ResellerID, 
                         TransactionView.ResellerName, Entry.SubTotal, TransactionView.StoreName, TransactionView.DeliveryDate, TransactionView.TrackNo, TransactionView.Rounding, TransactionView.CurrBalance, 
                         Users.UserName AS [User], Usr.UserName AS SaleAssociate
FROM            TransactionView LEFT OUTER JOIN
                             (SELECT        TransactionID, SUM(Total) AS SubTotal
                               FROM            TransactionEntry
                               WHERE        (TransactionEntryType <> 4) AND (Status > 0)
                               GROUP BY TransactionID) AS Entry ON TransactionView.TransactionID = Entry.TransactionID LEFT OUTER JOIN
                         Users ON TransactionView.UserCreated = Users.UserId LEFT OUTER JOIN
                         SaleAssociate ON TransactionView.TransactionID = SaleAssociate.TransactionID LEFT OUTER JOIN
                         Users AS Usr ON SaleAssociate.UserID = Usr.UserId
GO