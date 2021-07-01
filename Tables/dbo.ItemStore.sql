CREATE TABLE [dbo].[ItemStore] (
  [ItemStoreID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ItemStore_ItemStoreID] DEFAULT (newid()),
  [ItemNo] [uniqueidentifier] NOT NULL,
  [StoreNo] [uniqueidentifier] NOT NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [IsDiscount] [bit] NULL,
  [IsTaxable] [bit] NULL,
  [TaxID] [uniqueidentifier] NULL,
  [IsFoodStampable] [bit] NULL,
  [IsWIC] [bit] NULL,
  [Cost] [money] NULL,
  [ListPrice] [money] NULL,
  [Price] [money] NULL,
  [PriceA] [money] NULL CONSTRAINT [DF_ItemStore_PriceA] DEFAULT (0),
  [PriceB] [money] NULL CONSTRAINT [DF_ItemStore_PriceB] DEFAULT (0),
  [PriceC] [money] NULL CONSTRAINT [DF_ItemStore_PriceC] DEFAULT (0),
  [PriceD] [money] NULL CONSTRAINT [DF_ItemStore_PriceD] DEFAULT (0),
  [ExtraCharge1] [uniqueidentifier] NULL,
  [ExtraCharge2] [uniqueidentifier] NULL,
  [ExtraCharge3] [uniqueidentifier] NULL,
  [CogsAccount] [int] NULL,
  [IncomeAccount] [int] NULL,
  [ProfitCalculation] [int] NOT NULL CONSTRAINT [DF_ItemStore_ProfitCalculation] DEFAULT (0),
  [CommissionQty] [decimal](19, 3) NULL,
  [CommissionType] [int] NOT NULL CONSTRAINT [DF_ItemStore_CommissionType] DEFAULT (0),
  [PrefSaleBy] [int] NULL,
  [PrefOrderBy] [int] NULL,
  [MainSupplierID] [uniqueidentifier] NULL,
  [OnOrder] [decimal](19, 3) NULL,
  [OnTransferOrder] [decimal](19, 3) NULL,
  [OnHand] [decimal](19, 3) NULL,
  [ReorderPoint] [decimal](19, 3) NULL,
  [RestockLevel] [decimal](19, 3) NULL,
  [BinLocation] [nvarchar](50) NULL,
  [OnWorkOrder] [decimal] NULL,
  [DaysForReturn] [int] NULL,
  [AVGCost] [money] NULL,
  [SaleType] [int] NULL,
  [SalePrice] [money] NULL CONSTRAINT [DF_ItemStore_SalePrice] DEFAULT (0),
  [SaleStartDate] [datetime] NULL,
  [SaleEndDate] [datetime] NULL,
  [SaleMin] [int] NULL,
  [SaleMax] [int] NULL,
  [MinForSale] [money] NULL,
  [SpecialBuy] [int] NULL,
  [SpecialPrice] [money] NULL,
  [SpecialBuyFromDate] [datetime] NULL,
  [SpecialBuyToDate] [datetime] NULL,
  [MixAndMatchID] [uniqueidentifier] NULL,
  [AssignDate] [bit] NULL,
  [Status] [smallint] NULL,
  [MTDQty] [decimal] NULL,
  [MTDDollar] [money] NULL,
  [PTDQty] [decimal] NULL,
  [PTDDollar] [money] NULL,
  [YTDQty] [decimal] NULL,
  [YTDDollar] [money] NULL,
  [MTDReturnQty] [decimal] NULL,
  [PTDReturnQty] [decimal] NULL,
  [YTDReturnQty] [decimal] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TDDate] [datetime] NULL,
  [TDReturnDate] [datetime] NULL,
  [NewPrice] [money] NULL,
  [NewPriceDate] [datetime] NULL,
  [SpecialsMemberOnly] [bit] NULL CONSTRAINT [DF_ItemStore_SpecialsMemberOnly] DEFAULT (0),
  [CasePrice] [money] NULL CONSTRAINT [DF_ItemStore_CasePrice] DEFAULT (0),
  [CaseSpecial] [money] NULL,
  [PkgPrice] [money] NULL,
  [PkgQty] [int] NULL,
  [IsCaseDiscount] [bit] NULL,
  [IsPkgDiscount] [bit] NULL,
  [Tare] [decimal](19, 2) NULL,
  [RegCost] [money] NULL,
  [LoyaltyGroupID] [uniqueidentifier] NULL,
  [LoyaltyGroupFromDate] [datetime] NULL,
  [LoyaltyGroupToDate] [datetime] NULL,
  [VoidReason] [nvarchar](50) NULL,
  [LastCount] [int] NULL,
  [CountDate] [datetime] NULL,
  [CountOnHand] [decimal] NULL,
  [RegSalePrice] [money] NULL,
  [LastSoldDate] [datetime] NULL,
  [LastReceivedDate] [datetime] NULL,
  [LastReceivedQty] [decimal](18, 2) NULL,
  [EstimatedCost] [money] NULL,
  [NetCost] [money] NULL,
  [SpecialCost] [money] NULL,
  [ItemStoreInt] [int] IDENTITY,
  [SellOnWeb] [bit] NULL,
  [WebCasePrice] [money] NULL,
  [WebPrice] [money] NULL,
  [YTDQty1] [decimal] NULL,
  [YTDQty2] [decimal] NULL,
  [YTDQty3] [decimal] NULL,
  [LastSoldUser] [uniqueidentifier] NULL,
  [LastSoldQty] [decimal](19, 3) NULL,
  [LastReceivedUser] [uniqueidentifier] NULL,
  [TotalSold] [decimal](19, 3) NULL,
  [TotalReceive] [decimal](19, 3) NULL,
  [TotalProfit] [money] NULL,
  [OnRequest] [decimal](19, 3) NULL,
  [Reserved] [decimal](9, 3) NULL,
  CONSTRAINT [PK_ItemStore] PRIMARY KEY NONCLUSTERED ([ItemStoreID]) WITH (STATISTICS_NORECOMPUTE = ON),
  CONSTRAINT [IX_ItemIDStoreID] UNIQUE ([ItemNo], [Status], [StoreNo]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_ItemStore_21_264088427__K2_K1]
  ON [dbo].[ItemStore] ([ItemNo], [ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemStore_5_2050874423__K2_K50_K1_K4_K27_30]
  ON [dbo].[ItemStore] ([ItemNo], [Status], [ItemStoreID], [DepartmentID], [MainSupplierID])
  INCLUDE ([OnHand])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemStore_5_2130106629__K2_K50_K4_K1_K27]
  ON [dbo].[ItemStore] ([ItemNo], [Status], [DepartmentID], [ItemStoreID], [MainSupplierID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [ItemStore_ix_fields]
  ON [dbo].[ItemStore] ([StoreNo], [Status])
  INCLUDE ([AssignDate], [MixAndMatchID], [MTDDollar], [MTDQty], [SaleEndDate], [SaleStartDate], [SpecialPrice], [SpecialBuy], [PTDQty], [RegCost], [PkgQty], [SpecialCost], [NetCost], [YTDQty], [PTDDollar], [PkgPrice], [YTDDollar], [Price], [ListPrice], [PrefOrderBy], [PrefSaleBy], [ItemNo], [ItemStoreID], [Cost], [DepartmentID], [MainSupplierID], [OnWorkOrder], [ReorderPoint], [SalePrice], [SaleType], [OnOrder], [OnTransferOrder], [OnHand])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemParentView_001]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([ItemStoreID], [ItemNo], [StoreNo], [DepartmentID], [MainSupplierID], [OnOrder], [OnHand])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemsQuery1]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([DateModified], [ItemNo], [ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore]
  ON [dbo].[ItemStore] ([ItemNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_001_Speed]
  ON [dbo].[ItemStore] ([StoreNo])
  INCLUDE ([ItemStoreID], [ItemNo], [DepartmentID], [IsDiscount], [IsTaxable], [TaxID], [IsFoodStampable], [IsWIC], [Cost], [ListPrice], [Price], [PriceA], [PriceB], [PriceC], [PriceD], [ExtraCharge1], [ExtraCharge2], [ExtraCharge3], [CogsAccount], [IncomeAccount], [ProfitCalculation], [CommissionQty], [CommissionType], [PrefSaleBy], [PrefOrderBy], [MainSupplierID], [OnOrder], [OnTransferOrder], [OnHand], [ReorderPoint], [RestockLevel], [BinLocation], [OnWorkOrder], [DaysForReturn], [AVGCost], [SaleType], [SalePrice], [SaleStartDate], [SaleEndDate], [SaleMin], [SaleMax], [MinForSale], [SpecialBuy], [SpecialPrice], [SpecialBuyFromDate], [SpecialBuyToDate], [MixAndMatchID], [AssignDate], [Status], [MTDQty], [MTDDollar], [PTDQty], [PTDDollar], [YTDQty], [YTDDollar], [MTDReturnQty], [PTDReturnQty], [YTDReturnQty], [DateCreated], [UserCreated], [DateModified], [UserModified], [TDDate], [TDReturnDate], [NewPrice], [NewPriceDate], [SpecialsMemberOnly], [CasePrice], [CaseSpecial], [PkgPrice], [PkgQty], [IsCaseDiscount], [IsPkgDiscount], [Tare], [RegCost], [LoyaltyGroupID], [LoyaltyGroupFromDate], [LoyaltyGroupToDate], [VoidReason], [LastCount], [CountDate], [CountOnHand], [RegSalePrice], [LastSoldDate], [LastReceivedDate], [LastReceivedQty], [EstimatedCost], [NetCost], [SpecialCost], [ItemStoreInt], [SellOnWeb], [WebCasePrice], [WebPrice], [YTDQty1], [YTDQty2], [YTDQty3], [LastReceivedUser], [LastSoldQty], [LastSoldUser], [TotalProfit], [TotalReceive], [TotalSold], [OnRequest])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_1]
  ON [dbo].[ItemStore] ([MainSupplierID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_2]
  ON [dbo].[ItemStore] ([MixAndMatchID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_Dashboard]
  ON [dbo].[ItemStore] ([Status], [DateCreated])
  INCLUDE ([ItemStoreID], [StoreNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_Dashboard2]
  ON [dbo].[ItemStore] ([OnHand])
  INCLUDE ([ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_Dashboard3]
  ON [dbo].[ItemStore] ([Status], [DateCreated])
  INCLUDE ([ItemNo], [StoreNo], [Cost], [Price])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_DepartmentID_ItemStoreID_ItemNo_StoreNo]
  ON [dbo].[ItemStore] ([DepartmentID])
  INCLUDE ([StoreNo], [ItemNo], [ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [ix_ItemStore_ix2]
  ON [dbo].[ItemStore] ([StoreNo])
  INCLUDE ([Price], [OnHand], [AVGCost], [ListPrice], [ItemStoreID], [ItemNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_OnHandUpdate_Speed_001]
  ON [dbo].[ItemStore] ([OnHand])
  INCLUDE ([ItemNo], [ItemStoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_OnOrder_Speed_001]
  ON [dbo].[ItemStore] ([OnOrder])
  INCLUDE ([ItemNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_Status]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([ItemNo], [MTDQty], [PTDQty], [YTDQty], [DateModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_Status_Speed_005]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([ItemStoreID], [ItemNo], [DepartmentID], [IsTaxable], [IsFoodStampable], [Price], [OnHand], [SaleType], [SalePrice], [SaleEndDate], [SpecialBuy], [SpecialPrice], [MixAndMatchID], [AssignDate])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_StockLevels_Speed_001]
  ON [dbo].[ItemStore] ([StoreNo], [DepartmentID])
  INCLUDE ([ItemStoreID], [ItemNo], [IsDiscount], [IsTaxable], [TaxID], [IsFoodStampable], [IsWIC], [Cost], [ListPrice], [Price], [PriceA], [PriceB], [PriceC], [PriceD], [ExtraCharge1], [ExtraCharge2], [ExtraCharge3], [CogsAccount], [IncomeAccount], [ProfitCalculation], [CommissionQty], [CommissionType], [PrefSaleBy], [PrefOrderBy], [MainSupplierID], [OnOrder], [OnTransferOrder], [OnHand], [ReorderPoint], [RestockLevel], [BinLocation], [OnWorkOrder], [DaysForReturn], [AVGCost], [SaleType], [SalePrice], [SaleStartDate], [SaleEndDate], [SaleMin], [SaleMax], [MinForSale], [SpecialBuy], [SpecialPrice], [SpecialBuyFromDate], [SpecialBuyToDate], [MixAndMatchID], [AssignDate], [Status], [MTDQty], [MTDDollar], [PTDQty], [PTDDollar], [YTDQty], [YTDDollar], [MTDReturnQty], [PTDReturnQty], [YTDReturnQty], [DateCreated], [UserCreated], [DateModified], [UserModified], [TDDate], [TDReturnDate], [NewPrice], [NewPriceDate], [SpecialsMemberOnly], [CasePrice], [CaseSpecial], [PkgPrice], [PkgQty], [IsCaseDiscount], [IsPkgDiscount], [Tare], [RegCost], [LoyaltyGroupID], [LoyaltyGroupFromDate], [LoyaltyGroupToDate], [VoidReason], [LastCount], [CountDate], [CountOnHand], [RegSalePrice], [LastSoldDate], [LastReceivedDate], [LastReceivedQty], [EstimatedCost], [NetCost], [SpecialCost], [ItemStoreInt], [SellOnWeb], [WebCasePrice], [WebPrice], [YTDQty1], [YTDQty2], [YTDQty3], [LastSoldUser], [LastSoldQty], [LastReceivedUser], [TotalSold], [TotalReceive], [TotalProfit], [OnRequest], [Reserved])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_StoreNo]
  ON [dbo].[ItemStore] ([StoreNo])
  INCLUDE ([ItemStoreID], [ItemNo], [DepartmentID], [Cost], [ListPrice], [Price], [PriceA], [PriceB], [PriceC], [PriceD], [PrefSaleBy], [PrefOrderBy], [MainSupplierID], [OnOrder], [OnTransferOrder], [OnHand], [ReorderPoint], [OnWorkOrder], [SaleType], [SalePrice], [SaleStartDate], [SaleEndDate], [SpecialBuy], [SpecialPrice], [MixAndMatchID], [AssignDate], [Status], [MTDQty], [MTDDollar], [PTDQty], [PTDDollar], [YTDQty], [YTDDollar], [PkgPrice], [PkgQty], [RegCost], [NetCost], [SpecialCost], [YTDQty1], [YTDQty2], [YTDQty3])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_StoreNo_Status]
  ON [dbo].[ItemStore] ([StoreNo], [Status])
  INCLUDE ([NewPriceDate], [SpecialsMemberOnly], [CasePrice], [DateModified], [UserModified], [NewPrice], [IsCaseDiscount], [IsPkgDiscount], [Tare], [CaseSpecial], [PkgPrice], [PkgQty], [PTDQty], [PTDDollar], [YTDQty], [AssignDate], [MTDQty], [MTDDollar], [YTDReturnQty], [DateCreated], [UserCreated], [YTDDollar], [MTDReturnQty], [PTDReturnQty], [YTDQty1], [YTDQty2], [YTDQty3], [SellOnWeb], [WebCasePrice], [WebPrice], [TotalProfit], [TotalReceive], [TotalSold], [LastReceivedUser], [LastSoldQty], [LastSoldUser], [LoyaltyGroupToDate], [VoidReason], [RegSalePrice], [RegCost], [LoyaltyGroupID], [LoyaltyGroupFromDate], [EstimatedCost], [NetCost], [SpecialCost], [LastSoldDate], [LastReceivedDate], [LastReceivedQty], [ExtraCharge1], [ExtraCharge2], [ExtraCharge3], [PriceB], [PriceC], [PriceD], [CommissionQty], [CommissionType], [PrefSaleBy], [CogsAccount], [IncomeAccount], [ProfitCalculation], [IsDiscount], [IsTaxable], [TaxID], [ItemStoreID], [ItemNo], [DepartmentID], [ListPrice], [Price], [PriceA], [IsFoodStampable], [IsWIC], [Cost], [SaleMin], [SaleMax], [SaleEndDate], [SalePrice], [SaleStartDate], [MinForSale], [SpecialBuyToDate], [MixAndMatchID], [SpecialBuyFromDate], [SpecialBuy], [SpecialPrice], [SaleType], [OnTransferOrder], [OnHand], [OnOrder], [PrefOrderBy], [MainSupplierID], [ReorderPoint], [DaysForReturn], [AVGCost], [OnWorkOrder], [RestockLevel], [BinLocation])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_StoreNo_Status_DateModified]
  ON [dbo].[ItemStore] ([StoreNo], [Status], [DateModified])
  INCLUDE ([AssignDate], [AVGCost], [BinLocation], [CasePrice], [CaseSpecial], [CogsAccount], [CommissionQty], [CommissionType], [Cost], [DateCreated], [DaysForReturn], [DepartmentID], [EstimatedCost], [ExtraCharge1], [ExtraCharge2], [ExtraCharge3], [IncomeAccount], [IsCaseDiscount], [IsDiscount], [IsFoodStampable], [IsPkgDiscount], [IsTaxable], [IsWIC], [ItemNo], [ItemStoreID], [LastReceivedDate], [LastReceivedQty], [LastReceivedUser], [LastSoldDate], [LastSoldQty], [LastSoldUser], [ListPrice], [LoyaltyGroupFromDate], [LoyaltyGroupID], [LoyaltyGroupToDate], [MainSupplierID], [MinForSale], [MixAndMatchID], [MTDDollar], [MTDQty], [MTDReturnQty], [NetCost], [NewPrice], [NewPriceDate], [OnHand], [OnOrder], [OnTransferOrder], [OnWorkOrder], [PkgPrice], [PkgQty], [PrefOrderBy], [PrefSaleBy], [Price], [PriceA], [PriceB], [PriceC], [PriceD], [ProfitCalculation], [PTDDollar], [PTDQty], [PTDReturnQty], [RegCost], [RegSalePrice], [ReorderPoint], [RestockLevel], [SaleEndDate], [SaleMax], [SaleMin], [SalePrice], [SaleStartDate], [SaleType], [SellOnWeb], [SpecialBuy], [SpecialBuyFromDate], [SpecialBuyToDate], [SpecialCost], [SpecialPrice], [SpecialsMemberOnly], [Tare], [TaxID], [TotalProfit], [TotalReceive], [TotalSold], [UserCreated], [UserModified], [VoidReason], [WebCasePrice], [WebPrice], [YTDDollar], [YTDQty], [YTDQty1], [YTDQty2], [YTDQty3], [YTDReturnQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore_StoreNo_Status0]
  ON [dbo].[ItemStore] ([StoreNo], [Status])
  INCLUDE ([ItemStoreID], [ItemNo], [DateCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemStore000_Speed]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([ItemStoreID], [ItemNo], [StoreNo], [DepartmentID], [IsDiscount], [IsTaxable], [TaxID], [IsFoodStampable], [IsWIC], [Cost], [ListPrice], [Price], [PriceA], [PriceB], [PriceC], [PriceD], [ExtraCharge1], [ExtraCharge2], [ExtraCharge3], [CogsAccount], [IncomeAccount], [ProfitCalculation], [CommissionQty], [CommissionType], [PrefSaleBy], [PrefOrderBy], [MainSupplierID], [OnOrder], [OnTransferOrder], [OnHand], [ReorderPoint], [RestockLevel], [BinLocation], [OnWorkOrder], [DaysForReturn], [AVGCost], [SaleType], [SalePrice], [SaleStartDate], [SaleEndDate], [SaleMin], [SaleMax], [MinForSale], [SpecialBuy], [SpecialPrice], [SpecialBuyFromDate], [SpecialBuyToDate], [MixAndMatchID], [AssignDate], [MTDQty], [MTDDollar], [PTDQty], [PTDDollar], [YTDQty], [YTDDollar], [MTDReturnQty], [PTDReturnQty], [YTDReturnQty], [DateCreated], [UserCreated], [DateModified], [UserModified], [TDDate], [TDReturnDate], [NewPrice], [NewPriceDate], [SpecialsMemberOnly], [CasePrice], [CaseSpecial], [PkgPrice], [PkgQty], [IsCaseDiscount], [IsPkgDiscount], [Tare], [RegCost], [LoyaltyGroupID], [LoyaltyGroupFromDate], [LoyaltyGroupToDate], [VoidReason], [LastCount], [CountDate], [CountOnHand], [RegSalePrice], [LastSoldDate], [LastReceivedDate], [LastReceivedQty], [EstimatedCost], [NetCost], [SpecialCost], [ItemStoreInt], [SellOnWeb], [WebCasePrice], [WebPrice], [YTDQty1], [YTDQty2], [YTDQty3], [LastReceivedUser], [LastSoldQty], [LastSoldUser], [TotalProfit], [TotalReceive], [TotalSold], [OnRequest])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [Ix_OnHandQuery_012]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([ItemNo], [StoreNo], [OnHand])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_ItemStore_21DEC56]
  ON [dbo].[ItemStore] ([TaxID])
  INCLUDE ([DateModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_ItemStore_DFBB071E1D7B1B923B74BE392A1F3D38]
  ON [dbo].[ItemStore] ([Status])
  INCLUDE ([ItemNo], [OnHand], [OnOrder])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_ItemStore_F479175348FA29BAF27AF8720D738AAB]
  ON [dbo].[ItemStore] ([Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_PriceCostHistoryOnItemStore] on [dbo].[ItemStore]
for  update
as

if   Update (Cost) or Update (Price) or Update (SalePrice) 
BEGIN


    -- possible error occurs here...

Declare @UpdateTime datetime
SELECT @UpdateTime = dbo.GetLocalDATE()


Declare @OldCost money
Declare @OldPrice money
Declare @OldPriceA money
Declare @OldPriceB money
Declare @OldPriceC money
Declare @OldPriceD money
declare @OldDateModified datetime
declare @OldSaleType integer
declare @OldSalePrice money
Declare @OldSaleStartDate Datetime
Declare @OldSaleEndDate Datetime
declare @OldSpecialBuy Int
declare @oldSpecialPrice money
declare @oldAssignDate bit
declare @ItemStoreIDDel uniqueidentifier






Declare @ItemStoreID uniqueidentifier
Declare @ItemNo uniqueidentifier
Declare @StoreNo uniqueidentifier
Declare @Cost money =NULL 
Declare @ListPrice money =0 
Declare @Price money 
Declare @PriceA money =0 
Declare @PriceB money =0 
Declare @PriceC money =0 
Declare @PriceD money =0 
Declare @SaleType int=null 
Declare @SalePrice money=0 
Declare @SaleStartDate  datetime=null 
Declare @SaleEndDate datetime=null 
Declare @SaleMin int=null 
Declare @SaleMax int=null 
Declare @SpecialBuy int=null 
Declare @SpecialPrice money=null 
Declare @AssignDate bit=null 
Declare @ModifierID uniqueidentifier


DECLARE DelEntry CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	
SELECT  
ItemStoreID, 
 Price,
	PriceA,
	 PriceB,
	 PriceC,
	PriceD,
    DateModified,
    SaleType,
	SalePrice,
    SaleStartDate,
    SaleEndDate,
	SpecialBuy,
	SpecialPrice,
	 Cost
From deleted
	
	OPEN DelEntry
	
	FETCH NEXT FROM DelEntry 
	INTO 
	@ItemStoreIDDel,
	@OldPrice ,
	@OldPriceA ,
	@OldPriceB ,
	@OldPriceC ,
	@OldPriceD,
	@OldDateModified ,
	@OldSaleType ,
	@OldSalePrice,
    @OldSaleStartDate ,
    @OldSaleEndDate ,
	@OldSpecialBuy ,
	@oldSpecialPrice ,
	@OldCost 
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
	






--Select the New Records
select @ItemStoreID=ItemStoreID, @ItemNo=ItemNo, @StoreNo=StoreNo, @Cost=Cost, @ListPrice=ListPrice, @Price=Price, @PriceA=PriceA, @PriceB=PriceB,   
@PriceC=PriceC, @PriceD=PriceD, @SaleType=SaleType, @SalePrice=SalePrice, @SaleStartDate=SaleStartDate, @SaleEndDate=SaleEndDate, @SaleMin=SaleMin,
@SaleMax=SaleMax, @SpecialBuy=SpecialBuy, @SpecialPrice=SpecialPrice, @AssignDate=AssignDate, @ModifierID=UserModified
from inserted 
where ItemStoreID=@ItemStoreIDDel



IF @Cost<>@OldCost
begin 
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date], Status)
VALUES (NEWID(),@ItemStoreID,'Cost',@OldCost,@Cost,@ModifierID,@UpdateTime,1)
end 
IF @Price<>@OldPrice
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date], Status)
VALUES (NEWID(),@ItemStoreID,'Price',@OldPrice,@Price,@ModifierID,@UpdateTime,1)

IF @PriceA<>@OldPriceA
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date], Status)
VALUES (NEWID(),@ItemStoreID,'Price A',@OldPriceA,@PriceA,@ModifierID,@UpdateTime,1)

IF @PriceB<>@OldPriceB
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date], Status)
VALUES (NEWID(),@ItemStoreID,'Price B',@OldPriceB,@PriceB,@ModifierID,@UpdateTime,1)

