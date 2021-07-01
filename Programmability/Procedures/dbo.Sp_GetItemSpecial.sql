SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_GetItemSpecial]
(@ItemStoreID uniqueidentifier=null)
AS 
IF @ItemStoreID IS NOT NULL
  SELECT * FROM [dbo].[Sp_GetItemSpecial] WHERE ItemStoreID= @ItemStoreID 
ELSE
  SELECT * FROM [dbo].[Sp_GetItemSpecial]
GO