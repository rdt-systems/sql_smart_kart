SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetAppVersion]
as
select top 1 Version from AppVersion
Order by VersionDate Desc
GO