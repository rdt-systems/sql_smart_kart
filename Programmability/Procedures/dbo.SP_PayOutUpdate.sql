SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayOutUpdate]

(@PayOutID uniqueidentifier,
@Amount money,
@Reason nvarchar(4000),
@RegisterID uniqueidentifier,
@ChasierID uniqueidentifier,
@PayOutDate datetime,
@BatchID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

update dbo.payout
set     
	Amount=@Amount,
	Reason=@Reason,
	RegisterID=@RegisterID,
	ChasierID=@ChasierID,
	PayOutDate=@PayOutDate,
	BatchID=@BatchID,
	Status=@Status,
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
where  	PayOutID=@PayOutID  and (DateModified=@datemodified or @datemodified is null)
GO