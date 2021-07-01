SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[sp_Create_Indexs] as 

select script 
from 
(
select 0 n , ' SET ANSI_PADDING ON 'as script

--union all

-- SELECT  1 n,
--  '
--PRINT ' + '''' + Indexs_script_view.indexName + ' ON Table '  +   Indexs_script_view.TableName + '''' + '
--IF (EXISTS(SELECT * FROM sys.indexes WHERE name= ' + '''' + Indexs_script_view.indexName + '''' + ' AND object_id = OBJECT_ID(''' +   Indexs_script_view.TableName + '''))) ' + ' 
--DROP INDEX ['+ Indexs_script_view.indexName + ']' + ' ON ' +
--       Indexs_script_view.SCHEMA_NAME + '.' + '[' + Indexs_script_view.TableName + ']' + '
--go
--' 
--FROM   Indexs_script_view

UNION ALL 
 SELECT  2 n,
  '
PRINT ' + '''' + cc.CONSTRAINT_NAME + ' ON Table '  +   TABLE_NAME + '''' + '
IF (EXISTS(SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS WHERE CONSTRAINT_NAME= ' + '''' + cc.CONSTRAINT_NAME + ''''+')) ' + ' 
ALTER TABLE ['+cc.CONSTRAINT_SCHEMA+'].['+TABLE_NAME+'] DROP CONSTRAINT ['+ cc.CONSTRAINT_NAME+']
go
' as script
FROM   INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
 INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c 
           ON cc.CONSTRAINT_NAME = c.CONSTRAINT_NAME
  UNION ALL 
 SELECT  3 n,
  '
PRINT ' + '''' + [CONSTRAINT_UNIQUE_script_view].indexName + ' ON Table '  +   [CONSTRAINT_UNIQUE_script_view].TableName + '''' + '
IF (EXISTS(SELECT * FROM sys.indexes WHERE name= ' + '''' + [CONSTRAINT_UNIQUE_script_view].indexName + '''' + ' AND object_id = OBJECT_ID(''' +   [CONSTRAINT_UNIQUE_script_view].TableName + '''))) ' + ' 
ALTER TABLE  '+ CONSTRAINT_UNIQUE_script_view.SCHEMA_NAME + '.' + '[' + CONSTRAINT_UNIQUE_script_view.TableName + '] DROP CONSTRAINT  ['+ CONSTRAINT_UNIQUE_script_view.indexName + '] 
go
' as script
FROM   [CONSTRAINT_UNIQUE_script_view]




 UNION ALL 

select 4,
 '
 --create
 '
  UNION ALL 
  select 5 n , ' 
  SET ANSI_PADDING ON 
  'as script
    UNION ALL 
  select 
6,
'
IF NOT (EXISTS(SELECT * FROM sys.indexes WHERE name= ' + '''' + Indexs_script_view.indexName + '''' + ' AND object_id = OBJECT_ID(''' +   Indexs_script_view.TableName + '''))) ' + ' 
CREATE ' +
       
	   Indexs_script_view.[CreateIndexScript]
FROM   Indexs_script_view
  UNION ALL 
select 
7,
'
IF NOT (EXISTS(SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS WHERE CONSTRAINT_NAME= ' + '''' + cc.CONSTRAINT_NAME + ''''+')) 
ALTER TABLE ['+cc.CONSTRAINT_SCHEMA+'].['+TABLE_NAME+']  WITH CHECK ADD  CONSTRAINT ['+ cc.CONSTRAINT_NAME+'] CHECK ('+CHECK_CLAUSE+')
go
'     

FROM   INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
 INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c 
           ON cc.CONSTRAINT_NAME = c.CONSTRAINT_NAME
		     UNION ALL 

		     select 
8,
'
IF NOT (EXISTS(SELECT * FROM sys.indexes WHERE name= ' + '''' + [CONSTRAINT_UNIQUE_script_view].indexName COLLATE SQL_Latin1_General_CP1_CI_AS + '''' + ' AND object_id = OBJECT_ID(''' +   [CONSTRAINT_UNIQUE_script_view].TableName COLLATE SQL_Latin1_General_CP1_CI_AS + '''))) ' + ' 
 ' +
       
	   [CONSTRAINT_UNIQUE_script_view].[CreateIndexScript]
FROM   [CONSTRAINT_UNIQUE_script_view]


 )as ss
GO