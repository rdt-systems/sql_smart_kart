SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTranOrderToTransfer]
(@Filter nvarchar(4000))

as

declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.TransferOrder.*,dbo.Store.StoreName AS [From Store], Store_1.StoreName AS [To Store]
		        FROM       dbo.TransferOrder INNER JOIN
                           dbo.Store ON dbo.TransferOrder.FromStoreID = dbo.Store.StoreID INNER JOIN
                           dbo.Store Store_1 ON dbo.TransferOrder.ToStoreID = Store_1.StoreID
                Where  dbo.TransferOrder.OrderStatus <> 1  And TransferOrder.Status> 0 '
Execute (@MySelect + @Filter )
GO