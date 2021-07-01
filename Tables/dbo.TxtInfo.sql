CREATE TABLE [dbo].[TxtInfo] (
  [ID] [int] IDENTITY,
  [PhoneNo] [nvarchar](100) NULL,
  [DateCreated] [datetime] NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [Active] [bit] NULL,
  CONSTRAINT [PK_TxtInfo] PRIMARY KEY CLUSTERED ([ID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO