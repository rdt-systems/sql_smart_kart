CREATE TABLE [dbo].[Season] (
  [SeasonId] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Description] [nvarchar](4000) NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([SeasonId]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO