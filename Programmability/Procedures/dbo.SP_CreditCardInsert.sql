SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditCardInsert]
(@CreditCardID nvarchar(20),
@CreditCardName nvarchar(50),
@Status smallint)
AS INSERT INTO dbo.CreditCard
                      (CreditCardID, CreditCardName,Status,DateModified)
VALUES          (@CreditCardID, dbo.CheckString(@CreditCardName),1,dbo.GetLocalDATE())
GO