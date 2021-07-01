SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- Create date: <5/12/2016>
-- Description:	Create Back Order for Items Missing in Phone Order>
-- =============================================
CREATE PROCEDURE [dbo].[SP_BackOrder_PhoneOrderEntry]
	(@NewPhoneOrderID Uniqueidentifier,
	 @NewPhoneOrderEntryID Uniqueidentifier,
	 @OldPhoneOrderEntryID Uniqueidentifier,
	 @Qty decimal)
AS
BEGIN

INSERT INTO PhoneOrderEntry
                         (PhoneOrderEntryID, PhoneOrderID, ItemStoreNo, Qty, UOMQty, UOMType, UOMPrice, ExtPrice, LinkNo, Note, SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified, OnHand)
SELECT        @NewPhoneOrderEntryID AS PhoneOrderEntryID, @NewPhoneOrderID AS PhoneOrderID, ItemStoreNo, @Qty AS Qty, UOMQty, UOMType, UOMPrice, ExtPrice, LinkNo, Note, SortOrder, Status, DateCreated, 
                         UserCreated, DateModified, UserModified, OnHand
FROM            PhoneOrderEntry
WHERE        (PhoneOrderEntryID = @OldPhoneOrderEntryID)
END
GO