CREATE TABLE [dbo].[CustomerNotes] (
  [NoteID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NOT NULL,
  [TypeOfNote] [int] NOT NULL,
  [NoteValue] [ntext] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_CustomerNotes] PRIMARY KEY CLUSTERED ([NoteID])
)
GO

CREATE INDEX [IX_CustomerNotes]
  ON [dbo].[CustomerNotes] ([CustomerID], [Status], [DateCreated], [NoteID])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteCustomerNotes] on [dbo].[CustomerNotes]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT NoteID, 'CustomerNotesPOS' , Status, dbo.GetLocalDATE() , 1,'NoteID' FROM      inserted
  end
GO