CREATE TABLE [dbo].[CustomerGroup] (
  [CustomerGroupID] [uniqueidentifier] NOT NULL,
  [CustomerGroupName] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  [Sort] [int] NULL,
  PRIMARY KEY CLUSTERED ([CustomerGroupID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteCustomerGroup] on [dbo].[CustomerGroup]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
  Declare @ID Uniqueidentifier
  Select @ID = CustomerGroupID from inserted
   update  CustomerToGroup set Status = -1, DateModified = dbo.GetLocalDATE() where CustomerGroupID = @ID
  end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO