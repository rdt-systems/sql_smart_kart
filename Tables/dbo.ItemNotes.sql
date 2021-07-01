CREATE TABLE [dbo].[ItemNotes] (
  [NoteID] [uniqueidentifier] NOT NULL,
  [TypeOfNote] [int] NOT NULL,
  [ItemStoreNo] [uniqueidentifier] NOT NULL,
  [NoteValue] [ntext] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_ItemNotes] PRIMARY KEY CLUSTERED ([NoteID])
)
GO