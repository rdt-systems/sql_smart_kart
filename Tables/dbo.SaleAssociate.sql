CREATE TABLE [dbo].[SaleAssociate] (
  [SaleAssociateID] [int] NULL,
  [UserID] [uniqueidentifier] NULL,
  [TransactionID] [uniqueidentifier] NULL
)
GO

CREATE INDEX [IX_SaleAssociate_TransactionID]
  ON [dbo].[SaleAssociate] ([TransactionID])
  INCLUDE ([UserID])
GO