SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MixAndMatchUpdate]
(@MixAndMatchID uniqueidentifier,
@Name nvarchar(50),
@Qty int,
@Amount money,
@AssignDate bit,
@StartDate datetime,
@EndDate datetime,
@MinTotalSale money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE    dbo.MixAndMatch
SET              [Name] = @Name,Qty=@Qty, Amount=@Amount,AssignDate=@AssignDate,StartDate=@StartDate,EndDate=@EndDate,MinTotalSale=@MinTotalSale,Status = @Status, DateModified =@UpdateTime, 
                      UserModified = @ModifierID
WHERE     ( MixAndMatchID = @MixAndMatchID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO