SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceive]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ReceiveOrderView.*
                FROM       dbo.ReceiveOrderView
	        WHERE     '
PRINT (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO