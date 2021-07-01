SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_ComputersDelete]
(@ComputerID uniqueidentifier,
@ModifierID uniqueidentifier)
as
	update Computers
	Set 	Status=-1,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	where 	(ComputerID=@ComputerID)
GO