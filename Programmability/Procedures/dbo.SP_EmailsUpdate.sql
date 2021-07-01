SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailsUpdate]
(@EmailID uniqueidentifier,
@Subject nvarchar(50),
@Body ntext,
@From nvarchar(50),
@FromAddress nvarchar(50),
@To nvarchar(50),
@ToAddress nvarchar(50),
@DeliveryDate datetime,
@MailType int,
@MailStatus smallint,
@EmailUid nvarchar(2000),
@Attachment image,
@FileName Nvarchar(50),
@Status smallint,
@EmailText nvarchar(4000) = NULL,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update dbo.Emails

   
  SET [EmailID] = @EmailID
      ,[Subject] = @Subject
      ,[Body] = @Body
      ,[From] = @From
	  ,FromAddress=@FromAddress
      ,[To] = @To
	  ,ToAddress=@ToAddress
	  ,DeliveryDate=@DeliveryDate
	  ,MailType=@MailType
	  ,MailStatus=@MailStatus
	  ,EmailUid=@EmailUid
	  ,Attachment=@Attachment
	  ,[FileName]=@FileName 
      ,[Status] = @Status
	  ,[EmailText] = @EmailText
      ,[DateModified] = @updateTime
      ,[UserModified] = @ModifierID
 WHERE (EmailID = @EmailID) AND
      (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )

select @UpdateTime as DateModified
GO