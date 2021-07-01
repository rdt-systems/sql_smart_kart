SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierNotesUpdate]
(@NoteID uniqueidentifier,
@SupplierID uniqueidentifier,
@TypeOfNote int,
@NoteValue ntext,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.SupplierNotes
                   
SET       SupplierID =@SupplierID ,TypeOfNote= @TypeOfNote,NoteValue=@NoteValue,Status=@Status, DateModified=@UpdateTime,UserModified=@ModifierID


WHERE  (NoteID=@NoteID) and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO