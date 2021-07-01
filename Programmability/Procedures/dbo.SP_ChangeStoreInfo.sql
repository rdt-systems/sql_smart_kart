SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_ChangeStoreInfo](@StoreID uniqueidentifier)
AS

Update SetUpValues Set StoreID = @StoreID , DateModified = dbo.GetLocalDate() where StoreID <> '00000000-0000-0000-0000-000000000000'

Update ItemStore Set StoreNo = @StoreID, DateModified = dbo.GetLocalDate()

Update DepartmentStore Set StoreID = @StoreID, DateModified = dbo.GetLocalDate()

Delete from dbo.RecentActivity

Delete from dbo.GridsLayoutsUser

Update dbo.StatsResults Set StoreID = @StoreID, DateModified = dbo.GetLocalDate()

Update dbo.Customer Set StoreCreated = @StoreID, DateModified = dbo.GetLocalDate()

Update dbo.UsersStore Set StoreID = @StoreID, DateModified = dbo.GetLocalDate()

Update dbo.NumberSettings Set StoreID = @StoreID where StoreID is Not NULL

INSERT INTO SetUpValues
                         (OptionID, CategoryID, StoreID, OptionName, OptionValue, OptionValueHe, Status, DateCreated, UserCreated, DateModified, UserModified)
SELECT        OptionID, CategoryID, @StoreID, OptionName, OptionValue, OptionValueHe, Status, dbo.GetLocalDate(), NULL, dbo.GetLocalDate(), NULL
FROM            SetUpValues
WHERE        (StoreID = '00000000-0000-0000-0000-000000000000') AND (OptionName NOT IN
                             (SELECT        OptionName
                               FROM            SetUpValues
                               WHERE        (StoreID = @StoreID)))

Delete from EncData Where ISNULL(StoreID,@StoreID) <> @StoreID 

Delete from dbo.sqlStatmentLog
GO