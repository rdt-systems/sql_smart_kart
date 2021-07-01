SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReturnForCenter]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ReturnForCenter.*
                FROM         dbo.ReturnForCenter
	        WHERE     '
Execute (@MySelect + @Filter )
GO