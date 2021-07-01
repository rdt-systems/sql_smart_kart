CREATE TABLE [dbo].[TestFlushTable] (
  [RecID] [uniqueidentifier] NOT NULL,
  [RecEntryID] [uniqueidentifier] NULL,
  [Freight] [money] NULL,
  [Discount] [decimal](18, 3) NULL,
  [Total] [money] NULL,
  [CurrBal] [money] NULL,
  [DateCre] [datetime] NULL,
  [DateMod] [datetime] NULL,
  [Cost] [money] NULL,
  [Qty] [decimal](19, 3) NULL,
  [IsSpecialPrice] [bit] NULL,
  [Taxable] [bit] NULL,
  PRIMARY KEY CLUSTERED ([RecID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO