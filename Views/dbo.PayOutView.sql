SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO







CREATE VIEW [dbo].[PayOutView]
AS
SELECT        PayOut.PayOutID, PayOut.Amount, PayOut.Reason, PayOut.PayOutDate, dbo.FormatDateTime(PayOut.PayOutDate, 'HH:MM:SS 12') AS PayoutTime, PayOut.RegisterID, PayOut.ChasierID, PayOut.BatchID, 
                         PayOut.Status, PayOut.DateCreated, PayOut.UserCreated, PayOut.DateModified, PayOut.UserModified, Registers.RegisterNo, Users.UserName AS Cashier, Batch.BatchNumber AS BatchNo, 
                         '' AS UserAutherized,
						 Store.StoreName, Store.StoreID
FROM            PayOut LEFT OUTER JOIN
                         Batch ON PayOut.BatchID = Batch.BatchID LEFT OUTER JOIN
                         Registers ON PayOut.RegisterID = Registers.RegisterID LEFT OUTER JOIN
                         Users ON Batch.CashierID = Users.UserId LEFT OUTER JOIN
						 Store on Registers.StoreID =Store.StoreID
GO