CREATE TABLE [dbo].[ItemStoreOnHandHistory] (
  [ItemStoreID] [uniqueidentifier] NOT NULL,
  [ItemNo] [uniqueidentifier] NULL,
  [OldOnHand] [decimal] NULL,
  [NewOnHand] [decimal] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO