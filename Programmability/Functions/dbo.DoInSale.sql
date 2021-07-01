SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE function [dbo].[DoInSale](@SaleID uniqueidentifier) 
returns bit as
begin


if (Select SaleType from Sales where SaleID = @saleID )=3 --BO
  return 0
if (Select SaleType from Sales where SaleID = @saleID )=2 --Price For Last
    and (Select count(Price) from SalesBaskets Inner Join ItemStore 
                             On ItemStore.ItemNo=SalesBaskets.BaskItemID
							 Where SaleID=@SaleID)>1
  return 0
if
(
	SELECT count(*)
	FROM SalesBaskets  inner join Sales On Sales.SaleID=SalesBaskets.SaleID
                       inner join SaleToStore On Sales.SaleID=SaleToStore.SaleID
	WHERE
	SalesBaskets.status>0 
	and Sales.Status>0 
	and SalesBaskets.SaleID<> @SaleID 
	and (SalesBaskets.BaskItemID in (Select BaskItemID 
                                    from SalesBaskets 
                                    where SaleID=@SaleID and Status>0)
         or Sales.IsGeneral=1)
    and (AllowMultiSales=0 or (select AllowMultiSales from sales where saleid=@SaleID)=0)
    and dbo.Sales.FromDate < DATEADD(day, 1, dbo.GetLocalDATE())
    and dbo.Sales.ToDate > DATEADD(day, -1, dbo.GetLocalDATE())
    and SaleToStore.StoreID in (Select StoreID 
                                From  SaleToStore
                                Where SaleID=@SaleID)
 ) >0   
 return 0   

return 1
		
end
GO