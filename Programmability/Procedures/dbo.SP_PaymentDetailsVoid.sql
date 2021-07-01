SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PaymentDetailsVoid]
(@PaymentID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE dbo.PaymentDetails
                   
 SET    status=0, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE PaymentID=@PaymentID

---------------------Update Transaction LeftDebit

update [transaction]
set
	LeftDebit=IsNull(LeftDebit,0)+(Select Amount from PaymentDetails Where PaymentID=@PaymentID),
	DateModified=dbo.GetLocalDATE(),
	Usermodified=@ModifierID
Where 	TransactionID=(select TransactionPayedID from PaymentDetails WHERE PaymentID=@PaymentID)


-----------------------Update customer aging
declare @CustomerID uniqueidentifier
Set @CustomerID=(select CustomerID from [transaction] WHERE TransactionID=(select TransactionPayedID from PaymentDetails WHERE PaymentID=@PaymentID))
if @CustomerID is not null
	EXEC CustomerBalanceUpdate @CustomerID
/*
Declare @OldAmount money
set  @OldAmount = IsNull((select amount from PaymentDetails where PaymentID=@PaymentID),0)

declare @Diff as int
set @Diff=datediff(day,(select DueDate from [transaction] WHERE TransactionID=(select TransactionPayedID from PaymentDetails WHERE PaymentID=@PaymentID)),dbo.GetLocalDATE())

update customer

SET
		[current] = IsNull([current],0) +
			case when @diff<0 then @OldAmount else 0 end,
		
		Over0 = IsNull(Over0,0) +
			case when @diff>=0 and @diff<30 then @OldAmount else 0 end,
		
		Over30 = IsNull(Over30,0) +
			case when @diff>=30 and @diff<60 then @OldAmount else 0 end,
		
		Over60 = IsNull(Over60,0) +
			case when @diff>=60 and @diff<90 then @OldAmount else 0 end,
		
		Over90 = IsNull(Over90,0) +
			case when @diff>=90 and @diff<120 then @OldAmount else 0 end,
		
		Over120 = IsNull(Over120,0) +
			case when @diff>=120 then @OldAmount else 0 end

where customerID= (select CustomerID from [transaction] WHERE TransactionID=(select TransactionPayedID from PaymentDetails WHERE PaymentID=@PaymentID))
-----------------------------------------*/
GO