SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemNotesInsert]
(@NoteID uniqueidentifier,
@TypeOfNote int,
@ItemStoreNo uniqueidentifier,
@NoteValue ntext,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.ItemNotes
                      (NoteID, TypeOfNote, ItemStoreNo, NoteValue, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@NoteID, @TypeOfNote, @ItemStoreNo, @NoteValue, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO