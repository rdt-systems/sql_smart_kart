SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerTasksHistoryDelete]
(@TaskID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.CustomerTasks

 SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE TaskID =@TaskID
GO