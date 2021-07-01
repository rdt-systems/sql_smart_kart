SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneReceiveTransfer]
(@ID uniqueidentifier)
as
	SELECT     dbo.ReceiveTransferView.*
	FROM       dbo.ReceiveTransferView
	WHERE     (Status > -1) and (ReceiveTransferID=@ID)
GO