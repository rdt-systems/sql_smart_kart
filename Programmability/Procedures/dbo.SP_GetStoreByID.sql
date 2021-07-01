SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetStoreByID]
(
@StoreID uniqueidentifier
)
AS 

	SELECT     dbo.StoreView.*
	FROM         dbo.StoreView
	WHERE     (Status > - 1 and StoreID = @Storeid)
GO