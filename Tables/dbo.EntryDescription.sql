CREATE TABLE [dbo].[EntryDescription] (
  [TransactionEntryID] [uniqueidentifier] NOT NULL,
  [Description] [nvarchar](500) NULL,
  CONSTRAINT [PK_EntryDescription] PRIMARY KEY CLUSTERED ([TransactionEntryID])
)
GO

ALTER TABLE [dbo].[EntryDescription]
  ADD CONSTRAINT [FK_EntryDescription_TransactionEntry] FOREIGN KEY ([TransactionEntryID]) REFERENCES [dbo].[TransactionEntry] ([TransactionEntryID])
GO