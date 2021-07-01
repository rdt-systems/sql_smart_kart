SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditCardUpdate]
(@CreditCardID nvarchar(20),
@CreditCardName nvarchar(50),
@Status smallint,
@DateModified datetime)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE dbo.CreditCard
                  
SET       CreditCardName= dbo.CheckString(@CreditCardName),Status=@Status,DateModified=@UpdateTime

WHERE (CreditCardID=@CreditCardID)AND 
      (DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO