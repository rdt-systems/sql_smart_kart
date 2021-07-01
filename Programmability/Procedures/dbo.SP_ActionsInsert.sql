SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ActionsInsert]

(@ActionID uniqueidentifier,
@BatchID uniqueidentifier,
@ActionType int,
@ActionDate datetime,
@UserID uniqueidentifier,
@TransactionID uniqueidentifier,
@RegisterID uniqueidentifier,
@ActionSum decimal,
@Status smallint,
@ModifierID uniqueidentifier)

AS

insert into dbo.Actions (ActionID,BatchID,ActionType,ActionDate,UserID,TransactionID,RegisterID,ActionSum,
			Status,DateCreated,UserCreated,DateModified,UserModified)
	values		(@ActionID,@BatchID,@ActionType,@ActionDate,@UserID,@TransactionID,@RegisterID,@ActionSum,
			1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO