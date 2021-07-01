CREATE TABLE [dbo].[StockingLevels] (
  [DepartmentID] [uniqueidentifier] NOT NULL,
  [StoreID] [uniqueidentifier] NOT NULL,
  [ReorderPoint] [decimal] NULL,
  [RestockLevel] [decimal] NULL,
  [Status] [int] NOT NULL CONSTRAINT [DF_StockingLevels_Status] DEFAULT (1),
  [DateModified] [datetime] NULL,
  [RestockingID] [int] IDENTITY,
  [StoreName] [nvarchar](100) NULL,
  [Department] [nvarchar](100) NULL,
  [StoreNumber] [nvarchar](40) NULL,
  CONSTRAINT [PK_StockingLevels] PRIMARY KEY CLUSTERED ([RestockingID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO