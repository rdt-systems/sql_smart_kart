SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetNewBatch]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
  set @MySelect= 'SELECT        Users.UserName, Batch.BatchID, Batch.BatchNumber, Store.StoreName,
					(CASE WHEN Batchstatus =2 THEN ''Close''	ELSE ''Open'' END) AS Status, Batch.OpeningDateTime, Batch.ClosingDateTime
					FROM            Batch INNER JOIN
											 Users ON Batch.CashierID = Users.UserId INNER JOIN
											 Store ON Batch.StoreID = Store.StoreID '

Execute (@MySelect + @Filter )


--SELECT        Users.UserName, Batch.BatchID, Batch.BatchNumber, Store.StoreName,
--(CASE WHEN Batchstatus =2 THEN 'Close'	ELSE 'Open' END) AS Status, Batch.OpeningDateTime, Batch.ClosingDateTime
--FROM            Batch INNER JOIN
--                         Users ON Batch.CashierID = Users.UserId INNER JOIN
--                         Store ON Batch.StoreID = Store.StoreID
GO