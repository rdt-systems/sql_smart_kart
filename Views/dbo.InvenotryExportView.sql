SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[InvenotryExportView]
AS
Select 
M.BarcodeNumber AS UPC, 
I.Price AS Price,
ISNULL((CASE WHEN (I.SaleType IN (1, 5, 12)) 
THEN CASE WHEN ISNULL(I.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(I.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
THEN '1 @ $' + CONVERT(nvarchar, I.SalePrice, 110) END ELSE '1 @ $' + CONVERT(nvarchar, I.SalePrice, 110) 
END WHEN (I.SaleType IN (2, 6, 13)) AND ((ISNULL(I.AssignDate, 0) > 0) AND (dbo.GetDay(I.SaleEndDate) 
>= dbo.GetDay(dbo.GetLocalDATE())) OR
(ISNULL(I.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, I.SpecialBuy, 110) + ' @ $' + CONVERT(nvarchar, I.SpecialPrice, 110) 
WHEN I.SaleType = 3 THEN 'MIX ' + X.Name + ' ' + CONVERT(nvarchar, X.Qty, 110) + ' @ $' + CONVERT(nvarchar, 
X.Amount, 110) WHEN (I.SaleType IN (4, 11, 18)) AND ((ISNULL(I.AssignDate, 0) > 0) AND 
(dbo.GetDay(I.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
(ISNULL(I.AssignDate, 0) = 0)) THEN '1 @ $' + CONVERT(nvarchar, I.SalePrice, 110) + ' , ' + CONVERT(nvarchar, I.SpecialBuy, 
110) + ' @ $' + CONVERT(nvarchar, I.SpecialPrice, 110) END),'') AS SalePrice,
I.OnHand AS Qty,
S.StoreName
From 
dbo.[ItemMain] AS M INNER JOIN dbo.[ItemStore] AS I 
ON M.ItemID = I.ItemNo
INNER JOIN dbo.[Store] AS S ON I.StoreNo = S.StoreID LEFT OUTER JOIN dbo.[MixAndMatch] AS X
ON I.MixAndMatchID = X.MixAndMatchID
Where I.Status > 0 and M.Status > 0 and S.Status > 0 
GO