SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ExtraChargeUpdate]
(@ExtraChargeID uniqueidentifier,
@ExtraChargeName nvarchar(50),
@ExtraChargeDescription nvarchar(4000),
@ExtraChargeType int,
@ExtraChargeQty numeric(18,2),
@IsExtraChargeIncluded bit,
@ExtraChargeAccount uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE	dbo.ExtraCharge
SET	ExtraChargeName = @ExtraChargeName, ExtraChargeDescription = @ExtraChargeDescription,
	ExtraChargeType = @ExtraChargeType, ExtraChargeQty = @ExtraChargeQty,
	IsExtraChargeIncluded = @IsExtraChargeIncluded, ExtraChargeAccount = @ExtraChargeAccount, 
	ItemStoreNo = @ItemStoreNo, Status = @Status, DateModified=@UpdateTime

WHERE	(ExtraChargeID = @ExtraChargeID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO