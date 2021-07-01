SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetNextID]
(
@tbl nvarchar(30),
@col Nvarchar(30) 
)
as 
 
exec ('select Max('+ @col +')+1 from '+@tbl )
GO