CREATE TABLE [dbo].[CustomerSaleInfo] (
  [CustomerID] [uniqueidentifier] NOT NULL,
  [Visit] [int] NULL,
  [LastVisit] [datetime] NULL,
  [AverageAmount] [decimal] NULL,
  [TotalSpent] [decimal] NULL,
  [Last12MonthsTrans] [int] NULL,
  [Last90DaysTrans] [int] NULL,
  CONSTRAINT [PK_CustomerSaleInfo] PRIMARY KEY CLUSTERED ([CustomerID])
)
GO