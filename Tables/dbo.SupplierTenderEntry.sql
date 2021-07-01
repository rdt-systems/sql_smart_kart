CREATE TABLE [dbo].[SupplierTenderEntry] (
  [SuppTenderEntryID] [uniqueidentifier] NOT NULL,
  [SuppTenderNo] [nvarchar](50) NULL,
  [StoreID] [uniqueidentifier] NULL,
  [SupplierID] [uniqueidentifier] NULL,
  [TenderID] [int] NOT NULL,
  [Amount] [money] NULL,
  [Common1] [nvarchar](50) NULL,
  [Common2] [nvarchar](50) NULL,
  [Common3] [nvarchar](50) NULL,
  [Common4] [nvarchar](50) NULL,
  [Common5] [nvarchar](50) NULL,
  [Common6] [nvarchar](50) NULL,
  [TenderDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TransferedToBookkeeping] [bit] NULL,
  [QBNumber] [nvarchar](50) NULL,
  CONSTRAINT [PK__Supplier__6A06D5F9535B7B45] PRIMARY KEY CLUSTERED ([SuppTenderEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO