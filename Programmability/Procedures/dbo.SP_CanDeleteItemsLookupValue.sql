SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_CanDeleteItemsLookupValue]
(@ID uniqueidentifier,
@FieldName nvarchar(50))

as
declare 
@sql varchar
set @sql = 
'if (
select Count(1) from dbo.ItemMainView
          where '+ @FieldName+' ='''+convert(varchar(50),@ID)+''' AND Status>-1
		  
		  
		  )=0
                   select 1
else
                   select 0
				   '


				   print @sql

				   execute  @sql
GO