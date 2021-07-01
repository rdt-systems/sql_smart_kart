SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetActionDetailsByDate]
(@Filter nvarchar(4000))

as

declare @MySelect nvarchar(4000)
declare @MyGroupBy nvarchar(4000)

set @MySelect= 'SELECT     Batch.BatchNumber, [Transaction].StartSaleTime AS TranDate, SystemValues.SystemValueName AS Action, Actions.ActionType, 
                      Registers.CompName AS Register, [Transaction].TransactionNo, [Transaction].TransactionID, Users.UserName AS Cashier, Approve.UserName, 
                      Store.StoreName, Actions.ActionSum AS Amount, Info
FROM         Actions LEFT OUTER JOIN
                      [Transaction] ON [Transaction].TransactionID = Actions.TransactionID LEFT OUTER JOIN
                      Batch ON Batch.BatchID = Actions.BatchID LEFT OUTER JOIN
                      Users ON Users.UserId = Batch.CashierID LEFT OUTER JOIN
                      Users AS Approve ON Approve.UserId = Actions.UserID LEFT OUTER JOIN
                      Registers ON Registers.RegisterID = Actions.RegisterID LEFT OUTER JOIN
                      Store ON Store.StoreID = Batch.StoreID LEFT OUTER JOIN
                      SystemValues ON SystemValues.SystemValueNo = Actions.ActionType AND SystemValues.SystemTableNo = 27
WHERE     (1 = 1)'

set @MyGroupBy = ' ORDER BY dbo.[Transaction].StartSaleTime DESC'

Execute (@MySelect + @Filter + @MyGroupBy)
GO