SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_GetOneTransfer]
(@ID uniqueidentifier)
as
	SELECT     dbo.TransferItemsView.*
	FROM       dbo.TransferItemsView
	WHERE     (Status > -1) and (TransferID=@ID)
GO