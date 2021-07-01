SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[DeliveryDetailsTodayView]
AS
SELECT        D.TransactionID, T.TransactionNo, D.Cases, D.Box, D.Shift, D.Note, D.BeDeliverdDate AS ScheduledDate, PhoneOrderType.SystemValueName AS PhoneType, D.StatusType, D.PaidString, D.Status, 
                         D.DateModified
FROM            DeliveryDetails AS D WITH (NOLOCK) INNER JOIN
                         [Transaction] AS T WITH (NOLOCK) ON D.TransactionID = T.TransactionID LEFT OUTER JOIN
                         PhoneOrder AS P WITH (NOLOCK) ON D.TransactionID = P.TransactionID LEFT OUTER JOIN
                             (SELECT        SystemValueName, SystemValueNo
                               FROM            SystemValues
                               WHERE        (SystemTableNo = 56)) AS PhoneOrderType ON P.Type = PhoneOrderType.SystemValueNo
WHERE        (D.Status > - 1) AND (D.DateModified > dbo.GetLocalDate() - 2)

GO