SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GeneralSaleUpdate]
(@GeneralSaleID uniqueidentifier,
@DiscountID nvarchar(50),
@StartDate datetime,
@EndDate datetime,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.GeneralSale

SET 
DiscountID= @DiscountID,
StartDate= @StartDate,
EndDate= @EndDate,
Status=@Status,
DateModified=@UpdateTime,
UserModified= @ModifierID


WHERE (GeneralSaleID = @GeneralSaleID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)
GO