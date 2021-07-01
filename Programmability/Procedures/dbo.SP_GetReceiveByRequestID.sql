SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveByRequestID]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
Set @MySelect = 'select * from TransferEntryView 
'

print(@MySelect + @Filter)
Execute (@MySelect + @Filter)
GO