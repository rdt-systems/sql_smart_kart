CREATE TABLE [dbo].[Phone] (
  [PhoneID] [uniqueidentifier] NOT NULL,
  [PhoneNumber] [varchar](20) NULL,
  [PhoneType] [int] NULL,
  [SortOrder] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([PhoneID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO