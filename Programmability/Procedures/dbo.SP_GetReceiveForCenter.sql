SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveForCenter]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ReceiveForCenter.*
                FROM         dbo.ReceiveForCenter
	        WHERE     '
Execute (@MySelect + @Filter )
GO