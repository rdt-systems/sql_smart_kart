SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionNo_Exists]
(@Number nvarchar(50),
@Type int=-1,
@PaymentID uniqueidentifier=null)
As 
if (select Count(1) from dbo.[transaction]
where transactionNo = @Number  and Status>-1 and (TransactionID<>@PaymentID or @PaymentID is null)
	And (TransactionType=@Type or @Type=-1) ) > 0
	select 1
	
else
	select 0
GO