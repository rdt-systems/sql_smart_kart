SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[TransactionForCustomer]
AS
SELECT     dbo.TransactionView.TransactionID, dbo.TransactionView.StartSaleTime AS [Trans Time], dbo.TransactionView.TransactionNo AS [Trans #], dbo.TransactionView.Debit, 
                      dbo.TransactionView.Credit, dbo.Users.UserFName AS [User], dbo.SysTransactionTypeView.SystemValueName AS [Transaction Type], 
                      dbo.TransactionView.CustomerID, dbo.TransactionView.Status, dbo.TransactionView.StoreID, dbo.TransactionView.EndSaleTime
FROM         dbo.TransactionView LEFT OUTER JOIN
                      dbo.Users ON dbo.TransactionView.UserCreated = dbo.Users.UserId LEFT OUTER JOIN
                      dbo.SysTransactionTypeView ON dbo.TransactionView.TransactionType = dbo.SysTransactionTypeView.SystemValueNo
GO