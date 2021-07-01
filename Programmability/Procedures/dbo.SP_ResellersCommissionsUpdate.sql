SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ResellersCommissionsUpdate]
(@CommissionID uniqueidentifier,
@ResellerID uniqueidentifier,
@Amount money,
@SentDate datetime,
@CheckDate datetime,
@CheckNo nvarchar(50),
@CheckBank nvarchar(50),
@CheckSubsidiary nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.ResellersCommissions

SET 
ResellerID= @ResellerID,
Amount=@Amount,
SentDate=@SentDate,
CheckDate= @CheckDate,
CheckNo= @CheckNo,
CheckBank= @CheckBank,
CheckSubsidiary=@CheckSubsidiary,
Status=@Status,
DateModified=@UpdateTime,
UserModified= @ModifierID


WHERE (CommissionID = @CommissionID) AND 
      (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified
GO