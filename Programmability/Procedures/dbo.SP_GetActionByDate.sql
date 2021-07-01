SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetActionByDate]
(@Filter nvarchar(4000))

as

declare @MySelect nvarchar(4000)
declare @MyGroupBy nvarchar(4000)

set @MySelect= 'SELECT     Store.StoreID, Store.StoreName, Batch.BatchID, CONVERT(nvarchar, Actions.ActionDate, 111) AS ActionDate, COUNT(*) AS Times, 
                      upper(Users.UserName) AS Cashier, SystemValues.SystemValueName AS Action, Batch.CashierID, Actions.ActionType, Batch.BatchNumber
FROM         Actions INNER JOIN
                      Batch ON Batch.BatchID = Actions.BatchID LEFT OUTER JOIN
                      Store ON Store.StoreID = Batch.StoreID LEFT OUTER JOIN
                      Users ON Users.UserId = Batch.CashierID LEFT OUTER JOIN
                      SystemValues ON SystemValues.SystemValueNo = Actions.ActionType AND SystemValues.SystemTableNo = 27
WHERE     (1 = 1)'

set @MyGroupBy = ' GROUP BY Store.StoreID, Store.StoreName, Batch.BatchID, Users.UserName, SystemValues.SystemValueName, CONVERT(nvarchar, Actions.ActionDate, 111), 
                      Batch.CashierID, Actions.ActionType, Batch.BatchNumber
ORDER BY ActionDate DESC'

--print (@MySelect + @Filter + @MyGroupBy)
Execute (@MySelect + @Filter + @MyGroupBy)
GO