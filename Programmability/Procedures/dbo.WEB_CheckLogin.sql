SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_CheckLogin]

(@Name nvarchar(50),
@Password nvarchar(50))
as

select CustomerID 
from customer
where status>0
and lastname=@Name
and password=@Password
GO