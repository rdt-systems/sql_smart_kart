SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[QSP_GetItems]
(@Filter nvarchar(4000))

AS
Declare @MySelect  nvarchar (3888)
Set @MySelect = '
  SELECT distinct dbo.SearchForItemReport.Name,dbo.SearchForItemReport.BarcodeNumber,dbo.SearchForItemReport.Price,dbo.SearchForItemReport.OnHand

FROM         dbo.SearchForItemReport
WHERE 1=1 '

 Execute (@MySelect + @Filter )
GO