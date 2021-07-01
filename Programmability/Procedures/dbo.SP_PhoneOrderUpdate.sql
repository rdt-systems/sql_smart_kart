SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderUpdate]
(
@PhoneOrderID 	uniqueidentifier,
@PhoneOrderNo 	nvarchar(50),
@StoreID 	uniqueidentifier,
@CustomerID 	uniqueidentifier,
@DriversNote 	nvarchar(2000),
@CustomerNote 	nvarchar(2000),
@PickNote 	nvarchar(2000),
@PhoneOrderDate 	datetime,
@PhoneOrderTime 	datetime,
@DeliveryDate 	datetime,
@ShiftID 	nvarchar(25),
@ShippingID 	uniqueidentifier,
@PhoneOrderStatus 	int,
@PickByID	uniqueidentifier,
@TakeByID 	uniqueidentifier,
@TransactionID 	uniqueidentifier,
@Type 	int,
@Total 	money,
@PaymentNote nvarchar(2000)=null,
@TenderID int = null,
@Status 	smallint,
@DriversNoteID nvarchar(2000)= null,
@DateModified DateTime,
@ModifierID 	uniqueidentifier)

AS

If @DeliveryDate < @PhoneOrderDate
SET @DeliveryDate = @PhoneOrderDate

UPDATE dbo.PhoneOrder
SET

PhoneOrderID=@PhoneOrderID ,
PhoneOrderNo=@PhoneOrderNo ,
StoreID=@StoreID ,
CustomerID=@CustomerID ,
CustomerNote=@CustomerNote ,
DriversNote = @DriversNote,
PickNote=@PickNote ,
PhoneOrderDate= @PhoneOrderDate ,
PhoneOrderTime=@PhoneOrderTime ,
DeliveryDate= dbo.getday(@DeliveryDate) ,
ShiftID=@ShiftID ,
ShippingID=@ShippingID ,
PhoneOrderStatus=@PhoneOrderStatus,
PickByID=@PickByID,
TakeByID=@TakeByID ,
--TransactionID=@TransactionID ,
Type=@Type ,
Total=@Total ,
PaymentNote =@PaymentNote,
TenderID = @TenderID,
Status=IsNull(@Status,1) ,
DateModified=dbo.GetLocalDATE(),
UserModified=@ModifierID 

WHERE   (PhoneOrderID = @PhoneOrderID)
GO