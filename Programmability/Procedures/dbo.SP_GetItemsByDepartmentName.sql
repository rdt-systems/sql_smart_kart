SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemsByDepartmentName]
(@DepartmentName nvarchar(50))

--AS SELECT     ItemID, Name, OnOrder, OnHand, OnSaleOrder, Cost, Cost * OnHand AS ExtCost, DepartmentID, Department, Price, Price * OnHand AS ExtPrice,
              --            (SELECT     CASE WHEN Price = 0 THEN 0 ELSE (Price - Cost) / Price * 100 END) AS Margin,
               --           (SELECT     CASE WHEN Cost = 0 THEN 0 ELSE (Price - Cost) / Cost * 100 END) AS Markup, Price * OnHand - Cost * OnHand AS Profit
--FROM         dbo.ItemPiece
--WHERE     (StoreNo = @StoreID) AND (DepartmentID = @DepartmentID)

AS SELECT    BarcodeNumber,[Name],Price,ItemID,OnHand
FROM         dbo.ItemMainAndStoreView
where department=@DepartmentName
--WHERE     (DepartmentID = @DepartmentID)
GO