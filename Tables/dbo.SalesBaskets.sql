CREATE TABLE [dbo].[SalesBaskets] (
  [BasketID] [uniqueidentifier] NOT NULL,
  [BaskActionType] [int] NULL,
  [BaskItemID] [uniqueidentifier] NULL,
  [BaskItemType] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [MinQty] [decimal] NULL,
  [QtyBasket] [int] NULL,
  [SaleID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [SupplierID] [uniqueidentifier] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SalesBaskets_BasketID] PRIMARY KEY CLUSTERED ([BasketID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO