SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_UpdateCustomerAddress]
(
@CustomerID uniqueidentifier,
@Address nvarchar(50),
@Address2 nvarchar(50),
@City nvarchar(50),
@State nvarchar(50),
@Zip nvarchar(50),
@PhoneNumber nvarchar(50), 
@ModifierID uniqueidentifier)
AS

If @Address<>'' OR @Address2<>'' OR @City<>'' OR @State<>'' OR @Zip<>'' OR @PhoneNumber<>''

if (SELECT top 1 MainAddressID
	FROM Customer
	WHERE CustomerID=@CustomerID) is not null
begin 
UPDATE CustomerAddresses
SET	   Street1 = @Address,
	   Street2 = @Address2,
	   City=@City,
	   State = @State,
	   Zip = @Zip,
	   PhoneNumber1 = @PhoneNumber,
	   UserModified=@ModifierID,
	   DateModified=dbo.GetLocalDATE()

Where CustomerAddressID=(SELECT top 1 MainAddressID
						   FROM Customer
						   WHERE CustomerID=@CustomerID)

end

else

begin 

Declare @ID uniqueidentifier
set @ID=NEWID()
INSERT INTO CustomerAddresses(CustomerAddressID,CustomerID,AddressType, Street1, Street2, City, State,Zip,PhoneNumber1,Status, DateCreated, UserCreated, DateModified, UserModified)

VALUES(@ID,@CustomerID,6 ,@Address,@Address2,@City,@State,@Zip,@PhoneNumber,1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

UPDATE Customer
SET MainAddressID=@ID,
    UserModified=@ModifierID,
	DateModified=dbo.GetLocalDATE()

WHERE CustomerID=@CustomerID

end
GO