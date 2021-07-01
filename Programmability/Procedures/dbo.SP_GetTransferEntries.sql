SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransferEntries]
(@ID uniqueidentifier,
@MySort nvarchar(200) = NULL)
as

If ISNULL(@MySort,'') = ''
Set @MySort =  'SortOrder'

Declare @MySelect nvarchar(4000)
SET @MySelect = 'SELECT     dbo.TransferEntryView.*
	FROM       dbo.TransferEntryView
	WHERE     (Status > - 1) and (TransferID = ''' + CONVERT(nvarchar(50),@ID) + ''')
	Order By '

Print (@MySelect + @MySort)
Execute (@MySelect + @MySort)
GO