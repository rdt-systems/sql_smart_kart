SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailUpdate]
(@EmailID uniqueidentifier,
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

UPDATE    dbo.Email
SET              EmailAddress = @EmailAddress, OnlyText = @OnlyText, EmailSizeLimit = @EmailSizeLimit, DefaultEmail = @DefaultEmail, 
                       SortOrder = @SortOrder, Status = @Status, DateModified = @UpdateTime
WHERE  (EmailID = @EmailID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO