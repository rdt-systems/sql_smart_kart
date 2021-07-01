SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionByNo]
(@No nvarchar(50))
As 


select * from [Transaction]
where TransactionNo=@No
GO