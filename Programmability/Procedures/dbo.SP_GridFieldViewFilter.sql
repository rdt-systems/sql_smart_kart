SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[SP_GridFieldViewFilter](@strViewDescription nvarchar(50))
as
	Select ID,ShowField,Fieldname,FieldDescription,SQLField,TableName,SQlFieldAS,SQLFrom,ViewName,ShowRow,FieldType,
	xcolumns.columnName, xcolumns.Typename,xColumns.prec,xColumns.scale  
	from GridFieldsOptions, 
	(select syscolumns.name as columnName, systypes.name as Typename, syscolumns.prec, syscolumns.scale
	from sysobjects inner join syscolumns on sysobjects.id = syscolumns.id 
	inner join systypes on syscolumns.xtype = systypes.xtype 
	where sysobjects.name = 'ItemMainAndStoreView' and systypes.name <> 'sysname') as xColumns
	where replace(replace(GridFieldsOptions.FieldName,'[',''),']','') = xColumns.columnName 
	and ViewDescription = @strViewDescription
GO