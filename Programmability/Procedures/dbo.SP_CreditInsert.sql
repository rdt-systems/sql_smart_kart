SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CreditInsert]
(@CreditID uniqueidentifier,
@Name nvarchar(50),
@Description nvarchar(4000),
@Days smallint,
@CreditType bit,
@NetDue int,
@DayInMonth int,
@InterestRate numeric(6,3),
@Status smallint,
@InterestRate2 numeric(6,3) = NULL,
@CreditType2 bit = NULL,
@ModifierID uniqueidentifier)
AS 
INSERT INTO dbo.Credit
           (CreditID, Name, Description, Days, InterestRate,CreditType, NetDue, DayInMonth, Status, DateCreated, UserCreated, DateModified, UserModified, InterestRate2,CreditType2)
VALUES     (@CreditID, dbo.CheckString(@Name), dbo.CheckString(@Description), @Days, @InterestRate,@CreditType, @NetDue, @DayInMonth, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID, @InterestRate2,@CreditType2)
GO