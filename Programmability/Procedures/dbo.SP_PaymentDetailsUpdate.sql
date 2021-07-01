SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PaymentDetailsUpdate]
(
@PaymentID uniqueidentifier,
@TransactionID uniqueidentifier,
@TransactionPayedID uniqueidentifier,
@Amount money,
@Note nvarchar(4000),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldAmount money
set  @OldAmount = IsNull((select amount from PaymentDetails where PaymentID=@PaymentID),0)

UPDATE    dbo.PaymentDetails
SET              
		TransactionID = @TransactionID, 
		TransactionPayedID = @TransactionPayedID, 
		Amount = round(@Amount,2), 
		Note = @Note, 
		Status = @Status, 
		UserCreated = @ModifierID, 
		DateModified = @UpdateTime, 
		UserModified = @ModifierID

WHERE     (PaymentID = @PaymentID) AND (DateModified = @DateModified OR
                      DateModified IS NULL)

---------------------Update Transaction LeftDebit
declare @CustomerID uniqueidentifier
Set @CustomerID=(select CustomerID from [transaction] WHERE TransactionID=@TransactionPayedID)
if @CustomerID is not null
	EXEC CustomerBalanceUpdate @CustomerID

update [transaction]
set
	LeftDebit=IsNull(debit,0)-isnull((Select SUM(isnull(Amount,0)) FROM PaymentDetails where TransactionPayedID=[transaction].transactionID and status>0 ),0),
	DateModified=dbo.GetLocalDATE(),
	Usermodified=@ModifierID
Where 	TransactionID=@TransactionPayedID
/*


-----------------------Update customer aging
declare @Diff as int
set @Diff=datediff(day,(select DueDate from [transaction] WHERE TransactionID=@TransactionPayedID),dbo.GetLocalDATE())

update customer

SET
		[current] = IsNull([current],0) -
			case when @diff<0 then IsNull(@Amount,0) - @OldAmount else 0 end,
		
		Over0 = IsNull(Over0,0) -
			case when @diff>=0 and @diff<30 then IsNull(@Amount,0) - @OldAmount else 0 end,
		
		Over30 = IsNull(Over30,0) -
			case when @diff>=30 and @diff<60 then IsNull(@Amount,0) - @OldAmount else 0 end,
		
		Over60 = IsNull(Over60,0) -
			case when @diff>=60 and @diff<90 then IsNull(@Amount,0) - @OldAmount else 0 end,
		
		Over90 = IsNull(Over90,0) -
			case when @diff>=90 and @diff<120 then IsNull(@Amount,0) - @OldAmount else 0 end,
		
		Over120 = IsNull(Over120,0) -
			case when @diff>=120 then IsNull(@Amount,0) - @OldAmount else 0 end

where customerID= (select CustomerID from [transaction] WHERE TransactionID=@TransactionPayedID)
-----------------------------------------*/


select @UpdateTime as DateModified
GO