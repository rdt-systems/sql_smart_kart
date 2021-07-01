CREATE TABLE [dbo].[DiscountGroupEntry] (
  [DiscountGroupEntryID] [uniqueidentifier] NOT NULL,
  [DiscountGroupID] [uniqueidentifier] NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  CONSTRAINT [PK_DiscountGroupEntry] PRIMARY KEY CLUSTERED ([DiscountGroupEntryID])
)
GO