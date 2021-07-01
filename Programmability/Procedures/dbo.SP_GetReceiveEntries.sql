SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetReceiveEntries]
(@ID uniqueidentifier,
@MySort Varchar(200))
as

Declare @MySelect varchar(4000)

Set @MySelect = '
	SELECT     dbo.ReceiveEntryView.*
	FROM       dbo.ReceiveEntryView
	WHERE     (Status > - 1) and (ReceiveNo=''' +CONVERT(varchar(100), @ID) + ''')  Order By '


	Print (@MySelect + @MySort)
Execute (@MySelect + @MySort)
GO