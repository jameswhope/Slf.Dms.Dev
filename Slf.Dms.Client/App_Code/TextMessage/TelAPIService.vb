Imports System.IO
Imports System.Net
Imports System.Text
Imports TelAPI
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Data

Public Class TelAPIService

#Region "Fields"

    Dim _AccountSID As String = "AC6c889084219baafd25274e3587efe0e7"
    Dim _AuthToken As String = "bf6788e8a4cf460ab6e0dcfa70f5608f"
    Dim _FromPhone As String = "(909) 532-5057"
    Dim _ToPhone As String = ""
    Dim _Message As String = ""
    Dim _client As TelAPIRestClient
    Dim _SMS As TelAPI.SmsMessage

#End Region 'End Fields

#Region "Properties"

    Public Property FromPhone As String
        Get
            Return _FromPhone
        End Get
        Set(value As String)
            _FromPhone = value
        End Set
    End Property

    Public Property ToPhone As String
        Get
            Return _ToPhone
        End Get
        Set(value As String)
            _ToPhone = value
        End Set
    End Property

    Public Property Message As String
        Get
            Return _Message
        End Get
        Set(value As String)
            _Message = value
        End Set
    End Property
#End Region 'End Properties

#Region "Constructors"

    Sub New()

    End Sub

#End Region 'End Constructors

#Region "Methods"

    Public Sub SendTextMessage()
        'Using API
        _client = New TelAPIRestClient(_AccountSID, _AuthToken)

        Try
            _SMS = _client.SendSmsMessage(FromPhone, ToPhone, Message)
            SubmitRecordOfText()
        Catch ex As Exception

        End Try
    End Sub
    Public Function GetClientsCellPhone(clientid As Integer) As DataRow

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("clientid", clientid))

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetClientsPhoneNumber", Data.CommandType.StoredProcedure, params.ToArray)
        Return dt.Rows(0)

    End Function
    Public Function GetMessage(clientid As Integer, Langauge As String) As String

        Dim str As String = ""
        If Langauge = "2" Then
            str = "Esta es {0}. Hemos llegado a un arreglo en una de sus cuentas. Póngase en contacto con nosotros al {1}."
        Else
            str = "This is {0}. We have reached a Settlement on one of your accounts. Please contact us at {1} to finalize."
        End If

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("clientid", clientid))

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetSettlementTextMessage", Data.CommandType.StoredProcedure, params.ToArray)
        If dt.Rows.Count > 0 Then
            str = String.Format(str, dt.Rows(0)("LawFirm"), dt.Rows(0)("Phone"))
        End If

        _Message = str

        Return str

    End Function
    Public Sub InsertNote(clientid As Integer)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("value", _Message))
        params.Add(New SqlParameter("created", Now))
        params.Add(New SqlParameter("createdby", 1265))
        params.Add(New SqlParameter("lastmodified", Now))
        params.Add(New SqlParameter("lastmodifiedby", 1265))
        params.Add(New SqlParameter("clientid", clientid))

        SqlHelper.ExecuteNonQuery("stp_ImportClientNoteInsert", Data.CommandType.StoredProcedure, params.ToArray)

    End Sub
    Private Sub SubmitRecordOfText()

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("SID", _SMS.Sid))
        params.Add(New SqlParameter("AccountSID", _SMS.AccountSid))
        params.Add(New SqlParameter("To", _SMS.To))
        params.Add(New SqlParameter("From", _SMS.From))
        params.Add(New SqlParameter("Body", _SMS.Body))
        params.Add(New SqlParameter("Status", _SMS.Status))
        params.Add(New SqlParameter("Direction", _SMS.Direction))
        params.Add(New SqlParameter("Price", _SMS.Price))
        params.Add(New SqlParameter("DateSent", _SMS.DateSent))

        Try
            SqlHelper.ExecuteNonQuery("stp_InsertSMSTextMessage", CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception

        End Try

    End Sub

#End Region


End Class
