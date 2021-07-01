SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ClubDelete]
(@ClubID nvarchar(50),
@Status smallint)

AS UPDATE dbo.Club

 SET              Status = -1, DateModified = dbo.GetLocalDATE()


WHERE  ClubID=@ClubID
GO