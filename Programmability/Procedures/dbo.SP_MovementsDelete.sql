SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_MovementsDelete]
(@ActionType int,
@ModifierID uniqueidentifier)
as
UPDATE [dbo].[Movements]
   SET [Status] = -1,
		DateModified=dbo.GetLocalDATE(),
		userModified=@ModifierID

WHERE [ActionType] = @ActionType
GO