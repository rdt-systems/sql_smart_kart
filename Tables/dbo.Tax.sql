CREATE TABLE [dbo].[Tax] (
  [TaxID] [uniqueidentifier] NOT NULL,
  [TaxName] [nvarchar](50) NULL,
  [TaxDescription] [nvarchar](4000) NULL,
  [TaxRate] [decimal](19, 4) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [FromAmount] [money] NULL,
  [Amount2] [money] NULL,
  [TaxRate2] [decimal](18, 4) NULL,
  PRIMARY KEY CLUSTERED ([TaxID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO