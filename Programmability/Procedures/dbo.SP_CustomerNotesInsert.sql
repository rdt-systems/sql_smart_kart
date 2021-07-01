SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerNotesInsert]
(@NoteID uniqueidentifier,
@CustomerID uniqueidentifier,
@TypeOfNote int,
@NoteValue ntext,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.CustomerNotes
                     (NoteID,    CustomerID,    TypeOfNote,    NoteValue, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@NoteID, @CustomerID, @TypeOfNote,@NoteValue, 1,          dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO