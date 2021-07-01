CREATE TABLE [dbo].[PhoneOrderEntry] (
  [PhoneOrderEntryID] [uniqueidentifier] NOT NULL,
  [PhoneOrderID] [uniqueidentifier] NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [Qty] [decimal](19, 2) NULL,
  [UOMQty] [decimal](19, 2) NULL,
  [UOMType] [int] NULL,
  [UOMPrice] [money] NULL,
  [ExtPrice] [money] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [SortOrder] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [OnHand] [decimal](19, 3) NULL,
  CONSTRAINT [PK_PhoneOrderEntry] PRIMARY KEY CLUSTERED ([PhoneOrderEntryID])
)
GO

CREATE INDEX [IX_PhoneOrderEntry_PickSheet_Print_Speed]
  ON [dbo].[PhoneOrderEntry] ([ItemStoreNo], [Status])
  INCLUDE ([PhoneOrderID], [Qty])
GO

CREATE INDEX [IX_PhoneOrderEntry_WebExport_006]
  ON [dbo].[PhoneOrderEntry] ([Status])
  INCLUDE ([PhoneOrderID], [ItemStoreNo], [Qty])
GO

CREATE INDEX [PhoneOrderEntry_ix3]
  ON [dbo].[PhoneOrderEntry] ([PhoneOrderID], [ItemStoreNo], [Status])
GO