SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_SystemTableShiftNo]
(
@DateModified datetime=null
)
AS 
SELECT [SystemTableShiftNo].*  FROM [SystemTableShiftNo]  WHERE (DateModified >@DateModified) AND Status>0
GO