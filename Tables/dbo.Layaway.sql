CREATE TABLE [dbo].[Layaway] (
  [LayawayID] [uniqueidentifier] NOT NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Price] [money] NULL,
  [Qty] [money] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreate] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [LayawayStatus] [int] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_Layaway] PRIMARY KEY CLUSTERED ([LayawayID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO