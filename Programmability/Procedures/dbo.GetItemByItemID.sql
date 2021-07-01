SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemByItemID]
(
	@ItemID uniqueidentifier
	,
	@StoreId uniqueidentifier = null
	)
as
BEGIN
    if @StoreId is null
		SELECT * from ItemMainAndStoreView IMS where ItemID = @ItemID 
	else 
	    SELECT * from ItemMainAndStoreView IMS where ItemID = @ItemID AND Storeno = @StoreId and Status>0 
end
GO