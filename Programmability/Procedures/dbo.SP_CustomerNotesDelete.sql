SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerNotesDelete]
(@NoteID uniqueidentifier,
@CustomerID uniqueidentifier =null,
@ModifierID uniqueidentifier)
AS 
UPDATE dbo.CustomerNotes
                   
 SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE  NoteID=@NoteID
GO