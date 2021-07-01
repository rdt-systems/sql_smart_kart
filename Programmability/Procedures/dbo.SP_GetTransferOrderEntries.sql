SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetTransferOrderEntries]
(@ID uniqueidentifier)
as
	SELECT     dbo.TransferOrderEntryView.*
	FROM       dbo.TransferOrderEntryView
	WHERE     (Status > - 1) and (TransferOrderID=@ID)
GO