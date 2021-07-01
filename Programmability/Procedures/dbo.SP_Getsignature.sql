SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_Getsignature]
(
@transactionid uniqueidentifier
)
as 
select [Signature] from SigCapture
where TransactionID=  @transactionid
GO