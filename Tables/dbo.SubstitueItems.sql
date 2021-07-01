CREATE TABLE [dbo].[SubstitueItems] (
  [SubstitueItemsId] [uniqueidentifier] NOT NULL,
  [ItemNo] [uniqueidentifier] NULL,
  [SubstitueNo] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SubstitueItems] PRIMARY KEY CLUSTERED ([SubstitueItemsId]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO