CREATE TABLE [dbo].[CouponCust] (
  [FirstName] [nvarchar](50) NULL,
  [LastName] [nvarchar](50) NULL,
  [CompanyName] [nvarchar](50) NULL,
  [CustomerNo] [nvarchar](50) NULL,
  [Street1] [nvarchar](50) NULL,
  [Street2] [nvarchar](50) NULL,
  [City] [nvarchar](20) NULL,
  [State] [nvarchar](100) NULL,
  [Zip] [nvarchar](15) NULL,
  [PhoneNumber1] [nvarchar](20) NULL,
  [Amount] [money] NULL,
  [CouponNo] [nvarchar](50) NULL,
  [ExpDate] [datetime] NULL,
  [CouponIssueDate] [datetime] NULL,
  [CouponID] [uniqueidentifier] NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [PurchaseWeek] [datetime] NOT NULL,
  [Status] [int] NULL,
  [Notes] [nvarchar](500) NULL
)
GO