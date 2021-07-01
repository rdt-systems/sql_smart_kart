SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRecentActivity] (@FromDate datetime=null ,@ToDate datetime=null ,@StoreId uniqueidentifier=null)


AS

  
 

if @FromDate is null 
begin 
set @FromDate = CONVERT(DATE,  getDate()-1 ) 
end

if @ToDate  is null
begin 
set @ToDate = getDate()+1
end

select *
from RecentActivityview
where DateModified >=@FromDate
and DateModified <= @ToDate
and (@StoreId is null or RecentActivityview.StoreId=@StoreId OR RecentActivityview.StoreId IS null )
GO