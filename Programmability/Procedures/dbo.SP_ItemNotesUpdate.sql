SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemNotesUpdate]
(@NoteID uniqueidentifier,
@TypeOfNote int,
@ItemStoreNo uniqueidentifier,
@NoteValue ntext,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


update dbo.ItemNotes
set TypeOfNote = @TypeOfNote,
	ItemStoreNo = @ItemStoreNo,
	NoteValue = @NoteValue,
 	DateModified = @UpdateTime,
	UserModified = @ModifierID 

where (NoteID = @NoteID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO