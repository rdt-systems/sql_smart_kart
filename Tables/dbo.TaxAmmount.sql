CREATE TABLE [dbo].[TaxAmmount] (
  [TaxAmmountID] [uniqueidentifier] NOT NULL,
  [TaxNo] [uniqueidentifier] NOT NULL,
  [Percents] [numeric](9, 3) NULL,
  [FromSum] [numeric](18, 2) NULL,
  [ToSum] [numeric](18, 2) NULL,
  [Status] [smallint] NULL,
  PRIMARY KEY CLUSTERED ([TaxAmmountID])
)
GO