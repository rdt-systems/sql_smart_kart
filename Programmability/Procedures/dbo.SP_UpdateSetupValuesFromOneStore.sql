SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- ================================================
-- This Store Procedure is Used for Copying Settings from one store to the Other
-- ================================================

-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <08/27/2014>
-- Description:	<SP_UpdateSetupValuesFromOneStore>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateSetupValuesFromOneStore]
	(@FromStore Uniqueidentifier,
    @ToStore Uniqueidentifier)
AS
BEGIN
		SET NOCOUNT ON;

UPDATE       SetUpValues
SET                OptionValue = Set2.OptionValue, DateModified = dbo.GetLocalDATE()  -- Setting the value the same as the @FromStore

FROM            (SELECT        OptionID, CategoryID, StoreID, OptionName, OptionValue, OptionValueHe, Status, DateCreated, UserCreated, DateModified, UserModified, IsDefault
                          FROM            SetUpValues
--Set1 is the Not Good Store
                          WHERE        (StoreID = @ToStore)) AS Set1 INNER JOIN
                             (SELECT        OptionID, CategoryID, StoreID, OptionName, OptionValue, OptionValueHe, Status, DateCreated, UserCreated, DateModified, UserModified, IsDefault
                               FROM            SetUpValues
--Set2 is the God Store
                               WHERE        (StoreID = @FromStore)) AS Set2 ON Set2.OptionID = Set1.OptionID AND Set2.OptionName = Set1.OptionName INNER JOIN
                         SetUpValues ON Set1.StoreID = SetUpValues.StoreID
END
GO