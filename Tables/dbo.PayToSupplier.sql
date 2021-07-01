CREATE TABLE [dbo].[PayToSupplier] (
  [TransactionID] [uniqueidentifier] NOT NULL,
  [ApplyAmount] [money] NULL,
  PRIMARY KEY CLUSTERED ([TransactionID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO