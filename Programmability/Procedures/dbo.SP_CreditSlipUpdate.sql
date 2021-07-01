SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditSlipUpdate]
(@CreditSlipID uniqueidentifier,
@CreditSlipNo nvarchar(50),
@TransactionID uniqueidentifier,
@Amount money,
@ExpDate DateTime,
@Note nvarchar(400),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.CreditSlip
           
SET            CreditSlipNo = @CreditSlipNo,  TransactionID = @TransactionID, Amount = @Amount,   ExpDate = @ExpDate, Note=@Note, Status =@Status, 

	DateModified = @UpdateTime ,UserModified = @ModifierID

WHERE     (CreditSlipID= @CreditSlipID)AND 
      (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO