SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE Procedure [dbo].[SP_GridFieldsSQLUpdate](@ViewName nvarchar(50), @SQLQuery nvarchar(Max))
as
Delete from GridfieldsSQL where ViewName = @ViewName 

Insert into GridfieldsSQL(Viewname,SQLQuery) Values (@ViewName,@SQLQuery)
GO