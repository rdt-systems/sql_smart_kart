SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAuthorizationByGroup]
(@GroupID uniqueidentifier)
as


select * from dbo.[Authorization]
where GroupID=@GroupID
GO