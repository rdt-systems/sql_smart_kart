SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE view [dbo].[SalesQuery]
AS
SELECT DISTINCT 
          CONVERT(nvarchar(200), dbo.Sales.SaleID) + CONVERT(nvarchar(200), dbo.ItemStore.ItemStoreID) /*COLLATE HEBREW_CI_AS*/ as ID, 
		  dbo.Sales.SaleID, dbo.Sales.SaleNo,dbo.Sales.SaleName, dbo.Sales.FromDate, dbo.Sales.ToDate, 
          dbo.Sales.BuyQty, dbo.Sales.GetQty, dbo.Sales.MaxQty, dbo.Sales.MinTotalAmount,dbo.Sales.MinTotalQty, 
          dbo.Sales.SaleType, dbo.Sales.Price, dbo.Sales.Percentage, dbo.Sales.AmountLess, dbo.Sales.Priority, 
          dbo.Sales.AllowMultiSales, dbo.Sales.IsGeneral, dbo.Sales.IsCoupon, dbo.SalesBaskets.BasketID, dbo.SalesBaskets.BaskItemID, 
          dbo.SalesBaskets.BaskActionType, dbo.SalesBaskets.BaskItemType, dbo.SalesBaskets.QtyBasket, dbo.SalesBaskets.MinQty, 
          dbo.ItemStore.ItemStoreID, dbo.SaleTimes.Sunday, dbo.SaleTimes.SunFrom, dbo.SaleTimes.SunTo, dbo.SaleTimes.Munday, dbo.SaleTimes.MunFrom, 
          dbo.SaleTimes.MunTo, dbo.SaleTimes.Tuesday, dbo.SaleTimes.TueFrom, dbo.SaleTimes.TueTo, dbo.SaleTimes.Wednesday, 
          dbo.SaleTimes.WedFrom, dbo.SaleTimes.WedTo, dbo.SaleTimes.Thursday, dbo.SaleTimes.ThuFrom, dbo.SaleTimes.ThuTo, dbo.SaleTimes.Friday, 
          dbo.SaleTimes.FriFrom, dbo.SaleTimes.FriTo, dbo.SaleTimes.Saterday, dbo.SaleTimes.SatFrom, dbo.SaleTimes.SatTo, 
          ISNULL((SELECT DISTINCT 1 AS Expr1
                  FROM         dbo.SaleToClub
                  WHERE     (SaleID = dbo.Sales.SaleID)), 0) AS IsClub, 
          ISNULL((SELECT DISTINCT 1 AS Expr1
                  FROM         dbo.SaleToTender
                  WHERE     (SaleID = dbo.Sales.SaleID)), 0) AS IsTender, dbo.Sales.DateModified
          ,dbo.DoInSale(Sales.SaleID) DoInSale
FROM	  dbo.Sales INNER JOIN
                      dbo.SalesBaskets ON dbo.Sales.SaleID = dbo.SalesBaskets.SaleID LEFT OUTER JOIN
                      dbo.SaleTimes ON dbo.Sales.SaleID = dbo.SaleTimes.SaleID AND dbo.SaleTimes.Status > 0 LEFT OUTER JOIN
                      dbo.ItemMain ON dbo.ItemMain.ItemID = dbo.SalesBaskets.BaskItemID LEFT OUTER JOIN
                      dbo.ItemStore ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID
WHERE     (dbo.Sales.Status > 0) AND (dbo.SalesBaskets.Status > 0) AND (dbo.Sales.FromDate < DATEADD(day, 1, dbo.GetLocalDATE())) AND 
                      (dbo.Sales.ToDate > DATEADD(day, - 1, dbo.GetLocalDATE()))

--select * from SalesQuery
GO