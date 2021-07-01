SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO







CREATE VIEW [dbo].[AuthorizationView]
AS
SELECT        GroupID, ChangePrices, UpdateCustomer, UpdateCustomerCredit, UpdateCustomerDiscount, UpdateItems, UpdateItemsPrice, [Returns], ExitPOS, ChargeOnAccount, NoSales, DiscountSales, 
                         RequireCashBreakDown, VoidItem, SaleOnHold, VoidSale, Payout, RequirePayoutAmount, BOUpdateCustomerDiscount, BO_ItemsAdd, BO_ItemsDelete, BO_CustomerShow, BO_ItemsShow, BO_ItemsEdit, 
                         BO_DiscountAdd, BO_DiscountDelete, BO_DiscountEdit, BO_DepAdd, BO_DepDelete, BO_DepEdit, BO_ARRepCustomerList, BO_ARRepAgingReports, BO_ARRepAgingDetails, BO_ARRepCustomerSales, 
                         BO_ARRepCustomerTypeSummary, BO_ARRepZipSummary, BO_ARRepBalanceDetails, BO_ARRepOpenInvoice, BO_CustAdd, BO_CustDelete, BO_CustEdit, BO_CustCreditLevel, BO_CustChange_C_Level, 
                         BO_InvoiceAdd, BO_InvoiceDelete, BO_InvoiceEdit, BO_PayOnAccount, BO_CustCreditRefAdd, BO_CustCreditRefDelete, BO_CustCreditRefEdit, BO_SaleOrderAdd, BO_SaleOrderDelete, BO_SaleOrderEdit, 
                         BO_CustPaymentsAdd, BO_CustPaymentsDelete, BO_CustPaymentsEdit, BO_APRepAgingReports, BO_APRepAgingDetails, BO_APRepBalanceSummary, BO_APRepBalanceDetails, BO_APRepBillsDetails, 
                         BO_APRepPhoneList, BO_APRepContactList, BO_SupPaymentsAdd, BO_SupPaymentsDelete, BO_SupPaymentsEdit, BO_SupCreditRefAdd, BO_SupCreditRefDelete, BO_SupCreditRefEdit, BO_SuppliersAdd, 
                         BO_SuppliersDelete, BO_SuppliersEdit, BO_RecieveOrdersAdd, BO_RecieveOrdersDelete, BO_RecieveOrdersEdit, BO_PurchaseOrderAdd, BO_PurchaseOrderDelete, BO_PurchaseOrderEdit, 
                         BO_ItemChangePrice, BO_ItemChangeCost, BO_ItemAssSpecialPrice, BO_ItemChangeDep, BO_ItemChangeGroup, BO_DepAssDefMarkup, BO_DepAssDefRoundup, BO_CustAssPriceLevel, BO_CustAllowChecks, 
                         BO_CustChangeGroup, BO_ItemShowCost, BO_CustAssCreditLine, BO_InvoiceVoid, BO_CustPaymentVoid, BO_CustCreditRefVoid, BO_AllowHideCustomerColumns, BO_SaleOrderVoid, BO_SupOrderVoid, 
                         BO_SupPaymentVoid, BO_SupRecieveVoid, BO_SupCreditRefVoid, BO_InRepDateComp, BO_ShowHomePage, BO_ShowPOHis, BO_ShowReceiveHis, BO_ShowSalesHis, BO_AllowHideItemsColumns, 
                         BO_ShowSaleOrderHis, BO_ShowQuickRep, BO_ShowMonthlySales, BO_PRepBatch, BO_PRepTenderTotals, BO_PRepActionSummary, BO_PRepActionDetails, BO_PRepARSales, BO_PRepARPayments, 
                         BO_ChangePriceHist, BO_APNewTransfer, BO_CustAddCharge, BO_APEditTransfer, BO_APDeleteTransfer, BO_InRepSpecialsSummary, BO_InRepTaxCollected, BO_InRepReturnItem, BO_RepTransferList, 
                         BO_RepTransferStore, BO_PhoneOrderAdd, BO_PhoneOrderEdit, BO_PhoneOrderDelete, BO_PhoneOrderVoid, BO_WebComAdd, BO_WebComEdit, BO_WebComDelete, BO_WebComVoid, BO_WebResAdd, 
                         BO_WebResEdit, BO_WebResDelete, BO_WebResVoid, BO_PDailyHoursSale, BO_ARRepRunningBalance, BO_APRepRunningBalance, BO_CusStatement, BO_APVoidTransfer, BO_ItemMerge, BO_ItemCopy, 
                         BO_SupMerge, BO_InRepSaleByTrans, BO_InRepSaleByItem, BO_InRepSaleByDep, BO_InRepTagAlong, BO_InRepDiscountSale, BO_InRepItemDaily, BO_InRepItemWeekly, BO_InRepItemMonthly, 
                         BO_InRepDepDaily, BO_InRepDepMonthly, BO_InRepDepWeekly, BO_InRepSaleAvgByItem, BO_InRepItemValuation, BO_InRepDepValuation, BO_InRepItemsTotals, BO_InRepBestWorst, 
                         BO_InChangeGeneralSale, BO_InMixMatchNew, BO_InMixMatchEdit, BO_InMixMatchDelete, BO_InAdjustInventory, BO_PhoneRepItemsOnPhone, BO_PRepPayOut, Status, DateCreated, UserCreated, 
                         DateModified, UserModified, BO_RepTrackTotal, BO_PPCAdd, BO_PPCEdit, BO_PPCDelete, BO_PPCUserAdd, BO_PPCUserEdit, BO_PPCUserShow, BO_PPCUserDelete, BO_SupTransferOrderEdit, 
                         BO_SupTransferOrderDelete, BO_SupTransferOrderVoid, BO_SupTransferOrderAdd, BO_CustRestrictCheck, Bo_ReportsShowTotals, POS_Minus, POS_ViewTransaction, BO_ARRepCustomerLoyalty, 
                         POS_CashChecks, POS_ZOut, POS_TaxExempt, POS_Gift, BO_Block, BO_ViewTransaction, POS_AllowChangeForReturen, POS_AllowManualItem, BO_RepItemsReturend, BO_RepPriceChanges,POS_AllowToReprintCoupon, POS_LoadTransaction ,BO_SelectedDepartment,
						 BO_ViewDashBoard  , BO_ViewRecentActivities,BO_ViewStatistics,BO_ShowTransferOrderHis, ShowOtherOnHand
FROM            dbo.[Authorization]
WHERE        (Status > 0)
GO