SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RegistersDelete]
(@RegisterID uniqueidentifier,
@ModifierID uniqueidentifier)

as update  registers set
Status=-1,
DateModified=dbo.GetLocalDATE(),
UserModified=@ModifierID

where RegisterID=@RegisterID
GO