SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SeasonEntryInsert]
(@SeasonEntryId uniqueidentifier,
@SeasonNo uniqueidentifier,
@StartDate datetime,
@EndDate smallint,
@ModifierID  uniqueidentifier)
AS INSERT INTO dbo.SeasonEntry
                      (SeasonEntryId, SeasonNo, StartDate, EndDate, Status,DateCreated, UserCreated, DateModified,  UserModified)
VALUES     (@SeasonEntryId, @SeasonNo, @StartDate, @EndDate, 1, dbo.GetLocalDATE(),@ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO