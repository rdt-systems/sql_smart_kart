SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierContactEmailInsert]
(@SupplierContactToEmaillID nvarchar(50),
@ContactID nvarchar(50),
@EmailAddress nvarchar(50),
@OnlyText bit,
@EmailSizeLimit tinyint,
@DefaultEmail bit,
@SortOrder smallint,
@Status smallint,
@ModifierID uniqueidentifier)

AS
DECLARE @NewID uniqueidentifier
SET @NewID = NEWID()


INSERT INTO    dbo.Email
	(EmailID,    EmailAddress,     OnlyText,     EmailSizeLimit,    DefaultEmail,    SortOrder,   Status, DateModified)
VALUES	(@NewID, @EmailAddress,  @OnlyText, @EmailSizeLimit, @DefaultEmail, @SortOrder,     1,        dbo.GetLocalDATE())


 INSERT INTO dbo.SupplierContactToEmail
                  (SupplierContactToEmaillID,    ContactID,   EmailID,   Status,DateModified)
VALUES     (@SupplierContactToEmaillID, @ContactID,@NewID, 1,        dbo.GetLocalDATE())
GO