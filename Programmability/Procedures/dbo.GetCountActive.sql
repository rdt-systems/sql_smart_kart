SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetCountActive]


AS


select count(*)as count
from users
where status=1
and IsLogIn=1
GO