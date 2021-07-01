SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetReturnEntries]
(@ID uniqueidentifier)
as
	SELECT     dbo.ReturnToVenderEntryView.*
	FROM       dbo.ReturnToVenderEntryView
	WHERE     (Status > - 1) and (ReturnToVenderID=@ID)
GO