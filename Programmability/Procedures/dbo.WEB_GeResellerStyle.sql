SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GeResellerStyle] 
(@Domain  nvarchar(50)=null,@resellerID uniqueidentifier=null)


AS 
if @resellerID is null
SELECT    *
FROM         dbo.resellers
WHERE     (DomainName =@Domain)
and status > 0
else


SELECT    *
FROM         dbo.resellers
WHERE     (resellerID =@resellerID)
and status > 0
GO