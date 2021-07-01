SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ExtraChargeInsert]
(@ExtraChargeID uniqueidentifier,
@ExtraChargeName nvarchar(50),
@ExtraChargeDescription nvarchar(4000),
@ExtraChargeType int,
@ExtraChargeQty numeric(18,2),
@IsExtraChargeIncluded bit,
@ExtraChargeAccount uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.ExtraCharge
                      (ExtraChargeID, ExtraChargeName, ExtraChargeDescription, ExtraChargeType, ExtraChargeQty, IsExtraChargeIncluded, ExtraChargeAccount, 
                      ItemStoreNo, Status,DateModified)
VALUES     (@ExtraChargeID, @ExtraChargeName, @ExtraChargeDescription, @ExtraChargeType, @ExtraChargeQty, @IsExtraChargeIncluded, 
                      @ExtraChargeAccount, @ItemStoreNo, 1, dbo.GetLocalDATE())
GO