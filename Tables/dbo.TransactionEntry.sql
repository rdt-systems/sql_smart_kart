CREATE TABLE [dbo].[TransactionEntry] (
  [TransactionEntryID] [uniqueidentifier] NOT NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Sort] [int] NULL,
  [TransactionEntryType] [int] NOT NULL,
  [Taxable] [bit] NULL,
  [Qty] [decimal](19, 3) NULL,
  [UOMPrice] [money] NULL,
  [UOMType] [money] NULL,
  [UOMQty] [decimal](19, 3) NULL,
  [Total] [money] NULL,
  [RegUnitPrice] [money] NULL,
  [DiscountPerc] [decimal](19, 3) NULL,
  [DiscountAmount] [money] NULL,
  [SaleCode] [nvarchar](50) NULL,
  [PriceExplanation] [nvarchar](50) NULL,
  [ParentTransactionEntry] [uniqueidentifier] NULL,
  [AVGCost] [money] NULL,
  [Cost] [money] NULL,
  [ReturnReason] [int] NULL,
  [Note] [nvarchar](50) NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [DiscountOnTotal] [decimal](19, 3) NULL,
  [Status] [smallint] NOT NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TotalAfterDiscount] [decimal](18, 3) NULL,
  [TaxRate] [decimal](18, 4) NULL,
  [TaxID] [uniqueidentifier] NULL,
  [ToItemStoreID] [uniqueidentifier] NULL,
  [DiscountInt] [int] NULL,
  CONSTRAINT [PK_TransactionEntry] PRIMARY KEY CLUSTERED ([TransactionEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_TransactionEntry_10_1462100795__K2_K24_K5_11]
  ON [dbo].[TransactionEntry] ([TransactionID], [Status], [TransactionEntryType])
  INCLUDE ([Total])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_TransactionEntry_21_1462100795__K3_1_2_4_5_6_7_8_9_10_11_13_14_15_16_17_18_19_20_21_22_23_24_25_26_27_28]
  ON [dbo].[TransactionEntry] ([ItemStoreID])
  INCLUDE ([AVGCost], [Cost], [DateCreated], [DateModified], [DepartmentID], [DiscountAmount], [DiscountOnTotal], [DiscountPerc], [Note], [ParentTransactionEntry], [PriceExplanation], [Qty], [ReturnReason], [SaleCode], [Sort], [Status], [Taxable], [Total], [TransactionEntryID], [TransactionEntryType], [TransactionID], [UOMPrice], [UOMQty], [UOMType], [UserCreated], [UserModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_TransactionEntry_5_1621580815__K3_K24_K2_10_11_18]
  ON [dbo].[TransactionEntry] ([ItemStoreID], [Status], [TransactionID])
  INCLUDE ([AVGCost], [Total], [UOMQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_TransactionEntry_5_1832393597__K2_K24_K1_K3_5_7_9_10_11]
  ON [dbo].[TransactionEntry] ([TransactionID], [Status], [TransactionEntryID], [ItemStoreID])
  INCLUDE ([AVGCost], [Cost], [DepartmentID], [DiscountOnTotal], [Qty], [ReturnReason], [Taxable], [TaxRate], [Total], [TotalAfterDiscount], [TransactionEntryType], [UOMPrice], [UOMQty], [UOMType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IndexForTransactionEntryForTax]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([Taxable], [TaxRate], [Total], [TotalAfterDiscount], [TransactionEntryID], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustomerSales_01]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([TransactionID], [ItemStoreID], [TransactionEntryType], [Qty], [UOMPrice], [Total], [RegUnitPrice])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_DepartmentID]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([DepartmentID], [ItemStoreID], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_DiscountReport_001]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([TransactionID], [Qty], [Total])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_History_000001]
  ON [dbo].[TransactionEntry] ([Qty], [Status])
  INCLUDE ([TransactionID], [ItemStoreID], [TransactionEntryType], [UOMType], [UOMQty], [Total], [TotalAfterDiscount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_QuickReport_6]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([TransactionID], [ItemStoreID], [Qty], [UOMType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Status_TransactionEntry_Speed_001]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([TransactionID], [ItemStoreID], [Sort], [TransactionEntryType], [Taxable], [Qty], [UOMPrice], [UOMType], [UOMQty], [Total], [RegUnitPrice], [DiscountPerc], [DiscountAmount], [SaleCode], [PriceExplanation], [ParentTransactionEntry], [AVGCost], [Cost], [ReturnReason], [Note], [DepartmentID], [DiscountOnTotal], [DateCreated], [UserCreated], [DateModified], [UserModified], [TotalAfterDiscount], [TaxRate], [TaxID], [ToItemStoreID], [DiscountInt])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_164251656165]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Qty], [Status])
  INCLUDE ([TransactionID], [Total])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_1651656165]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [Qty], [AVGCost], [Cost])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_91515]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([TransactionID], [ItemStoreID], [Sort], [TransactionEntryType], [UOMPrice], [UOMQty], [Total], [RegUnitPrice], [TotalAfterDiscount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_Dashboard01]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [Qty], [Total], [TotalAfterDiscount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_Dashboard02]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [ItemStoreID], [UOMPrice])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_Dashboard03]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [ItemStoreID], [Qty], [UOMPrice], [UOMType], [UOMQty], [Total], [RegUnitPrice], [AVGCost], [Cost], [DiscountOnTotal], [TotalAfterDiscount])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_Qty]
  ON [dbo].[TransactionEntry] ([Qty])
  INCLUDE ([TransactionID], [Total])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_Speed_0056]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntry_SpeedUp_0000]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [ItemStoreID], [Sort], [Taxable], [Qty], [UOMPrice], [UOMType], [UOMQty], [Total], [RegUnitPrice], [DiscountPerc], [DiscountAmount], [SaleCode], [PriceExplanation], [ParentTransactionEntry], [AVGCost], [Cost], [ReturnReason], [Note], [DepartmentID], [DiscountOnTotal], [DateCreated], [UserCreated], [DateModified], [UserModified], [TotalAfterDiscount], [TaxRate], [TaxID], [ToItemStoreID], [DiscountInt])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntryItem]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionID], [ItemStoreID], [Taxable], [Qty], [UOMPrice], [UOMType], [UOMQty], [Total], [RegUnitPrice], [AVGCost], [Cost], [ReturnReason], [DepartmentID], [DiscountOnTotal], [TotalAfterDiscount], [TaxRate])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransactionEntryItem_0001]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([TransactionEntryID], [TransactionID], [ItemStoreID], [Taxable], [Qty], [UOMPrice], [UOMType], [UOMQty], [Total], [RegUnitPrice], [AVGCost], [Cost], [ReturnReason], [DepartmentID], [DiscountOnTotal], [TotalAfterDiscount], [TaxRate])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [missing_index_15809_15808_TransactionEntry]
  ON [dbo].[TransactionEntry] ([TransactionEntryType], [Status])
  INCLUDE ([ItemStoreID], [Total], [TotalAfterDiscount], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_TransactionEntry_19B062477EAB7980D3AFC5344EB51681]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([UOMQty], [UOMPrice], [RegUnitPrice], [Total], [ItemStoreID], [TransactionID], [TransactionEntryType], [Sort])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [RM_HelpGenOrders]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([ItemStoreID], [Qty], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [RM_TransactionEntry_Status_TransactionID]
  ON [dbo].[TransactionEntry] ([Status])
  INCLUDE ([TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO