CREATE TABLE [dbo].[ItemSpecial] (
  [ItemSpecialID] [int] IDENTITY,
  [ItemStoreID] [uniqueidentifier] NULL,
  [SaleType] [int] NULL,
  [SalePrice] [money] NULL CONSTRAINT [DF_ItemSpecial_SalePrice] DEFAULT (0),
  [SaleStartDate] [datetime] NULL,
  [SaleEndDate] [datetime] NULL,
  [SaleMin] [int] NULL,
  [SaleMax] [int] NULL,
  [MinForSale] [money] NULL,
  [SpecialBuy] [int] NULL,
  [SpecialPrice] [money] NULL,
  [AssignDate] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_ItemSpecial] PRIMARY KEY CLUSTERED ([ItemSpecialID])
)
GO

CREATE UNIQUE INDEX [ItemStoreID_Unique]
  ON [dbo].[ItemSpecial] ([ItemStoreID])
  WHERE ([ItemStoreID] IS NOT NULL AND [Status]>(-1))
GO

CREATE INDEX [IX_ItemSpecial]
  ON [dbo].[ItemSpecial] ([ItemStoreID])
GO

ALTER TABLE [dbo].[ItemSpecial]
  ADD CONSTRAINT [FK_ItemSpecial_ItemStore] FOREIGN KEY ([ItemStoreID]) REFERENCES [dbo].[ItemStore] ([ItemStoreID])
GO