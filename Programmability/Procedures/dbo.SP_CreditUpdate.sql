SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditUpdate]
(@CreditID uniqueidentifier,
@Name nvarchar(50),
@Description nvarchar(4000),
@Days smallint,
@InterestRate numeric(6,3),
@CreditType bit,
@NetDue int,
@DayInMonth int,
@Status smallint,
@InterestRate2 numeric(6,3) = NULL,
@CreditType2 bit = NULL,
@DateModified datetime,
@ModifierID uniqueidentifier) 

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.Credit
SET 
     [Name] = dbo.CheckString(@Name),
     [Description] =dbo.CheckString(@Description),
     Days = @Days,
     InterestRate = @InterestRate,
     CreditType=@CreditType,
     NetDue= @NetDue,
     DayInMonth =@DayInMonth,
     Status = @Status,
     DateModified = @UpdateTime, 
	InterestRate2 = @InterestRate2,
    CreditType2 = @CreditType2,
     UserModified = @ModifierID

WHERE (CreditID = @CreditID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO