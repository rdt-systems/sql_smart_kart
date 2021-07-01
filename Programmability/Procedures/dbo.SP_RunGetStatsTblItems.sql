SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_RunGetStatsTblItems]
(@StatId int,
@userId  uniqueidentifier,
@StoreId  uniqueidentifier)
as 

begin 
declare @result1 table (Items uniqueidentifier)

declare @sql2 varchar(4000)
declare @sql3 varchar(4000)
declare @dbName varchar(50)
--set @dbName = DB_NAME()
set @dbName = 'MyItems'+convert(varchar(20),NEXT VALUE FOR MyItemID)

WHILE (Select COUNT(1) from sys.tables where name = @dbName) > 0
BEGIN
set @dbName = 'MyItems'+convert(varchar(20),NEXT VALUE FOR MyItemID)
END


EXEC [dbo].[SP_GetStatsTblItems]
		@StatsId = @Statid,
		@userId = @UserId,
		@StoreId = @StoreId,
		@Tablename = @dbName

--set @sql2 ='''set fmtonly off 
--SET NOCOUNT ON
-- EXEC ['+@dbName+'].dbo.[SP_GetStatsTblItems] @StatsId=' + convert(varchar(50),@Statid)+' ,@userId='''''+convert(varchar(50),@UserId)+''''',@StoreId='''''+convert(varchar(50),@StoreID)+'''''    WITH RESULT SETS (
--  (
--    ItemId uniqueidentifier
--  )
--)' 

--print @sql2



create table #TempItems(ItemStoreId uniqueidentifier)
set @sql3= 'INSERT INTO #TempItems select * from '+@dbName
exec (@sql3)
set @sql3= 'DROP TABLE '+@dbName
exec (@sql3)

--set @sql3= 'INSERT INTO #TempItems
--SELECT * FROM OPENROWSET (''SQLOLEDB'',''Server=(local);TRUSTED_CONNECTION=YES;'','+@sql2 +''')'
--print @sql3
--exec (@sql3)

select * from #TempItems
end
GO