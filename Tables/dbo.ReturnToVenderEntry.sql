CREATE TABLE [dbo].[ReturnToVenderEntry] (
  [ReturnToVenderEntryID] [uniqueidentifier] NOT NULL,
  [ReturnToVenderID] [uniqueidentifier] NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [Cost] [money] NULL,
  [Qty] [decimal](19, 3) NULL,
  [UOMQty] [decimal] NULL,
  [UOMType] [int] NULL,
  [ExtPrice] [money] NULL,
  [IsSpecialPrice] [bit] NULL,
  [ReturnReason] [int] NULL,
  [Taxable] [bit] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [ReceiveID] [uniqueidentifier] NULL,
  [SortOrder] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ReturnToVenderEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO