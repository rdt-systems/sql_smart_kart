﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AuthorizationUpdate]
( @GroupID uniqueidentifier,
@ChangePrices bit, 
@UpdateCustomer bit, 
@UpdateCustomerCredit bit, 
@UpdateCustomerDiscount bit,
@UpdateItems bit, 
@UpdateItemsPrice bit,
@Returns bit, 
@ExitPOS bit, 
@ChargeOnAccount bit, 
@NoSales bit, 
@DiscountSales bit, 
@RequireCashBreakDown bit,
@VoidItem bit, 
@SaleOnHold bit, 
@VoidSale bit, 
@Payout bit, 
@RequirePayoutAmount  bit,
@BOUpdateCustomerDiscount Bit,
@BO_ARRepCustomerList	bit,		
@BO_ARRepAgingReports	bit,	
@BO_ARRepAgingDetails	bit,		
@BO_ARRepCustomerSales	bit,	
@BO_ARRepCustomerLoyalty bit =0,	
@BO_ARRepCustomerTypeSummary	bit,			
@BO_ARRepZipSummary	bit,		
@BO_ARRepBalanceDetails	bit,		
@BO_ARRepOpenInvoice	bit,	
@BO_APRepAgingReports	bit,
@BO_APRepAgingDetails	bit,		
@BO_APRepBalanceSummary	bit,		
@BO_APRepBalanceDetails	bit,		
@BO_APRepBillsDetails	bit,		
@BO_APRepPhoneList	bit,		
@BO_APRepContactList	bit,	
@BO_ItemsAdd		bit,	
@BO_ItemsDelete		bit,	
@BO_ItemsEdit		bit,	
@BO_DiscountAdd		bit,	
@BO_DiscountDelete	bit,	
@BO_DiscountEdit	bit,	
@BO_DepAdd		bit,	
@BO_DepDelete		bit,	
@BO_DepEdit		bit,	
@BO_CustAdd		bit,	
@BO_CustDelete		bit,	
@BO_CustEdit		bit,	
@BO_CustCreditLevel  Smallint,
@BO_CustChange_C_Level bit,
@BO_CustPaymentsAdd  bit ,
@BO_CustPaymentsDelete  bit,
@BO_CustPaymentsEdit  bit,
@BO_CustCreditRefAdd  bit,
@BO_CustCreditRefDelete bit  ,
@BO_CustCreditRefEdit  bit,
@BO_InvoiceAdd	bit,	
@BO_InvoiceDelete	bit,	
@BO_InvoiceEdit	bit,	
@BO_PayOnAccount  bit,
@BO_SaleOrderAdd	bit,	
@BO_SaleOrderDelete	bit,	
@BO_SaleOrderEdit	bit,	
@BO_SupPaymentsAdd bit,
@BO_SupPaymentsDelete bit,
@BO_SupPaymentsEdit bit, 
@BO_SupCreditRefAdd bit,
@BO_SupCreditRefDelete bit,
@BO_SupCreditRefEdit bit,	
@BO_SuppliersAdd	bit,	
@BO_SuppliersDelete	bit,	
@BO_SuppliersEdit	bit,	
@BO_RecieveOrdersAdd		bit,	
@BO_RecieveOrdersDelete	bit,	
@BO_RecieveOrdersEdit		bit,	
@BO_PurchaseOrderAdd	bit,	
@BO_PurchaseOrderDelete	bit,	
@BO_PurchaseOrderEdit	bit,
@BO_ItemChangePrice	bit,	
@BO_ItemChangeCost	bit,	
@BO_ItemAssSpecialPrice bit,	
@BO_ItemChangeDep	bit,	
@BO_ItemChangeGroup	bit,	
@BO_DepAssDefMarkup bit,	
@BO_DepAssDefRoundup bit,	
@BO_CustAssPriceLevel bit,	
@BO_CustAllowChecks	bit,	
@BO_CustChangeGroup  bit,	
@BO_CustAssCreditLine	 bit,	
@BO_ItemShowCost bit,
@BO_InvoiceVoid bit,
@BO_CustPaymentVoid	bit,	
@BO_CustCreditRefVoid	bit,		
@BO_SaleOrderVoid	bit,		
@BO_SupOrderVoid	bit,		
@BO_SupPaymentVoid	bit,		
@BO_SupRecieveVoid	bit,		
@BO_SupCreditRefVoid	bit,	
@BO_ShowHomePage        bit,
@BO_ChangePriceHist bit,
@BO_ShowPOHis		bit,		
@BO_ShowReceiveHis	bit,	
@BO_ShowSalesHis	bit,	
@BO_ShowSaleOrderHis	bit,	
@BO_ShowQuickRep	bit,	
@BO_ShowMonthlySales	bit,	
@BO_APNewTransfer	bit,	
@BO_APEditTransfer	bit,	
@BO_APDeleteTransfer	bit,	
@BO_CustAddCharge bit,
@BO_ItemsShow Bit,
@BO_CustomerShow Bit,
@BO_AllowHideItemsColumns Bit,
@BO_AllowHideCustomerColumns Bit,
@BO_PRepBatch bit,
@BO_PRepTenderTotals bit,
@BO_PRepActionSummary bit,
@BO_PRepActionDetails bit,
@BO_PRepARSales bit,
@BO_PRepARPayments bit,


@BO_InRepSpecialsSummary	bit	,
@BO_InRepTaxCollected	bit	,
@BO_InRepReturnItem	bit	,
@BO_InRepDateComp	bit,	


@BO_InRepBestWorst	bit,
@BO_RepTrackTotal Bit,

@BO_InRepSaleByTrans	bit,	
@BO_InRepSaleByItem	bit,	
@BO_InRepSaleByDep	bit,	
@BO_InRepTagAlong	bit,	
@BO_InRepDiscountSale	bit,	
@BO_InRepItemDaily	bit,
@BO_InRepItemWeekly	bit,	
@BO_InRepItemMonthly	bit,	
@BO_InRepDepDaily	bit,	
@BO_InRepDepMonthly	bit,	
@BO_InRepDepWeekly	bit,	
@BO_InRepSaleAvgByItem	bit,	
@BO_InRepItemValuation	bit,	
@BO_InRepDepValuation	bit,	
@BO_InRepItemsTotals	bit,	

@BO_SupTransferOrderEdit bit,
@BO_SupTransferOrderVoid bit,
@BO_SupTransferOrderDelete bit,
@BO_SupTransferOrderAdd bit,

@BO_RepTransferList	bit,	
@BO_RepTransferStore	bit	,
@BO_PhoneOrderAdd	bit,	
@BO_PhoneOrderEdit	bit,	
@BO_PhoneOrderDelete	bit,	
@BO_PhoneOrderVoid	bit,	
@BO_WebComAdd	bit,	
@BO_WebComEdit	bit,	
@BO_WebComDelete	bit,	
@BO_WebComVoid	bit,	
@BO_WebResAdd	bit	,
@BO_WebResEdit	bit,	
@BO_WebResDelete	bit,	
@BO_WebResVoid	bit,	
@BO_PDailyHoursSale	bit,	
@BO_ARRepRunningBalance	bit,	
@BO_APRepRunningBalance	bit,	
@BO_CusStatement	bit,	
@BO_APVoidTransfer	bit,	
@BO_ItemMerge	bit,	
@BO_ItemCopy	bit,	
@BO_SupMerge	bit,
@BO_RepItemsReturend bit =1, 
@BO_RepPriceChanges bit =1,	

@BO_ViewTransaction bit,
@BO_InChangeGeneralSale	bit	,
@BO_InMixMatchNew	bit	,
@BO_InMixMatchEdit	bit	,
@BO_InMixMatchDelete	bit,
@BO_InAdjustInventory	bit	,
@BO_PhoneRepItemsOnPhone	bit	,
@POS_AllowChangeForReturen bit,
@BO_PPCAdd	bit,	
@BO_PPCEdit	bit,	
@BO_PPCDelete	bit,	
@BO_PPCUserAdd	bit,	
@BO_PPCUserEdit	bit,	
@BO_PPCUserShow	bit,	
@BO_PPCUserDelete	bit,	
@BO_PRepPayOut bit,
@Bo_ReportsShowTotals	bit,
@POS_Minus bit=1,
@POS_ViewTransaction	bit =1,
@POS_TaxExempt bit =1,
@POS_ZOut bit =1,
@POS_Gift bit =1,
@POS_AllowToReprintCoupon bit =1,
@POS_AllowManualItem bit =1,
@BO_CustRestrictCheck bit,
@POS_CashChecks bit ,
@BO_Block bit ,
@POS_LoadTransaction bit =0,
@BO_SelectedDepartment  bit = null,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@BO_ViewRecentActivities bit=null,
@BO_ViewDashBoard bit=null,
@BO_ViewStatistics  bit=null,
@BO_ShowTransferOrderHis bit=null,
@ShowOtherOnHand bit=null)

AS
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.[Authorization]
set
			ChangePrices=@ChangePrices, 
			UpdateCustomer=@UpdateCustomer, 
			UpdateCustomerCredit=@UpdateCustomerCredit, 
			UpdateCustomerDiscount=@UpdateCustomerDiscount,
			UpdateItems=@UpdateItems, 
			UpdateItemsPrice =@UpdateItemsPrice ,
			[Returns]=@Returns, 
			ExitPOS=@ExitPOS, 
			ChargeOnAccount=@ChargeOnAccount, 
			NoSales=@NoSales, 
			DiscountSales=@DiscountSales, 
			RequireCashBreakDown=@RequireCashBreakDown,
			VoidItem=@VoidItem, 
			SaleOnHold=@SaleOnHold, 
			VoidSale=@VoidSale, 
			Payout=@Payout, 
			RequirePayoutAmount=@RequirePayoutAmount, 
			BOUpdateCustomerDiscount=@BOUpdateCustomerDiscount,
			BO_ARRepCustomerList=@BO_ARRepCustomerList,
			BO_ARRepAgingReports=@BO_ARRepAgingReports,
			BO_ARRepAgingDetails=@BO_ARRepAgingDetails,
			BO_ARRepCustomerSales=@BO_ARRepCustomerSales,
			BO_ARRepCustomerLoyalty=@BO_ARRepCustomerLoyalty,
			BO_ARRepCustomerTypeSummary=@BO_ARRepCustomerTypeSummary,
			BO_ARRepZipSummary=    @BO_ARRepZipSummary,
			BO_ARRepBalanceDetails= @BO_ARRepBalanceDetails,
			BO_ARRepOpenInvoice=   @BO_ARRepOpenInvoice,
			BO_APRepAgingReports	=         @BO_APRepAgingReports,
			BO_APRepAgingDetails	=	@BO_APRepAgingDetails,	
			BO_APRepBalanceSummary	=@BO_APRepBalanceSummary,	
			BO_APRepBalanceDetails	=@BO_APRepBalanceDetails,	
			BO_APRepBillsDetails	=	@BO_APRepBillsDetails,	
			BO_APRepPhoneList	=	@BO_APRepPhoneList,	
			BO_APRepContactList	=	@BO_APRepContactList,
			BO_ItemsAdd=@BO_ItemsAdd	,	
			BO_ItemsDelete=	@BO_ItemsDelete,
			BO_ItemsEdit=@BO_ItemsEdit,
			BO_DiscountAdd=@BO_DiscountAdd,	
			BO_DiscountDelete=@BO_DiscountDelete,	
			BO_DiscountEdit=@BO_DiscountEdit,	
			BO_DepAdd=@BO_DepAdd,	
			BO_DepDelete=@BO_DepDelete,	
			BO_DepEdit=@BO_DepEdit,	
			BO_CustAdd=@BO_CustAdd,	
			BO_CustDelete=@BO_CustDelete,
			BO_CustEdit=@BO_CustEdit,	
			BO_CustCreditLevel =@BO_CustCreditLevel ,
			BO_CustChange_C_Level= @BO_CustChange_C_Level ,
			BO_CustPaymentsAdd =@BO_CustPaymentsAdd ,
			BO_CustPaymentsDelete =@BO_CustPaymentsDelete ,
			BO_CustPaymentsEdit =@BO_CustPaymentsEdit ,
			BO_CustCreditRefAdd  =@BO_CustCreditRefAdd  ,
			BO_CustCreditRefDelete  =@BO_CustCreditRefDelete  ,
			BO_CustCreditRefEdit  =@BO_CustCreditRefEdit  ,
			BO_InvoiceAdd	=	@BO_InvoiceAdd	,	
			BO_InvoiceDelete	=	@BO_InvoiceDelete	,	
			BO_InvoiceEdit	=	@BO_InvoiceEdit	,	
			BO_PayOnAccount =@BO_PayOnAccount ,
			BO_SaleOrderAdd=@BO_SaleOrderAdd,	
			BO_SaleOrderDelete=@BO_SaleOrderDelete,
			BO_SaleOrderEdit=@BO_SaleOrderEdit,
			BO_SupPaymentsAdd=@BO_SupPaymentsAdd,
			BO_SupPaymentsDelete=@BO_SupPaymentsDelete,
			BO_SupPaymentsEdit=@BO_SupPaymentsEdit,
			BO_SupCreditRefAdd=@BO_SupCreditRefAdd,
			BO_SupCreditRefDelete=@BO_SupCreditRefDelete,
			BO_SupCreditRefEdit=	@BO_SupCreditRefEdit,
			BO_SuppliersAdd	=@BO_SuppliersAdd,
			BO_SuppliersDelete=@BO_SuppliersDelete,
			BO_RepTrackTotal=@BO_RepTrackTotal,
			BO_SuppliersEdit=@BO_SuppliersEdit,
			BO_RecieveOrdersAdd=@BO_RecieveOrdersAdd,
			BO_RecieveOrdersDelete	=@BO_RecieveOrdersDelete,
			BO_RecieveOrdersEdit=@BO_RecieveOrdersEdit,
			BO_PurchaseOrderAdd=@BO_PurchaseOrderAdd,	
			BO_PurchaseOrderDelete=@BO_PurchaseOrderDelete,
			BO_PurchaseOrderEdit=@BO_PurchaseOrderEdit,
			BO_ItemChangePrice=	@BO_ItemChangePrice,	
			BO_ItemChangeCost	=@BO_ItemChangeCost,	
			BO_ItemAssSpecialPrice	=@BO_ItemAssSpecialPrice,	
			BO_ItemChangeDep	=@BO_ItemChangeDep,	
			BO_ItemChangeGroup	=@BO_ItemChangeGroup,	
			BO_DepAssDefMarkup	=@BO_DepAssDefMarkup,	
			BO_DepAssDefRoundup	=@BO_DepAssDefRoundup,	
			BO_CustAssPriceLevel	=@BO_CustAssPriceLevel,	
			BO_CustAllowChecks	=@BO_CustAllowChecks,	
			BO_CustChangeGroup=	@BO_CustChangeGroup,	
			BO_CustAssCreditLine	=@BO_CustAssCreditLine,	
			BO_ItemShowCost=@BO_ItemShowCost,
			BO_InvoiceVoid=         @BO_InvoiceVoid,
			BO_CustPaymentVoid =@BO_CustPaymentVoid,
			BO_CustCreditRefVoid =@BO_CustCreditRefVoid,
			BO_SaleOrderVoid =	@BO_SaleOrderVoid,
			BO_SupOrderVoid=	@BO_SupOrderVoid,
			BO_SupPaymentVoid=	@BO_SupPaymentVoid,
			BO_SupRecieveVoid=	@BO_SupRecieveVoid,
			BO_SupCreditRefVoid=	@BO_SupCreditRefVoid,
			BO_InRepBestWorst=@BO_InRepBestWorst	,
			BO_InRepSaleByTrans=@BO_InRepSaleByTrans	,	
			BO_InRepSaleByItem=@BO_InRepSaleByItem	,	
			BO_InRepSaleByDep=@BO_InRepSaleByDep	,	
			BO_InRepTagAlong=@BO_InRepTagAlong	,	
			BO_InRepDiscountSale=@BO_InRepDiscountSale	,	
			BO_InRepItemDaily=@BO_InRepItemDaily	,
			BO_InRepItemWeekly	=@BO_InRepItemWeekly,	
			BO_InRepItemMonthly=@BO_InRepItemMonthly	,	
			BO_InRepDepDaily=@BO_InRepDepDaily	,	
			BO_InRepDepMonthly	=@BO_InRepDepMonthly,	
			BO_InRepDepWeekly	=@BO_InRepDepWeekly,	
			BO_InRepSaleAvgByItem=@BO_InRepSaleAvgByItem	,	
			BO_InRepItemValuation=@BO_InRepItemValuation	,	
			BO_InRepDepValuation=@BO_InRepDepValuation	,	
			BO_InRepItemsTotals	=@BO_InRepItemsTotals,
			BO_InRepDateComp=	@BO_InRepDateComp,
            BO_ShowHomePage=@BO_ShowHomePage,
			BO_CustAddCharge=@BO_CustAddCharge,
			BO_ItemsShow =@BO_ItemsShow,
			BO_CustomerShow =@BO_CustomerShow,
			BO_AllowHideItemsColumns=@BO_AllowHideItemsColumns,
			BO_AllowHideCustomerColumns=@BO_AllowHideCustomerColumns,
			BO_ChangePriceHist=@BO_ChangePriceHist,
			BO_ShowPOHis	=@BO_ShowPOHis,
			BO_ShowReceiveHis		=@BO_ShowReceiveHis,
			BO_ShowSalesHis	=@BO_ShowSalesHis,
			BO_ShowSaleOrderHis	=@BO_ShowSaleOrderHis,
			BO_ShowQuickRep	=@BO_ShowQuickRep,
			BO_ShowMonthlySales	=@BO_ShowMonthlySales,
			BO_APNewTransfer	=@BO_APNewTransfer,
			BO_APEditTransfer	=@BO_APEditTransfer,
			BO_APDeleteTransfer	=@BO_APDeleteTransfer,
			BO_PRepBatch =@BO_PRepBatch,
			BO_PRepTenderTotals= @BO_PRepTenderTotals,
			BO_PRepActionSummary= @BO_PRepActionSummary,
			BO_PRepActionDetails =@BO_PRepActionDetails,
			BO_PRepARSales =@BO_PRepARSales,
			BO_PRepARPayments =@BO_PRepARPayments,
			BO_InRepSpecialsSummary=@BO_InRepSpecialsSummary,	
			BO_InRepTaxCollected=@BO_InRepTaxCollected,
			BO_InRepReturnItem=@BO_InRepReturnItem,
			BO_SupTransferOrderEdit =@BO_SupTransferOrderEdit,
			BO_SupTransferOrderVoid =@BO_SupTransferOrderEdit,
			BO_SupTransferOrderDelete =@BO_SupTransferOrderEdit,
			BO_SupTransferOrderAdd =@BO_SupTransferOrderEdit,
			BO_RepTransferList=@BO_RepTransferList,	
			BO_RepTransferStore=@BO_RepTransferStore,
			BO_PhoneOrderAdd=@BO_PhoneOrderAdd,	
			BO_PhoneOrderEdit=@BO_PhoneOrderEdit,	
			BO_PhoneOrderDelete=@BO_PhoneOrderDelete,		
			BO_PhoneOrderVoid=@BO_PhoneOrderVoid,	
			BO_WebComAdd=@BO_WebComAdd	,
			BO_WebComEdit=@BO_WebComEdit	,
		    BO_WebComDelete=@BO_WebComDelete,		
			BO_WebComVoid=@BO_WebComVoid,	
			BO_WebResAdd=@BO_WebResAdd,
		    BO_WebResEdit=@BO_WebResEdit,	
			BO_WebResDelete=@BO_WebResDelete,	
			BO_WebResVoid=@BO_WebResVoid,	
			BO_PDailyHoursSale=@BO_PDailyHoursSale,	
			BO_ARRepRunningBalance=@BO_ARRepRunningBalance,	
			BO_APRepRunningBalance=@BO_APRepRunningBalance,
			BO_CusStatement=@BO_CusStatement,		
			BO_APVoidTransfer=@BO_APVoidTransfer,	
			BO_ItemMerge=@BO_ItemMerge,	
			BO_ItemCopy	=@BO_ItemCopy,	
			BO_SupMerge	=@BO_SupMerge,
			BO_InChangeGeneralSale	=@BO_InChangeGeneralSale	,
			BO_InMixMatchNew=@BO_InMixMatchNew		,
			BO_InMixMatchEdit	=@BO_InMixMatchEdit	,
			BO_InMixMatchDelete=@BO_InMixMatchDelete	,
		    BO_InAdjustInventory=@BO_InAdjustInventory		,
			BO_PhoneRepItemsOnPhone=@BO_PhoneRepItemsOnPhone		,
			BO_PRepPayOut=@BO_PRepPayOut,
			BO_PPCAdd=@BO_PPCAdd	,	
			BO_PPCEdit=@BO_PPCEdit	,	
			BO_PPCDelete=@BO_PPCDelete	,	
			BO_PPCUserAdd=@BO_PPCUserAdd	,	
			BO_PPCUserEdit=@BO_PPCUserEdit	,	
			BO_PPCUserShow=@BO_PPCUserShow	,	
			BO_PPCUserDelete=@BO_PPCUserDelete	,	
			Bo_ReportsShowTotals=@Bo_ReportsShowTotals,
			BO_CustRestrictCheck=@BO_CustRestrictCheck,
			BO_ViewTransaction =@BO_ViewTransaction ,
			BO_RepItemsReturend = @BO_RepItemsReturend ,
			BO_RepPriceChanges = @BO_RepPriceChanges,
			BO_ViewRecentActivities=@BO_ViewRecentActivities,
			BO_ViewDashBoard = @BO_ViewDashBoard,
			BO_ViewStatistics = @BO_ViewStatistics,
			POS_CashChecks =@POS_CashChecks,
            POS_Minus =@POS_Minus,
            POS_ViewTransaction =@POS_ViewTransaction,
            POS_TaxExempt = @POS_TaxExempt,
            POS_ZOut = @POS_ZOut,
            POS_Gift  = @POS_Gift ,
			BO_Block =@BO_Block ,
			POS_AllowChangeForReturen = @POS_AllowChangeForReturen,
			POS_AllowManualItem = @POS_AllowManualItem,
			POS_AllowToReprintCoupon = @POS_AllowToReprintCoupon,
			POS_LoadTransaction=@POS_LoadTransaction,
			BO_SelectedDepartment=@BO_SelectedDepartment,
			ShowOtherOnHand=@ShowOtherOnHand,
			Status =@Status, 
	        DateModified =@UpdateTime, 
			UserModified = @ModifierID,
			BO_ShowTransferOrderHis=@BO_ShowTransferOrderHis

Where  GroupID=@GroupID AND (DateModified = @DateModified OR
                      DateModified IS NULL)

					  Update Users Set DateModified = dbo.GetLocalDATE()

select @UpdateTime as DateModified




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO