CREATE TABLE [dbo].[GiftToTender] (
  [GiftToTenderID] [uniqueidentifier] NOT NULL,
  [GiftID] [uniqueidentifier] NULL,
  [TenderEntryID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_GiftToTender] PRIMARY KEY CLUSTERED ([GiftToTenderID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO