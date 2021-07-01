SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <5/12/2016>
-- Description:	ALTER Back Order for Items Missing in Phone Order>
-- =============================================
CREATE PROCEDURE [dbo].[SP_BackOrder_PhoneOrder]
	(@NewPhoneOrderID Uniqueidentifier,
	 @OldPhoneOrderID Uniqueidentifier)
AS
BEGIN

INSERT INTO PhoneOrder
                         (PhoneOrderID, PhoneOrderNo, StoreID, CustomerID, DriversNote, CustomerNote, PickNote, PhoneOrderDate, PhoneOrderTime, DeliveryDate, ShiftID, ShippingID, PhoneOrderStatus, PickByID, TakeByID, 
                         TransactionID, Type, Total, Status, DateCreated, UserCreated, DateModified, UserModified, Freezer, PaymentNote, UserEditing, StartEditing, TenderID)
SELECT        @NewPhoneOrderID AS PhoneOrderID, PhoneOrderNo + '-1' AS PhoneOrderNo, StoreID, CustomerID, DriversNote, CustomerNote, PickNote, PhoneOrderDate, PhoneOrderTime, DeliveryDate, ShiftID, ShippingID, 
                         0 AS PhoneOrderStatus, PickByID, TakeByID, NULL AS TransactionID, Type, Total, 1 AS Status, dbo.GetLocalDATE() AS DateCreated, UserCreated, dbo.GetLocalDATE() AS DateModified, UserModified, Freezer, PaymentNote, 
                         UserEditing, StartEditing, TenderID
FROM            PhoneOrder
WHERE        (PhoneOrderID = @OldPhoneOrderID)
END
GO