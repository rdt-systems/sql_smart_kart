SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneReturn]
(@ID uniqueidentifier)
as
	SELECT     dbo.ReturnToVenderView.*
	FROM       dbo.ReturnToVenderView
	WHERE     (Status > -1) and (ReturnToVenderID=@ID)
GO