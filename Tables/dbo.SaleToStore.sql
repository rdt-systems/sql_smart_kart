CREATE TABLE [dbo].[SaleToStore] (
  [SaleToStoreID] [uniqueidentifier] NOT NULL,
  [ActivationStatus] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [SaleID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModifed] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SaleToStore] PRIMARY KEY CLUSTERED ([SaleToStoreID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO