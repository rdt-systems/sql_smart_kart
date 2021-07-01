SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetOneReseller]
(@ResellerID uniqueidentifier)
as
	SELECT     *
	FROM       dbo.ResellersView
	WHERE     (Status > - 1) and (ResellerID=@ResellerID)
GO