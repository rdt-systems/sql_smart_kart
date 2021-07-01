SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionForCustomer]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.TransactionForCustomer.*
                FROM       dbo.TransactionForCustomer
	        WHERE     (Status > 0)'
Execute (@MySelect + @Filter )
GO