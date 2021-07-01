SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTblChangesByDate]
(@Tbl nvarchar(50),
@Date datetime,
@StoreFieldName nvarchar(40)=null,
@StoreID uniqueidentifier =null)
as
declare @Str1 nvarchar(50)
declare @Str2 nvarchar(50)
declare @Str3 nvarchar(50)
declare @Str4 nvarchar(50)
declare @ExecStr nvarchar(50)

set @Str1='Select * from ['
set @Str2='] where DateModified > '''

if (@StoreID is null)
	exec (@Str1 + @Tbl +@Str2 + @Date+'''')
else
	begin
		set @str3=''' and '
		set @str4= ' = '''
		exec (  @Str1 + @Tbl +@Str2 + @Date + @str3 + @StoreFieldName + @str4 +@StoreID+'''')
	end
GO