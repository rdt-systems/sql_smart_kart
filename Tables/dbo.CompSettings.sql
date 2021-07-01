CREATE TABLE [dbo].[CompSettings] (
  [CompSettingID] [bigint] IDENTITY,
  [CompName] [nvarchar](50) NOT NULL,
  [CompStoreID] [uniqueidentifier] NULL,
  [CompUserLogedID] [uniqueidentifier] NULL,
  [mpUserLogOnTime] [datetime] NULL,
  [mpUserLogOffTime] [datetime] NULL,
  [CompPrinterPath] [nvarchar](50) NULL,
  [CompDBUpdatePath] [nvarchar](50) NULL
)
GO