SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[CustomerNotesPOS]
AS
SELECT     DateModified, NoteID, CustomerID, TypeOfNote, NoteValue, Status
FROM         dbo.CustomerNotes
WHERE     (Status > 0) AND ((TYPEOFNOTE=2) OR (TYPEOFNOTE=4))
GO