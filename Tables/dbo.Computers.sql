CREATE TABLE [dbo].[Computers] (
  [ComputerID] [uniqueidentifier] NOT NULL,
  [ComputerName] [nvarchar](255) NULL,
  [ComputerNo] [nvarchar](255) NULL,
  [StoreID] [uniqueidentifier] NULL,
  [LabelPrinter] [nvarchar](255) NULL,
  [ShelfPrinter] [nvarchar](255) NULL,
  [InvoicePrinter] [nvarchar](255) NULL,
  [StatementPrinter] [nvarchar](255) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_Computers] PRIMARY KEY CLUSTERED ([ComputerID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO