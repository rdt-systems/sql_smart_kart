SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransactionPOSView]
AS
SELECT        TransactionView.TransactionID, TransactionView.TransactionNo, TransactionView.TransactionType, TransactionView.RegisterTransaction, TransactionView.BatchID, TransactionView.StoreID, 
                         TransactionView.CustomerID, TransactionView.Debit, TransactionView.Credit, TransactionView.StartSaleTime, TransactionView.EndSaleTime, TransactionView.DueDate, TransactionView.Tax, 
                         TransactionView.TaxType, TransactionView.TaxID, TransactionView.TaxRate, TransactionView.ShipTo, TransactionView.ShipVia, TransactionView.PONo, TransactionView.RepID, TransactionView.TermsID, 
                         TransactionView.PhoneOrder, TransactionView.ToPrint, TransactionView.ToEmail, TransactionView.CustomerMessage, TransactionView.Note, TransactionView.Status, TransactionView.DateCreated, 
                         TransactionView.UserCreated, TransactionView.DateModified, TransactionView.UserModified, dbo.FormatDateTime(TransactionView.EndSaleTime, 'HH:MM:SS 12') AS EndTime, 
                         dbo.FormatDateTime(TransactionView.StartSaleTime, 'HH:MM:SS 12') AS StartTime, TransactionView.CustomerName, TransactionView.Freight, TransactionView.CustomerNo, TransactionView.RegisterID, 
                         TransactionView.VoidReason, TransactionView.ResellerID, TransactionView.ResellerName, TransactionView.StoreName, TransactionView.DeliveryDate, TransactionView.TrackNo, TransactionView.Rounding, 
                         TransactionView.RegShiftID, Users.UserName AS [User], Usr.UserName AS SaleAssociate
FROM            TransactionView LEFT OUTER JOIN
                         Users ON TransactionView.UserCreated = Users.UserId LEFT OUTER JOIN
                         SaleAssociate ON TransactionView.TransactionID = SaleAssociate.TransactionID LEFT OUTER JOIN
                         Users AS Usr ON SaleAssociate.UserID = Usr.UserId
GO