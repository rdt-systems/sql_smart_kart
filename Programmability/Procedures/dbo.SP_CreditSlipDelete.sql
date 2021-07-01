SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditSlipDelete]
(@CreditSlipID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
UPDATE dbo.CreditSlip
           
SET        Status =-1, DateModified = dbo.GetLocalDATE(),UserModified = @ModifierID

WHERE     CreditSlipID= @CreditSlipID
GO