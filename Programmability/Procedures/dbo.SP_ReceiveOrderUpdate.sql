SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveOrderUpdate]
(@ReceiveID uniqueidentifier,
@PackingSlipNo nvarchar(50),
@StoreID uniqueidentifier,
@SupplierNo uniqueidentifier,
@BillID uniqueidentifier,
@Freight money,
@CustomsDuties money = 0,
@OtherCharges money = 0,
@Discount decimal(9, 3),
@Note nvarchar(500),
@Total money,
@ReceiveOrderDate datetime,
@IsDiscAmount Bit,
@CurrBalance Money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@FilePath nvarchar (150) = null)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

exec UpdateReceiveEntry @ReceiveID,-1,@ModifierID

UPDATE    dbo.ReceiveOrder
SET              PackingSlipNo = @PackingSlipNo,StoreID=@StoreID, SupplierNo = @SupplierNo, BillID = @BillID, Freight = @Freight, Note = @Note, Total = 

@Total, CustomsDuties = @CustomsDuties,OtherCharges = @OtherCharges,
                      Discount = @Discount, ReceiveOrderDate = @ReceiveOrderDate ,IsDiscAmount =@IsDiscAmount,
CurrBalance=@CurrBalance, Status = isnull(@Status,1), DateModified = @UpdateTime, FilePath = @FilePath, 

UserModified = @ModifierID
WHERE     (ReceiveID = @ReceiveID) AND
      (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )


select @UpdateTime as DateModified
GO