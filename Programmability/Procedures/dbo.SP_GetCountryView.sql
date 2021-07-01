SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetCountryView]
( @refreshTime  datetime output)
AS
SELECT     dbo.Country.*
FROM         dbo.Country
set @refreshTime = dbo.GetLocalDATE()
GO