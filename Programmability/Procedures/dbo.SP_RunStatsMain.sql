SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_RunStatsMain]  (@statIdParam int =null, @UserId uniqueidentifier=null,@StoreIDParam uniqueidentifier =null)

As 



DECLARE @UpdateText varchar(8000)
DECLARE @userIdR uniqueidentifier
declare @StoreID uniqueidentifier
declare @IsMainStore bit
DECLARE @StatId int

DECLARE @sql1 nvarchar(4000)
DECLARE @sql2 nvarchar(4000)
DECLARE cUpdates CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
 select StatsMain.StatId,isnull(StatSqlBegin,'')+ statsql  +isnull(StatSqlEnd,''),StatsUsers.UserId,Store.StoreID,isnull(Store.IsMainStore,0)as IsMainStore
from StatsMain  join StatsUsers on StatsMain.StatId =StatsUsers.StatId  join Store on store.Status>0
 where StatsMain.status=1
 and StatsMain.statId = isnull(@statIdParam,StatsMain.statId)
  and Store.StoreID = isnull(@StoreIDParam,Store.StoreID)
 and  StatsUsers.userId is null
 union all
 select StatsMain.StatId, isnull(StatSqlBegin,'')+ statsql  +isnull(StatSqlEnd,'') ,StatsUsers.UserId,Store.StoreID,isnull(Store.IsMainStore,0)as IsMainStore
from StatsMain  join StatsUsers on StatsMain.StatId =StatsUsers.StatId  join Store on store.Status>0
 where StatsMain.status=1
 and StatsMain.statId = isnull(@statIdParam,StatsMain.statId)
 and  StatsUsers.userId =isnull(@UserId,StatsUsers.userId ) 
   and Store.StoreID = isnull(@StoreIDParam,Store.StoreID)
 order by StatId desc
 SET NOCOUNT ON;

OPEN cUpdates

FETCH NEXT FROM cUpdates
INTO @StatId,@UpdateText,@userIdR,@StoreID,@IsMainStore

WHILE @@FETCH_STATUS = 0

begin


print @StatId

if @userIdR is not null 
begin 
set @UpdateText= replace(@UpdateText,'and StatsUsers.userId is null','and StatsUsers.userId ='''+convert(varchar(50),@userIdR)+'''')
end

--print @UpdateText

if @IsMainStore=0
begin 
set @UpdateText= replace(@UpdateText,'and Store.StoreId is null','and Store.StoreId ='''+convert(varchar(50),@StoreID)+'''')
end
else 
begin 
set @UpdateText= replace(@UpdateText,'and Store.StoreId is null','and Store.StoreId =Store.StoreId')
end
--print @UpdateText

begin 
set @UpdateText= replace(@UpdateText,'and  Store.StoreId  is null','and Store.StoreId ='''+convert(varchar(50),@StoreID)+'''')
end

--print @UpdateText



set @sql1= ('begin 
			if (select count(*) from  StatsResults where StatsResults.StatId =' + convert(varchar(20),@StatId)+' and StatsResults.UserId is null 
 and  StatsResults.StoreId is null
			)=0 
			begin 
			insert into StatsResults (StatId,StatsResult,status,DateCreated,DateModified,UserId,StoreId) values(' + convert(varchar(20),@StatId) +',0,1,dbo.GetLocalDate(),dbo.GetLocalDate(),'+
			case when @userIdR is not null then ''''+convert(varchar(50),@userIdR)+'''' else 'null' end +','+''''+convert(varchar(50),@StoreID)+''''  +')
			end 
			end ')

if @userIdR is not null 
begin 
set @sql1= replace(@sql1,'and StatsResults.userId is null','and StatsResults.userId ='''+convert(varchar(50),@userIdR)+'''')
end

--if @IsMainStore=0
begin 
set @sql1= replace(@sql1,'and  StatsResults.StoreId is null','and StatsResults.StoreId ='''+convert(varchar(50),@StoreID)+'''')
end

print @sql1 
Exec (@sql1)

	set @sql2 = ('update  StatsResults set StatsResult =('+@UpdateText+') , DateModified =dbo.GetLocalDate()  where StatsResults.StatId =' + convert(varchar(20),@StatId) +' and StatsResults.UserId is null  
	and StatsResults.StoreId is null '   )
if @userIdR is not null 
begin 
set @sql2= replace(@sql2,'and StatsResults.userId is null','and StatsResults.userId ='''+convert(varchar(50),@userIdR)+'''')
end


begin 

set @sql2= replace(@sql2,'and StatsResults.StoreID is null','and StatsResults.StoreID ='''+convert(varchar(50),@StoreID)+'''')
end
declare @da datetime
set @da =dbo.GetLocalDate()
			print @sql2
	        EXECUTE  sp_executesql @statement=@sql2--, @params=''

			--PRINT 'GO' 
print convert(varchar, dbo.GetLocalDate()-@da, 114) 

		FETCH NEXT FROM cUpdates   
		INTO @StatId,@UpdateText,@userIdR,@StoreID,@IsMainStore

	END

CLOSE cUpdates
DEALLOCATE cUpdates


If @statIdParam IS NULL
Delete from RecentActivity Where DateModified < dbo.GetLocalDate() -1.5
GO