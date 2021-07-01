CREATE TABLE [dbo].[W_TenderEntry] (
  [Amount] [money] NULL,
  [Common1] [nvarchar](50) NULL,
  [Common2] [nvarchar](50) NULL,
  [Common3] [nvarchar](50) NULL,
  [Common4] [nvarchar](50) NULL,
  [Common5] [nvarchar](50) NULL,
  [Common6] [nvarchar](50) NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [smallint] NULL,
  [TenderDate] [datetime] NULL,
  [TenderEntryID] [uniqueidentifier] NOT NULL,
  [TenderID] [int] NOT NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [TransactionType] [int] NULL CONSTRAINT [DF_W_TenderEntry_TransactionType] DEFAULT (0),
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO