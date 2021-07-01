SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_GetOneTransferOrder]
(@ID uniqueidentifier)
as
	SELECT     dbo.TransferorderView.*
	FROM       dbo.TransferorderView
	WHERE     (Status > -1) and (TransferOrderID=@ID)
GO