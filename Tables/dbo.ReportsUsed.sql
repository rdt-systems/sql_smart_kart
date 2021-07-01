CREATE TABLE [dbo].[ReportsUsed] (
  [RepUserId] [int] IDENTITY,
  [RepNama] [varchar](50) NULL,
  [UserId] [uniqueidentifier] NULL,
  [DateUsed] [datetime] NULL
)
GO