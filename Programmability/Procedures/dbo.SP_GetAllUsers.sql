SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetAllUsers]
AS

 	SELECT     dbo.UsersView.*
	FROM       dbo.UsersView
	WHERE     (Status > - 1)
GO