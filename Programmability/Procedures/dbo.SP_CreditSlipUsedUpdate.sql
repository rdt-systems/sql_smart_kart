SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditSlipUsedUpdate]
(@CreditSlipUsedID uniqueidentifier,
@CreditSlipID char(50),
@TransactionID uniqueidentifier,
@Amount money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE  dbo.CreditSlipUsed
         
 SET  CreditSlipID = @CreditSlipID, TransactionID = @TransactionID, Amount = @Amount, Status =@Status,    DateModified= @UpdateTime, 

UserModified =@ModifierID

WHERE (CreditSlipUsedID = @CreditSlipUsedID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO