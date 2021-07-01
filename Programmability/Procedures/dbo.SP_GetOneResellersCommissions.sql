SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetOneResellersCommissions]
(@CommissionID Uniqueidentifier)
AS

SELECT     dbo.ResellersCommissionsView.*
FROM         dbo.ResellersCommissionsView
WHERE     Status > 0 and CommissionID=@CommissionID
GO