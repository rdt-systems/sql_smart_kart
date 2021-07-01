SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetDBVersionDate]
as
select top 1 VersionDate from DBVersion
Order by VersionDate Desc
GO