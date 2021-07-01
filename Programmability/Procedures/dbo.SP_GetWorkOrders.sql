SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetWorkOrders]

(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT   dbo.WorkOrderView.*
		FROM dbo.WorkOrderView
		WHERE Status>-1 '
Execute (@MySelect + @Filter )
GO