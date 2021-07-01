SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemAliasUpdate]
(@AliasId uniqueidentifier,
@ItemNo uniqueidentifier,
@BarcodeNumber nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE dbo.ItemAlias

 SET     ItemNo = @ItemNo, BarcodeNumber = @BarcodeNumber, Status = @Status,  DateModified = @UpdateTime,  UserModified =  @ModifierID

WHERE  (AliasId = @AliasId)
-- AND      (DateModified = @DateModified OR DateModified IS NULL)
 
Update ItemMain Set DateModified = dbo.GetLocalDATE() Where ItemID = @ItemNo
Update ItemStore Set DateModified = dbo.GetLocalDATE() Where ItemNo = @ItemNo
select @UpdateTime as DateModified
GO