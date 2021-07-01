SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactToPhoneUpdate]
(@SupplierContactToPhoneID uniqueidentifier,
@ContactID uniqueidentifier,
@PhoneType  int,
@PhoneNumber  nvarchar (20),
@SortOrder smallint,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

Update dbo.SupplierContactToPhone
SET    ContactID= @ContactID,  Status= @Status,DateModified=dbo.GetLocalDATE()
Where (@SupplierContactToPhoneID =@SupplierContactToPhoneID) and  (DateModified = @DateModified or DateModified is NULL)


UPDATE  dbo.phone
SET	  PhoneType= @PhoneType, PhoneNumber=@PhoneNumber, SortOrder=@SortOrder, Status=@Status,     DateModified= dbo.GetLocalDATE()
WHERE  phoneID=(SELECT phoneID FROM  dbo.SupplierContactToPhone WHERE SupplierContactToPhoneID=@SupplierContactToPhoneID)
GO