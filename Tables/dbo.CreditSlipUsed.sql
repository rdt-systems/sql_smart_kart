CREATE TABLE [dbo].[CreditSlipUsed] (
  [CreditSlipUsedID] [uniqueidentifier] NOT NULL,
  [CreditSlipID] [uniqueidentifier] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [Amount] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([CreditSlipUsedID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO