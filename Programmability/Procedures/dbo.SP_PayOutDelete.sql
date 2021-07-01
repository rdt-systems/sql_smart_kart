SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PayOutDelete]

(@PayOutID uniqueidentifier,
 @UserID uniqueidentifier)

AS

UPDATE PayOut SET Status =-1,DateModified =dbo.GetLocalDATE(),UserModified =@UserID WHERE PayOutID = @PayOutID 

Update TenderEntry Set Status =-1, DateModified = dbo.GetLocalDATE() Where TransactionID = @PayOutID
GO