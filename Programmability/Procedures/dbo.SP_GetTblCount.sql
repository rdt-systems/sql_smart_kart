SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetTblCount]
(@TblName nvarchar(50),
@Filter nvarchar(4000))
as 
exec ('Select count(*) From [' + @TblName + '] where 1=1 ' +@Filter)
GO