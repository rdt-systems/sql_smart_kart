CREATE TABLE [dbo].[CreditCard] (
  [CreditCardID] [uniqueidentifier] NOT NULL,
  [CreditCardName] [nvarchar](20) NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([CreditCardID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO