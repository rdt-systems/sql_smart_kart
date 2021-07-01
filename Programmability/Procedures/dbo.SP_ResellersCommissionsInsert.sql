SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ResellersCommissionsInsert]
(@CommissionID uniqueidentifier,
@ResellerID uniqueidentifier,
@Amount money,
@SentDate datetime,
@CheckDate datetime,
@CheckNo nvarchar(50),
@CheckBank nvarchar(50),
@CheckSubsidiary nvarchar(50),
@ModifierID uniqueidentifier,
@Status smallint)
AS 
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
INSERT INTO dbo.ResellersCommissions
                      (CommissionID, ResellerID, Amount, SentDate, CheckDate, CheckNo, CheckBank, CheckSubsidiary, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES               (@CommissionID, @ResellerID,@Amount, @SentDate, @CheckDate, @CheckNo, @CheckBank, @CheckSubsidiary, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)




select @UpdateTime as DateModified
GO