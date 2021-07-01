SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetClubView]
AS

   SELECT     dbo.ClubView.*
   FROM         dbo.ClubView
   WHERE     (Status > -1)
GO