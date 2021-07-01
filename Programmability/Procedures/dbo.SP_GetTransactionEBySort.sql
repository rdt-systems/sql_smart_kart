SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionEBySort]
(@ID nvarchar(50),
@Sort int)
As 


select * from TransactionEntry
where TransactionID=@ID And Sort=@Sort
GO