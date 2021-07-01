SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ActionsUpdate]

(@ActionID uniqueidentifier,
@BatchID uniqueidentifier,
@ActionType int,
@ActionDate datetime,
@UserID uniqueidentifier,
@TransactionID uniqueidentifier,
@RegisterID uniqueidentifier,
@ActionSum decimal,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

update dbo.Actions
set	BatchID=@BatchID,
	ActionType=@ActionType,
	ActionDate=@ActionDate,
	UserID=@UserID,
	TransactionID=@TransactionID,
	RegisterID=@RegisterID,
	ActionSum=@ActionSum,
	Status=@Status,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
where	ActionID=@ActionID and (datemodified=@DateModified or @DateModified is null)
GO