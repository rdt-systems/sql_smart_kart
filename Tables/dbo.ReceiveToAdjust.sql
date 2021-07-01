CREATE TABLE [dbo].[ReceiveToAdjust] (
  [AdjustID] [uniqueidentifier] NOT NULL,
  [ReceiveEntryID] [uniqueidentifier] NOT NULL,
  [Qty] [decimal] NOT NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([AdjustID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO