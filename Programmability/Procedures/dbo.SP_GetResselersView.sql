SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetResselersView]

AS
   SELECT     dbo.ResellersView.*
   FROM         dbo.ResellersView
   WHERE     (Status > - 1)
GO