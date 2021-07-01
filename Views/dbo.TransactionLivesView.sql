SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransactionLivesView]
AS

SELECT     CASE WHEN TransactionType = 2 THEN 'Open Balance' WHEN TransactionType = 4 THEN 'Add Charge' WHEN TransactionType = 3 THEN 'Return Items' ELSE 'Sale' END
                       AS Type, TransactionView.EndSaleTime AS DateT, TransactionView.TransactionNo AS Num, TransactionView.DueDate, 
                      ISNULL(TransactionView.LeftDebit, 0) AS OpenBalance, TransactionView.Debit - ISNULL(TransactionView.LeftDebit, 0) 
                      AS AmountPay, TransactionView.TransactionID AS IDc, TransactionView.CustomerID AS PID, 
                      TransactionView.Debit - TransactionView.Credit AS Amount, TransactionView.Name, 
                      TransactionView.CustomerNo, TransactionView.Status, TransactionView.Debit, TransactionView.Credit, 
                      TransactionView.TransactionType, TransactionView.StartSaleTime, TransactionView.EndTime AS TimeT, 
                      TransactionView.StoreID, TransactionView.StoreName, TransactionView.UserCreated, Users.UserName
FROM         dbo.Users RIGHT OUTER JOIN
                      dbo.TransactionView ON Users.UserId = TransactionView.UserCreated
GO