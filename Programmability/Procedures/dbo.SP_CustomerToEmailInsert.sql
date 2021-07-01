SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerToEmailInsert]
(@CustomerToEmailID uniqueidentifier,
@CustomerID uniqueidentifier,
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
	(               EmailID, EmailAddress,      OnlyText,     EmailSizeLimit,    DefaultEmail,      SortOrder,   Status, DateModified)
VALUES	(@NewID, @EmailAddress,  @OnlyText, @EmailSizeLimit, @DefaultEmail,  @SortOrder,     1,        dbo.GetLocalDATE())


 INSERT INTO dbo.CustomerToEmail
                     (CustomerToEmailID, CustomerID, EmailID, Status, DateModified)
VALUES     (@CustomerToEmailID, @CustomerID, @NewID, 1, dbo.GetLocalDATE())
GO