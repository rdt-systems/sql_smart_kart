CREATE TABLE [dbo].[PaymentDetails] (
  [PaymentID] [uniqueidentifier] NOT NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [TransactionPayedID] [uniqueidentifier] NULL,
  [Amount] [money] NULL,
  [Note] [nvarchar](4000) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_PaymentDetails] PRIMARY KEY CLUSTERED ([PaymentID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_PaymentDetails_10_1477580302__K2_4_6]
  ON [dbo].[PaymentDetails] ([TransactionID])
  INCLUDE ([Amount], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_PaymentDetails_11_1221579390__K2_K6_4]
  ON [dbo].[PaymentDetails] ([TransactionID], [Status])
  INCLUDE ([Amount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_PaymentDetails]
  ON [dbo].[PaymentDetails] ([TransactionPayedID], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_PaymentDetails_RunningBalance_Speed_01]
  ON [dbo].[PaymentDetails] ([Status])
  INCLUDE ([Amount], [TransactionPayedID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO