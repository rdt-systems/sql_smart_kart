SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_GetTenderByOneTransaction]
(@ID uniqueidentifier)
as
	SELECT     dbo.TenderEntryView.*
	FROM       dbo.TenderEntryView
	WHERE     (Status > - 1) and (TransactionID=@ID)
GO