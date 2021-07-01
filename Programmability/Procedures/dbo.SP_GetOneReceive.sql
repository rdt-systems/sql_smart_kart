SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneReceive]
(@ID uniqueidentifier)
as
	SELECT     dbo.ReceiveOrderView.*
	FROM       dbo.ReceiveOrderView
	WHERE     (Status > -1) and (ReceiveID=@ID)
GO