CREATE TABLE [dbo].[QBSuppliers] (
  [QbSupplierID] [int] IDENTITY,
  [StoreID] [uniqueidentifier] NULL,
  [QbNumber] [nvarchar](50) NULL,
  [SupplierID] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK__QBSuppli__0D066D511E9A6CE7] PRIMARY KEY CLUSTERED ([QbSupplierID])
)
GO

ALTER TABLE [dbo].[QBSuppliers]
  ADD CONSTRAINT [FK_QBSuppliers_Supplier] FOREIGN KEY ([SupplierID]) REFERENCES [dbo].[Supplier] ([SupplierID])
GO