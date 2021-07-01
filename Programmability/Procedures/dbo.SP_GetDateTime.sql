SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetDateTime]
@NOW datetime output
AS
select @NOW=dbo.GetLocalDATE()
GO