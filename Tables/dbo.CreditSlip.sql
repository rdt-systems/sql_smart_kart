CREATE TABLE [dbo].[CreditSlip] (
  [CreditSlipID] [uniqueidentifier] NOT NULL,
  [CreditSlipNo] [nvarchar](50) NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [Amount] [money] NULL,
  [ExpDate] [datetime] NULL,
  [Note] [nvarchar](400) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([CreditSlipID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO