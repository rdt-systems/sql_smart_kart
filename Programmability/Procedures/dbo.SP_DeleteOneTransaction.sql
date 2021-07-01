SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeleteOneTransaction]
(@No nvarchar(50),
@ModifierID uniqueidentifier)


AS 
Declare @TransactionID uniqueidentifier
set @TransactionID=(select top 1 TransactionID 
		    from dbo.[Transaction] 
		    where TransactionNo=@No AND Status>0)


exec SP_TransactionDelete @TransactionID,@ModifierID
GO