IF @PriceC<>@OldPriceC
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date], Status)
VALUES (NEWID(),@ItemStoreID,'Price C',@OldPriceC,@PriceC,@ModifierID,@UpdateTime,1)

IF @PriceD<>@OldPriceD
INSERT INTO dbo.PriceChangeHistory(PriceChangeHistoryID,ItemStoreID,PriceLevel,OldPrice,NewPrice,UserID,[Date], Status)
VALUES (NEWID(),@ItemStoreID,'Price D',@OldPriceD,@PriceD,@ModifierID,@UpdateTime,1)

	IF 	(@OldSaleType <> @SaleType)or
		(@OldSalePrice <> @SalePrice)or
		(@OldSaleStartDate <> @SaleStartDate)or
		(@OldSaleEndDate <> @SaleEndDate) or
		(@OldSpecialBuy <> @SpecialBuy)or
		(@oldSpecialPrice <> @SpecialPrice)or
		(@oldAssignDate <> @AssignDate)
	BEGIN
		INSERT INTO dbo.PriceChangeHistory
							  (PriceChangeHistoryID, ItemStoreID,OldPrice, UserID, Date, SaleType, SP_Price, SaleDate, status, DateCreated)
		VALUES     (NEWID(),@ItemStoreID,@Price,@ModifierID,@UpdateTime,
/*SaleType */		 (CASE WHEN @SaleType =1 Then 'Reg Sale' WHEN @SaleType =2 then 'Break Down'WHEN @SaleType =4 then 'Combined' ELSE 'None' END),
/*SalePrice */		 (CASE WHEN @SaleType = 1 THEN CASE WHEN ISNULL(@AssignDate, 0) 
                      > 0 THEN CASE WHEN (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) 
                      END ELSE '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) END WHEN @SaleType = 2 AND ((ISNULL(@AssignDate, 0) > 0) AND 
                      (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(@AssignDate, 0) = 0)) THEN CONVERT(nvarchar, @SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, @SpecialPrice, 110) 
                       WHEN @SaleType = 4 AND ((ISNULL(@AssignDate, 0) > 0) AND (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(@AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) + ' , ' + CONVERT(nvarchar, @SpecialBuy, 
                      110) + ' @ ' + CONVERT(nvarchar, @SpecialPrice, 110) END) , 
/*SaleDate */		  (CASE WHEN @AssignDate =1 Then CONVERT(nvarchar, @SaleStartDate, 110)+' - '+ CONVERT(nvarchar, @SaleEndDate, 110) ELSE '' END), 
		  1, dbo.GetLocalDATE())
	END



		FETCH NEXT FROM DelEntry   
			INTO 
			@ItemStoreIDDel,
			@OldPrice ,
	@OldPriceA ,
	@OldPriceB ,
	@OldPriceC ,
	@OldPriceD,
	@OldDateModified ,
	@OldSaleType ,
	@OldSalePrice,
    @OldSaleStartDate ,
    @OldSaleEndDate ,
	@OldSpecialBuy ,
	@oldSpecialPrice ,
	@OldCost 
		END
	
	CLOSE DelEntry


	--END TRY
--BEGIN CATCH
--insert into  [dbo].[sqlStatmentLog](sqlString)
--values ( 'Error on line ' + CAST(ERROR_LINE() AS VARCHAR(10)) +ERROR_MESSAGE())
   
--END CATCH
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteItemStore] on [dbo].[ItemStore]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT ItemStoreID, 'ItemsQuery' , Status, dbo.GetLocalDATE() , 1,'ItemStoreID' FROM      inserted
  end

IF update (Status) AND ((select count(0) from inserted WHERE STATUS >0) > 0)
Begin
Delete From DeleteRecordes Where TableID IN (Select CONVERT(nvarchar(50),ItemStoreID) From inserted)
End
if   Update (Status)
Begin

Declare @ActivityID Uniqueidentifier
Declare @ActivityNo int
Declare @TableName int

--RDT-129 Delete item: application error when item has history 
-- 6 Dec 2017, 
--SELECT @ActivityID = NewID()
set @ActivityNo = 1
set @TableName = 1

--Alex Abreu
--Insert the Activity 
INSERT INTO [dbo].[Activity]
           ([ActivityID]
           ,[ActivityNo]
           ,[TableName]
           ,[UserID]
           ,[Status]
           ,[Description]
		   ,[RowID])
    
           SELECT NewID(),@ActivityNo,@TableName,UserModified,Status, CASE WHEN Status > 0 Then 'Activated' WHEN Status < 0 THEN ' Deleted' ELSE 'Inactivated' End  ,ItemNo From inserted

End
GO



























































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO