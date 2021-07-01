CREATE TABLE [dbo].[OrderType] (
  [OrderTypeID] [int] IDENTITY,
  [Name] [char](100) NOT NULL,
  CONSTRAINT [PK_OrderType] PRIMARY KEY CLUSTERED ([OrderTypeID])
)
GO