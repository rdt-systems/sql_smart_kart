SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetDBVersion]
as
select top 1 Version from DBVersion
Order by VersionDate Desc
GO