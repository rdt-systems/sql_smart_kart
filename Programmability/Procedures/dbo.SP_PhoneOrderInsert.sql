SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderInsert]
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
@ShiftID 	char(50),
@ShippingID 	uniqueidentifier,
@PhoneOrderStatus 	int,
@PickByID	uniqueidentifier,
@TakeByID 	uniqueidentifier,
@TransactionID 	uniqueidentifier,
@DriversNoteID nvarchar(2000)= null,
@Type 	int,
@Total 	money,
@PaymentNote nvarchar(2000)= null,
@TenderID int = null,
@Status 	smallint,
@ModifierID 	uniqueidentifier)


AS 

If @DeliveryDate < @PhoneOrderDate
SET @DeliveryDate = @PhoneOrderDate

INSERT INTO dbo.PhoneOrder
	 ( [PhoneOrderID],
	 [PhoneOrderNo],
	 [StoreID],
	 [CustomerID],
	 [DriversNote],
	 [CustomerNote],
	 [PickNote],
	 [PhoneOrderDate],
	 [PhoneOrderTime],
	 [DeliveryDate],
	 [ShiftID],
	 [ShippingID],
	 [PhoneOrderStatus],
	 [PickByID],
	 [TakeByID],
	 [TransactionID],
	 [Type],
	 [Total],
     [PaymentNote],
	 [TenderID],
	 [Status],
	 [DateCreated],
	 [UserCreated],
	 [DateModified],
	 [UserModified]) 
 
VALUES 
	( @PhoneOrderID,
	 @PhoneOrderNo,
	 @StoreID,
	 @CustomerID,
	 @DriversNote,
	 @CustomerNote,
	 @PickNote,
	 @PhoneOrderDate,
	 @PhoneOrderTime,
	dbo.getday( @DeliveryDate),
	RTRIM(@ShiftID) ,
	 @ShippingID,
	 @PhoneOrderStatus,
	 @PickByID,
	 @TakeByID,
	 @TransactionID,
	 @Type,
	 @Total,
     @PaymentNote,
	 @TenderID,
	 1,
	 dbo.GetLocalDATE(),
	 @ModifierID,
	 dbo.GetLocalDATE(),
	 @ModifierID)
GO