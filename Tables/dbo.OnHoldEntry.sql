﻿CREATE TABLE [dbo].[OnHoldEntry] (
  [BreakdownPrice] [money] NULL,
  [BreakdownQty] [decimal](19, 3) NULL,
  [CaseItem] [bit] NULL,
  [Cost] [money] NULL,
  [dAmount] [money] NULL,
  [dDescription] [nvarchar](550) NULL,
  [dDiscountID] [nvarchar](50) NULL,
  [dDiscountType] [int] NULL,
  [DefaultPrice] [money] NULL,
  [Description] [nvarchar](550) NULL,
  [Discountable] [bit] NULL,
  [dMinTotalSale] [money] NULL,
  [EntryType] [int] NULL,
  [FoodStampable] [bit] NULL,
  [ID] [int] NOT NULL,
  [ItemID] [nvarchar](50) NULL,
  [ItemType] [int] NULL,
  [ManualItem] [bit] NULL,
  [ModelNo] [nvarchar](50) NULL,
  [Note] [nvarchar](4000) NULL,
  [OnHoldID] [uniqueidentifier] NULL,
  [Price] [money] NULL,
  [PriceA] [money] NULL,
  [PriceB] [money] NULL,
  [PriceBaseOnTotal] [bit] NULL,
  [PriceC] [money] NULL,
  [PriceD] [money] NULL,
  [Qty] [decimal](19, 3) NULL,
  [RegPrice] [money] NULL,
  [Return] [bit] NULL,
  [SaleAssignDate] [bit] NULL,
  [SaleEndDate] [datetime] NULL,
  [SalePrice] [decimal](19, 3) NULL,
  [SaleStartDate] [datetime] NULL,
  [SaleType] [int] NULL,
  [SplitItem] [bit] NULL,
  [TagAlong1] [nvarchar](50) NULL,
  [TagAlong2] [nvarchar](50) NULL,
  [TagAlong3] [nvarchar](50) NULL,
  [Taxable] [bit] NULL,
  [Total] [money] NULL,
  [UOMQty] [decimal](19, 3) NULL,
  [UOMType] [int] NULL,
  [UPC] [nvarchar](50) NULL,
  [MinQtySale] [int] NULL,
  [MaxQtySale] [int] NULL,
  [CaseQty] [float] NULL,
  [CasePrice] [money] NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [TableItemID] [nvarchar](50) NULL,
  [ItemDiscountPercent] [real] NULL,
  [AltNeed] [bit] NULL,
  [AltExpectedDate] [datetime] NULL,
  [AvgCost] [money] NULL,
  [NewDescription] [nchar](550) NULL,
  [ReturenEntryID] [nvarchar](50) NULL
)
GO