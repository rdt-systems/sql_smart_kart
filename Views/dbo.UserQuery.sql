SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



						 
CREATE VIEW [dbo].[UserQuery]
AS
SELECT DISTINCT 
                         dbo.Users.UserId, dbo.Users.UserName, dbo.Users.Password, dbo.Users.UserFName, dbo.Users.UserLName, dbo.Users.Address, dbo.Users.HomePhoneNumber, dbo.Users.WorkPhoneNumber, dbo.Users.Fax, 
                         dbo.Users.Email, dbo.Users.ZipCode, dbo.Users.IsSuperAdmin, dbo.UsersStoreView.StoreID, dbo.UsersStoreView.OnLine, dbo.UsersStoreView.IsDefault, dbo.UsersStoreView.Manager, dbo.Groups.GroupName, 
                         dbo.Groups.IsSystem, dbo.[Authorization].ChangePrices, dbo.[Authorization].UpdateCustomer, dbo.[Authorization].UpdateCustomerCredit, dbo.[Authorization].UpdateCustomerDiscount, 
                         dbo.[Authorization].UpdateItems, dbo.[Authorization].UpdateItemsPrice, dbo.[Authorization].[Returns], dbo.[Authorization].ExitPOS, dbo.[Authorization].ChargeOnAccount, dbo.[Authorization].NoSales, 
                         dbo.[Authorization].DiscountSales, dbo.[Authorization].RequireCashBreakDown, dbo.[Authorization].VoidItem, dbo.[Authorization].SaleOnHold, dbo.[Authorization].VoidSale, dbo.[Authorization].Payout, 
                         dbo.[Authorization].RequirePayoutAmount, dbo.Users.DateModified, dbo.[Authorization].DateModified AS AuthorizationDateModified, dbo.[Authorization].POS_CashChecks, dbo.[Authorization].BO_CustCreditLevel, 
                         dbo.[Authorization].POS_Minus, dbo.[Authorization].POS_ViewTransaction, dbo.[Authorization].POS_TaxExempt, dbo.[Authorization].POS_ZOut, dbo.[Authorization].POS_Gift, dbo.Users.Status, 
                         dbo.[Authorization].POS_AllowChangeForReturen, ISNULL(dbo.[Authorization].POS_AllowManualItem, 1) AS POS_AllowManualItem, dbo.[Authorization].POS_AllowToReprintCoupon, 
                         dbo.[Authorization].POS_LoadTransaction AS BO_ViewTransaction , dbo.[Authorization].BO_SelectedDepartment AS BO_SelectedDepartment ,dbo.Groups.GroupID, dbo.[Authorization].ShowOtherOnHand
FROM            dbo.Groups INNER JOIN
                         dbo.[Authorization] ON dbo.Groups.GroupID = dbo.[Authorization].GroupID RIGHT OUTER JOIN
                         dbo.UsersStoreView ON dbo.Groups.GroupID = dbo.UsersStoreView.GroupID RIGHT OUTER JOIN
                         dbo.Users ON dbo.UsersStoreView.UserID = dbo.Users.UserId
WHERE        (dbo.Users.Status > 0) AND (dbo.UsersStoreView.Status > 0 OR
                         dbo.UsersStoreView.Status IS NULL)
GO