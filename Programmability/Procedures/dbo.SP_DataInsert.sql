SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DataInsert]
AS
SELECT ISNULL(A,'') AS A, ISNULL(B,'') AS B FROM 
(
SELECT   ' IF EXISTS(SELECT * From GridFieldsOptions Where  FieldName = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(FieldName,'')),'''','''''') +''')  
 Update GridFieldsOptions SET ' 
 
 + 'SQLField = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(SQLField,'')),'''','''''') +''','
 + 'TableName = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(TableName,'')),'''','''''') +''','
 + 'SQLFieldAS = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(SQLFieldAS,'')),'''','''''') +''','
 + 'SQLFrom = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(SQLFrom,'')),'''','''''') +''','
 + 'EnumModuleName = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(EnumModuleName,'')),'''','''''') +''','
 + 'ShowRow = ' + CONVERT(nvarchar(4000),ISNULL(ShowRow,'')) +','
 + 'FieldType = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(FieldType,'')),'''','''''') +''''
 + ' WHERE FieldName = N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(FieldName,'')),'''','''''') +'''
 ELSE 
 INSERT INTO [GridFieldsOptions] ([ViewName],[ViewDescription],[ShowField],[FieldName],[FieldDescription],[SQLField],[TableName],[SQLFieldAS],[SQLFrom],[EnumModuleName],[ShowRow],[FieldType]) 
 Values  (N'''+ ViewName +''',N'''+ ViewDescription +''', '
 + CONVERT(NVARCHAR(10),ISNULL(ShowField,1)) +',N'''
 + FieldName +''',N'''
 + FieldDescription + ''',' 
 +'N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(SQLField,'')),'''','''''') +''','
 +'N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(TableName,'')),'''','''''') +''',' AS A ,''
 +'N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(SQLFieldAS,'')),'''','''''') +''',' 
 +'N'''+ REPLACE(CONVERT(nvarchar(4000),ISNULL(SQLFrom,'')),'''','''''') +''','
 +'N''' + REPLACE(CONVERT(nvarchar(4000),ISNULL(EnumModuleName,'')),'''','''''') + ''',' 
 + CONVERT(nvarchar(4000),ISNULL(ShowRow,1)) 
 + ',N'''+REPLACE(CONVERT(nvarchar(4000),ISNULL(FieldType,'')),'''','''''')
 +''');
' AS B, 0 AS Sort



FROM            GridFieldsOptions

UNION

select
'IF   EXISTS (SELECT * From SetUpValues  Where OptionID = ' + CONVERT(nvarchar(50),OptionID) + ' AND  StoreID = ''00000000-0000-0000-0000-000000000000'') 
UPDATE SetupValues  Set OptionName = ''' + REPLACE(OptionName,'''','''''') + ''', DateModified = GETDATE() WHERE OptionID = ' + CONVERT(nvarchar(50),OptionID) + ' AND OptionName <> ''' + REPLACE(OptionName,'''','''''') + '''
ELSE
INSERT INTO [SetupValues ] ([CategoryID],[DateCreated],[DateModified],[Description],[FeildType],[IsDefault],[OptionID],[OptionName],[OptionValue],[OptionValueHe],[Status],[StoreID],[UserCreated],[UserModified]) Values  
(2,dbo.GetLocalDATE(),dbo.GetLocalDATE(),NULL,NULL,1,'+ CONVERT(nvarchar(50),OptionID) +',N'''+ REPLACE(OptionName,'''', '''''') + ''',0,NULL,1,N''00000000-0000-0000-0000-000000000000'',NULL,NULL)


Insert Into SetUpValues  (CategoryID, OptionID, OptionName, OptionValue, Status, DateCreated, DateModified, StoreID)
SELECT 2,' +CONVERT(nvarchar(50),OptionID) +', ''' + REPLACE(OptionName,'''', '''''') + ''', ''' + OptionValue + ''', 1, dbo.GetLocalDATE(), dbo.GetLocalDATE(), StoreID From Store Where StoreID NOT IN (SELECT StoreID From SetUpValues  where OptionID = '+ CONVERT(nvarchar(50),OptionID) +' )


' AS A, '' AS B,0 AS Sort
from SetupValues   
where 1=1
and StoreID = '00000000-0000-0000-0000-000000000000'

UNION
SELECT 
'IF NOT Exists (SELECT 1 From SystemValues  Where SystemValueNo = '+ CONVERT(nvarchar(50),SystemValueNo) + ' and SystemValueName = ''' + SystemValueName +''' and SystemTableNo = ' + CONVERT(nvarchar(50),SystemTableNo) + ')
INSERT INTO SystemValues  (SystemValueNo, SystemValueName, SortOrder, SystemTableNo, DateModified)
Values  (' +CONVERT(nvarchar(50),SystemValueNo) +','''+ SystemValueName + ''', '+ CONVERT(nvarchar(50),SortOrder) + ', ' + CONVERT(nvarchar(50),SystemTableNo) +', dbo.GetLocalDATE())


' AS A, '' AS B,1  AS Sort
FROM            SystemValues 

UNION
SELECT 
'IF NOT Exists (SELECT 1 From SystemTables  Where SystemTableId = '+ CONVERT(nvarchar(50),SystemTableId) + ' and SystemTableName = ''' + SystemTableName + ''')
INSERT INTO SystemTables  (SystemTableId, SystemTableName)
Values  (' +CONVERT(nvarchar(50),SystemTableId) +','''+ SystemTableName  + ''')


' AS A, '' AS B,2  AS Sort
FROM            SystemTables 


--UNION
--Select '
   
--delete from [Country]' AS A, '' AS B,2 AS Sort
--union select '
--insert into [Country](ContryName)
--Values  ('''+ ContryName + ''')' AS A, '' AS B,3 AS Sort from  Country

UNION
Select '       
delete from [State]' AS A, '' AS B,4 AS Sort 
union select '
         insert into [State](StateCode,StateName) Values ('''+ StateCode+''',''' +StateName + ''')' AS A, '' AS B,5 AS Sort from  [State]  
union
select '  
delete from [ZipCodes]' AS A, '' AS B,6 AS Sort 
Union select '
         insert into [ZipCodes](ZipCode,City,StateID) Values ( '''+ ZipCode+''',''' +REPLACE(City,'''','''''')+''',''' +StateID+''')' AS A, '' AS B,7 AS Sort  from  [ZipCodes]  where City is not NULL 
Union 
select '  
delete from [GridColumnsNotVisible] ' AS A, '' AS B,8 AS Sort 
union select '
        insert into [GridColumnsNotVisible](ID,GridNumber,FieldName) Values ('+ convert(nvarchar(50),ID) +','+convert(nvarchar(50),GridNumber) + ',''' + FieldName+ ''')' AS A, '' AS B,9 AS Sort  from  [GridColumnsNotVisible]     
union 
select '
delete from  [GridColumnsCaptions]' AS A, '' AS B,10 AS Sort 
union select '
         insert into [GridColumnsCaptions](ID,GridNumber,FieldName,FieldCaption) Values (' + + convert(nvarchar(50),ID) +','+convert(nvarchar(50),GridNumber) + ',''' + FieldName+ ''', ''' +FieldCaption+''')' AS A, '' AS B,11 AS Sort  from  [GridColumnsCaptions]    
union
select ' 
delete from  [SystemTables] ','',12 AS Sort  union select '
        insert into [SystemTables](SystemTableId,SystemTableName) Values ('+ convert(nvarchar(50),SystemTableId) +','''+SystemTableName+''')' AS A, '' AS B,13 AS Sort  from  [SystemTables]
union
select '     
delete from  [SystemValues ]   ' AS A, '' AS B,14 AS Sort 
union select '
      insert into [SystemValues ](SystemValueNo,SystemValueName,SortOrder,SystemTableNo,DateModified) Values ('+ convert(nvarchar(50),SystemValueNo) +',''' + SystemValueName + ''',' +convert(nvarchar(50),SortOrder) +',' + convert(nvarchar(50),SystemTableNo) + ',''' + convert(nvarchar(50),ISNULL(DateModified,GETDATE())) +''')' AS A, '' AS B,15 AS Sort  from  [SystemValues]     
union
select '
delete from [TtTransferData]' AS A, '' AS B,16 AS Sort 
union select '
         insert into [TtTransferData](TableName) Values ( '''+ TableName+ ''')' AS A, '' AS B,17 AS Sort  from  [TtTransferData]     
union
select '
delete from [DefaultPrintLabelLayout] ' AS A, '' AS B,18 AS Sort 
union select '
        insert into [DefaultPrintLabelLayout](PrintLabelLayoutID,LayoutName,LayoutContent,PrinterType) 
Values ( ''' + convert(nvarchar(50),PrintLabelLayoutID) +''',''' + LayoutName +''',''' + CONVERT(VARCHAR(MAX),LayoutContent) + ''',' + convert(nvarchar(50),PrinterType) +')' AS A, '' AS B,19 AS Sort  from  [DefaultPrintLabelLayout]     
union
select '
delete from  [StatsMain]' AS A, '' AS B,20 AS Sort 
union select '
 insert into [StatsMain] (StatId,StatDescription,StatSqlBegin,StatSql,StatSqlEnd,status,FormatType,Icon,Grid,DateCreated,DateModified)
 Values ('+ CONVERT(nvarchar(50),StatId) +','''+ StatDescription +''', ' +CASE WHEN StatSqlBegin IS NOT NULL THEN '''' + replace(StatSqlBegin,'''','''''') + '''' ELSE 'NULL' END + ',' +CASE WHEN StatSql IS NOT NULL THEN '''' + replace(StatSql,'''','''''') + '''' ELSE 'NULL' END + ','+ CASE WHEN StatSqlEnd IS NOT NULL THEN '''' + replace(StatSqlEnd,'''','''''') + '''' ELSE 'NULL' END + ','+ convert(nvarchar(50),status) +',' + convert(nvarchar(50),FormatType) + ',' + CASE WHEN Icon is not null then convert(nvarchar(50),Icon) else 'NULL' END + ',' + CASE when Grid IS NOT NULL THEN convert(nvarchar(50),Grid) ELSE 'NULL' END + ',GETDATE(),GETDATE())' AS A, '' AS B ,21 AS Sort 
 from  [StatsMain]     
-- union 
-- select '
--delete from [StatsUsers] ' AS A, '' AS B,22 AS Sort 
--union SELECT '
--Insert Into StatsUsers (StatId,StatDateType,StatDateCount,DateModified) Values(' +convert(nvarchar(5),StatId)+','+convert(nvarchar(5),StatDateType)+','+convert(nvarchar(5),StatDateCount)+',dbo.GetLocalDate())'  AS A, '' AS B ,23 AS Sort  from StatsUsers  Where UserId is null
-- union
-- select 'Delete From GridsLayouts' AS A, '' AS B, 25 AS Sort
-- Union
-- select '
--INSERT INTO GridsLayouts (LayoutName, LayoutFileName, LayoutXMLContent) Values ( '''+LayoutName+''','''+ LayoutFileName+''',''' AS A,  convert(varchar(max),LayoutXMLContent)+ ''')
--' AS B, 26 AS Sort
--from GridsLayouts
union
select ' Delete From ReportsTable ' AS A, '' AS B, 27 AS Sort
union Select '
Insert Into [ReportsTable]([ReportName] ,[ReportDescription] ,[ReportSection],[ReportDll],[Status],[SortOrder],[ReportType],[Handlers],[Icon]) VALUES (''' + [ReportName]+''' ,'''+[ReportDescription]+''' ,'''+ [ReportSection]+''' ,' + CASE When [ReportDll]IS NOT NULL THEN ''''+ [ReportDll] +'''' ELSE 'NULL' END+  ' ,'+convert(nvarchar(1),[Status])+','+CASE When [SortOrder] IS NOT NULL THEN convert(nvarchar(5),[SortOrder]) ELSE 'NULL' END +' ,' + CASE When [ReportType] IS NOT NULL THEN ''''+ [ReportType] +'''' ELSE 'NULL' END+  ' ,'+ CASE When [Handlers] IS NOT NULL THEN ''''+ [Handlers]  +'''' ELSE 'NULL' END+  ' ,'+ CASE When [Icon] IS NOT NULL THEN ''''+ [Icon] +'''' ELSE 'NULL' END + ')' AS A, '' AS B, 28 AS Sort
  FROM [dbo].[ReportsTable]
  --union
  --select ' Delete From RegisterKeys ' AS A, '' AS B, 29 AS Sort
--union
--  select'
--insert into RegisterKeys (ActionID,ActionKey,DateCreated,DateModified,IsAction,IsButton,RegisterKeyID,ShiftType,Status)
--Values (' +convert(nvarchar(5),ActionID) + ', '+ convert(nvarchar(5),ActionKey) +', dbo.GetLocalDate(),dbo.GetLocalDate(),' +convert(nvarchar(5),IsAction) + ',' +convert(nvarchar(5),IsButton) +',' +convert(nvarchar(5),RegisterKeyID) +',' + convert(nvarchar(5),ShiftType) +',' + convert(nvarchar(5),Status) + ')' AS A, '' AS B, 30 AS Sort from dbo.RegisterKeys
union
 select 'GO ' AS A,'' AS B, 33 AS Sort

union
 select 'Exec SP_RunStatsMain ' AS A,'' AS B, 34 AS Sort

union
 select 'Update SetupValues Set OptionValue = ''00000000-0000-0000-0000-000000000000'' Where OptionID = 796 and OptionValue = ''0'' ' AS A,'' AS B, 35 AS Sort
 ) AS AA
 Order By Sort
GO