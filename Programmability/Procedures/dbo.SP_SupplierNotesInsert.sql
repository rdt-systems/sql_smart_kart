SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierNotesInsert]
(@NoteID uniqueidentifier,
@SupplierID uniqueidentifier,
@TypeOfNote int,
@NoteValue ntext,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.SupplierNotes
                     (NoteID,    SupplierID,    TypeOfNote,    NoteValue, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@NoteID, @SupplierID, @TypeOfNote,@NoteValue, 1,          dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO