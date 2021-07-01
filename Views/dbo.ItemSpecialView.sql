SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemSpecialView]
    with schemabinding
AS
SELECT        dbo.ItemSpecial.ItemSpecialID, dbo.ItemSpecial.ItemStoreID, ISNULL(dbo.ItemSpecial.SaleType,1) AS SaleType, dbo.ItemSpecial.SalePrice, dbo.ItemSpecial.SaleStartDate, 
                         dbo.ItemSpecial.SaleEndDate, dbo.ItemSpecial.SaleMin, dbo.ItemSpecial.SaleMax, dbo.ItemSpecial.MinForSale, dbo.ItemSpecial.SpecialBuy, 
                         dbo.ItemSpecial.SpecialPrice, dbo.ItemSpecial.AssignDate, dbo.ItemSpecial.Status, dbo.ItemSpecial.DateCreated, dbo.ItemSpecial.UserCreated, 
                         dbo.ItemSpecial.DateModified, dbo.ItemSpecial.UserModified, dbo.ItemStore.StoreNo
FROM            dbo.ItemSpecial INNER JOIN
                         dbo.ItemStore ON dbo.ItemSpecial.ItemStoreID = dbo.ItemStore.ItemStoreID
WHERE        (dbo.ItemSpecial.Status > - 1)
GO