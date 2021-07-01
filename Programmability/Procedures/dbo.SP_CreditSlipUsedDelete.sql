SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditSlipUsedDelete]
(@CreditSlipUsedID uniqueidentifier,
@ModifierID uniqueidentifier)
AS
UPDATE  dbo.CreditSlipUsed
         
 SET Status =-1,    DateModified=  dbo.GetLocalDATE(), UserModified =@ModifierID

WHERE CreditSlipUsedID = @CreditSlipUsedID
GO