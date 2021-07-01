SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_VoidGift]
(@GiftID uniqueidentifier,
@ModifierID uniqueidentifier,
@VoidReason nvarchar(150))
AS
Update Coupon
     SET       Status = 0 ,  DateModified = dbo.GetLocalDATE() , UserModified = @ModifierID,VoidReason =@VoidReason
WHERE  CouponID  = @GiftID


	--DECLARE @GiftToTenderID uniqueidentifier
	
	--DECLARE DelEntry CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	--SELECT GiftToTenderID
	--FROM dbo.GiftToTender WHERE(GiftID=@GiftID) 
	
	--OPEN DelEntry
	
	--FETCH NEXT FROM DelEntry 
	--INTO @GiftToTenderID   -- holds the current transaction entry
	
	--WHILE @@FETCH_STATUS = 0
	--	BEGIN
	--		exec SP_GiftToTenderDelete @GiftToTenderID,@ModifierID
	--	FETCH NEXT FROM DelEntry    --insert the next values to the instance
	--		INTO @GiftToTenderID
	--	END
	
	--CLOSE DelEntry
	--DEALLOCATE DelEntry
GO