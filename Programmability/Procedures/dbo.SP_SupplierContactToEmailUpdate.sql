SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactToEmailUpdate]
(@SupplierContactToEmaillID nvarchar(50),
@ContactID nvarchar(50),
@EmailAddress nvarchar(50),
@OnlyText bit,
@EmailSizeLimit tinyint,
@DefaultEmail bit,
@SortOrder smallint,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)


AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.SupplierContactToEmail

SET  ContactID= @ContactID, Status=@Status, DateModified=@UpdateTime

WHERE SupplierContactToEmaillID =@SupplierContactToEmaillID 


UPDATE dbo.Email

SET    EmailAddress =@EmailAddress,    OnlyText = @OnlyText,EmailSizeLimit = @EmailSizeLimit,DefaultEmail= @DefaultEmail,SortOrder=@SortOrder, Status=@Status,    DateModified=dbo.GetLocalDATE()

WHERE  (EmailID=(SELECT EmailID FROM dbo.SupplierContactToEmail WHERE SupplierContactToEmaillID=@SupplierContactToEmaillID)) and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO