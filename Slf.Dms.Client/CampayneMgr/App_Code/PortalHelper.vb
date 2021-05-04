Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Imports Microsoft.VisualBasic

Public Class PortalHelper

#Region "Methods"
    Public Shared Function BuildUserNameBlock(loggedInUser As UserHelper.UserObj) As String
        Dim uname As String = loggedInUser.FirstName
        Select Case loggedInUser.UserTypeId
            Case 5
                'get affiliate name
                uname = SqlHelper.ExecuteScalar(String.Format("SELECT name FROM tblAffiliate where AffiliateID={0}", loggedInUser.UserTypeUniqueID), Data.CommandType.Text)
            Case 6
                'get buyer name
                uname = SqlHelper.ExecuteScalar(String.Format("SELECT buyer FROM tblbuyers where buyerid={0}", loggedInUser.UserTypeUniqueID), Data.CommandType.Text)
            Case 7
                'get advertiser name
                uname = SqlHelper.ExecuteScalar(String.Format("SELECT name FROM tblAdvertiser where AdvertiserID={0}", loggedInUser.UserTypeUniqueID), Data.CommandType.Text)
            Case 1
                uname = "(Admin)"
        End Select
        Return String.Format("Welcome <strong>{0}</strong>, {1}", loggedInUser.FirstName, uname)
    End Function
    Public Shared Sub CreateDownloadFile(pathToCreateFile As String, fileData As DataTable)
        Using sw As New StreamWriter(pathToCreateFile)
            Dim hdr As New List(Of String)
            For Each dc As DataColumn In fileData.Columns
                hdr.Add(String.Format("""{0}""", dc.ColumnName.ToString))
            Next
            sw.WriteLine(Join(hdr.ToArray, ","))
            For Each dr As DataRow In fileData.Rows
                Dim line As New List(Of String)
                For Each dc As DataColumn In fileData.Columns
                    line.Add(String.Format("""{0}""", dr(dc).ToString))
                Next
                sw.WriteLine(Join(line.ToArray, ","))
            Next
        End Using
    End Sub

    Public Shared Function GetPortalNofications(userid As Integer) As List(Of PortalNotification)
        GetPortalNofications = New List(Of PortalNotification)
        Dim ssql As String = "stp_portals_GetNotifications"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("userid", userid))

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                Dim pn As New PortalNotification(ID:=dr("NotificationID").ToString, _
                                                  Text:=dr("NotificationText").ToString, _
                                                  Type:=dr("NotificationTypeID").ToString)

                GetPortalNofications.Add(pn)
            Next
        End Using
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Structure downloadArgs

#Region "Fields"

        Public DataArguments As List(Of String)
        Public DownloadType As Integer

#End Region 'Fields

    End Structure

    Public Class PortalNotification

#Region "Fields"

        Private _NotificationID As Integer
        Private _NotificationText As String
        Private _NotificationType As enumTypeNotification
        Private _NotificationUserID As Integer
        Private _ReadBy As Integer
        Private _ReadDate As Date

#End Region 'Fields

#Region "Constructors"

        Sub New(ID As Integer, Text As String, type As enumTypeNotification)
            NotificationID = ID
            NotificationText = Text
            NotificationType = type
        End Sub

#End Region 'Constructors

#Region "Enumerations"

        Public Enum enumTypeNotification
            pnInfo = 1
            pnWarning = 2
            pnError = 3
        End Enum

#End Region 'Enumerations

#Region "Properties"

        Public Property NotificationID() As Integer
            Get
                Return _NotificationID
            End Get
            Set(ByVal Value As Integer)
                _NotificationID = Value
            End Set
        End Property

        Public Property NotificationText() As String
            Get
                Return _NotificationText
            End Get
            Set(ByVal Value As String)
                _NotificationText = Value
            End Set
        End Property

        Public Property NotificationType() As enumTypeNotification
            Get
                Return _NotificationType
            End Get
            Set(ByVal value As enumTypeNotification)
                _NotificationType = value
            End Set
        End Property

        Public Property NotificationUserID() As Integer
            Get
                Return _NotificationUserID
            End Get
            Set(ByVal Value As Integer)
                _NotificationUserID = Value
            End Set
        End Property

        Public Property ReadBy() As Integer
            Get
                Return _ReadBy
            End Get
            Set(ByVal Value As Integer)
                _ReadBy = Value
            End Set
        End Property

        Public Property ReadDate() As Date
            Get
                Return _ReadDate
            End Get
            Set(ByVal Value As Date)
                _ReadDate = Value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"
        Public Shared Sub InsertNotification(NotifyUserID As Integer, NoticeText As String, NoticeType As enumTypeNotification, SentBy As Integer)

            Dim ssql As String = "stp_portals_InsertNotification"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("UserID", NotifyUserID))
            params.Add(New SqlParameter("NotificationText", NoticeText))
            params.Add(New SqlParameter("NotificationTypeID", NoticeType))
            params.Add(New SqlParameter("SentBy", SentBy))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

        End Sub
        Public Shared Sub MarkAsRead(notificationid As Integer, userid As Integer)
            Dim ssql As String = "stp_portals_MarkNotificationAsRead"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("notificationid", notificationid))
            params.Add(New SqlParameter("readby", userid))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
        End Sub

#End Region 'Methods

    End Class

#End Region 'Nested Types

End Class