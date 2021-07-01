CREATE TABLE [dbo].[Customer] (
  [CustomerID] [uniqueidentifier] NOT NULL,
  [CustomerNo] [nvarchar](50) NULL,
  [FirstName] [nvarchar](50) NULL,
  [LastName] [nvarchar](50) NULL,
  [ClubID] [uniqueidentifier] NULL,
  [MainAddressID] [uniqueidentifier] NULL,
  [SalesPersonID] [uniqueidentifier] NULL,
  [SortOrder] [bigint] NULL,
  [BirthDay] [datetime] NULL,
  [CustomerType] [int] NOT NULL,
  [TaxID] [uniqueidentifier] NULL,
  [Current] [money] NULL,
  [Over0] [money] NULL CONSTRAINT [DF_Customer_Over150] DEFAULT (0),
  [Over30] [money] NULL CONSTRAINT [DF_Customer_Over30] DEFAULT (0),
  [Over60] [money] NULL CONSTRAINT [DF_Customer_Over60] DEFAULT (0),
  [Over90] [money] NULL CONSTRAINT [DF_Customer_Over90] DEFAULT (0),
  [Over120] [money] NULL CONSTRAINT [DF_Customer_Over120] DEFAULT (0),
  [Credit] [money] NULL CONSTRAINT [DF_Customer_Credit] DEFAULT (0),
  [AssignCreditLevel] [bit] NULL,
  [CreditLevel1] [money] NULL CONSTRAINT [DF_Customer_CreditLevel12] DEFAULT (0),
  [CreditLevel2] [money] NULL CONSTRAINT [DF_Customer_CreditLevel11] DEFAULT (0),
  [CreditLevel3] [money] NULL CONSTRAINT [DF_Customer_CreditByManger] DEFAULT (0),
  [CreditOnDelivery] [money] NULL,
  [TermDays] [int] NULL,
  [TermDiscount] [decimal] NULL,
  [CreditCardID] [int] NULL,
  [CreditCardNO] [nvarchar](500) NULL,
  [CSV] [nvarchar](20) NULL,
  [CCExpDate] [datetime] NULL,
  [CCTrack] [nvarchar](200) NULL,
  [DriverLicenseNo] [nvarchar](50) NULL,
  [State] [nvarchar](50) NULL,
  [SocialSecurytyNO] [nvarchar](50) NULL,
  [Password] [nvarchar](50) NULL,
  [Statment] [bit] NULL,
  [CheckAccept] [bit] NULL,
  [EnforceCreditLimit] [bit] NULL,
  [EnforceCheckSign] [bit] NULL,
  [OnMailingList] [bit] NULL,
  [FaxNumber] [nvarchar](50) NULL,
  [Contact1] [nvarchar](50) NULL,
  [Contact2] [nvarchar](50) NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [ResellerID] [uniqueidentifier] NULL,
  [PriceLevelID] [int] NULL,
  [DefaultTerms] [uniqueidentifier] NULL,
  [TaxExempt] [bit] NULL,
  [FoodStampNo] [nvarchar](50) NULL,
  [FoodStampCode] [nvarchar](50) NULL,
  [EnforceSignOnAccount] [bit] NULL,
  [LockAccount] [bit] NULL,
  [LockOutDays] [int] NULL,
  [CreditNameOn] [nvarchar](50) NULL,
  [CreditZip] [varchar](50) NULL,
  [InActiveReason] [nvarchar](4000) NULL,
  [AccountNo] [nvarchar](50) NULL,
  [SOTerms] [int] NULL,
  [Email] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [LastPayment] [money] NULL,
  [LastPaymentDate] [datetime] NULL,
  [BalanceDoe] [money] NULL,
  [StartBalance] [money] NULL,
  [StartBalanceDate] [datetime] NULL,
  [LoyaltyMembertype] [smallint] NULL,
  [NoBalance] [bit] NULL,
  [TaxNumber] [nvarchar](25) NULL,
  [ExpDiscount] [datetime] NULL,
  [OldCustNo] [nvarchar](15) NULL,
  [CODBalance] [money] NULL,
  [RPNBalance] [money] NULL,
  [RPNCardNumber] [nvarchar](30) NULL,
  [HideInPOS] [bit] NULL,
  [RegularPaymentType] [int] NULL,
  [DayOfMounth] [int] NULL,
  [StoreCreated] [uniqueidentifier] NULL,
  [CountSales] [int] NULL,
  [SumSales] [money] NULL,
  [LastSaleDate] [datetime] NULL,
  CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_Customer_10_1759149858__K1_2_3_4]
  ON [dbo].[Customer] ([CustomerID])
  INCLUDE ([FirstName], [LastName], [CustomerNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [Customer_IX1]
  ON [dbo].[Customer] ([Status], [DateCreated])
  INCLUDE ([CustomerID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE UNIQUE INDEX [CustomerNo_Unique]
  ON [dbo].[Customer] ([CustomerNo])
  WHERE ([Status]>(-1))
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Customer_CustomerNo_CustomerID_Status]
  ON [dbo].[Customer] ([CustomerNo], [CustomerID], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Customer_CustomerNo_Status]
  ON [dbo].[Customer] ([CustomerNo], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Customer_DateModified]
  ON [dbo].[Customer] ([DateModified])
  INCLUDE ([CustomerNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Customer_UpdateBalance_Speed_0001]
  ON [dbo].[Customer] ([DateModified])
  INCLUDE ([BalanceDoe])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustStatus]
  ON [dbo].[Customer] ([Status])
  INCLUDE ([MainAddressID], [DiscountID], [StoreCreated], [LastName], [CustomerID], [CustomerNo], [FirstName])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeletetMember] on [dbo].[Customer]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT CustomerID, 'CustomerMemberCards' , Status, dbo.GetLocalDATE() , 1,'CardID' FROM      inserted
  end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeletetCustomer] on [dbo].[Customer]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT CustomerID, 'CustomerQuery' , Status, dbo.GetLocalDATE() , 1,'CustomerID' FROM      inserted
  end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_CustomerCreated] on [dbo].[Customer]
for  insert
as


BEGIN

Declare @ModifierID uniqueidentifier
Declare @ToCustomerID uniqueidentifier




select  @ToCustomerID = CustomerID ,@ModifierID=UserModified
from inserted


Begin

exec SP_SaveRecentActivity 2,'Customer',1,@ToCustomerID,1,'CustomerID',@ModifierID,null

End




END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_CreditLineChanged] on [dbo].[Customer]
for  update
as

if   Update (Credit)
BEGIN

Declare @OldCredit money
Declare @NewCredit money

SELECT   TOP(1) @OldCredit = Credit
From deleted

--Select the New Records
select  @NewCredit = Credit
from inserted

If @NewCredit <> @OldCredit
Begin

Insert Into CustomerActivaty (CustomerID,OldCreditLine,NewCreditLine, UserCreated)
SELECT CustomerID, @OldCredit, @NewCredit, UserModified from inserted
End

END
GO

















SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO