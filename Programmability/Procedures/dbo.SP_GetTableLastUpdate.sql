SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTableLastUpdate]
(@Tbl nvarchar(50))
as 

declare @Str nvarchar(200)
set @Str='select max(dateModified)from ['
exec (@str + @Tbl+'] where Status <> 10')
GO