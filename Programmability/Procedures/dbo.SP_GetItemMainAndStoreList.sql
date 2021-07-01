SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemMainAndStoreList]
(
@StoreID uniqueidentifier,
@DeletedOnly bit =0,
@DateModified datetime=null,
@FromStatus as Int = -1,
@ID uniqueidentifier=null,
@PageIndex int = 0,
@NumRows Int = 100000,
@Filter nvarchar(4000)='',
@StatParam nvarchar(4000)='',
@Statid Int=null,
@UserId uniqueidentifier=null,


@refreshTime  datetime output)
AS
 DECLARE @Select nvarchar(2000),@Select1 nvarchar(2000) 
 DECLARE @F  nvarchar(2000)
 DECLARE @sStoreID  nvarchar(60),@sDate nvarchar(20)
 SET @sStoreID  =@StoreID 
if @DateModified is not null  
   SET @sDate  =''''+dbo.FormatDateTime(@DateModified,'YYYY-MM-DD')+' '+dbo.FormatDateTime(@DateModified,'HH:MM 24')+''''

 IF @Filter <>''
   SET @F= @Filter   
 set @refreshTime = dbo.GetLocalDATE()

IF NOT EXISTS(SELECT 1 FROM ItemStore Where ItemStoreID = @ID)
SELECT @ID = ItemStoreID From ItemStore Where ItemNo = @ID and StoreNo = @StoreID

DECLARE @startRowIndex INT
SET @startRowIndex = (@PageIndex * @NumRows)+1;
PRINT 'LINE 1'
IF @ID IS NOT NULL
BEGIN 
PRINT 'SELECT 1'
	   SELECT     dbo.ItemMainAndStoreList.*
	   FROM         dbo.ItemMainAndStoreList
	   WHERE     (Status >@FromStatus ) AND (StoreNo = @StoreID)AND(ItemStoreID=@ID) AND (ItemStoreDateModified>=isnull(@DateModified,ItemStoreDateModified)  OR MainDateModified >=isnull(@DateModified,MainDateModified) OR DepartmentDateModified >=isnull(@DateModified,DepartmentDateModified)
                                   OR GroupDateModified>=isnull(@DateModified,GroupDateModified))
   RETURN
END 
PRINT 'LINE 2'
if @DateModified is null 
begin
PRINT 'SELECT 2'
     SET @Select1 ='SELECT  * FROM Page WHERE Row BETWEEN '+CONVERT(nvarchar, @startRowIndex, 110)+'  AND '+CONVERT(nvarchar, @StartRowIndex+ @NumRows-1, 110) 
	 set @Select ='With Page as (	SELECT     ROW_NUMBER() OVER (Order By DateCREATEd Asc) AS Row, 
		         dbo.ItemMainAndStoreList.*
			FROM         dbo.ItemMainAndStoreList
			WHERE  (StoreNo = '''+@sStoreID+''') AND   
			 (Status> '+CONVERT(nvarchar, @FromStatus, 110)+') AND (MainStatus>-1)'
			 
PRINT 'LINE 3'
if @Statid is not null

begin 
declare @result1 table (Items uniqueidentifier)

declare @sql2 varchar(4000)
declare @sql3 varchar(4000)
declare @dbName varchar(50)
set @dbName = 'MyItems'+convert(varchar(20),NEXT VALUE FOR MyItemID)
PRINT 'LINE 4'

EXEC [dbo].[SP_GetStatsTblItems]
		@StatsId = @Statid,--'5895EFF5-E2EF-4B99-9B29-B843AA76F23E',
		@userId = @UserId,
		@StoreId = @StoreId,
		@Tablename = @dbName


--set @sql2 ='''set fmtonly off 
--SET NOCOUNT ON
-- EXEC ['+@dbName+'].dbo.[SP_GetStatsTblItems] @StatsId=' + convert(varchar(50),@Statid)+' ,@userId='''''+convert(varchar(50),@UserId)+''''',@StoreId='''''+convert(varchar(50),@StoreID)+'''''    WITH RESULT SETS (
--  (
--    ItemStoreId uniqueidentifier
--  )
--)' 

--print @sql2
PRINT 'LINE 5'
create table #TempItems(ItemStoreId uniqueidentifier)
set @sql3= 'INSERT INTO #TempItems select * from '+@dbName
exec (@sql3)
set @sql3= 'DROP TABLE '+@dbName
exec (@sql3)
PRINT 'LINE 6'
--set @sql3= 'INSERT INTO #TempItems
--SELECT * FROM OPENROWSET (''SQLOLEDB'',''Server=(local);TRUSTED_CONNECTION=YES;'','+@sql2 +''')'
--print @sql3
--exec (@sql3)
PRINT 'LINE 7'
set @select=@select +' and ItemStoreID in ( '+ 'select * from #TempItems)'
end

  print @Select +@F +')'+  + @Select1      
  exec(@Select +@F +')'+  @Select1)  
  PRINT 'LINE 8'

	  SET @RefreshTime = dbo.GetLocalDATE()  
      return  set @refreshTime = dbo.GetLocalDATE()

end 

PRINT 'LINE 9'
if  @DeletedOnly=0 
BEGIN 
PRINT 'SELECT 3'
 set @Select =' With Page as (SELECT     ROW_NUMBER() OVER (Order By DateCREATEd Asc) AS Row, 
		         dbo.ItemMainAndStoreList.ItemStoreID 
			FROM         dbo.ItemMainAndStoreList
			WHERE  (StoreNo = '''+@sStoreID+''') AND   (Status> 0) AND (MainStatus>-1)'--)
SET @Select1 ='	SELECT     Page.Row ,ItemMainAndStoreList.*
            FROM  ItemMainAndStoreList INNER JOIN Page ON ItemMainAndStoreList.ItemStoreID = Page.ItemStoreID  
            WHERE Row BETWEEN '+CONVERT(nvarchar, @startRowIndex, 110)+'  AND '+CONVERT(nvarchar, @StartRowIndex+ @NumRows-1, 110)+' AND    	
			(StoreNo = '''+@sStoreID+''') AND   
			(ItemStoreDateModified>='+@sDate+'  OR MainDateModified >='+@sDate+' OR DepartmentDateModified >='+@sDate+' OR GroupDateModified>='+@sDate+')AND 
	        (Status> '+CONVERT(nvarchar, @FromStatus, 110)+')'
PRINT 'LINE 10'
  --exec(@Select +@F )
   exec(@Select +@F +')'+  @Select1)  
  print @Select +@F +')'+  @Select1 
   return  set @refreshTime = dbo.GetLocalDATE()

			
END
ELSE 
BEGIN
PRINT 'SELECT 4'
	SELECT     dbo.ItemMainAndStoreList.*
	FROM         dbo.ItemMainAndStoreList
	WHERE     (StoreNo = @StoreID) 
	AND (ItemStoreDateModified>=@DateModified  OR MainDateModified >=@DateModified OR DepartmentDateModified >=@DateModified
	                                       OR GroupDateModified>=@DateModified)
                AND  (MainStatus= - 1   OR  Status = - 1)
 Print 'ELSE BEGIN'
                
END
GO