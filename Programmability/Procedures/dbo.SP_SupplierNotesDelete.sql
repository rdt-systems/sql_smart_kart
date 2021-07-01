SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierNotesDelete]
(@NoteID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.SupplierNotes
                   
 SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE  NoteID=@NoteID
GO