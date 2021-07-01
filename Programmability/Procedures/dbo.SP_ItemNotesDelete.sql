SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemNotesDelete]
	@NoteID uniqueidentifier,
	@ModifierID uniqueidentifier
AS
update dbo.ItemNotes
set Status = -1, DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
where NoteID = @NoteID
GO