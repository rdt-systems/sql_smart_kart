SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_EmailsDelete]
(@EmailID uniqueidentifier,
@ModifierID uniqueidentifier)

AS Update dbo.Emails

   
  SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
   
  WHERE   EmailID = @EmailID
GO