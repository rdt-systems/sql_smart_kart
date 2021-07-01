SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetFullTbl]
(@TblName nvarchar(50),
@Filter nvarchar(4000))
as 
exec ('Select * From [' + @TblName + '] where 1=1 ' +@Filter)
GO