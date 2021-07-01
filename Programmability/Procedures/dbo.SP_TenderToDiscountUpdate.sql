SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TenderToDiscountUpdate]
(@TenderToDiscountID uniqueidentifier,
@DiscountID uniqueidentifier,
@TenderID int,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.TenderToDiscount

SET 
DiscountID= @DiscountID,
TenderID= @TenderID,
Status=@Status,
DateModified=@UpdateTime,
UserModified= @ModifierID


WHERE (TenderToDiscountID= @TenderToDiscountID) AND 
      (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified
GO