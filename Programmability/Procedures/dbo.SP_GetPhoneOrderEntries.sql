SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetPhoneOrderEntries]
(@ID uniqueidentifier)
as
	SELECT     dbo.PhoneOrderEntryView.*
	FROM       dbo.PhoneOrderEntryView
	WHERE     (Status > = 0) and (PhoneOrderID=@ID)
GO