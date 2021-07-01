CREATE TABLE [dbo].[TransEntryToRegEntry] (
  [TransEntryToRegEntryID] [uniqueidentifier] NOT NULL,
  [TransEntryID] [uniqueidentifier] NULL,
  [RegEntryID] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  CONSTRAINT [PK_TransEntryToRegEntry] PRIMARY KEY CLUSTERED ([TransEntryToRegEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO