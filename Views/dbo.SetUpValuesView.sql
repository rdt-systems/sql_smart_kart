SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[SetUpValuesView]
AS
SELECT        OptionID, CategoryID, StoreID, OptionName, CASE WHEN OptionValue = 'false' THEN '0' WHEN OptionValue = 'true' THEN '1' ELSE OptionValue END AS OptionValue, OptionValueHe, Status, DateCreated, 
                         UserCreated, DateModified, UserModified, IsDefault, Description, FeildType
FROM            SetUpValues
GO