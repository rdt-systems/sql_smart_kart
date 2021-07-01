SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerToPhoneDelete]
(@CostumerToPhoneID uniqueidentifier,
@ModifierID uniqueidentifier)

AS UPDATE dbo.CustomerToPhone
                      
SET    status=-1, DateModified = dbo.GetLocalDATE()

WHERE CostumerToPhoneID=@CostumerToPhoneID
GO