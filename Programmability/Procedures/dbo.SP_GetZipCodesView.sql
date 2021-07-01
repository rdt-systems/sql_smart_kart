SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetZipCodesView]
(
@refreshTime  datetime output
)
AS 

SELECT     dbo.ZipCodesView.*
FROM         dbo.ZipCodesView
set @refreshTime = dbo.GetLocalDATE()
GO