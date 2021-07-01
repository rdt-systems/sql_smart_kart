SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PaymentDetailsInsert]
(@PaymentID uniqueidentifier,
@TransactionID uniqueidentifier,
@TransactionPayedID uniqueidentifier,
@Amount  money,
@Note nvarchar(4000),
@Status smallint,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.PaymentDetails
                      (PaymentID, TransactionID, TransactionPayedID,Amount, Note,Status, DateCreated, UserCreated, DateModified, UserModified)

VALUES     (@PaymentID, @TransactionID, @TransactionPayedID,round(@Amount,2), @Note,1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

---------------------Update Transaction LeftDebit

update [transaction]
set
	LeftDebit=--isnull(debit,0)-
	--isnull((select sum(isnull(amount,0)) from PaymentDetails Where TransactionPayedID=[Transaction].TransactionID and Status>0 ),0),
	IsNull(LeftDebit,0)-@Amount, --is not good if the payment paid in the invoice
	DateModified=dbo.GetLocalDATE(),
	Usermodified=@ModifierID
Where 	TransactionID=@TransactionPayedID

-----------------------Update customer aging
declare @CustomerID uniqueidentifier
Set @CustomerID=(select CustomerID from [transaction] WHERE TransactionID=@TransactionPayedID)
if @CustomerID is not null
	EXEC CustomerBalanceUpdate @CustomerID
/*
declare @Diff as int
set @Diff=datediff(day,(select DueDate from [transaction] WHERE TransactionID=@TransactionPayedID),dbo.GetLocalDATE())

update customer

SET
		[current] = IsNull([current],0) -
			case when @diff<0 then IsNull(@Amount,0) else 0 end,
		
		Over0 = IsNull(Over0,0) -
			case when @diff>=0 and @diff<30 then IsNull(@Amount,0) else 0 end,
		
		Over30 = IsNull(Over30,0) -
			case when @diff>=30 and @diff<60 then IsNull(@Amount,0) else 0 end,
		
		Over60 = IsNull(Over60,0) -
			case when @diff>=60 and @diff<90 then IsNull(@Amount,0) else 0 end,
		
		Over90 = IsNull(Over90,0) -
			case when @diff>=90 and @diff<120 then IsNull(@Amount,0) else 0 end,
		
		Over120 = IsNull(Over120,0) -
			case when @diff>=120 then IsNull(@Amount,0) else 0 end

where customerID= (select CustomerID from [transaction] WHERE TransactionID=@TransactionPayedID)
*/
GO