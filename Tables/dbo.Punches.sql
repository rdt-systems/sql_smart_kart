CREATE TABLE [dbo].[Punches] (
  [PunchID] [int] IDENTITY,
  [UserID] [uniqueidentifier] NOT NULL,
  [PunchTime] [datetime] NOT NULL,
  [PunchType] [bit] NOT NULL,
  [Status] [int] NOT NULL,
  [RegisterID] [uniqueidentifier] NULL,
  [InOutID] [int] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Ragulare] [decimal](18, 2) NULL,
  [Holiday] [decimal](18, 2) NULL,
  [OverTime] [decimal](18, 2) NULL,
  [Sick] [decimal](18, 2) NULL,
  CONSTRAINT [PK_Punches] PRIMARY KEY CLUSTERED ([PunchID])
)
GO