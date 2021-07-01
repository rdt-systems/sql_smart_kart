SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[CustomerNotesView]
AS
SELECT     NoteID, CustomerID, TypeOfNote, NoteValue, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.CustomerNotes
GO