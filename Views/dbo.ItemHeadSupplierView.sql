SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






CREATE VIEW [dbo].[ItemHeadSupplierView]
WITH SCHEMABINDING 
AS
SELECT     [ItemSupplyID]
      ,[ItemStoreNo]
      ,[SupplierNo]
      ,[TotalCost]
      ,[GrossCost]
      ,[MinimumQty]
      ,[QtyPerCase]
      ,[IsOrderedOnlyInCase]
      ,[AverageDeliveryDelay]
      ,[ItemCode]
      ,[IsMainSupplier]
      ,[SortOrder]
      ,[Status]
      ,[DateCreated]
      ,[UserCreated]
      ,[DateModified]
      ,[UserModified]
      ,[CaseQty]
      ,[SalePrice]
      ,[AssignDate]
      ,[FromDate]
      ,[ToDate]
      ,[OnSpecialReq]
      ,[MinQty]
      ,[MaxQty]
      ,[UOMType]
	  ,[ColorName]
FROM         dbo.ItemSupply
WHERE     (IsMainSupplier = 1) AND (Status > - 1)
GO