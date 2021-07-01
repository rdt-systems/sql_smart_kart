SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


/* 
Alex Abreu 
12/21/15
Procedure created to select al global changes made by the user
*/
CREATE PROCEDURE [dbo].[Sp_GetGlobalChanges]
(@Userid uniqueidentifier=NULL)
as
select * from GlobalChange where UserID = @Userid
GO