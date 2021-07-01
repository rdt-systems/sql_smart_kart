SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[GetTablesColumns](@TableName varchar(max))
RETURNS  varchar(Max)  AS  
BEGIN 

 declare @Result varchar(max)=''
            select  @Result=@Result+','+ColumnName
            from
            (
                select
                    replace(col.name, ' ', '_') ColumnName,
                    column_id ColumnId
                from sys.columns col
                    join sys.types typ on
                        col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
                where object_id = object_id(@TableName)
            ) t
            order by ColumnId




return  substring(@Result,2,len(@Result))

END
GO