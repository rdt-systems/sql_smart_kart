SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOrders]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.PurchaseOrdersView.*
                FROM       dbo.PurchaseOrdersView 
                Where  '
PRINT(@MySelect + @Filter)
Execute (@MySelect + @Filter )
GO