CREATE TABLE [dbo].[SetUpValues] (
  [OptionID] [int] NOT NULL,
  [CategoryID] [smallint] NULL,
  [StoreID] [uniqueidentifier] NOT NULL,
  [OptionName] [nvarchar](50) NOT NULL,
  [OptionValue] [nvarchar](4000) NULL,
  [OptionValueHe] [nvarchar](4000) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [IsDefault] [bit] NULL CONSTRAINT [DF_SetUpValues_IsDefault] DEFAULT (0),
  [Description] [nvarchar](500) NULL,
  [FeildType] [int] NULL
)
GO

CREATE UNIQUE INDEX [IX_SetUpValues_ix1]
  ON [dbo].[SetUpValues] ([StoreID], [OptionName])
GO

CREATE UNIQUE INDEX [IX_SetUpValues_ix2]
  ON [dbo].[SetUpValues] ([StoreID], [OptionID])
GO

CREATE INDEX [IX_SetUpValues_OptionID]
  ON [dbo].[SetUpValues] ([OptionID])
GO