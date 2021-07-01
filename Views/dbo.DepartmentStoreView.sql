SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[DepartmentStoreView]
AS
SELECT     DepartmentStoreID, Name, Description, ParentDepartmentID, StoreID, DefaultMarkup, DefaultMarkupA, DefaultMarkupB, DefaultMarkupC, DefaultMarkupD, RoundUp, 
                      RoundUpA, RoundUpB, RoundUpC, RoundUpD, RoundValue, RoundValueA, RoundValueB, RoundValueC, RoundValueD, DefaultCogsAccount, DefaultIncomeAccount, 
                      DefaultTaxNo, IsDefaultTaxInclude, IsDefaultFoodStampable, IsDefaultDiscountable, DefaultProfitCalculation, Status, DateCreated, UserCreated, DateModified, 
                      UserModified, KeyNumber, DepartmentNo, DiscountID
FROM         dbo.DepartmentStore
GO