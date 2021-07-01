SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveOrderInsert](@ReceiveID uniqueidentifier,
@PackingSlipNo nvarchar(50),
@StoreID uniqueidentifier,
@SupplierNo uniqueidentifier,
@BillID uniqueidentifier,
@Freight money,
@CustomsDuties money = 0,
@OtherCharges money = 0,
@Discount decimal(9, 3),
@Note nvarchar(50),
@Total money,
@ReceiveOrderDate datetime,
@IsDiscAmount Bit,
@CurrBalance Money,
@Status Smallint,
@FilePath nvarchar (150) =null,
@ModifierID uniqueidentifier)

AS INSERT INTO dbo.ReceiveOrder
                      (ReceiveID, PackingSlipNo,StoreID, SupplierNo, BillID, Freight, Discount, Note, Total, CustomsDuties, OtherCharges, ReceiveOrderDate,IsDiscAmount,CurrBalance, Status, DateCreated, UserCreated, DateModified, 
                   FilePath ,  UserModified)
VALUES     (@ReceiveID, @PackingSlipNo,@StoreID, @SupplierNo, @BillID, @Freight, @Discount, @Note, @Total, @CustomsDuties, @OtherCharges, @ReceiveOrderDate,@IsDiscAmount,@CurrBalance, 1, dbo.GetLocalDATE(), @ModifierID, 
                      dbo.GetLocalDATE(),@FilePath, @ModifierID)
GO