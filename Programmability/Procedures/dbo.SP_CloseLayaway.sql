SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CloseLayaway]
(@TransID uniqueidentifier,
 @CloseType Int,
 @CustomerID uniqueidentifier)
AS
--16 = Close
--15 = Void
Declare @Balance money 

IF @CloseType= 16 
BEGIN
 --SET @Balance = (SELECT (Debit -Credit ) from [Transaction] Where TransactionID =@TransID)
 UPDATE [Transaction] SET TransactionType = @CloseType, DateModified=dbo.GetLocalDATE(),Note =ISNULL(Note,'')+' Close Layaway'  WHERE TransactionID =@TransID
END
 
ELSE IF @CloseType= 15
BEGIN
	SET @Balance = (SELECT (Debit) from [Transaction] Where TransactionID =@TransID)
	UPDATE [Transaction] SET TransactionType = @CloseType,Debit =0, DateModified=dbo.GetLocalDATE(),Note =ISNULL(Note,'')+' Void Layaway' WHERE TransactionID =@TransID

    UPDATE [Layaway]
	SET [LayawayStatus]=0,
		[DateModified] = dbo.GetLocalDATE()
    WHERE (TransactionID =@TransID ) 

UPDATE ItemStore SET OnHand = ISNULL(ItemStore.OnHand, 0)+Layaway.Qty
FROM            ItemStore INNER JOIN
                         Layaway ON ItemStore.ItemStoreID = Layaway.ItemStoreID
WHERE        (Layaway.Status > 0) AND (Layaway.TransactionID = @TransID) 
END


UPDATE Customer set BalanceDoe= (IsNull(BalanceDoe,0)-@Balance ),DateModified =dbo.GetLocalDATE() WHERE CustomerID = @CustomerID 
EXEC [dbo].[SP_UpdateRuningBalance]@TransactionID =@TransID
GO