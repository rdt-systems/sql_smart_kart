SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create Procedure [dbo].[SP_SearchFullName]
AS


PRINT 'SearchFullName'

if (select SERVERPROPERTY('IsFullTextInstalled')) =1
IF (NOT EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[SearchItemByName]') AND [type]='P'))
BEGIN
Declare @DBName nvarchar(100), @Quary1 nvarchar(4000), @Quary2 nvarchar(4000), @Quary3 nvarchar(4000)
SELECT @DBName = DB_NAME()
SET @Quary1 = 'CREATE FULLTEXT CATALOG [' + @DBName + ']'
SET @Quary2 ='CREATE FULLTEXT INDEX ON [' + @DBName + '].dbo.ItemMain(Name)   
   KEY INDEX PK_ItemMain   
  ON [' + @DBName + ']'

SET @Quary3 = 'CREATE  procedure [dbo].[SearchItemByName]
(
	@Name nvarchar(4000),
	@StoreID uniqueidentifier
)
AS
BEGIN
	Set @Name = ''"*'' + @Name + ''*"''

	   	Select ItemID From 
		ItemMain im inner join ItemStore i on i.ItemNo = im.ItemID
		Where i.Status > 0 and  Contains(Name,  @Name) AND im.Status > 0 AND StoreNo = @StoreID 

END'
PRINT @Quary1
Exec sp_executesql @Quary1
PRINT @Quary2
Exec sp_executesql @Quary2
PRINT @Quary3
Exec sp_executesql @Quary3
END
GO