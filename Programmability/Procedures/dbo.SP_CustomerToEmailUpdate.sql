SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  


  PROCEDURE [dbo].[SP_CustomerToEmailUpdate]
(@CustomerToEmailID uniqueidentifier,
@CustomerID uniqueidentifier,
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

 UPDATE dbo.CustomerToEmail
                    
SET     CustomerID= @CustomerID, Status=@Status, DateModified=@UpdateTime

WHERE (CustomerToEmailID=@CustomerToEmailID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

UPDATE     dbo.Email

	SET    EmailAddress =@EmailAddress,    OnlyText = @OnlyText,EmailSizeLimit = @EmailSizeLimit,DefaultEmail= 

@DefaultEmail,SortOrder=@SortOrder, Status=@Status,    DateModified=@UpdateTime

WHERE  EmailID=(SELECT EmailID FROM dbo.CustomerToEmail WHERE CustomerToEmailID=@CustomerToEmailID)


select @UpdateTime as DateModified
GO