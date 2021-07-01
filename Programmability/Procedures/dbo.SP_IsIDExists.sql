SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_IsIDExists]
(@Tbl nvarchar(50),
@IDFieldName nvarchar(50),
@ID uniqueidentifier )
as 

declare @Str1 nvarchar(50)
declare @Str2 nvarchar(50)
declare @Str3 nvarchar(50)
set @Str1='select DateModified from ['
set @Str2='] where '
set @Str3='='''
exec (@str1 + @Tbl+ @Str2 + @IDFieldName + @Str3 +@ID+'''')
GO