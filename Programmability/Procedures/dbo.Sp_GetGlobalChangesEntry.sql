SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


/* 
Alex Abreu 
12/29/15
Procedure created to select al global changes detail
*/
CREATE PROCEDURE [dbo].[Sp_GetGlobalChangesEntry]
(@GlobalChangeID uniqueidentifier=NULL)
as
select * from GlobalChangeEntry where GlobalChangeID = @GlobalChangeID
GO