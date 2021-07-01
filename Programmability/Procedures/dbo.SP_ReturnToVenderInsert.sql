SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReturnToVenderInsert]
(@ReturnToVenderID  uniqueidentifier,
@ReturnToVenderNo nvarchar(50),
@StoreNo uniqueidentifier,
@SupplierID uniqueidentifier,
@PersonReturnID uniqueidentifier,
@Total money,
@Note nvarchar(4000),
@ReturnToVenderDate  datetime,
@Taxable bit,
@TaxRate decimal(19,4),
@TaxAmount money,
@Status smallint,
@ModifierID uniqueidentifier,
@Discount float,
@IsDiscountInAmount bit
)

AS INSERT INTO dbo.ReturnToVender
                      (ReturnToVenderID, ReturnToVenderNo,StoreNo, SupplierID, PersonReturnID,  Total,  Note,ReturnToVenderDate,
						Taxable,TaxRate,TaxAmount, Status, DateCreated,  UserCreated, DateModified, UserModified,Discount,IsDiscountInAmount)

VALUES     (@ReturnToVenderID, @ReturnToVenderNo,@StoreNo, @SupplierID, @PersonReturnID,  @Total,   @Note,@ReturnToVenderDate,
			@Taxable,@TaxRate,@TaxAmount, 1,dbo.GetLocalDATE(),  @ModifierID,dbo.GetLocalDATE(), @ModifierID,@Discount,@IsDiscountInAmount)
GO