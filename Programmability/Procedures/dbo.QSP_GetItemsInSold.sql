SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[QSP_GetItemsInSold]
(@Filter nvarchar(4000))

AS
Declare @MySelect  nvarchar (3888)
Set @MySelect = '
  SELECT    distinct dbo.RptItemsSold.Name,dbo.RptItemsSold.Description,dbo.RptItemsSold.Price,dbo.RptItemsSold.BarcodeNumber,dbo.RptItemsSold.OnHand,dbo.RptItemsSold.Cost,dbo.RptItemsSold.TransactionNo,dbo.RptItemsSold.Qty,dbo.RptItemsSold.TransactionType,dbo.RptItemsSold.PriceEntry
FROM         dbo.RptItemsSold
WHERE    1=1 '

 Execute (@MySelect + @Filter)
GO