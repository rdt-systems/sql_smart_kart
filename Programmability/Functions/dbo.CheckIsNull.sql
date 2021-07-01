SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[CheckIsNull](@var sql_variant,@VarType smallint=0)
RETURNS varchar(200)  AS  
BEGIN 
declare @ret varchar(200)
IF @var IS NULL 
set @ret= 'null'
ELSE
set @ret= case when @VarType =0 then '''' + cast(@var as varchar(200)) + ''''  else cast(@var as varchar(200))  end  
return @ret
END
GO