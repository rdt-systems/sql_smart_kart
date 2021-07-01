SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetMultiStoreItemsView]
(@ItemID uniqueidentifier =null, 
@refreshTime  datetime output)
AS 
  iF @ItemID IS NULL 
    SELECT * FROM dbo.MultiStoreItemsView
  ELSE
    SELECT * FROM dbo.MultiStoreItemsView WHERE ItemID =@ItemID 
set @refreshTime = dbo.GetLocalDATE()
GO