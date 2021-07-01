SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetRegisterKeysView]

AS

  SELECT     dbo.RegisterKeysView.*
   FROM         dbo.RegisterKeysView
   WHERE     (Status > - 1)
GO