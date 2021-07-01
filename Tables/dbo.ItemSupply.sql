CREATE TABLE [dbo].[ItemSupply] (
  [ItemSupplyID] [uniqueidentifier] NOT NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [SupplierNo] [uniqueidentifier] NULL,
  [TotalCost] [money] NULL,
  [GrossCost] [money] NULL,
  [MinimumQty] [int] NULL,
  [QtyPerCase] [int] NULL,
  [IsOrderedOnlyInCase] [bit] NULL,
  [AverageDeliveryDelay] [int] NULL,
  [ItemCode] [nvarchar](50) NULL,
  [IsMainSupplier] [bit] NULL,
  [SortOrder] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [CaseQty] [decimal] NULL,
  [SalePrice] [money] NULL,
  [AssignDate] [bit] NULL,
  [FromDate] [datetime] NULL,
  [ToDate] [datetime] NULL,
  [OnSpecialReq] [bit] NULL,
  [MinQty] [int] NULL,
  [MaxQty] [int] NULL,
  [UOMType] [int] NULL,
  [ColorName] [nvarchar](50) NULL,
  CONSTRAINT [PK_ItemSupply] PRIMARY KEY CLUSTERED ([ItemSupplyID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_ItemSupply_5_238623893__K3_K12_K10]
  ON [dbo].[ItemSupply] ([SupplierNo], [Status], [IsMainSupplier])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemSupply_5_718625603__K3_K11_K13_K1_10]
  ON [dbo].[ItemSupply] ([SupplierNo], [IsMainSupplier], [Status], [ItemSupplyID])
  INCLUDE ([ItemCode])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemSupply_Status]
  ON [dbo].[ItemSupply] ([Status])
  INCLUDE ([ItemStoreNo], [SupplierNo], [TotalCost], [GrossCost], [MinimumQty], [QtyPerCase], [IsOrderedOnlyInCase], [AverageDeliveryDelay], [ItemCode], [IsMainSupplier], [SortOrder], [DateCreated], [UserCreated], [DateModified], [UserModified], [CaseQty], [SalePrice], [AssignDate], [FromDate], [ToDate], [OnSpecialReq], [MinQty], [MaxQty], [ColorName])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemSupply_TransactionEntryItem_Speed_1]
  ON [dbo].[ItemSupply] ([SupplierNo], [Status])
  INCLUDE ([ItemStoreNo], [ItemCode])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE UNIQUE INDEX [IX_ItemSupplyItemSupplier]
  ON [dbo].[ItemSupply] ([ItemStoreNo], [SupplierNo])
  WHERE ([Status]>(0))
GO

CREATE UNIQUE INDEX [IX_ItemSupplyMainSupplier]
  ON [dbo].[ItemSupply] ([ItemStoreNo], [IsMainSupplier])
  WHERE ([Status]>(0) AND [IsMainSupplier]=(1))
GO

CREATE INDEX [IX_Supplier_Main_Mis]
  ON [dbo].[ItemSupply] ([IsMainSupplier], [Status])
  INCLUDE ([ItemStoreNo], [SupplierNo], [TotalCost], [GrossCost], [MinimumQty], [QtyPerCase], [IsOrderedOnlyInCase], [AverageDeliveryDelay], [ItemCode], [SortOrder], [DateCreated], [UserCreated], [DateModified], [UserModified], [CaseQty], [SalePrice], [AssignDate], [FromDate], [ToDate], [OnSpecialReq], [MinQty], [MaxQty], [UOMType], [ColorName])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IxItemSupply_Speed_001]
  ON [dbo].[ItemSupply] ([Status])
  INCLUDE ([AssignDate], [AverageDeliveryDelay], [CaseQty], [ColorName], [DateCreated], [DateModified], [FromDate], [GrossCost], [IsMainSupplier], [IsOrderedOnlyInCase], [ItemCode], [ItemStoreNo], [ItemSupplyID], [MaxQty], [MinimumQty], [MinQty], [OnSpecialReq], [QtyPerCase], [SalePrice], [SortOrder], [SupplierNo], [ToDate], [TotalCost], [UOMType], [UserCreated], [UserModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [missing_index_4063_4062_ItemSupply]
  ON [dbo].[ItemSupply] ([ItemStoreNo], [IsMainSupplier], [Status])
  INCLUDE ([DateModified], [ItemCode], [ItemSupplyID], [SupplierNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [missing_index_4065_4064_ItemSupply]
  ON [dbo].[ItemSupply] ([IsMainSupplier], [Status])
  INCLUDE ([DateModified], [ItemCode], [ItemStoreNo], [ItemSupplyID], [SupplierNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
CREATE TRIGGER [TR_MainSupplier] On [dbo].[ItemSupply]
   AFTER INSERT,UPDATE
AS 

IF Update (Status) AND ((select count(0) from inserted WHERE IsMainSupplier = 1 and Status >0) > 0)

BEGIN

-------
insert into ItemSupplyLog (ItemSupplyID, ItemStoreNo, SupplierNo, TotalCost, GrossCost, MinimumQty, QtyPerCase, IsOrderedOnlyInCase, AverageDeliveryDelay, ItemCode, IsMainSupplier, SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified, CaseQty, SalePrice, AssignDate, FromDate, ToDate, OnSpecialReq, MinQty, MaxQty, UOMType, ColorName, datecreatedlog, step)
select i.ItemSupplyID,
i. ItemStoreNo,
i. SupplierNo,
i. TotalCost,
i. GrossCost,
i. MinimumQty,
i. QtyPerCase,
i. IsOrderedOnlyInCase,
i. AverageDeliveryDelay,
i. ItemCode,
i. IsMainSupplier,
i. SortOrder,
i. Status,
i. DateCreated,
i. UserCreated,
i. DateModified,
i. UserModified,
i. CaseQty,
i. SalePrice,
i. AssignDate,
i. FromDate,
i. ToDate,
i. OnSpecialReq,
i. MinQty,
i. MaxQty,
i. UOMType,
i. ColorName,
dbo.GetLocalDATE(),7
from   ItemSupply AS T INNER JOIN
                         Inserted AS I ON T.ItemStoreNo = I.ItemStoreNo
WHERE        (T.ItemSupplyID <> I.ItemSupplyID) AND (ISNULL(T.IsMainSupplier, 0) = 1)

------------
Update ItemSupply Set IsMainSupplier =0, DateModified = dbo.GetLocalDATE()       
FROM            ItemSupply AS T INNER JOIN
                         Inserted AS I ON T.ItemStoreNo = I.ItemStoreNo
WHERE        (T.ItemSupplyID <> I.ItemSupplyID) AND (ISNULL(T.IsMainSupplier, 0) = 1)

----------------
insert into itemstoreLog (ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue)
select IT.ItemStoreID,
IT.ItemNo,
IT.StoreNo,
IT.DepartmentID,
IT.IsDiscount,
IT.IsTaxable,
IT.TaxID,
IT.IsFoodStampable,
IT.IsWIC,
IT.Cost,
IT.ListPrice,
IT.Price,
IT.PriceA,
IT.PriceB,
IT.PriceC,
IT.PriceD,
IT.ExtraCharge1,
IT.ExtraCharge2,
IT.ExtraCharge3,
IT.CogsAccount,
IT.IncomeAccount,
IT.ProfitCalculation,
IT.CommissionQty,
IT.CommissionType,
IT.PrefSaleBy,
IT.PrefOrderBy,
IT.MainSupplierID,
IT.OnOrder,
IT.OnTransferOrder,
IT.OnHand,
IT.ReorderPoint,
IT.RestockLevel,
IT.BinLocation,
IT.OnWorkOrder,
IT.DaysForReturn,
IT.AVGCost,
IT.SaleType,
IT.SalePrice,
IT.SaleStartDate,
IT.SaleEndDate,
IT.SaleMin,
IT.SaleMax,
IT.MinForSale,
IT.SpecialBuy,
IT.SpecialPrice,
IT.SpecialBuyFromDate,
IT.SpecialBuyToDate,
IT.MixAndMatchID,
IT.AssignDate,
IT.Status,
IT.MTDQty,
IT.MTDDollar,
IT.PTDQty,
IT.PTDDollar,
IT.YTDQty,
IT.YTDDollar,
IT.MTDReturnQty,
IT.PTDReturnQty,
IT.YTDReturnQty,
IT.DateCreated,
IT.UserCreated,
IT.DateModified,
IT.UserModified,
IT.TDDate,
IT.TDReturnDate,
IT.NewPrice,
IT.NewPriceDate,
IT.SpecialsMemberOnly,
IT.CasePrice,
IT.CaseSpecial,
IT.PkgPrice,
IT.PkgQty,
IT.IsCaseDiscount,
IT.IsPkgDiscount,
IT.Tare,
IT.RegCost,
IT.LoyaltyGroupID,
IT.LoyaltyGroupFromDate,
IT.LoyaltyGroupToDate,
IT.VoidReason,
IT.LastCount,
IT.CountDate,
IT.CountOnHand,
IT.RegSalePrice,
IT.LastSoldDate,
IT.LastReceivedDate,
IT.LastReceivedQty,
IT.SpecialCost,
IT.NetCost,
IT.EstimatedCost,
dbo.GetLocalDATE(),8,I.ItemSupplyID
  from  ItemStore AS IT INNER JOIN
                         Inserted AS I ON IT.ItemStoreID = I.ItemStoreNo
Where ISNULL(IT.MainSupplierID,'00000000-0000-0000-0000-000000000000') <> I.ItemSupplyID
-----------------------

Update ItemStore Set MainSupplierID = I.ItemSupplyID, DateModified = dbo.GetLocalDATE()      
FROM            ItemStore AS IT INNER JOIN
                         Inserted AS I ON IT.ItemStoreID = I.ItemStoreNo
Where ISNULL(IT.MainSupplierID,'00000000-0000-0000-0000-000000000000') <> I.ItemSupplyID

END
GO

ALTER TABLE [dbo].[ItemSupply] WITH NOCHECK
  ADD CONSTRAINT [FK_ItemSupply_ItemStore] FOREIGN KEY ([ItemStoreNo]) REFERENCES [dbo].[ItemStore] ([ItemStoreID])
GO