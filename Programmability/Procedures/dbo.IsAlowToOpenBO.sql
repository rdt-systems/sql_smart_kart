SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Nathan Ehrenthal>
-- Create date: <1/21/2013>
-- Description:	<Reture True If Alow to Open BackOffice>
-- =============================================
CREATE PROCEDURE [dbo].[IsAlowToOpenBO] (@UserID as uniqueidentifier)
AS
BEGIN
SELECT        IsNull([Authorization].BO_Block,0)As BO_Block
FROM            Groups INNER JOIN
                         UsersView ON Groups.GroupID = UsersView.GroupID INNER JOIN
                         [Authorization] ON Groups.GroupID = [Authorization].GroupID
						 where UsersView.UserId=@UserID 
END
GO