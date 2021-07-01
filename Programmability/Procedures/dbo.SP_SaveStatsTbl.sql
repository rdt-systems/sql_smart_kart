SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_SaveStatsTbl]
(@StatsId int ,@StatDateCount int ,@StatDateType int,@UserId uniqueidentifier,@StoreID uniqueidentifier)
as 


if (select count(*)
from StatsUsers
where  StatsUsers.StatId =@StatsId 
and UserId =@UserId)>0

begin 

update StatsUsers 
set StatsUsers.StatDateCount=@StatDateCount ,StatsUsers.StatDateType =@StatDateType ,DateModified = dbo.GetLocalDate()
where StatsUsers.StatId =@StatsId 
and UserId =@UserId
end
else
begin 
insert into  StatsUsers (StatId,StatDateCount,StatDateType,DateModified,UserId)values(@StatsId,@StatDateCount ,@StatDateType , dbo.GetLocalDate(),@UserId)
end

exec [SP_RunStatsMain] @StatsId,@UserId,@StoreID

exec [SP_GetStatsTbl] @StatsId,@UserId,1,@StoreID
GO