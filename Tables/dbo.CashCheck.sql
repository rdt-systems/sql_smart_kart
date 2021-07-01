CREATE TABLE [dbo].[CashCheck] (
  [CashCheckID] [uniqueidentifier] NOT NULL,
  [BatchID] [uniqueidentifier] NULL,
  [Date] [datetime] NOT NULL,
  [UserID] [uniqueidentifier] NULL,
  [Amount] [money] NOT NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [CustomerID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_CashCheck] PRIMARY KEY CLUSTERED ([CashCheckID])
)
GO