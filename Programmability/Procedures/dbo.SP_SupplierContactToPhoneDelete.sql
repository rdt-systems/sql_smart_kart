SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactToPhoneDelete]
(@SupplierContactToPhoneID uniqueidentifier,
@ModifierID uniqueidentifier)
AS 
Update
 dbo.SupplierContactToPhone
   
SET   Status= -1,DateModified=dbo.GetLocalDATE()

Where @SupplierContactToPhoneID =@SupplierContactToPhoneID
GO