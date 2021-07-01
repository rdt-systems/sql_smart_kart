SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ManufacturersView]
(
@DateModified datetime=null
)
AS 
SELECT [ManufacturersView].*  FROM [ManufacturersView] WHERE (DateModified >@DateModified) AND Status>0
GO