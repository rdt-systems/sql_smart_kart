SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemByItemStoreID]
(
	@Code uniqueidentifier
	,
	@StoreId uniqueidentifier = null
	)
as
BEGIN

	SELECT *from ItemSearchView IMS
	where  ItemStoreID = @Code 
end
GO