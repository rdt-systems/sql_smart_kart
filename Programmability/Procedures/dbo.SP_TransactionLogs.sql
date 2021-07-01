SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_TransactionLogs]
(@TransactionID nvarchar(4000))

AS
SELECT        TransactionLogs.TransactionID, TransactionLogs.OldRecipt, TransactionLogs.ChangeLogs, CustomerView.CustomerNo, CustomerView.LastName, CustomerView.FirstName, UsersView.UserName, 
                         TransactionLogs.DateCreated, TransactionLogs.TransLogID
FROM            TransactionLogs INNER JOIN
                         UsersView ON TransactionLogs.UserCreated = UsersView.UserId INNER JOIN
                         CustomerView ON TransactionLogs.OldCustomerID = CustomerView.CustomerID
WHERE        (TransactionLogs.TransactionID = @TransactionID)
GO