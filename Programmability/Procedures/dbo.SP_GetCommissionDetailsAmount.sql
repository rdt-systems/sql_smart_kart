SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCommissionDetailsAmount]
(@TransactionID uniqueidentifier ,
 @CommissionID uniqueidentifier )

AS 

declare @Amount money
set  @Amount=(SELECT      sum(Commission)
			FROM  dbo.CommissionDetails
			where  Status>0 and commissionID= @CommissionID and TransactionID =@TransactionID )
select isnull(@Amount,0)
GO