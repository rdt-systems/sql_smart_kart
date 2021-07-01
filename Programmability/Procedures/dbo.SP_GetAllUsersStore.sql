SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetAllUsersStore]
AS

 	SELECT     dbo.UsersStoreView.*
	FROM       dbo.UsersStoreView
	WHERE     (Status > - 1)
GO