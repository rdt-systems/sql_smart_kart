CREATE TABLE [dbo].[Loyalty] (
  [LoyaltyID] [uniqueidentifier] NOT NULL,
  [AvailPoints] [decimal](18, 2) NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL,
  [Points] [decimal](18, 2) NULL,
  [Status] [int] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  CONSTRAINT [PK_Loyalty] PRIMARY KEY CLUSTERED ([LoyaltyID])
)
GO

CREATE INDEX [_dta_index_Loyalty_7_1826105546__K2_K6_1]
  ON [dbo].[Loyalty] ([CustomerID], [Status])
  INCLUDE ([AvailPoints])
GO

ALTER TABLE [dbo].[Loyalty]
  ADD CONSTRAINT [FK_Loyalty_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
GO