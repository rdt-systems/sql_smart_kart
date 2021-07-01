SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[StoreView]
AS
SELECT        StoreID, StoreName, StoreDescription, ParentStore, DefaultMarkup, DefaultMarkupA, DefaultMarkupB, DefaultMarkupC, DefaultMarkupD, RoundUp, 
                         RoundValue, DefaultCogsAccount, DefaultIncomeAccount, DefaultTaxNo, IsDefaultTaxInclude, DefaultProfitCalculation, StoreEmail, Logo, Status, DateCreated, 
                         UserCreated, DateModified, UserModified, IsMainStore, Address, CityStateZip, Country, DateClosed, DateOpened, DistrictID, Fax, Phone1, Phone2, RegionID, 
                         StoreNumber, CashDiscount
FROM            dbo.Store
GO