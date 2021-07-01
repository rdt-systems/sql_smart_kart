SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sp_Create_FK] as 


	 select case when ac.is_nullable =1 then 
'
update    '+Col.Table_Name+' set '+Column_Name+'=null  where not exists (select 1 from '+op.name+' where '+op.name+'.'+acc.name +'='+Col.Table_Name+'.'+Column_Name+' ) and  '+Col.Table_Name+'.'+Column_Name + ' is not null 
go' 
else 
'delete   '+Col.Table_Name+' where not exists (select 1 from '+op.name+' where '+op.name+'.'+acc.name +'='+Col.Table_Name+'.'+Column_Name+' )  
go '
end + 
'
if not exists(select 1 from  
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE 
    Col.Constraint_Name = Tab.Constraint_Name
    AND Col.Table_Name = Tab.Table_Name
    AND Constraint_Type = ''FOREIGN KEY''
	and Col.Table_Name='''+Col.Table_Name+'''
	and Col.Column_Name='''+Col.Column_Name+''')
begin 
ALTER TABLE ['+Col.Table_Name COLLATE SQL_Latin1_General_CP1_CI_AS +'] WITH CHECK  ADD CONSTRAINT '+Col.Constraint_Name COLLATE SQL_Latin1_General_CP1_CI_AS +'  '+ Constraint_Type COLLATE SQL_Latin1_General_CP1_CI_AS  + ' ' + '(['+Column_Name COLLATE SQL_Latin1_General_CP1_CI_AS +'])
REFERENCES ['+op.name+'] (['+acc.name+'])
end
go
' AS A
from 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col ,
	sys.foreign_key_columns fkc ,
	sys.all_objects  o,
	[sys].[all_columns] ac ,
	sys.all_objects  op,
	[sys].[all_columns] acc
WHERE 
    Col.Constraint_Name = Tab.Constraint_Name
    AND Col.Table_Name = Tab.Table_Name
	and fkc.constraint_object_id =o.object_id
	and o.name =Col.Constraint_Name
	and o.type ='F'
	and ac.object_id =fkc.parent_object_id 
    and op.object_id =fkc.referenced_object_id 
	and fkc.parent_column_id  =ac.[column_id]
	and fkc.referenced_object_id  =acc.object_id
	and fkc.referenced_column_id  =acc.[column_id]

   AND Constraint_Type = 'FOREIGN KEY'
GO