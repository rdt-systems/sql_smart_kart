CREATE TABLE [dbo].[PayToSupplier] (
  [TransactionID] [uniqueidentifier] NOT NULL,
  [ApplyAmount] [money] NULL,
  PRIMARY KEY CLUSTERED ([TransactionID])
)
GO