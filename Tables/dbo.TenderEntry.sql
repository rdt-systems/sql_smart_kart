CREATE TABLE [dbo].[TenderEntry] (
  [TenderEntryID] [uniqueidentifier] NOT NULL,
  [TenderID] [int] NOT NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [TransactionType] [int] NULL CONSTRAINT [DF_TenderEntry_TransactionType] DEFAULT (0),
  [Amount] [money] NULL,
  [Common1] [nvarchar](50) NULL,
  [Common2] [nvarchar](50) NULL,
  [Common3] [nvarchar](50) NULL,
  [Common4] [nvarchar](50) NULL,
  [Common5] [nvarchar](50) NULL,
  [Common6] [nvarchar](50) NULL,
  [TenderDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_TenderEntry] PRIMARY KEY CLUSTERED ([TenderEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_TenderEntry_5_1925581898__K3_K2_5]
  ON [dbo].[TenderEntry] ([TransactionID], [TenderID])
  INCLUDE ([Amount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [Index_For_COD_1]
  ON [dbo].[TenderEntry] ([Status])
  INCLUDE ([Amount], [TransactionID], [TenderID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [Index_For_COD_2]
  ON [dbo].[TenderEntry] ([TenderID], [Status])
  INCLUDE ([Amount], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderEntry_QBSync_Speed_001]
  ON [dbo].[TenderEntry] ([Status])
  INCLUDE ([TenderID], [TransactionID], [Amount], [Common3])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderEntry_RunningBalance_Speed_01]
  ON [dbo].[TenderEntry] ([Status])
  INCLUDE ([Common1], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderEntry_Speed_0001]
  ON [dbo].[TenderEntry] ([Amount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderEntry_Status_Speed_001]
  ON [dbo].[TenderEntry] ([TenderID], [Status])
  INCLUDE ([TransactionID], [TransactionType], [Amount], [Common1], [Common2], [Common3], [Common4], [Common5], [Common6], [TenderDate], [DateCreated], [UserCreated], [DateModified], [UserModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderEntry_TransactionType_Status]
  ON [dbo].[TenderEntry] ([TransactionType], [Status])
  INCLUDE ([TenderID], [TransactionID], [Amount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderEntry_TransactionType_Status0]
  ON [dbo].[TenderEntry] ([TransactionType], [Status])
  INCLUDE ([TenderID], [TransactionID], [Amount], [Common3], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TenderTotalsReport_001]
  ON [dbo].[TenderEntry] ([TransactionType], [Status])
  INCLUDE ([TenderID], [TransactionID], [Amount], [Common1], [Common3], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO