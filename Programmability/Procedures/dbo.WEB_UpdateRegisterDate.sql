SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_UpdateRegisterDate]
(@Date as datetime,@ResellerID uniqueidentifier)
AS
update resellers
set lastregistereddate=@Date
where resellerid=@ResellerID
and status>0
GO