CREATE TABLE [dbo].[GiftRegistery] (
  [GiftRegisteryID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [CustomerID1] [uniqueidentifier] NULL,
  [EventDate] [datetime] NULL,
  [EventType] [nvarchar](20) NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [Status] [int] NOT NULL,
  [GiftRegisteryNo] [nvarchar](50) NULL,
  [EventName] [nvarchar](50) NULL,
  CONSTRAINT [PK_GiftRegistery] PRIMARY KEY CLUSTERED ([GiftRegisteryID])
)
GO