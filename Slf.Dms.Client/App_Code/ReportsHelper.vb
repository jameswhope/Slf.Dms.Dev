Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Imports Drg.Util.DataAccess

Imports Microsoft.VisualBasic

Public Class ReportsHelper

    #Region "Methods"

    Public Shared Function CreateLeadDocumentRelation(ByVal leadApplicantID As Integer, ByVal documentName As String, ByVal documentPath As String, ByVal currentUserID As Integer) As Integer
        Dim sqlInsert As String = "INSERT INTO [tblLeadDocumentRelations]([LeadApplicantID],[DocumentName],[DocumentPath],[RelatedDate],[RelatedBy])"
        sqlInsert += String.Format("VALUES ({0},'{1}','{2}','{3}',{4})", leadApplicantID, documentName, documentPath, Now.ToString, currentUserID)
        Return SharedFunctions.AsyncDB.executeScalar(sqlInsert, ConfigurationManager.AppSettings("connectionstring").ToString)
    End Function

    ''' <summary>
    ''' list of clients creditor accounts
    ''' </summary>
    ''' <param name="ClientID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetCreditorAccounts(ByVal ClientID As String) As Dictionary(Of Integer, ClientAccountInfo)
        Dim creditors As New Dictionary(Of Integer, ClientAccountInfo)
        Dim strSQL As String = String.Format("stp_LetterTemplates_GetClientCreditors {0}", ClientID.ToString)

        Using cmd As New SqlCommand(strSQL, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString")))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()

                        creditors.Add(CInt(DatabaseHelper.Peel_int(reader, "currentcreditorinstanceid")), New ClientAccountInfo(CInt(DatabaseHelper.Peel_int(reader, "AccountID")), DatabaseHelper.Peel_string(reader, "Name").ToString(), CInt(DatabaseHelper.Peel_int(reader, "currentcreditorinstanceid"))))
                    End While
                End Using
            End Using
        End Using

        Return creditors
    End Function

    Public Shared Function GetNewDocID() As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="docTypeID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetUniqueDocumentName(ByVal ClientID As Integer, ByVal docTypeID As String, Optional ByVal ext As String = ".pdf") As String
        Dim ret As String

        Using conn As SqlConnection = ConnectionFactory.Create()
            conn.Open()
            ret = GetClientAccountNumber(conn, ClientID) + "_" + docTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ext
        End Using

        Return ret
    End Function

    ''' <summary>
    ''' builds pdf name for report to export
    ''' </summary>
    ''' <param name="rootDir"></param>
    ''' <param name="ClientID"></param>
    ''' <param name="strDocTypeID"></param>
    ''' <param name="UserID"></param>
    ''' <param name="subFolder"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetUniqueDocumentNameForReports(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, ByVal UserID As Integer, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ret As String

        Using conn As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            conn.Open()

            ret = rootDir + subFolder + GetClientAccountNumber(conn, ClientID) + "_" + strDocTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        Return ret
    End Function

    Public Shared Function GetUniqueDocumentNameForReports(ByVal ClientID As Integer, ByVal strDocTypeID As String, ByVal UserID As Integer) As String
        Dim ret As String

        Using conn As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            conn.Open()

            ret = GetClientAccountNumber(conn, ClientID) + "_" + strDocTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        Return ret
    End Function
    Public Shared Function GetUniqueDocumentNameForReports(ByVal rootDir As String, ByVal ClientID As Integer, ByVal DocTypeID As String, ByVal LexxiomDocumentID As String, ByVal UserID As Integer, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ret As String

        Using conn As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            conn.Open()

            ret = rootDir + subFolder + GetClientAccountNumber(conn, ClientID) + "_" + DocTypeID + "_" + LexxiomDocumentID + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        Return ret
    End Function
    Public Shared Sub InsertPrintInfo(ByVal docTypeID As String, ByVal dataClientID As Integer, ByVal documentPath As String, ByVal currentUser As Integer)
        Dim sqlInsert As New StringBuilder
        sqlInsert.AppendFormat("stp_LetterTemplates_InsertPrinted '{0}',{1},'{2}',{3}", docTypeID, dataClientID, documentPath, currentUser)
        SharedFunctions.AsyncDB.executeScalar(sqlInsert.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
    End Sub

    Public Shared Sub InsertPrintInfo(ByVal docTypeID As String, ByVal dataClientID As Integer, ByVal documentPath As String, ByVal currentUser As Integer, ByVal pageCount As Integer)
        Dim sqlInsert As New StringBuilder
        sqlInsert.AppendFormat("stp_LetterTemplates_InsertPrinted '{0}',{1},'{2}',{3},{4}", docTypeID, dataClientID, documentPath, currentUser, pageCount)
        SharedFunctions.AsyncDB.executeScalar(sqlInsert.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
    End Sub

    ''' <summary>
    ''' sets the clients printed date for specific report
    ''' </summary>
    ''' <param name="letters"></param>
    ''' <param name="ClientID"></param>
    ''' <param name="UserID"></param>
    ''' <remarks></remarks>
    Public Shared Sub SetPrinted(ByVal letters() As String, ByVal ClientID As Integer, ByVal UserID As Integer)
        Dim idxCreds As Integer

        Using cmd As New SqlCommand("", New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString))
            Using cmd.Connection
                cmd.Connection.Open()

                For Each letter As String In letters
                    idxCreds = letter.IndexOf("_")

                    If idxCreds < 0 Then
                        idxCreds = letter.Length
                    End If

                    letter = letter.Substring(0, idxCreds).Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "").Replace("/", "").Replace("*", "").Replace("&", "")

                    Try
                        cmd.CommandText = "UPDATE tblClient SET Sent" + letter + " = getdate(), SentBy" + letter + " = " + UserID.ToString() + " WHERE ClientID = " + ClientID.ToString()
                        cmd.ExecuteNonQuery()
                    Catch ex As SqlException
                        Continue For
                    End Try
                Next
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' gets client 600 number
    ''' </summary>
    ''' <param name="conn"></param>
    ''' <param name="ClientID"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function GetClientAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        If conn.State = ConnectionState.Closed Then conn.Open()

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function

    ''' <summary>
    ''' gets next doc id from db table property
    ''' </summary>
    ''' <param name="conn"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function GetDocID(ByVal conn As SqlConnection) As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", conn)
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function

    #End Region 'Methods

    #Region "Nested Types"

    <Serializable> _
    Public Structure AutoNoteTextVariable

        #Region "Fields"

        Public VariableID As Integer
        Public VariableName As String
        Public VariableType As String
        Public VariableValue As String

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal _VariableID As Integer, ByVal _VariableName As String, ByVal _VariableType As String, ByVal _VariableValue As String)
            VariableID = _VariableID
            VariableName = _VariableName
            VariableType = _VariableType
            VariableValue = _VariableValue
        End Sub

        #End Region 'Constructors

    End Structure

    <Serializable> _
    Public Structure ClientAccountInfo

        #Region "Fields"

        Public AccountID As Integer
        Public CreditorInstanceID As Integer
        Public CreditorName As String

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal id As Integer, ByVal credname As String, ByVal credinstID As Integer)
            Me.AccountID = id
            Me.CreditorName = credname
            Me.CreditorInstanceID = credinstID
        End Sub

        #End Region 'Constructors

    End Structure

    <Serializable> _
    Public Structure NoteTemplate

        #Region "Fields"

        Dim NoteText As String
        Dim NoteTitle As String
        Dim NoteTypeName As String
        Dim NoteVariables As List(Of AutoNoteTextVariable)
        Dim WizardStep As Integer

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal strNoteTitle As String, ByVal strNoteTypeName As String, ByVal lstNoteVariables As List(Of AutoNoteTextVariable), ByVal strNoteText As String, ByVal intWizardStep As Integer)
            Me.NoteVariables = lstNoteVariables
            Me.NoteText = strNoteText
            Me.NoteTitle = strNoteTitle
            Me.NoteTypeName = strNoteTypeName
            Me.WizardStep = intWizardStep
        End Sub

        #End Region 'Constructors

    End Structure

    <Serializable> _
    Public Structure ReportNoteInfo

        #Region "Fields"

        Dim ReportCreditor As String
        Dim ReportFilePath As String
        Dim ReportFolderPath As String
        Dim ReportType As String
        Dim ReportTypeName As String

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal sRptType As String, ByVal sDocTypeName As String, ByVal sDocFilePath As String, ByVal sDocFolderPath As String, Optional ByVal sCreditor As String = "")
            Me.ReportType = sRptType
            Me.ReportFilePath = sDocFilePath
            Me.ReportFolderPath = sDocFolderPath
            Me.ReportTypeName = sDocTypeName
            Me.ReportCreditor = sCreditor
        End Sub

        #End Region 'Constructors

    End Structure

    <Serializable> _
    Public Structure VariableValues

        #Region "Fields"

        Dim VarChoices As String
        Dim VarType As String

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal AvailableChoicesCommaSep As String, ByVal VariableType As String)
            Me.VarChoices = AvailableChoicesCommaSep
            Me.VarType = VariableType
        End Sub

        #End Region 'Constructors

    End Structure

    #End Region 'Nested Types

End Class