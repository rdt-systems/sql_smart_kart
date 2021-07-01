SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[QSP_GetItemsInOrder]
(@Filter nvarchar(4000))

AS
Declare @MySelect  nvarchar (3888)
Set @MySelect = '
  SELECT    distinct dbo.RptOrdersItem.Name,dbo.RptOrdersItem.PoNo,dbo.RptOrdersItem.OrderDate,dbo.RptOrdersItem.QtyOrdered,dbo.RptOrdersItem.SupplierName,dbo.RptOrdersItem.PricePerUnit,dbo.RptOrdersItem.BarcodeNumber

FROM         dbo.RptOrdersItem
WHERE 1=1'

 Execute (@MySelect + @Filter )
GO