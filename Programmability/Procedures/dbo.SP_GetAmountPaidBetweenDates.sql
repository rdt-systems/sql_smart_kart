SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAmountPaidBetweenDates]

(@Filter nvarchar(4000))

as
               
declare @MySelect1 nvarchar(4000)
set @MySelect1= 'SELECT     Sum(Credit) as Credit
                 FROM         dbo.[Transaction]
                 where (TransactionType = 1 or TransactionType = 2  or TransactionType=4) and Status > 0 '
Execute (@MySelect1 + @Filter)
GO