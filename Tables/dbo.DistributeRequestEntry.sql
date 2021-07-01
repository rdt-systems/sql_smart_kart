CREATE TABLE [dbo].[DistributeRequestEntry] (
  [DistributeRequestEntryID] [uniqueidentifier] NOT NULL,
  [DistributeRequestID] [uniqueidentifier] NULL,
  [ItemID] [nchar](10) NULL,
  [Qty] [numeric](18, 2) NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_DistributeRequestEntry_Status] DEFAULT (1),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DistributeRequestEntry] PRIMARY KEY CLUSTERED ([DistributeRequestEntryID])
)
GO