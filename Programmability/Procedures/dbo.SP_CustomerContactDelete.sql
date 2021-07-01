SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerContactDelete]
(@CustomerContactID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.CustomerContact
SET              Status =-1, DateModified = dbo.GetLocalDATE()
WHERE     (CustomerContactID = @CustomerContactID)
GO