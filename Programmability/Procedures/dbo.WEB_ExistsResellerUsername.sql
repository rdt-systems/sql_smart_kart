SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE 
            PROCEDURE [dbo].[WEB_ExistsResellerUsername]
(@Username nvarchar(50))
As 

if (select Count(1) from dbo.resellers
where UserName= @Username and Status>-1 )
> 0
	select 1
	
else
	select 0
GO