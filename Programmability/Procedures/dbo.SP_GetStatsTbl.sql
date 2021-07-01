SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetStatsTbl]  
(@StatsIds nvarchar(100),  
@userId  uniqueidentifier,
@First bit = 0,  
@StoreId  uniqueidentifier)  
as   

declare @vStatId VARCHAR(20)
declare @StatId int   
If @First = 0
BEGIN
 DECLARE cInfo CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
 SELECT 
     Split.a.value('.', 'VARCHAR(100)') AS Data  
 FROM  
 (
   SELECT CAST ('<M>' + REPLACE(@StatsIds, ',', '</M><M>') + '</M>' AS XML) AS Data  
 ) AS A CROSS APPLY Data.nodes ('/M') AS Split(a); 
  SET NOCOUNT ON;
OPEN cInfo
FETCH NEXT FROM cInfo
INTO @vStatId
WHILE @@FETCH_STATUS = 0
begin
if @vStatId<>'' 
BEGIN
  print 'ABC '+ @vStatId
  set @StatId =CAST(@vStatId AS INT)
  exec SP_RunStatsMain @userId=@userid,@statIdParam=@StatId,@StoreIDParam=@StoreId
END   
FETCH NEXT FROM cInfo   
		INTO @vStatId
	END
CLOSE cInfo
DEALLOCATE cInfo
end
declare @Str nvarchar(4000)  
set @str=   'select StatsResults.StatId,StatsMain.StatDescription,isnull(StatsResults.StatsResult,0) as StatsResult,StatsUsers.StatDateCount,StatsMain.FormatType,StatsUsers.StatDateType,StatsResults.DateModified,StatsMain.Icon,StatsUsers.UserId,StatsMain.
Grid  
     from StatsResults join StatsMain on StatsMain.StatId =StatsResults.StatId join StatsUsers on StatsUsers.StatId=StatsMain.StatId   
     and isnull(StatsUsers.Userid,convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000''))=isnull(StatsResults.Userid, convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000''))   
     where StatsResults.StatId in ('+ @StatsIds +')  
     and (StatsResults.UserId is null or StatsResults.UserId ='''+convert(varchar(50),@userId)+ ''')'+  
     'and isnull(StatsResults.StoreId,convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000''))='''+  
     +convert(varchar(50),@StoreId)+''''  
    
  print  @str    
  
exec (@str)
GO