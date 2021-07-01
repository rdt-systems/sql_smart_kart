CREATE TABLE [dbo].[Supplier] (
  [SupplierID] [uniqueidentifier] NOT NULL,
  [SupplierNo] [nvarchar](50) NULL,
  [Name] [nvarchar](50) NULL,
  [DefaultCredit] [uniqueidentifier] NULL,
  [WebSite] [nvarchar](50) NULL,
  [EmailAddress] [nvarchar](50) NULL,
  [MainAddress] [uniqueidentifier] NULL,
  [ContactName] [nvarchar](50) NULL,
  [BarterID] [uniqueidentifier] NULL,
  [WarehouseID] [uniqueidentifier] NULL,
  [AccountNo] [nvarchar](50) NULL,
  [Note] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [QBNumber] [nvarchar](50) NULL,
  [BuyerID] [uniqueidentifier] NULL,
  [MinMarkup] [decimal](18, 4) NULL,
  [ListPrice] [decimal](18, 4) NULL,
  [Department] [uniqueidentifier] NULL,
  [Import] [smallint] NULL,
  CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([SupplierID])
)
GO

CREATE INDEX [_dta_index_Supplier_5_1109578991__K1_K7]
  ON [dbo].[Supplier] ([SupplierID], [MainAddress])
GO

CREATE INDEX [_dta_index_Supplier_5_1109578991__K1_K7_K3]
  ON [dbo].[Supplier] ([SupplierID], [MainAddress], [Name])
GO

ALTER TABLE [dbo].[Supplier] WITH NOCHECK
  ADD CONSTRAINT [FK_Supplier_SupplierAddresses] FOREIGN KEY ([MainAddress]) REFERENCES [dbo].[SupplierAddresses] ([AddressID])
GO