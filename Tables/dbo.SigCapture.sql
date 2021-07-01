CREATE TABLE [dbo].[SigCapture] (
  [SigID] [uniqueidentifier] NOT NULL,
  [Signature] [image] NOT NULL,
  [TransactionID] [uniqueidentifier] NOT NULL,
  [TenderID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SigCapture] PRIMARY KEY CLUSTERED ([SigID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO