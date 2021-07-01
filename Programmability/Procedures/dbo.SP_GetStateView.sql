SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetStateView]
(
@refreshTime  datetime output
)
AS 

SELECT     dbo.StateView.*
FROM         dbo.StateView
set @refreshTime = dbo.GetLocalDATE()
GO