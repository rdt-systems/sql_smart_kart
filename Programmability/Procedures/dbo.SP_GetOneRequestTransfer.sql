SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneRequestTransfer]
(@ID uniqueidentifier)
as
	SELECT     dbo.RequestTransferView.*
	FROM       dbo.RequestTransferView
	WHERE     (Status > -1) and (RequestTransferID=@ID)
GO