CREATE TABLE [dbo].[AlterationsStatus] (
  [StatusChangedID] [int] IDENTITY,
  [AlterationID] [int] NOT NULL,
  [Status] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  [UserID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_AlterationsStatus] PRIMARY KEY CLUSTERED ([StatusChangedID])
)
GO