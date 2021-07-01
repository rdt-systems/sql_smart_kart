SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CountInventoryEntryInsert]
(
    @CountID Uniqueidentifier,
	@StoreID Uniqueidentifier,
	@CountDate datetime,
	@ItemStoreID Uniqueidentifier,
	@CountEntryID Uniqueidentifier,
	@UserID Uniqueidentifier,
	@Onhand decimal(18,0),
	@Total Int,
	@Status Int = 1,
	@DateCreated datetime,
	@DateModified datetime
)
AS

Declare @CountInventoryID int

IF NOT EXISTS (Select * From CountInventory Where CountID = @CountID)
INSERT INTO CountInventory (CountID,CountDate, DateCreated, DateModified,StoreID, UserID, Status)
VALUES (@CountID, @CountDate, @DateCreated, @DateModified, @StoreID, @UserID, @Status)

SELECT @CountInventoryID = CountInventoryID From CountInventory Where CountID = @CountID

INSERT INTO CountInventoryEntry (CountInventoryID, CountEntryID,ItemStoreID, OnHand, Total, Status, DateCreated, DateModified)
VALUES (@CountInventoryID, @CountEntryID, @ItemStoreID, @Onhand, @Total, @Status, @DateCreated, @DateModified)
GO