CREATE TABLE [dbo].[LoyaltyGroup] (
  [LoyaltyGroupID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Points] [int] NULL,
  [DateModified] [datetime] NULL,
  [Status] [int] NULL,
  CONSTRAINT [PK_LoyaltyGroup] PRIMARY KEY CLUSTERED ([LoyaltyGroupID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO