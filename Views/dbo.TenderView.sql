SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[TenderView]
AS
SELECT        TOP (100) PERCENT TenderID, TenderGroup, SortOrder, TenderType, TenderName, TenderDescription, RequiresCustomer, AllowDiscount, FillByPressEnter, 
                         OpenDrawer, MinimumAmount, Status, DateCreated, UserCreated, DateModified, UserModified, TenderNameHe, GivePoints, OverTender, AllowMinus, ShowOnPhoneOrder, NoChange
FROM            dbo.Tender
ORDER BY SortOrder
GO