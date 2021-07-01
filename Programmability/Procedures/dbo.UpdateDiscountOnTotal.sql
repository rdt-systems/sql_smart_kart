SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateDiscountOnTotal]
(@ID uniqueidentifier)
 
as

DECLARE @Sum decimal(19,3)
DECLARE @Dis decimal(19,3)


		set @Sum=(select sum(Total) from Transactionentry where transactionentrytype<>4 and status>0 and transactionid=@ID)
		set @Dis=(select top 1 uomprice from transactionentry where transactionentrytype=4 and  status>0 and transactionid=@ID)
		set @Sum=@dis*100/@Sum
		
		update TransactionEntry
		set DiscountOnTotal=@Sum
		where transactionentrytype<>4 and transactionid=@ID
GO