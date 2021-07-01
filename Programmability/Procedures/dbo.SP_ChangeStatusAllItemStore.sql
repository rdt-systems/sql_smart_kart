SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ChangeStatusAllItemStore]
(@ItemNo uniqueidentifier
,@Status int
,@UserID uniqueidentifier)

AS

update Dbo.ItemStore
set Status=@Status,
    UserModified=@UserID,
    DateModified=dbo.GetLocalDATE()
where ItemNo=@ItemNo

Declare @ItemID uniqueidentifier
DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
SELECT  ItemID
FROM dbo.ItemMain
WHERE LinkNo=@ItemNo

OPEN i

FETCH NEXT FROM i 
INTO @ItemID


WHILE @@FETCH_STATUS = 0
	BEGIN
		Declare @ItemStoreID uniqueidentifier
		DECLARE ii CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT  ItemStoreID
		FROM dbo.ItemStore
		WHERE ItemNo=@ItemID
		
		OPEN ii
		
		FETCH NEXT FROM ii
		INTO @ItemStoreID
		
		
		WHILE @@FETCH_STATUS = 0
			BEGIN
				update ItemStore
				set Status= @Status,
				UserModified=@UserID,
			        DateModified=dbo.GetLocalDATE()
				Where ItemStoreID=@ItemStoreID
			FETCH NEXT FROM ii    --insert the next values to the instance
				INTO @ItemStoreID
			END
		
		CLOSE ii
		DEALLOCATE ii
		
		



	FETCH NEXT FROM i    --insert the next values to the instance
		INTO @ItemID
	END

CLOSE i
DEALLOCATE i
GO