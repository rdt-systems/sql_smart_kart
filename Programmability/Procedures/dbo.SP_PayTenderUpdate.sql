SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayTenderUpdate]
(@PayTenderID uniqueidentifier,
@AccountPaymentID uniqueidentifier,
@Amount money,
@PayType int,
@PayNo nvarchar(50),
@AccountNO nvarchar(50),
@CodeNO nvarchar(50),
@CodeNO2 nvarchar(50),
@PayDate DateTime,
@SortOrder smallint,
@Note  nvarchar(4000),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)


As

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE PayTender

SET  AccountPaymentID  = @AccountPaymentID,Amount =  @Amount, PayType =  @PayType, PayNo = @PayNo,AccountNO = @AccountNO, CodeNO = 

@CodeNo, CodeNO2= CodeNO2,
        PayDate =  @PayDate,SortOrder= @SortOrder,  Note =@Note, 
       Status = @Status, DateModified = @UpdateTime, UserModified = @ModifierID


WHERE (PayTenderID =@PayTenderID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO