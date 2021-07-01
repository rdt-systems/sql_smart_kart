SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[QSP_GetItemsInStock]
(@Filter nvarchar(4000))

AS
Declare @MySelect  nvarchar (3888)
Set @MySelect = '
  SELECT  distinct   dbo.SearchForItemReport.Name,dbo.SearchForItemReport.Description,dbo.SearchForItemReport.Price,dbo.SearchForItemReport.BarcodeNumber,dbo.SearchForItemReport.Quantization,dbo.SearchForItemReport.OnHand,dbo.SearchForItemReport.RestockLevel,dbo.SearchForItemReport.ReorderPoint
FROM         dbo.SearchForItemReport
WHERE 1=1'

 Execute (@MySelect + @Filter )
GO