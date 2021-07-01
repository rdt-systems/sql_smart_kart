CREATE TABLE [dbo].[ItemsLookupValues] (
  [ValueType] [smallint] NOT NULL,
  [ValueID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ItemsLookupValues_ValueID] DEFAULT (newid()),
  [ValueName] [nvarchar](50) NOT NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_ItemsLookupValue] PRIMARY KEY CLUSTERED ([ValueID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO