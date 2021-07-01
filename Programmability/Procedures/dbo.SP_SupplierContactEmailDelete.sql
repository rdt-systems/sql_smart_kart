SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactEmailDelete]
(@SupplierContactToEmaillID nvarchar(50),
@ModifierID uniqueidentifier)

AS UPDATE dbo.SupplierContactToEmail

SET   Status=-1, DateModified=dbo.GetLocalDATE()

WHERE SupplierContactToEmaillID =@SupplierContactToEmaillID 


UPDATE dbo.Email

SET   Status=-1,    DateModified=dbo.GetLocalDATE()

WHERE  EmailID=(SELECT EmailID FROM dbo.SupplierContactToEmail WHERE SupplierContactToEmaillID=@SupplierContactToEmaillID)
GO