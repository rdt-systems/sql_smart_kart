SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactToPhoneInsert]
(@SupplierContactToPhoneID uniqueidentifier,
@ContactID uniqueidentifier,
@PhoneType  int,
@PhoneNumber  nvarchar (20),
@SortOrder smallint,
@Status smallint,
@ModifierID uniqueidentifier)

AS

DECLARE @NewID uniqueidentifier
SET @NewID = NEWID()

INSERT INTO    dbo.phone
	(phoneID,       PhoneType,    PhoneNumber,    SortOrder,     Status, DateModified)
VALUES	(@NewID,   @PhoneType, @PhoneNumber, @SortOrder,     1,        dbo.GetLocalDATE())

 INSERT INTO dbo.SupplierContactToPhone
                      (SupplierContactToPhoneID, ContactID, PhoneID, Status,DateModified)
VALUES     (@SupplierContactToPhoneID, @ContactID, @NewID, 1,dbo.GetLocalDATE())
GO