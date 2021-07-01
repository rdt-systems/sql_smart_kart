SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SeasonDelete]

(@SeasonId uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
if 
(select count(*) 
from dbo.[ItemMain]
where SeasonID = @SeasonId) = 0
begin

UPDATE  dbo.Season
 
  SET                       
           status = -1 , DateModified =dbo.GetLocalDATE(), UserModified =@ModifierID

 WHERE  SeasonId = @SeasonId

end
GO