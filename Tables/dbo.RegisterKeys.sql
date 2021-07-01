CREATE TABLE [dbo].[RegisterKeys] (
  [ActionID] [nvarchar](50) NULL,
  [ActionKey] [nvarchar](10) NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [IsAction] [bit] NULL,
  [IsButton] [bit] NULL,
  [RegisterKeyID] [int] NOT NULL,
  [ShiftType] [smallint] NULL,
  [Status] [smallint] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_RegisterKeys] PRIMARY KEY CLUSTERED ([RegisterKeyID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO