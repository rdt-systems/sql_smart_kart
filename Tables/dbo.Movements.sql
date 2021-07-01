CREATE TABLE [dbo].[Movements] (
  [ActionType] [int] NOT NULL,
  [MovementType] [nvarchar](3) NOT NULL,
  [Details] [nvarchar](50) NULL,
  [DebitAccount] [nvarchar](8) NULL,
  [CreditAccount] [nvarchar](8) NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_Movements_Status] DEFAULT (1),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO