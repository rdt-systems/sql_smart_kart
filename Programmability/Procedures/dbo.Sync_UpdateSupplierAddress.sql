SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_UpdateSupplierAddress]
(
@SupplierID uniqueidentifier,
@Address1 nvarchar(50),
@Address2 nvarchar(50),
@City nvarchar(50),
@State nvarchar(50),
@Zip nvarchar(50),
@PhoneNumber nvarchar(50), 
@ModifierID uniqueidentifier)
AS

If @Address1<>'' OR @Address2<>'' OR @City<>'' OR @State<>'' OR @Zip<>'' OR @PhoneNumber<>''

if (SELECT top 1 MainAddress
	FROM Supplier
	WHERE SupplierID=@SupplierID) is not null
begin 
UPDATE SupplierAddresses
SET	   Line1 = @Address1,
	   Line2 = @Address2,
	   City=@City,
	   State = @State,
	   Zip = @Zip,
	   PhoneNumber1 = @PhoneNumber,
	   UserModified=@ModifierID,
	   DateModified=dbo.GetLocalDATE()

Where AddressID=(SELECT top 1 MainAddress
				 FROM Supplier
				 WHERE SupplierID=@SupplierID)

end

else

begin 

Declare @ID uniqueidentifier
set @ID=NEWID()
INSERT INTO SupplierAddresses(AddressID,AddressType, Line1, Line2, City, State,Zip,PhoneNumber1,Status,  UserCreated,  UserModified)

VALUES(@ID,0 ,@Address1,@Address2,@City,@State,@Zip,@PhoneNumber,1,  @ModifierID,  @ModifierID)

UPDATE Supplier
SET MainAddress=@ID,
    UserModified=@ModifierID,
	DateModified=dbo.GetLocalDATE()

WHERE SupplierID=@SupplierID

end
GO