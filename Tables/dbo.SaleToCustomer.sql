CREATE TABLE [dbo].[SaleToCustomer] (
  [SaleToCustomerID] [int] IDENTITY,
  [CustomerID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [SalePrice] [money] NULL,
  [MinTotalSale] [money] NULL,
  [MinQty] [decimal] NULL,
  [MaxQty] [decimal] NULL,
  [StartSaleDate] [datetime] NULL,
  [EndSaleTime] [datetime] NULL,
  [Used] [int] NULL CONSTRAINT [DF_SaleToCustomer_Used] DEFAULT (0),
  [Status] [smallint] NULL CONSTRAINT [DF_SaleToCustomer_Status] DEFAULT (1),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SaleToCustomer] PRIMARY KEY CLUSTERED ([SaleToCustomerID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO