CREATE TABLE [dbo].[CustomerToPhone] (
  [CostumerToPhoneID] [uniqueidentifier] NOT NULL,
  [CostumerID] [uniqueidentifier] NULL,
  [PhoneID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([CostumerToPhoneID])
)
GO