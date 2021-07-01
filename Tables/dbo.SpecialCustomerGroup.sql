CREATE TABLE [dbo].[SpecialCustomerGroup] (
  [SpecialCustomerGroupID] [int] IDENTITY,
  [ItemStoreID] [uniqueidentifier] NULL,
  [CustomerGroupID] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SpecialCustomerGroup] PRIMARY KEY CLUSTERED ([SpecialCustomerGroupID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO