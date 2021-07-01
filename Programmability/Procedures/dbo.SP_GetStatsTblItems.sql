SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*

    Open DBDiff 0.9.0.0
    http://opendbiff.codeplex.com/

    Script created by CUSTOMERSUPPORT\Moshe Freund on 7/3/2018 at 2:44:52 PM.

    Created on:  CUSTOMERSUPPORT
    Source:      SmartKart on rdt-cloud.database.windows.net,1433
    Destination: Temp_Regular on rdt-cloud.database.windows.net,1433

*/

CREATE procedure [dbo].[SP_GetStatsTblItems]
(@StatsId int,
@userId  uniqueidentifier,
@StoreId  uniqueidentifier,
@TableName nvarchar(50))
as 


declare @Str nvarchar(4000)
declare @IsMainStore bit=0


select @IsMainStore=isnull(IsMainStore,0)
from Store 
where StoreID=@StoreId 


set @str='select @strA=
replace(
case when exists (select 1 from  StatsUsers s where s.StatId='''+convert(varchar(50),@StatsId)+''' and s.UserId='''+convert(varchar(50),@userId)+''') then 
replace (StatsMain.StatSql,''and StatsUsers.userId is null'',''and StatsUsers.userId='''''+convert(varchar(50),@userId)+''''''')
else StatsMain.StatSql end
,''and Store.StoreId is null'' ,''and Store.StoreId='''''+convert(varchar(50),@StoreId)+''''''')
from  StatsMain join StatsUsers on StatsUsers.StatId=StatsMain.StatId 
where StatsMain.StatId ='+convert(varchar(50),@StatsId)+''


if @IsMainStore = 1
begin  
	print @str 
	print      '     '
	set @str =REPLACE(@str,'and Store.StoreId is null','and Store.StoreId =Store.StoreId')
	print      '     '
end



if exists (select 1 from  StatsUsers s where s.StatId=@StatsId and s.UserId=@userId)
begin 
	set @str =@str+ ' and StatsUsers.UserId='''+convert(varchar(50),@userId)+''''
end
else
begin 
	set @str =@str+ ' and StatsUsers.UserId  is null ' 
end
 print @str
declare @str1 varchar(4000)	
exec sp_executesql @str, N'@strA varchar(4000) output', @str1 output;
--print 'A4.1' 
print @str1
--print 'A4.2' 


--set @str1 =REPLACE (@str1,'and  Store.StoreId  is null','and Store.StoreId='''+convert(varchar(50),@StoreId)+'''')
--print @str1

--if @IsMainStore = 1
--begin
--    print 'A5' 
--	print @str1 
--	print      '     '
--	set @str1 =REPLACE(@str1,'and Store.StoreId is null','and Store.StoreId =Store.StoreId')
--	print      '     '
--end

--print 'AA'
--print @str1
--exec (@str1);

declare @str2 nvarchar(4000)
SET @str2=' IF EXISTS (select * from sys.tables where name = ''' + @TableName + ''') DROP TABLE '+@TableName +' CREATE TABLE '+@TableName +'(Items uniqueidentifier NULL) insert into '+@TableName +' (Items) ('+@str1+')'
exec(@str2)
print 'BB'
print @str2 

print 'CC'


--declare @result table (Items uniqueidentifier);
--insert into @result (Items)
--exec (@str1);



--EXEC [Develop].dbo.[SP_GetStatsTblItems] @StatsId=5 ,@userId='D224F3EA-717A-4D96-9215-98664579974C',@StoreId='308B80A6-EA16-41EF-928B-FA5FF0C17DD5'
GO