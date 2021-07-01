SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SubstitueItemsUpdate]
(@SubstitueItemsId uniqueidentifier,
@ItemNo uniqueidentifier,
@SubstitueNo uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE   dbo.SubstitueItems
                  SET  ItemNo = @ItemNo , SubstitueNo = @SubstitueNo, Status = @Status,  DateModified = @UpdateTime, UserModified  = @ModifierID
WHERE  (@SubstitueItemsId = SubstitueItemsId) and  (DateModified = @DateModified or DateModified is NULL)

select @UpdateTime as DateModified
GO