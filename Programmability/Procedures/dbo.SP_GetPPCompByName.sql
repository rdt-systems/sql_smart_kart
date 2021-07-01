SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_GetPPCompByName]
@PPCName nvarchar(50)
as

SELECT * FROM [PPComp] where PPCName=@PPCName
GO