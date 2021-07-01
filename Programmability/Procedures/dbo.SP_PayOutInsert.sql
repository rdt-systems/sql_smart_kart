SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayOutInsert]

(@PayOutID uniqueidentifier,
@Amount money,
@Reason nvarchar(4000),
@RegisterID uniqueidentifier,
@ChasierID uniqueidentifier,
@PayOutDate datetime,
@BatchID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.payout
       (PayOutID,Amount,Reason,RegisterID,ChasierID,PayOutDate,BatchID,
	Status,DateCreated,UserCreated,DateModified,UserModified)
VALUES (@PayOutID,@Amount,@Reason,@RegisterID,@ChasierID,@PayOutDate,@BatchID,
	1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO