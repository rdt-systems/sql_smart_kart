SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_UsersView]
(@FromDate DateTime)

As 
SELECT AssociatedUserID as UserID,
	   AssociatedResellerID as ResellerID,
	   UserName, 
	   Password,
	   [Type] as UserType

FROM PPCUsers

Where Status>0 And
	  (DateCreated>@FromDate Or DateModified>@FromDate)
GO