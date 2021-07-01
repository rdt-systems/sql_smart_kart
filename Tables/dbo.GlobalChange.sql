CREATE TABLE [dbo].[GlobalChange] (
  [GlobalChangeID] [uniqueidentifier] NOT NULL,
  [UserID] [uniqueidentifier] NULL,
  [ChangeDescr] [nvarchar](150) NULL,
  [AllStores] [bit] NULL,
  [DateCreated] [datetime] NULL,
  CONSTRAINT [PK_GlobalChange] PRIMARY KEY NONCLUSTERED ([GlobalChangeID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO