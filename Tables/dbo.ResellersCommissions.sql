CREATE TABLE [dbo].[ResellersCommissions] (
  [CommissionID] [uniqueidentifier] NOT NULL,
  [ResellerID] [uniqueidentifier] NOT NULL,
  [Amount] [money] NULL,
  [SentDate] [datetime] NULL,
  [CheckDate] [datetime] NULL,
  [CheckNo] [nvarchar](50) NULL,
  [CheckBank] [nvarchar](50) NULL,
  [CheckSubsidiary] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_ResellersCommissions] PRIMARY KEY CLUSTERED ([CommissionID])
)
GO