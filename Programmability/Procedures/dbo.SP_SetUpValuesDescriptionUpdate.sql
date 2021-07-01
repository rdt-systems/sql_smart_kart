SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <11/03/2014>
-- Description:	<Set>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SetUpValuesDescriptionUpdate]
(@Description Nvarchar(4000),
@OptionID Int)

AS
BEGIN
UPDATE       SetUpValues
SET                Description = @Description, DateModified = dbo.GetLocalDATE()
WHERE        (OptionID = @OptionID)
END
GO