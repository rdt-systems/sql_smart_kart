CREATE TABLE [dbo].[CustomerActivaty] (
  [CustomerActivatyID] [int] IDENTITY,
  [CustomerID] [uniqueidentifier] NULL,
  [OldCreditLine] [money] NULL,
  [NewCreditLine] [money] NULL,
  [DateCreated] [datetime] NOT NULL CONSTRAINT [DF_CustomerActivaty_DateCreated] DEFAULT (getdate()),
  [DateModified] [datetime] NOT NULL CONSTRAINT [DF_CustomerActivaty_DateModified] DEFAULT (getdate()),
  [Status] [int] NOT NULL CONSTRAINT [DF_CustomerActivaty_Status] DEFAULT (1),
  [UserCreated] [uniqueidentifier] NULL
)
GO