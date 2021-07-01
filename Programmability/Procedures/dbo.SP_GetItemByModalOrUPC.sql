SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemByModalOrUPC]
(@UPC nvarchar(50) = null,
@ModaNo nvarchar(50) =null)
AS 
if (not @UPC is null) 
 (SELECT     *
  FROM         dbo.ItemSearchView
  WHERE BarcodeNumber = @UPC) 
else
 (SELECT     *
  FROM         dbo.ItemSearchView
  WHERE ModalNumber = @ModaNo)
GO