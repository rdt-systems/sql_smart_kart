SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerNotesUpdate]
(@NoteID uniqueidentifier,
@CustomerID uniqueidentifier,
@TypeOfNote int,
@NoteValue ntext,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.CustomerNotes
                   
SET       CustomerID=@CustomerID,TypeOfNote= @TypeOfNote,NoteValue=@NoteValue,Status=@Status, DateModified=@UpdateTime

,UserModified=@ModifierID


WHERE  (NoteID=@NoteID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO