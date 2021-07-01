SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditSlipInsert]
(@CreditSlipID uniqueidentifier,
@CreditSlipNo nvarchar(50),
@TransactionID uniqueidentifier,
@Amount money,
@ExpDate DateTime,
@Note nvarchar(400),
@Status smallint,
@ModifierID uniqueidentifier)

AS 
INSERT INTO dbo.CreditSlip
                      (CreditSlipID,    CreditSlipNo,     TransactionID,        Amount,            ExpDate,    Note,      Status,  DateCreated, UserCreated, DateModified, UserModified)

VALUES     (@CreditSlipID,  @CreditSlipNo,  @TransactionID, @Amount,   @ExpDate, @Note,  1, dbo.GetLocalDATE(), @ModifierID,  dbo.GetLocalDATE(),  @ModifierID)
GO