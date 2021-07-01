CREATE TABLE [dbo].[DiscountGroup] (
  [DiscountGroupID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [GroupNo] [varchar](50) NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [Name] [nvarchar](50) NULL,
  CONSTRAINT [PK_DiscountGroup] PRIMARY KEY CLUSTERED ([DiscountGroupID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO