SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemStoreView]
    with schemabinding
AS
SELECT        TOP (100) PERCENT i.ItemStoreID, i.ItemNo, i.StoreNo, i.DepartmentID, i.IsDiscount, i.IsTaxable, i.IsFoodStampable, i.IsWIC, 
                         i.Cost, ISNULL(i.ListPrice, 0) AS ListPrice, ISNULL(i.Price, 0) AS Price, ISNULL(i.PriceA, 0) AS PriceA, ISNULL(i.PriceB, 0) AS PriceB, ISNULL(i.PriceC, 0) 
                         AS PriceC, ISNULL(i.PriceD, 0) AS PriceD, i.ExtraCharge1, i.ExtraCharge2, i.ExtraCharge3, i.CogsAccount, i.IncomeAccount, i.ProfitCalculation, 
                         i.CommissionQty, i.CommissionType, i.PrefSaleBy, i.PrefOrderBy, i.MainSupplierID, i.OnOrder, i.OnHand, i.ReorderPoint, 
                         i.RestockLevel, i.BinLocation, i.OnWorkOrder, i.DaysForReturn, i.NewPrice, i.NewPriceDate, i.AVGCost, i.SaleType, i.SalePrice, 
                         i.SaleStartDate, i.SaleEndDate, i.SaleMin, i.SaleMax, i.MinForSale, i.SpecialBuy, i.SpecialPrice, i.SpecialBuyFromDate, 
                         i.SpecialBuyToDate, i.MixAndMatchID, i.AssignDate, i.Status, i.MTDQty, i.MTDDollar, i.PTDQty, i.PTDDollar, i.YTDQty, 
                         i.YTDDollar, i.MTDReturnQty, i.PTDReturnQty, i.YTDReturnQty, i.DateCreated, i.UserCreated, i.DateModified, i.UserModified, 
                         ISNULL(PriceChange.LastPriceChange, i.DateCreated) AS LastPriceChange, i.OnTransferOrder, i.SpecialsMemberOnly, i.CasePrice, i.PkgQty, i.PkgPrice, 
                         i.Tare, i.TaxID, i.RegCost, i.LoyaltyGroupID, i.LoyaltyGroupFromDate, i.LoyaltyGroupToDate, i.VoidReason, (CASE WHEN (ISNULL(Price, 0) > 0 AND 
                         ISNULL(ListPrice, 0) > 0) THEN (1 - (Price / ListPrice)) * 100 ELSE 0 END) AS ListPriceMarkdown, i.IsPkgDiscount, i.IsCaseDiscount, i.CaseSpecial, i.LastReceivedDate, 
                         i.LastReceivedQty, i.LastSoldDate, i.RegSalePrice, isnull(i.SpecialCost,0) as SpecialCost , isnull(i.NetCost,0)as NetCost ,isnull(i.EstimatedCost,0)as EstimatedCost,
						 i.WebPrice,i.WebCasePrice,i.SellOnWeb,i.YTDQty1,i.YTDQty2,i.YTDQty3,i.LastSoldUser,i.LastSoldQty,i.LastReceivedUser,i.TotalSold,i.TotalReceive,i.TotalProfit, i.OnRequest, i.Reserved
FROM            dbo.ItemStore i LEFT OUTER JOIN
                             (SELECT        ItemStoreID, MAX(Date) AS LastPriceChange
                               FROM            dbo.PriceChangeHistory
                               GROUP BY ItemStoreID) AS PriceChange ON PriceChange.ItemStoreID = i.ItemStoreID
WHERE        (i.StoreNo IN
                             (SELECT        StoreID
                               FROM            dbo.Store
                               WHERE        (Status > 0)))
GO