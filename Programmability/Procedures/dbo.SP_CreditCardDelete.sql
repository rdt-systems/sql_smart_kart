SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditCardDelete]
(@CreditCardID nvarchar(20),
@ModifierID uniqueidentifier)
AS UPDATE dbo.CreditCard
                  
SET       Status=-1,DateModified=dbo.GetLocalDATE()

WHERE CreditCardID=@CreditCardID
GO