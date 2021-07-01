CREATE TABLE [dbo].[CRM] (
  [CRMID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [RegularPaymentType] [int] NULL,
  [DateOfMounth] [datetime] NULL,
  [NextCallDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_CRM] PRIMARY KEY CLUSTERED ([CRMID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO