SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CustomerMessageDelete]
(@CustomerMessageID uniqueidentifier,
@ModifierID uniqueidentifier)
AS

update  customermessage

set 	
	Status=-1,
	DateModified= dbo.GetLocalDATE(),
	UserModified=@ModifierID

where  (CustomerMessageID=@CustomerMessageID)
GO