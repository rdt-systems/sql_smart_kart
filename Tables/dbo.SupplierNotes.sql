CREATE TABLE [dbo].[SupplierNotes] (
  [NoteID] [uniqueidentifier] NOT NULL,
  [SupplierID] [uniqueidentifier] NOT NULL,
  [TypeOfNote] [int] NOT NULL,
  [NoteValue] [ntext] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([NoteID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO