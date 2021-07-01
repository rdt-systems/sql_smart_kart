SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[Search](@Word Nvarchar(4000))
as

SELECT OBJECT_NAME(id) ,[text]
FROM syscomments 
WHERE [text] LIKE '%' + @word + '%'
GO