CREATE TABLE [dbo].[PayTender] (
  [PayTenderID] [uniqueidentifier] NOT NULL,
  [AccountPaymentID] [uniqueidentifier] NULL,
  [Amount] [money] NULL,
  [PayType] [int] NOT NULL,
  [PayNo] [nvarchar](50) NULL,
  [AccountNO] [nvarchar](50) NULL,
  [CodeNO] [nvarchar](50) NULL,
  [CodeNO2] [nvarchar](50) NULL,
  [PayDate] [datetime] NULL,
  [SortOrder] [smallint] NULL,
  [Note] [nvarchar](4000) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_PayTender] PRIMARY KEY CLUSTERED ([PayTenderID])
)
GO