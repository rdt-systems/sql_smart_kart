SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CanDeleteCustomer]
(@ID uniqueidentifier)

as
if (select Count(*) from dbo.[Transaction]
          where Status>-1 and CustomerID=@ID)=0
                   select 1
else
                   select 0
GO