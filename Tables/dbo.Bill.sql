CREATE TABLE [dbo].[Bill] (
  [BillID] [uniqueidentifier] NOT NULL,
  [BillNo] [nvarchar](50) NULL,
  [SupplierID] [uniqueidentifier] NULL,
  [Discount] [decimal](18, 3) NULL,
  [Amount] [money] NULL,
  [AmountPay] [money] NULL,
  [BillDate] [datetime] NULL,
  [BillDue] [datetime] NULL,
  [PersonGet] [uniqueidentifier] NULL,
  [TermsID] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [Taxable] [bit] NULL,
  [TaxRate] [decimal](19, 4) NULL,
  [TaxAmount] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TransferedToBookkeeping] [bit] NULL,
  [QBNumber] [nvarchar](50) NULL,
  CONSTRAINT [PK_Bill] PRIMARY KEY NONCLUSTERED ([BillID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_Bill_Speed_001]
  ON [dbo].[Bill] ([Status])
  INCLUDE ([BillID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO