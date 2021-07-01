SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetReceiveTransferEntries]
(@ID uniqueidentifier,
@MySort nvarchar(200) = NULL)
as

If ISNULL(@MySort,'') = ''
Set @MySort =  'SortOrder'

Declare @MySelect nvarchar(4000)
SET @MySelect = 'SELECT     dbo.ReceiveTransferEntryView.*
	FROM       dbo.ReceiveTransferEntryView
	WHERE     (Status > - 1) and (ReceiveTransferID = ''' + CONVERT(nvarchar(50),@ID) + ''')
	Order By '

Print (@MySelect + @MySort)
Execute (@MySelect + @MySort)
GO