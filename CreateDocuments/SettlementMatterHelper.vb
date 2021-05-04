Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.IO
Imports System.Linq
Imports System.Xml.Linq
Imports DataDynamics.ActiveReports.Export.Pdf
Imports System.Text

Public Class SettlementMatterHelper

#Region "Structures"
    Public Structure SettlementInformation
        Public SettlementID As Integer
        Public AccountID As Integer
        Public ClientID As Integer
        Public RegisterBalance As Double
        Public SDABalance As Double
        Public PFOBalance As Double
        Public CreditorAccountBalance As Double
        Public SettlementPercent As Single
        Public SettlementAmount As Double
        Public SettlementAmountAvailable As Double
        Public SettlementAmountSent As Double
        Public SettlementAmountOwed As Double
        Public SettlementDueDate As DateTime
        Public SettlementSavings As Double
        Public SettlementFee As Double
        Public AdjustedSettlementFee As Double
        Public SettlementFeeCredit As Double
        Public OvernightDeliveryFee As Double
        Public DeliveryMethod As String
        Public DeliveryAmount As Double
        Public SettlementCost As Double
        Public SettlementFeeAmountAvailable As Double
        Public SettlementFeeAmountBeingPaid As Double
        Public SettlementFeeAmountOwed As Double
        Public IsPaymentArrangement As Boolean
        Public IsRestrictiveEndorsement As Boolean
        Public MatterSubStatusId As Integer
        Public MatterStatusCodeId As Integer
        Public MatterId As Integer
        Public MatterStatusCode As String
        Public MatterSubStatus As String
        Public BankReserve As Double
        Public FrozenAmount As Double
        Public SpecialInstructions As String
        Public EnrollmentDate As String
        Public CreditorOriginalBalance As Double
        Public CreditorCurrentBalance As Double
        Public DownPayment As Double

        Public Sub New(ByVal _SettlementID As Integer, ByVal _AccountID As Integer, ByVal _ClientID As Integer, _
                       ByVal _RegisterBalance As Double, ByVal _SDABalance As Double, ByVal _PFOBalance As Double, _
                       ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
                       ByVal _SettlementAmount As Double, ByVal _SettlementAmountAvailable As Double, _
                       ByVal _SettlementAmountSent As Double, ByVal _SettlementAmountOwed As Double, ByVal _SettlementDueDate As DateTime, _
                       ByVal _SettlementSavings As Double, ByVal _SettlementFee As Double, ByVal _AdjustedFee As Double, ByVal _SettlementFeeCredit As Double, _
                       ByVal _OvernightDeliveryFee As Double, ByVal _DeliveryAmount As Double, ByVal _DeliveryMethod As String, _
                       ByVal _SettlementCost As Double, ByVal _SettlementFeeAmountAvailable As Double, _
                       ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
                       ByVal _IsRestrictiveEndorsement As Boolean, ByVal _MatterSubStatusId As Integer, ByVal _MatterStatusCodeId As Integer, _
                       ByVal _MatterId As Integer, ByVal _MatterStatusCode As String, ByVal _MatterSubStatus As String, ByVal _BankReserve As Double, ByVal _FrozenAmount As Double, _
                       ByVal _IsPaymentArrangement As Boolean, ByVal _DownPayment As Double)

            Me.SettlementID = _SettlementID
            Me.AccountID = _AccountID
            Me.ClientID = _ClientID
            Me.RegisterBalance = _RegisterBalance
            Me.SDABalance = _SDABalance
            Me.PFOBalance = _PFOBalance
            Me.CreditorAccountBalance = _CreditorAccountBalance
            Me.SettlementPercent = _SettlementPercent
            Me.SettlementAmount = _SettlementAmount
            Me.SettlementAmountAvailable = _SettlementAmountAvailable
            Me.SettlementAmountSent = _SettlementAmountSent
            Me.SettlementAmountOwed = _SettlementAmountOwed
            Me.SettlementDueDate = _SettlementDueDate
            Me.SettlementSavings = _SettlementSavings
            Me.SettlementFee = _SettlementFee
            Me.AdjustedSettlementFee = _AdjustedFee
            Me.SettlementFeeCredit = _SettlementFeeCredit
            Me.OvernightDeliveryFee = _OvernightDeliveryFee
            Me.DeliveryMethod = _DeliveryMethod
            Me.DeliveryAmount = _DeliveryAmount
            Me.SettlementCost = _SettlementCost
            Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
            Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
            Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
            Me.MatterId = _MatterId
            Me.MatterSubStatusId = _MatterSubStatusId
            Me.MatterStatusCodeId = _MatterStatusCodeId
            Me.IsRestrictiveEndorsement = _IsRestrictiveEndorsement
            Me.MatterStatusCode = _MatterStatusCode
            Me.MatterSubStatus = _MatterSubStatus
            Me.BankReserve = _BankReserve
            Me.FrozenAmount = _FrozenAmount
            Me.IsPaymentArrangement = _IsPaymentArrangement
            Me.DownPayment = _DownPayment
        End Sub
        Public Sub New(ByVal _SettlementID As Integer, ByVal _AccountID As Integer, ByVal _ClientID As Integer, _
                       ByVal _RegisterBalance As Double, ByVal _SDABalance As Double, ByVal _PFOBalance As Double, _
                       ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
                       ByVal _SettlementAmount As Double, ByVal _SettlementAmountAvailable As Double, _
                       ByVal _SettlementAmountSent As Double, ByVal _SettlementAmountOwed As Double, ByVal _SettlementDueDate As DateTime, _
                       ByVal _SettlementSavings As Double, ByVal _SettlementFee As Double, ByVal _AdjustedFee As Double, ByVal _SettlementFeeCredit As Double, _
                       ByVal _OvernightDeliveryFee As Double, ByVal _DeliveryAmount As Double, ByVal _DeliveryMethod As String, _
                       ByVal _SettlementCost As Double, ByVal _SettlementFeeAmountAvailable As Double, _
                       ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
                       ByVal _IsRestrictiveEndorsement As Boolean, ByVal _MatterSubStatusId As Integer, ByVal _MatterStatusCodeId As Integer, _
                       ByVal _MatterId As Integer, ByVal _MatterStatusCode As String, ByVal _MatterSubStatus As String, _
                       ByVal _BankReserve As Double, ByVal _FrozenAmount As Double, ByVal _SpecialInstructions As String, _
                       ByVal _IsPaymentArrangement As Boolean, ByVal _DownPayment As Double)

            Me.SettlementID = _SettlementID
            Me.AccountID = _AccountID
            Me.ClientID = _ClientID
            Me.RegisterBalance = _RegisterBalance
            Me.SDABalance = _SDABalance
            Me.PFOBalance = _PFOBalance
            Me.CreditorAccountBalance = _CreditorAccountBalance
            Me.SettlementPercent = _SettlementPercent
            Me.SettlementAmount = _SettlementAmount
            Me.SettlementAmountAvailable = _SettlementAmountAvailable
            Me.SettlementAmountSent = _SettlementAmountSent
            Me.SettlementAmountOwed = _SettlementAmountOwed
            Me.SettlementDueDate = _SettlementDueDate
            Me.SettlementSavings = _SettlementSavings
            Me.SettlementFee = _SettlementFee
            Me.AdjustedSettlementFee = _AdjustedFee
            Me.SettlementFeeCredit = _SettlementFeeCredit
            Me.OvernightDeliveryFee = _OvernightDeliveryFee
            Me.DeliveryMethod = _DeliveryMethod
            Me.DeliveryAmount = _DeliveryAmount
            Me.SettlementCost = _SettlementCost
            Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
            Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
            Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
            Me.MatterId = _MatterId
            Me.MatterSubStatusId = _MatterSubStatusId
            Me.MatterStatusCodeId = _MatterStatusCodeId
            Me.IsRestrictiveEndorsement = _IsRestrictiveEndorsement
            Me.MatterStatusCode = _MatterStatusCode
            Me.MatterSubStatus = _MatterSubStatus
            Me.BankReserve = _BankReserve
            Me.FrozenAmount = _FrozenAmount
            Me.SpecialInstructions = _SpecialInstructions
            Me.IsPaymentArrangement = _IsPaymentArrangement
            Me.DownPayment = _DownPayment
        End Sub
        Public Sub New(ByVal _SettlementID As Integer, ByVal _AccountID As Integer, ByVal _ClientID As Integer, _
                       ByVal _RegisterBalance As Double, ByVal _SDABalance As Double, ByVal _PFOBalance As Double, _
                       ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
                       ByVal _SettlementAmount As Double, ByVal _SettlementAmountAvailable As Double, _
                       ByVal _SettlementAmountSent As Double, ByVal _SettlementAmountOwed As Double, ByVal _SettlementDueDate As DateTime, _
                       ByVal _SettlementSavings As Double, ByVal _SettlementFee As Double, ByVal _AdjustedFee As Double, ByVal _SettlementFeeCredit As Double, _
                       ByVal _OvernightDeliveryFee As Double, ByVal _DeliveryAmount As Double, ByVal _DeliveryMethod As String, _
                       ByVal _SettlementCost As Double, ByVal _SettlementFeeAmountAvailable As Double, _
                       ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
                       ByVal _IsRestrictiveEndorsement As Boolean, ByVal _MatterSubStatusId As Integer, ByVal _MatterStatusCodeId As Integer, _
                       ByVal _MatterId As Integer, ByVal _MatterStatusCode As String, ByVal _MatterSubStatus As String, _
                       ByVal _BankReserve As Double, ByVal _FrozenAmount As Double, ByVal _SpecialInstructions As String, _
                       ByVal _EnrollmentDate As String, ByVal _CreditorOriginalBalance As Double, ByVal _CreditorCurrentBalance As String, _
                       ByVal _IsPaymentArrangement As Boolean, ByVal _DownPayment As Double)

            Me.SettlementID = _SettlementID
            Me.AccountID = _AccountID
            Me.ClientID = _ClientID
            Me.RegisterBalance = _RegisterBalance
            Me.SDABalance = _SDABalance
            Me.PFOBalance = _PFOBalance
            Me.CreditorAccountBalance = _CreditorAccountBalance
            Me.SettlementPercent = _SettlementPercent
            Me.SettlementAmount = _SettlementAmount
            Me.SettlementAmountAvailable = _SettlementAmountAvailable
            Me.SettlementAmountSent = _SettlementAmountSent
            Me.SettlementAmountOwed = _SettlementAmountOwed
            Me.SettlementDueDate = _SettlementDueDate
            Me.SettlementSavings = _SettlementSavings
            Me.SettlementFee = _SettlementFee
            Me.AdjustedSettlementFee = _AdjustedFee
            Me.SettlementFeeCredit = _SettlementFeeCredit
            Me.OvernightDeliveryFee = _OvernightDeliveryFee
            Me.DeliveryMethod = _DeliveryMethod
            Me.DeliveryAmount = _DeliveryAmount
            Me.SettlementCost = _SettlementCost
            Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
            Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
            Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
            Me.MatterId = _MatterId
            Me.MatterSubStatusId = _MatterSubStatusId
            Me.MatterStatusCodeId = _MatterStatusCodeId
            Me.IsRestrictiveEndorsement = _IsRestrictiveEndorsement
            Me.MatterStatusCode = _MatterStatusCode
            Me.MatterSubStatus = _MatterSubStatus
            Me.BankReserve = _BankReserve
            Me.FrozenAmount = _FrozenAmount
            Me.SpecialInstructions = _SpecialInstructions
            Me.EnrollmentDate = _EnrollmentDate
            Me.CreditorOriginalBalance = _CreditorOriginalBalance
            Me.CreditorCurrentBalance = _CreditorCurrentBalance
            Me.IsPaymentArrangement = _IsPaymentArrangement
            Me.DownPayment = _DownPayment
        End Sub

    End Structure

    Public Structure ClientVerification
        Public ApprovalType As String
        Public Note As String
        Public RejectionReason As String

        Public Sub New(ByVal _ApprovalType As String, ByVal _Note As String, ByVal _RejectionReason As String)
            Me.ApprovalType = _ApprovalType
            Me.Note = _Note
            Me.RejectionReason = _RejectionReason
        End Sub
    End Structure

    Public Structure AdjustedFeeDetails
        Public NewAmount As Double
        Public Reason As String
        Public EntryTypeId As Integer

        Public Sub New(ByVal _NewAmount As Double, ByVal _EntryTypeId As Integer, ByVal _Reason As String)
            Me.NewAmount = _NewAmount
            Me.Reason = _Reason
            Me.EntryTypeId = _EntryTypeId
        End Sub
    End Structure
#End Region

    ''' <summary>
    ''' Adds a note to the settlement
    ''' </summary>
    ''' <param name="SettlementId">Integer to uniquely identify the settlement</param>
    ''' <param name="Note">Note to be added</param>
    ''' <param name="UserId">Integer to uniquely identify the User adding the note</param>
    Public Shared Sub AddSettlementNote(ByVal SettlementId As Integer, ByVal Note As String, ByVal UserId As Integer)
        Dim outputParam As IDataParameter
        Dim tblSettlementInfo As DataTable = SqlHelper.GetDataTable(String.Format("select MatterId, ClientId, CreditorAccountId from tblSettlements with(nolock)  where SettlementId = {0}", SettlementId))
        Dim MatterId As Integer
        Dim ClientId As Integer
        Dim _AccountID As Integer

        If tblSettlementInfo.Rows.Count = 1 Then
            MatterId = CInt(tblSettlementInfo.Rows(0)(0))
            ClientId = CInt(tblSettlementInfo.Rows(0)(1))
            _AccountID = CInt(tblSettlementInfo.Rows(0)(2))
        End If

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_InsertNoteForSettlementMatter"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientId)
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "CreditorAcctId", _AccountID)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserId)
                DatabaseHelper.AddParameter(cmd, "Note", Note)
                outputParam = DatabaseHelper.CreateAndAddParamater(cmd, "ReturnNoteId", DbType.Int32)
                outputParam.Direction = ParameterDirection.Output
                cmd.ExecuteNonQuery()
            End Using

            Dim sqlInsert As String
            sqlInsert = "INSERT INTO tblSettlementNote (SettlementID, Note, CreatedBy, CreatedDateTime, NoteId) VALUES (" & SettlementId & ", "
            sqlInsert += "'" & Note.Replace("'", "''") & "', " & UserId & "," & "'" & DateTime.Now.ToString() & "' ," & CInt(outputParam.Value) & ")"

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = sqlInsert
                cmd.ExecuteNonQuery()
            End Using
        End Using

    End Sub
    Public Function GetCreditorAccountID(ByVal intSettlementID As Integer) As Integer
        Return DataHelper.FieldLookup("tblSettlements", "CreditorAccountID", "SettlementID = " & intSettlementID)
    End Function
    ''' <summary>
    ''' Gets the Status of the matter associated with the settlement
    ''' </summary>
    ''' <param name="settlementId">Integer to uniquely identify the settlement</param>
    ''' <returns>Integer representing the status of the matter</returns>
    ''' <remarks></remarks>
    Public Shared Function GetSettlementMatterStatus(ByVal settlementId As Integer) As Integer

        Dim matterStatus As Integer = 0
        Using cmd As New SqlCommand("Select m.MatterStatusCodeId From tblMatter m with(nolock) " & _
                                    "inner join tblSettlements s with(nolock) On s.MatterId = m.MatterId and s.settlementId = " & settlementId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        matterStatus = DatabaseHelper.Peel_int(reader, "MatterStatusCodeId")
                    End If
                End Using
            End Using
        End Using
        Return matterStatus

    End Function
    ''' <summary>
    ''' Returns the account number of the creditor associated with the settlement
    ''' </summary>
    ''' <param name="settlementId">Integer to uniquely identify the Settlement</param>
    ''' <returns>Account number of Creditor</returns>
    Public Shared Function GetCreditorAccountNumber(ByVal settlementId As Integer) As String

        Dim accountNo As String = String.Empty
        Using cmd As New SqlCommand("select AccountNumber from tblSettlements s with(nolock) inner join " & _
                                "tblAccount a with(nolock)  on a.AccountId = s.CreditorAccountId inner join " & _
                                "tblCreditorInstance ci with(nolock) on ci.CreditorInstanceId = a.CurrentCreditorInstanceId " & _
                                "where SettlementId =" & settlementId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        accountNo = DatabaseHelper.Peel_string(reader, "AccountNumber")
                    End If
                End Using
            End Using
        End Using
        Return accountNo

    End Function
    ''' <summary>
    ''' Returns the note associated with a resolved verification task
    ''' </summary>
    ''' <param name="TaskId">Integer to uniquely identify the Task</param>
    ''' <returns>note associated with a resolved verification task</returns>
    ''' <remarks>This could return a null value if no note is present</remarks>
    Public Shared Function GetVerificationNote(ByVal TaskId As Integer) As String

        Dim note As String
        Using cmd As New SqlCommand("SELECT n.[Value] AS Note FROM tblNote n with(nolock) WHERE n.NoteId = ( " & _
                                    "SELECT min(tn.NoteId) FROM tblTaskNote tn with(nolock) " & _
                                    "WHERE tn.TaskId =" & TaskId & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        note = DatabaseHelper.Peel_string(reader, "Note")
                    End If
                End Using
            End Using
        End Using
        Return note

    End Function
    ''' <summary>
    ''' Gets all the information of a resolved ClientApproval Task
    ''' </summary>
    ''' <param name="SettlementID">Integer to uniquely identify the settlement</param>
    ''' <returns>Structure containing the details</returns>
    Public Shared Function GetClientApproval(ByVal SettlementID As Integer) As ClientVerification
        Dim ret As ClientVerification = Nothing

        Using cmd As New SqlCommand("Select ApprovalType, n.[Value] As Note, cr.ReasonName As Reason " & _
                                    "From tblSettlements s with(nolock) inner join " & _
                                    "tblMatter m with(nolock) ON m.MatterId = s.MatterId left join " & _
                                    "tblSettlementClientApproval sc with(nolock) ON sc.MatterId = m.MatterId left join " & _
                                    "tblClientRejectionReason cr with(nolock) ON cr.ReasonId = sc.ReasonId left join " & _
                                    "tblNote n with(nolock) ON n.NoteId = sc.NoteId " & _
                                    "Where s.SettlementId =" & SettlementID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        ret.ApprovalType = DatabaseHelper.Peel_string(reader, "ApprovalType")
                        ret.Note = DatabaseHelper.Peel_string(reader, "Note")
                        ret.RejectionReason = DatabaseHelper.Peel_string(reader, "Reason")
                    End If
                End Using
            End Using
        End Using

        Return ret
    End Function
    ''' <summary>
    ''' Distributes the tasks created for settlements among the Settlement Processing users
    ''' </summary>
    ''' <param name="connection">DB connection to be used</param>
    ''' <param name="inTransaction">Transaction associated with the connection</param>
    ''' <returns>List of users</returns>
    Public Shared Function DistributeSettlements(ByVal connection As IDbConnection, ByVal inTransaction As IDbTransaction) As Dictionary(Of Integer, List(Of Integer))
        Dim entityIDs As New Dictionary(Of Integer, Double)()
        Dim settlements As New Dictionary(Of Integer, Double)()
        Dim list As New Dictionary(Of Integer, List(Of Integer))()

        'connection.Open()
        Using cmd As IDbCommand = connection.CreateCommand()
            cmd.CommandText = "SELECT u.UserID, isnull(sp.SettlementAmount, 0) as SettlementAmount " & _
                            "FROM tblUser as u with(nolock) left join " & _
                            "(SELECT sum(isnull(s.SettlementAmount, 0)) as SettlementAmount, t.AssignedTo as UserID " & _
                            "FROM tblSettlements as s with(nolock) inner join tblMatterTask mt with(nolock) ON mt.MatterId = s.MatterId  " & _
                            "inner join tblTask t with(nolock) on t.TaskId = mt.TaskId AND TaskTypeId IN (40,41,42) " & _
                            "WHERE s.Active = 1 GROUP BY t.AssignedTo) as sp ON " & _
                            "sp.UserID = u.UserID " & _
                            "WHERE u.UserGroupID = 22 and u.Locked = 0 ORDER BY u.UserID "
            cmd.CommandType = CommandType.Text
            cmd.Transaction = inTransaction
            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    entityIDs.Add(CInt(reader("UserID")), CDbl(reader("SettlementAmount")))
                End While
            End Using
        End Using

        Using cmd As IDbCommand = connection.CreateCommand()
            cmd.CommandText = "SELECT Distinct(s.SettlementID), s.SettlementAmount FROM tblSettlements s with(nolock)  " & _
                          "INNER JOIN tblMatter m with(nolock)  ON m.MatterId = s.MatterId AND m.MatterStatusCodeId IN (23,22,27) AND m.IsDeleted = 0 " & _
                          "LEFT JOIN tblMatterTask mt with(nolock)  ON m.MatterId = mt.MatterId " & _
                          "LEFT JOIN tblTask t with(nolock)  ON mt.TaskId = t.TaskId AND TaskTypeId IN (40,41) AND AssignedTo IS NULL WHERE s.Active = 1"
            cmd.CommandType = CommandType.Text
            cmd.Transaction = inTransaction
            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    settlements.Add(CInt(reader("SettlementID")), CDbl(reader("SettlementAmount")))
                End While
            End Using
        End Using

        list = DistributionHelper.DistributeEvenly(entityIDs, settlements)

        Return list
    End Function
    ''' <summary>
    ''' Gets the DocId from a given file name (not the full path)
    ''' </summary>
    ''' <param name="filepath">The file name</param>
    ''' <returns>DocId of the file in the system</returns>
    Public Shared Function GetDocIdFromPath(ByVal filepath As String) As String
        Dim idx1 As Integer = 0
        Dim idx2 As Integer = filepath.IndexOf("_", 0)

        idx1 = idx2 + 1
        idx2 = filepath.IndexOf("_", idx1)

        idx1 = idx2 + 1
        idx2 = filepath.IndexOf("_", idx1)

        Dim DocId As String = filepath.Substring(idx1, idx2 - idx1)

        Return DocId
    End Function
    Public Shared Function GetSubFolder(ByVal _AccountId As Integer) As String
        Dim subFolderPath As String = _AccountId.ToString() + "_"
        Dim cmdStr As String = "SELECT c.Name FROM tblAccount a with(nolock)  inner join " & _
                "tblCreditorInstance ci with(nolock)  on ci.CreditorInstanceId = a.CurrentCreditorInstanceId " & _
                "inner join tblCreditor c with(nolock)  on ci.CreditorId = c.CreditorId " & _
                "where a.AccountId = " & _AccountId

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            cmd.Connection.Open()
            Using reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    'subFolderPath += reader("Name").ToString().Replace("&", "").Replace(" ", "_").Replace(".", "").Replace("'", "").Replace(":", "").Replace("""", "")
                    subFolderPath += reader("Name").ToString().Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")
                End While
            End Using
        End Using

        subFolderPath += "\"

        Return subFolderPath
    End Function
    ''' <summary>
    ''' Builds the Path in which the document is to be saved
    ''' </summary>
    ''' <param name="_AccountId">Integer to uniquely identify the Creditor Account</param>
    ''' <param name="_ClientId">Integer to uniquely identify the client associated with the settlement</param>
    ''' <param name="DocTypeID">Type of Document</param>
    ''' <returns>Path to be saved</returns>
    Public Shared Function BuildDocumentPath(ByVal _AccountId As Integer, ByVal _ClientId As Integer, ByVal DocTypeId As String) As String
        Dim dateString As String = String.Format("{0:yyMMdd}", DateTime.Now)
        Dim fileName As String = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(DocTypeId, _ClientId.ToString())

        Dim DocId As String = GetDocIdFromPath(fileName)
        Dim subFolderPath As String

        If _AccountId = 0 Then
            subFolderPath = ""
        Else
            subFolderPath = GetSubFolder(_AccountId)
        End If


        Dim newFilePath As String = SharedFunctions.DocumentAttachment.BuildAttachmentPath(DocTypeId, DocId, dateString, _ClientId, subFolderPath)

        Return newFilePath
    End Function
    ''' <summary>
    ''' Generate a PDF Check for settlement
    ''' </summary>
    ''' <param name="SettlementID">Integer to uniquely identify the settlement</param>
    ''' <param name="_ClientId">Integer to uniquely identify the client associated with the settlement</param>
    ''' <param name="CheckNumber">Check number to be printed on the check</param>
    ''' <param name="CheckAmount">The amount for which the check is to be generated</param>
    ''' <param name="_AccountId">Integer to uniquely identify the Account to Pay the check</param>
    ''' <param name="UserID">Integer to uniquely identify the user who requested the check generation</param>
    ''' <param name="Voided">Boolean value indicating if the check has to be voided</param>
    ''' <param name="DocTypeID">Type of Document</param>
    ''' <returns>The Path in which the PDF check is saved</returns>
    Public Shared Function GenerateSettlementCheck(ByVal PaymentId As Integer, ByVal SettlementID As String, ByVal _ClientId As Integer, ByVal CheckNumber As String, _
                                                   ByVal CheckAmount As Double, ByVal _AccountId As Integer, ByVal UserID As Integer, _
                                                   ByVal Voided As Boolean, ByVal DocTypeID As String, Optional ByVal Note As String = "Check Printed") As String
        Dim strDocTypeName As String = String.Empty

        If Voided Then
            strDocTypeName = "VoidedSettlementCheck"
        Else
            strDocTypeName = "SettlementCheck"
        End If

        Dim strDocID As String = ""
        Dim checkFilePath As String = ""
        Try
            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
                Using report As New DataDynamics.ActiveReports.ActiveReport3

                    Dim pdf As New PdfExport()
                    Dim rptDoc As DataDynamics.ActiveReports.Document.Document = Nothing

                    strDocID = rptTemplates.GetDocTypeID(strDocTypeName)
                    checkFilePath = BuildDocumentPath(_AccountId, _ClientId, DocTypeID)
                    Dim ParentDirectory As String = Directory.GetParent(checkFilePath).FullName

                    If Not Directory.Exists(ParentDirectory) Then
                        Directory.CreateDirectory(ParentDirectory)
                    End If

                    'Add relations to the Check for AccountID, ClientId and MatterId 
                    Dim checkHelper As New CheckHelper()

                    Dim rArgs As String = strDocTypeName & "," & SettlementID & "," & CheckNumber & "," & checkHelper.AmountToText(CheckAmount).Replace(",", "-") & "," & CheckAmount & "," & Note & "," & PaymentId
                    Dim args As String() = rArgs.Split(",")
                    rptDoc = rptTemplates.ViewTemplate(strDocTypeName, _ClientId, args, False, UserID)
                    report.Document.Pages.AddRange(rptDoc.Pages)

                    Using fStream As New System.IO.FileStream(checkFilePath, FileMode.CreateNew)
                        pdf.Export(report.Document, fStream)
                    End Using
                End Using
            End Using

        Catch ex As Exception
            Throw ex
        End Try

        Return checkFilePath
    End Function
    ''' <summary>
    ''' Inserts a new batch for printing the Checks
    ''' </summary>
    ''' <param name="UserId">Integer to uniquely identify the user who issued the batch print</param>
    ''' <returns>Integer to uniquely identify the newly inserted batch</returns>
    Public Shared Function InsertCheckBatch(ByVal UserId As Integer) As Integer
        Dim batchId As Integer = 0
        Using cmd As New SqlCommand("INSERT INTO tblSettlement_CheckBatch (RequestedBy, RequestStartDate) VALUES (" & UserId & ",'" & DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss.fff") & "')", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Using cmd As New SqlCommand("SELECT max(ProcessBatchId)as ProcessBatchId FROM tblSettlement_CheckBatch  with(nolock) ", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        batchId = DataHelper.Nz_int(reader("ProcessBatchId"))
                        Exit While
                    End While
                End Using
            End Using
        End Using

        Return batchId
    End Function
    ''' <summary>
    ''' Updates the end datetime of batch of checks to Print
    ''' </summary>
    ''' <param name="Batchid">Integer to uniquely identify the Batch to update</param>
    Public Shared Sub UpdateCheckBatchEndDate(ByVal Batchid As Integer)
        Using cmd As New SqlCommand("Update tblSettlement_CheckBatch Set RequestEndDate = '" & DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss.fff") & "' where ProcessBatchId = " & Batchid, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

    End Sub
    ''' <summary>
    ''' Resolves the task for Client Approval based on input
    ''' </summary>
    ''' <param name="_SettlementID">Integer to uniquely identify the settlement to resolve</param>
    ''' <param name="_UserId">Integer to uniquely identify the user resolving the task</param>
    ''' <param name="approvalType">indicates the method in which the task is resolved 1)Written 2)Verbal</param>
    ''' <param name="IsApproved">boolean value indicating the success of the task</param>
    ''' <param name="note">Any note to be associated with the settlement</param>
    ''' <param name="reason">If rejected, the reason of rejection</param>
    ''' <param name="dateFormat">string in the format of yyMMdd to be used for relating documents</param>
    ''' <param name="docId">String to uniquely identify the document in the system</param>
    ''' <param name="subFolder">Name of the subfolder in which the document is present</param>
    ''' <param name="_DocTypeId">Type of Document 1)D6004SCAN 2)9074</param>
    ''' <returns>Returns 0 if successful else negative integer</returns>
    ''' <remarks>If isApproved is true, creates the next task else marks the matter and settlement as InActive</remarks>
    Public Shared Function ResolveClientApproval(ByVal _SettlementID As Integer, ByVal _UserId As Integer, ByVal approvalType As String, _
                                                 ByVal IsApproved As Boolean, Optional ByVal note As String = Nothing, _
                                                 Optional ByVal reason As String = Nothing, Optional ByVal dateFormat As String = Nothing, Optional ByVal docId As String = Nothing, _
                                                 Optional ByVal subFolder As String = Nothing, Optional ByVal _DocTypeId As String = Nothing) As Integer
        Dim ret As Integer
        Dim returnParam As IDataParameter
        Dim strFolder As String
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()
            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_ResolveClientApprovalTask"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "SettlementId", _SettlementID)
                DatabaseHelper.AddParameter(cmd, "IsApproved", IsApproved)
                DatabaseHelper.AddParameter(cmd, "Note", IIf(String.IsNullOrEmpty(note), Nothing, note))
                DatabaseHelper.AddParameter(cmd, "CreatedBy", _UserId)
                DatabaseHelper.AddParameter(cmd, "ApprovalType", approvalType)
                DatabaseHelper.AddParameter(cmd, "ReasonName", reason)
                DatabaseHelper.AddParameter(cmd, "DateString", dateFormat)
                DatabaseHelper.AddParameter(cmd, "DocId", IIf(String.IsNullOrEmpty(docId), Nothing, docId))
                strFolder = IIf(String.IsNullOrEmpty(subFolder), Nothing, subFolder)
                DatabaseHelper.AddParameter(cmd, "SubFolder", strFolder)
                DatabaseHelper.AddParameter(cmd, "DocTypeId", IIf(String.IsNullOrEmpty(_DocTypeId), Nothing, _DocTypeId))
                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
                returnParam.Direction = ParameterDirection.ReturnValue
                ret = cmd.ExecuteNonQuery()
            End Using
        End Using

        Return returnParam.Value
    End Function
    ''' <summary>
    ''' Resolves the payment process task by assigning the check number, check amount and method of delivery for the settlement
    ''' </summary>
    ''' <param name="SettlementID">Integer to uniquely identify the settlement to resolve</param>
    ''' <param name="UserID">Integer to uniquely identify the user resolving the task</param>
    ''' <param name="CheckAmount">The amount on teh check</param>
    ''' <param name="deliveryMethod">Delivery method of payment</param>
    ''' <param name="OvernightDeliveryFee">Delivery fees to be charged for the settlement</param>
    ''' <param name="notes">Any note to be associated with the settlement</param>
    ''' <returns>Returns 0 if successful else negative integer</returns>
    Public Shared Function ResolvePaymentTask(ByVal SettlementID As Integer, ByVal UserID As Integer, _
                                              ByVal CheckAmount As Double, ByVal deliveryMethod As String, ByVal OvernightDeliveryFee As Double, _
                                              ByVal DeliveryAmount As Double, _
                                              ByVal AdjustedFee As Double, Optional ByVal IsAdjusted As Boolean = False, Optional ByVal notes As String = Nothing) As Integer
        Dim returnParam As IDataParameter
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_ResolveProcessPaymentTask"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementID)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "CheckAmount", CheckAmount)
                DatabaseHelper.AddParameter(cmd, "DeliveryMethod", deliveryMethod)
                DatabaseHelper.AddParameter(cmd, "OvernightFees", OvernightDeliveryFee)
                DatabaseHelper.AddParameter(cmd, "DeliveryAmount", DeliveryAmount)
                DatabaseHelper.AddParameter(cmd, "AdjustedFee", AdjustedFee)
                DatabaseHelper.AddParameter(cmd, "IsAdjusted", IsAdjusted)
                DatabaseHelper.AddParameter(cmd, "Note", IIf(String.IsNullOrEmpty(notes), Nothing, notes))
                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
                returnParam.Direction = ParameterDirection.ReturnValue
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Return returnParam.Value
    End Function
    ''' <summary>
    ''' Creates a task for a settlement matter
    ''' </summary>
    ''' <param name="SettlementID">Integer to uniquely identify the settlement</param>
    ''' <param name="UserId">Integer to uniquely identify the user creating the task</param>
    ''' <param name="TaskTypeId">Integer to specify the type of task being created</param>
    ''' <param name="TaskDescription">Description of the task</param>
    ''' <param name="connection">DB Connection to be used for creating the task</param>
    ''' <param name="inTransaction">The transaction reference to be associated with the connection</param>
    ''' <returns>Returns 0 if successful else negative integer</returns>
    Public Shared Function InsertTaskForSettlement(ByVal SettlementId As Integer, ByVal UserId As Integer, ByVal TaskTypeId As Integer, _
                                                   ByVal TaskDescription As String, ByVal connection As IDbConnection, ByVal inTransaction As IDbTransaction) As Integer
        Dim returnParam As IDataParameter
        Using cmd As IDbCommand = connection.CreateCommand()
            cmd.CommandText = "stp_InsertTaskForSettlement"
            cmd.CommandType = CommandType.StoredProcedure
            DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementId)
            DatabaseHelper.AddParameter(cmd, "TaskTypeId", TaskTypeId)
            DatabaseHelper.AddParameter(cmd, "Description", TaskDescription)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserId)
            returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
            returnParam.Direction = ParameterDirection.ReturnValue
            cmd.Transaction = inTransaction
            cmd.ExecuteNonQuery()
        End Using

        Return returnParam.Value
    End Function

    Public Shared Function GetCheckNumber(ByVal _clientId As Integer) As Integer
        Dim returnParam As IDataParameter
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_GetCheckNumber"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", _clientId)
                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "CheckNumber", DbType.Int32)
                returnParam.Direction = ParameterDirection.Output
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return returnParam.Value
    End Function
    Public Shared Function GetSettlementFeeAdjustments(ByVal _SettlementId As Integer) As List(Of AdjustedFeeDetails)
        Dim adjustedFeeList As New List(Of AdjustedFeeDetails)()
        Dim adjustedDetail As AdjustedFeeDetails
        Using cmd As New SqlCommand("SELECT isnull(NewAmount,0) [NewAmount], EntryTypeId, isnull(AdjustedReason,'') [AdjustedReason] FROM tblSettlement_AdjustedFeeDetail  with(nolock) WHERE Approved = 1 and IsDeleted = 0 and SettlementId = " & _SettlementId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        adjustedDetail = New AdjustedFeeDetails(CDbl(reader("NewAmount").ToString()), _
                                                                DataHelper.Nz_int(reader("EntryTypeId")), _
                                                                reader("AdjustedReason").ToString())
                        adjustedFeeList.Add(adjustedDetail)
                    End While
                End Using
            End Using
        End Using

        Return adjustedFeeList
    End Function

    Public Shared Function InsertSettlementPayments(ByVal _PaymentId As Integer, ByVal _ClientId As Integer, ByVal _AccountId As Integer, _
                                                    ByVal _CheckNumber As Integer, ByVal _UserId As Integer, _
                                                    ByVal _SettlementId As Integer) As XElement
        Dim SettFeeRegisterId As Integer
        Dim RegisterId As Integer
        Dim DelFeeRegisterId As Integer = 0
        Dim RegisterXml As XElement = New XElement("Register")
        Dim Information As SettlementMatterHelper.SettlementInformation = SettlementMatterHelper.GetSettlementInformation(_SettlementId)

        Dim settDesc As String = "Settlement - "
        Dim settFeeDesc As String = "Settlement Fee - "
        Dim adjustedDesc As String = "Fee Adjustment - "
        Dim DelDesc As String = "Delivery Fee - "
        Dim Desc As String

        Desc = SettlementMatterHelper.GetSettRegisterEntryDesc(_AccountId)
        settDesc += Desc
        settFeeDesc += Desc
        adjustedDesc += Desc
        DelDesc += Desc

        Dim pmtScheduleId As Integer = 0
        Dim paymentAmount As Double = Information.SettlementAmount
        Dim requesttype As String = "Settlement"

        If Information.IsPaymentArrangement Then
            Dim paymentschedule As DataTable = PaymentScheduleHelper.GetPaymentScheduleByPaymentId(_PaymentId)
            If paymentschedule.Rows.Count > 0 Then
                pmtScheduleId = CInt(paymentschedule.Rows(0)("pmtscheduleid"))
                paymentAmount = CDbl(paymentschedule.Rows(0)("pmtamount"))
                requesttype = paymentschedule.Rows(0)("requesttype")
            Else
                Throw New Exception("Payment arrangement record could not be found")
            End If
        End If

        Dim adjustedFeeList As List(Of AdjustedFeeDetails) = SettlementMatterHelper.GetSettlementFeeAdjustments(_SettlementId)

        RegisterId = RegisterHelper.InsertDebit(_ClientId, _AccountId, DateTime.Now, _CheckNumber.ToString(), settDesc, (Math.Abs(paymentAmount) * -1), Nothing, 18, _UserId)

        If pmtScheduleId > 0 Then
            'Update RegisterId
            PaymentScheduleHelper.MarkPaymentScheduleAsPaid(pmtScheduleId, RegisterId, _UserId)
        End If

        'Request type of settlement represents a full settlement or the 1rst payment of arrangement. Charge Settlement Fee
        'Request type of settlement - p.a. represents subsequent payament arrangement. Skip settlement fee
        If Information.SettlementFee <> 0 AndAlso requesttype.ToLower.Trim = "settlement" Then
            SettFeeRegisterId = RegisterHelper.InsertFee(RegisterId, _ClientId, _AccountId, DateTime.Now, settFeeDesc, (Math.Abs(Information.SettlementFee) * -1), 4, Nothing, Nothing, Nothing, _UserId, False)

            If Information.AdjustedSettlementFee <> 0 Then
                RegisterHelper.InsertFeeAdjustment(_ClientId, SettFeeRegisterId, DateTime.Now, adjustedDesc, ((Information.AdjustedSettlementFee) * -1), -2, _UserId, False)
            End If

            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_PayFeeForClient")
                DatabaseHelper.AddParameter(cmd, "ClientID", _ClientId)

                Using cn As IDbConnection = cmd.Connection
                    cn.Open()
                    cmd.ExecuteNonQuery()
                End Using

            End Using
        End If

        If Information.SettlementAmount <> 0 Then
            Dim runPayFees As Boolean = False

            Dim chargebyphone As Boolean = False
            If Information.DeliveryMethod.Equals("chkbytel") AndAlso Information.DeliveryAmount <> 0 Then
                chargebyphone = True
                runPayFees = True
                DelFeeRegisterId = RegisterHelper.InsertFee(RegisterId, _ClientId, _AccountId, DateTime.Now, DelDesc, (Math.Abs(Information.DeliveryAmount) * -1), 28, Nothing, Nothing, Nothing, _UserId, False)
            End If

            Dim deliveryfee As Decimal = Math.Abs(GetSettlementDeliveryFee("Client", _ClientId))
            If deliveryfee > 0 AndAlso (Not chargebyphone OrElse IgnoreChargeByPhone(_ClientId)) Then
                runPayFees = True
                RegisterHelper.InsertFee(RegisterId, _ClientId, _AccountId, DateTime.Now, DelDesc, deliveryfee * -1, 6, Nothing, Nothing, Nothing, _UserId, False)
            End If

            If runPayFees Then
                Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_PayFeeForClient")
                    DatabaseHelper.AddParameter(cmd, "ClientID", _ClientId)

                    Using cn As IDbConnection = cmd.Connection
                        cn.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            End If
        End If

        RegisterXml.Add(New XAttribute("Id", RegisterId), New XAttribute("FeeId", DelFeeRegisterId))

        RegisterHelper.Rebalance(_ClientId)

        Return RegisterXml
    End Function

    Public Shared Function IgnoreChargeByPhone(ByVal Clientid As Integer) As Boolean
        Dim CompanyID As Integer = CInt(DataHelper.FieldLookup("tblClient", "Companyid", "ClientId = " & Clientid))
        Select Case CompanyID
            Case 10, 11
                Return True
            Case Else
                Return False
        End Select
    End Function

    Public Shared Function GetSettlementDeliveryFee(ByVal IDType As String, ByVal ID As Integer) As Double
        Dim strSQL As String
        Dim CompanyID As Integer = 0
        Dim ClientID As Integer = 0

        Select Case IDType
            Case "Client"
                ClientID = ID
                strSQL = "stp_GetDeliveryFee " & ID & ", " & 0
            Case Else
                CompanyID = ID
                strSQL = "stp_GetDeliveryFee " & 0 & ", " & ID
        End Select

        Return SqlHelper.ExecuteScalar(strSQL, CommandType.Text)

    End Function

    Public Shared Function InsertCheckInfo(ByVal PaymentId As Integer, ByVal MatterId As Integer, ByVal UserID As Integer, ByVal CheckNumber As Integer, _
                                              ByVal DocId As String, ByVal SubFolder As String, ByVal BatchId As Integer, _
                                              ByVal isPrinted As Boolean) As Integer
        Dim returnParam As IDataParameter
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_InsertCheckPrintingInfo"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "PaymentProcessingId", PaymentId)
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                DatabaseHelper.AddParameter(cmd, "BatchId", BatchId)
                DatabaseHelper.AddParameter(cmd, "isPrinted", isPrinted)
                DatabaseHelper.AddParameter(cmd, "CheckNumber", CInt(CheckNumber))
                DatabaseHelper.AddParameter(cmd, "DocId", IIf(DocId.Equals(String.Empty), Nothing, DocId))
                DatabaseHelper.AddParameter(cmd, "DateString", String.Format("{0:yyMMdd}", DateTime.Now))
                DatabaseHelper.AddParameter(cmd, "SubFolder", IIf(SubFolder.Equals(String.Empty), Nothing, SubFolder))
                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
                returnParam.Direction = ParameterDirection.ReturnValue
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Return returnParam.Value
    End Function

    Public Shared Sub VoidSettlementAmount(ByVal Paymentid As Integer, ByVal RegisterId As Integer, ByVal CheckNumber As Integer, ByVal CheckAmount As Double, _
                                           ByVal UserId As Integer)
        Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "MatterId", "PaymentProcessingId = " & Paymentid))
        Dim SettlementID As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
        Dim DataClientId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "ClientId", "SettlementId = " & SettlementID))
        Dim DataAccountId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "CreditorAccountId", "SettlementId = " & SettlementID))

        'Delete all relations for previously generated check
        Dim docList As List(Of SharedFunctions.AttachedDocument) = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(MatterId, "matter")
        For Each relationDoc In docList
            If relationDoc.DocumentType.Equals("Settlement Check") Then
                SharedFunctions.DocumentAttachment.DeleteAllDocumentRelations(relationDoc.DocumentName, UserId)
            End If
        Next

        'Generate Voided Check, mark previous settlement Check as deleted. Insert the new settlement check and associate it with matter
        Dim filePath As String = SettlementMatterHelper.GenerateSettlementCheck(Paymentid, SettlementID, DataClientId, CheckNumber, CheckAmount, DataAccountId, UserId, True, "D9011")
        Dim SubFolder As String = SettlementMatterHelper.GetSubFolder(DataAccountId)
        Dim folderPaths() As String = filePath.Split("\")
        Dim DocId As String = SettlementMatterHelper.GetDocIdFromPath(folderPaths(folderPaths.Length - 1))
        SharedFunctions.DocumentAttachment.CreateScan(folderPaths(folderPaths.Length - 1), UserId, DateTime.Now)

        SharedFunctions.DocumentAttachment.AttachDocument("client", DataClientId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), DataClientId, UserId, SubFolder)
        SharedFunctions.DocumentAttachment.AttachDocument("account", DataAccountId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), DataClientId, UserId, SubFolder)
        SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), DataClientId, UserId, SubFolder)
    End Sub
    Public Shared Sub AddNewSettlementAmountAsCleared(ByVal PaymentId As Integer, ByVal RegisterId As Integer, ByVal FeeId As Integer, ByVal FirmId As Integer, ByVal CheckNumber As Integer, ByVal CheckAmount As Double, _
                                           ByVal UserId As Integer, ByVal RecipientAccount As String, ByVal RecipientName As String, ByVal _dataType As String, ByVal FirmRegisterId As Integer)
        Dim ret As Integer

        'Mark FirmRegister entry as Voided
        Using cmd As New SqlCommand("Update tblFirmRegister set RegisterId = " & RegisterId & ", FeeRegisterId =" & FeeId & ", " & _
                                    "Amount = " & CheckAmount & ", Cleared = 1, ClearedDate = getdate(), " & _
                                    "LastModified = getdate(), LastModifiedBy = " & UserId & " Where FirmRegisterId = " & FirmRegisterId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                ret = cmd.ExecuteNonQuery()
            End Using
        End Using

        If ret > 0 Then
            Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "MatterId", "PaymentProcessingId = " & PaymentId))
            Dim SettlementID As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
            Dim DataClientId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "ClientId", "SettlementId = " & SettlementID))
            Dim DataAccountId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "CreditorAccountId", "SettlementId = " & SettlementID))

            'Generate Check, mark previous settlement Check as deleted. Insert the new settlement check and associate it with matter
            Dim filePath As String = SettlementMatterHelper.GenerateSettlementCheck(PaymentId, SettlementID, DataClientId, CheckNumber, CheckAmount, DataAccountId, UserId, False, "D9011")
            Dim SubFolder As String = SettlementMatterHelper.GetSubFolder(DataAccountId)
            Dim folderPaths() As String = filePath.Split("\")
            Dim DocId As String = SettlementMatterHelper.GetDocIdFromPath(folderPaths(folderPaths.Length - 1))
            SharedFunctions.DocumentAttachment.CreateScan(folderPaths(folderPaths.Length - 1), UserId, DateTime.Now)

            SharedFunctions.DocumentAttachment.AttachDocument("client", DataClientId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), DataClientId, UserId, SubFolder)
            SharedFunctions.DocumentAttachment.AttachDocument("account", DataAccountId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), DataClientId, UserId, SubFolder)
            SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), DataClientId, UserId, SubFolder)
        End If
    End Sub

    Public Shared Sub AddFeeAdjustmentsToSettlement(ByVal SettlementId As Integer, ByVal EntryTypeId As Integer, ByVal Desc As String, ByVal Amount As Double, ByVal UserID As Integer, ByVal isApproved As Boolean, ByVal ApprovedBy As Integer, ByVal isDeleted As Boolean, ByVal DeletedBy As Integer)
        Dim params(8) As SqlParameter

        params(0) = New SqlParameter("SettlementId", SettlementId)
        params(1) = New SqlParameter("NewAmount", Amount)
        params(2) = New SqlParameter("EntryTypeId", EntryTypeId)
        params(3) = New SqlParameter("AdjustedBy", UserID)
        params(4) = New SqlParameter("AdjustedReason", Desc)
        params(5) = New SqlParameter("IsApproved", isApproved)
        params(6) = New SqlParameter("ApprovedBy", ApprovedBy)
        params(7) = New SqlParameter("IsDeleted", isDeleted)
        params(8) = New SqlParameter("DeletedBy", DeletedBy)

        SqlHelper.ExecuteNonQuery("stp_AddFeeAdjustmentsToSettlement", , params)
    End Sub

    Public Shared Function GetSIFForPrinting(ByVal _MatterId As Integer) As String
        Dim filepath As String
        'Check for SIF attached to Matter First
        Using cmd As New SqlCommand("select top 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath " & _
                                    "from tblDocRelation dr with(nolock) inner join " & _
                                    "tblDocumentType d with(nolock) ON d.TypeId = dr.DocTypeId inner join " & _
                                    "tblClient c with(nolock) ON c.ClientId = dr.ClientId " & _
                                    "where RelationType='matter' and RelationId =" & _MatterId & _
                                    "and DeletedFlag = 0 and dr.DocTypeID IN ('D6011', 'D3033') order by dr.RelatedDate desc ", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        filepath = DatabaseHelper.Peel_string(reader, "FilePath")
                    End If
                End Using
            End Using
        End Using


        If String.IsNullOrEmpty(filepath) Then
            Using cmd As New SqlCommand("SELECT " & _
                "'\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath " & _
                "FROM " & _
                "tblSettlements s with(nolock) inner join " & _
                "tblClient c with(nolock) ON c.ClientId = s.ClientId left join " & _
                "tblNegotiationRoadmap nr with(nolock) on nr.SettlementId = s.SettlementId And (SettlementStatusId = 8 Or SettlementStatusId = 6) inner join " & _
                "tblDocRelation dr with(nolock) ON dr.ClientId = s.ClientId and dr.RelationId = s.CreditorAccountId and dr.RelationType = 'account' and " & _
                "dr.DocTypeId IN ('D6011', 'D3033') and DeletedFlag <> 1 inner join " & _
                "tblDocumentType d with(nolock) ON dr.DocTypeId = d.TypeID	" & _
                "WHERE " & _
                "s.MatterId = " & _MatterId & " and dr.RelatedDate between s.Created and DATEADD(mi, 2, nr.Created)", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            filepath = DatabaseHelper.Peel_string(reader, "FilePath")
                        End If
                    End Using
                End Using
            End Using
        End If

        Return filepath
    End Function
    Public Shared Function GetCheckPathForPrinting(ByVal _MatterId As Integer) As String
        Dim filepath As String

        Using cmd As New SqlCommand("select top 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath " & _
                                    "from tblDocRelation dr with(nolock) inner join " & _
                                    "tblDocumentType d with(nolock) ON d.TypeId = dr.DocTypeId inner join " & _
                                    "tblClient c with(nolock) ON c.ClientId = dr.ClientId " & _
                                    "where RelationType='matter' and RelationId =" & _MatterId & _
                                    " and DeletedFlag = 0 and DocTypeId = 'D9011' order by dr.RelatedDate desc ", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        filepath = DatabaseHelper.Peel_string(reader, "FilePath")
                    End If
                End Using
            End Using
        End Using

        Return filepath
    End Function

    Public Shared Function GetStipulationDocPath(ByVal _MatterId As Integer) As String
        Dim filepath As String = String.Empty

        Using cmd As New SqlCommand("select top 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath " & _
                                    "from tblDocRelation dr with(nolock) inner join " & _
                                    "tblDocumentType d with(nolock) ON d.TypeId = dr.DocTypeId inner join " & _
                                    "tblClient c with(nolock) ON c.ClientId = dr.ClientId " & _
                                    "where RelationType='matter' and RelationId =" & _MatterId & _
                                    " and DeletedFlag = 0 and DocTypeId = 'D9012' order by dr.RelatedDate desc ", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        filepath = DatabaseHelper.Peel_string(reader, "FilePath")
                    End If
                End Using
            End Using
        End Using

        Return filepath
    End Function

    Public Shared Function GetSignedStipulationPathForPrinting(ByVal _MatterId As Integer) As String
        Dim filepath As String = String.Empty

        Using cmd As New SqlCommand("select top 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath " & _
                                    "from tblDocRelation dr with(nolock) inner join " & _
                                    "tblDocumentType d with(nolock) ON d.TypeId = dr.DocTypeId inner join " & _
                                    "tblClient c with(nolock) ON c.ClientId = dr.ClientId " & _
                                    "where RelationType='matter' and RelationId =" & _MatterId & _
                                    " and DeletedFlag = 0 and DocTypeId = 'D9022SCAN' order by dr.RelatedDate desc ", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        filepath = DatabaseHelper.Peel_string(reader, "FilePath")
                    End If
                End Using
            End Using
        End Using

        Return filepath
    End Function

    Public Shared Function GetRELPathForPrinting(ByVal _MatterId As Integer, Optional ByVal settlementID As Integer = Nothing) As String
        Dim filepath As String = String.Empty
        Dim ssql As String = "stp_printQ_getdocpath"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("matterid", _MatterId))
        params.Add(New SqlParameter("settlementID", settlementID))
        params.Add(New SqlParameter("doctypeid", "D3033"))
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
            For Each fp As DataRow In dt.Rows
                filepath = fp("FilePath").ToString
            Next
        End Using

        Return filepath
    End Function
    Public Shared Function GetSAFPathForPrinting(ByVal _MatterId As Integer, Optional ByVal settlementID As Integer = Nothing) As String
        Dim filepath As String = String.Empty
        Dim ssql As New StringBuilder
        ssql.Append("select top 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath ")
        ssql.Append("from tblDocRelation dr with(nolock) inner join tblDocumentType d with(nolock) ON d.TypeId = dr.DocTypeId inner join tblClient c with(nolock) ON c.ClientId = dr.ClientId ")
        ssql.AppendFormat("where RelationType='matter' and RelationId = {0}", _MatterId)
        ssql.Append("and DeletedFlag = 0 and DocTypeId = 'D6004' order by dr.RelatedDate desc ")
        Using dt As DataTable = SqlHelper.GetDataTable(ssql.ToString, CommandType.Text)
            For Each fp As DataRow In dt.Rows
                filepath = fp("FilePath").ToString
            Next
        End Using

        If String.IsNullOrEmpty(filepath) Then
            ssql = New StringBuilder
            ssql.Append("SELECT TOP 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.AccountNumber + '\' + d.DocFolder + '\' + dr.SubFolder+ c.AccountNumber + '_' + dr.DocTypeId+'_'+dr.DocId+'_'+dr.DateString+'.pdf' AS FilePath ")
            ssql.Append("FROM tblSettlements s with(nolock) inner join tblCLient c with(nolock) ON c.ClientId = s.ClientId left join tblNegotiationRoadmap nr with(nolock) on nr.SettlementId = s.SettlementId And (SettlementStatusId = 8 Or SettlementStatusId = 6) inner join tblDocRelation dr with(nolock) ON dr.ClientId = s.ClientId and dr.RelationId = s.CreditorAccountId and dr.RelationType = 'account' and dr.DocTypeId = 'D6004' and DeletedFlag <> 1 inner join tblDocumentType d with(nolock) ON dr.DocTypeId = d.TypeID	")
            ssql.AppendFormat("WHERE s.matterid = {0} and dr.RelatedDate between s.Created and DATEADD(mi, 2, nr.Created)", _MatterId)
            Using dt As DataTable = SqlHelper.GetDataTable(ssql.ToString, CommandType.Text)
                For Each fp As DataRow In dt.Rows
                    filepath = fp("FilePath").ToString
                Next
            End Using
        End If
        Return filepath
    End Function
    Private Shared Function FileInfoComparison(ByVal fi1 As FileInfo, ByVal fi2 As FileInfo) As Integer
        Return Date.Compare(fi1.LastWriteTime, fi2.LastWriteTime)
    End Function

    Public Shared Function InsertBankUpload(ByVal _BankAccount As String, ByVal _UserId As Integer) As Integer
        Dim uploadId As Integer
        Using cmd As New SqlCommand("Insert Into tblBankUpload(BankAccountName, UploadedDate, UploadedBy," & _
                     "Processed)" & _
                     "Values('" & _BankAccount & "', getdate() ," & _UserId & ", 0)", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Using cmd As New SqlCommand("SELECT max(BankUploadId)as UploadId FROM tblBankUpload", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        uploadId = DataHelper.Nz_int(reader("UploadId"))
                        Exit While
                    End While
                End Using
            End Using
        End Using

        Return uploadId
    End Function
    Public Shared Sub UpdateBankUpload(ByVal BankAccountName As String, ByVal _UploadId As Integer, ByVal _UserId As Integer)
        Using cmd As New SqlCommand("Update tblBankUpload Set Processed = 1, ProcessedDate = getdate(), ProcessedBy = " & _
                                    _UserId & " where BankUploadId <> " & _UploadId & " and BankAccountName = '" & BankAccountName & "'", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub UpdateBankUploadAsProcessed(ByVal _UploadId As Integer, ByVal _UserId As Integer)
        Using cmd As New SqlCommand("Update tblBankUpload Set Processed = 1, ProcessedDate = getdate(), ProcessedBy = " & _
                                    _UserId & " where BankUploadId = " & _UploadId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Using cmd As New SqlCommand("Update tblBankReconciliationInfo Set Reconciled = 1" & _
                                     " where BankUploadId = " & _UploadId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub SetBankRegisterAsRejected(ByVal _BankregisterId As Integer)
        Using cmd As New SqlCommand("Update tblBankReconciliationInfo Set Rejected = 1" & _
                                    " where BankRegisterId = " & _BankregisterId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Sub UpdateSettlementCalculations(ByVal SettlementID As Integer, ByVal CreatedBy As Integer, ByVal DeliveryMethod As String, ByVal DeliveryAmount As Double, ByVal AdjustedFee As Double)
        Dim params(4) As SqlParameter

        params(0) = New SqlParameter("SettlementID", SettlementID)
        params(1) = New SqlParameter("CreatedBy", CreatedBy)
        params(2) = New SqlParameter("DeliveryMethod", DeliveryMethod.Replace("Check", "chk"))
        params(3) = New SqlParameter("DeliveryAmount", DeliveryAmount)
        params(4) = New SqlParameter("AdjustedFee", AdjustedFee)

        SqlHelper.ExecuteNonQuery("stp_UpdateSettlementCalculations", , params)
    End Sub

    Public Shared Function SaveEmailtoLog(ByVal FromMail As String, ByVal ToMail As String, ByVal strBody As String, _
                                    ByVal strSubject As String, ByVal UserId As Integer, ByVal strFooter As String, _
                                    ByVal ClientId As Integer, ByVal UserGroupId As Integer) As Integer
        Dim NewId As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.Connection.Open()
                cmd.CommandText = "stp_InsertEmailRelayLog"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "FromMailID", FromMail)
                DatabaseHelper.AddParameter(cmd, "ToMailID", ToMail)
                DatabaseHelper.AddParameter(cmd, "MailSubject", strSubject)
                DatabaseHelper.AddParameter(cmd, "MailMessage", strBody)
                DatabaseHelper.AddParameter(cmd, "Attachment", "")
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserId)
                DatabaseHelper.AddParameter(cmd, "MailFooter", strFooter)
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientId)
                DatabaseHelper.AddParameter(cmd, "UserGroupID", UserGroupId)
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        NewId = rd("NewId")

                    End While
                End Using
            End Using
        End Using
        Return NewId
    End Function

    Public Shared Sub UpdateMatterCurrentTaskID(ByVal matterid As Integer, ByVal taskID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set currenttaskid = {0} where matterid = {1}", taskID, matterid), CommandType.Text)
        SqlHelper.ExecuteNonQuery(String.Format("update tbltask set matterid = {0} where taskID = {1}", matterid, taskID), CommandType.Text)
        Settlement_InsertMatterTask(matterid, taskID)
    End Sub
    Public Shared Sub UpdateMatterSubStatus(ByVal matterid As Integer, ByVal taskTypeID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set  mattersubstatusid = {0} where matterid = {1}", taskTypeID, matterid), CommandType.Text)
    End Sub
    Public Shared Sub UpdateMatterStatus(ByVal matterid As Integer, ByVal MatterStatusCodeID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set  MatterStatusCodeId = {0} where matterid = {1}", MatterStatusCodeID, matterid), CommandType.Text)
    End Sub
    Public Shared Function GetMatterCurrentTaskID(ByVal matterID As Integer) As Integer
        Dim tid As Integer = SqlHelper.ExecuteScalar(String.Format("Select isnull(currenttaskid,0) from tblmatter with(nolock) where matterid = {0}", matterID), CommandType.Text)
        If tid = 0 Then
            tid = SqlHelper.ExecuteScalar(String.Format("Select isnull(taskid,0) from tblmattertask with(nolock) where matterid = {0}", matterID), CommandType.Text)
            SqlHelper.ExecuteNonQuery(String.Format("update tblmatter set currenttaskid = {0} where matterid = {1}", tid, matterID), CommandType.Text)
        End If
        Return tid
    End Function
    Private Shared Function Settlement_InsertTask(ByVal _UserId As Integer, ByVal SettlementDueDate As String, ByVal taskTypeId As Integer, ByVal TaskDescription As String) As Integer
        Dim sqlTask As String = "INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,CreatedBy, LastModified, LastModifiedBy, AssignedTo) Values ("
        sqlTask += String.Format("{0},'{1}','{2}',null,getdate(),{3},getdate(),{3},0); select scope_identity()", taskTypeId, TaskDescription, SettlementDueDate, _UserId)
        Dim taskId As Integer = SqlHelper.ExecuteScalar(sqlTask, CommandType.Text)
        Return taskId
    End Function
    Private Shared Sub Settlement_InsertClientTask(ByVal _UserId As Integer, ByVal dataClientID As Integer, ByVal taskId As Integer)
        Dim sqlClientTask As String = "INSERT INTO tblClientTask(ClientId,TaskId,Created,CreatedBy,LastModified,LastModifiedBy)"
        sqlClientTask += String.Format("VALUES({0}, {1}, getdate(), {2}, getdate(), {2})", dataClientID, taskId, _UserId)
        SqlHelper.ExecuteNonQuery(sqlClientTask, CommandType.Text)
    End Sub
    Private Shared Sub Settlement_InsertMatterTask(ByVal SettlementMatterID As Integer, ByVal taskId As Integer)
        'associate with matter still
        Dim sqlMT As String = String.Format("Select * from tblmattertask with(nolock) where matterid = {0}", SettlementMatterID)
        Dim dtMT As DataTable = SqlHelper.GetDataTable(sqlMT, CommandType.Text)
        If dtMT.Rows.Count > 0 Then
            Dim sqlAssoc As String = String.Format("update tblMatterTask set taskid = {0} where matterid = {1}", taskId, SettlementMatterID)
            SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
        Else
            Dim sqlAssoc As String = String.Format("INSERT INTO tblMatterTask(MatterId, TaskId) VALUES({0}, {1})", SettlementMatterID, taskId)
            SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
        End If
    End Sub
    Private Shared Sub Settlement_InsertClientAlert(ByVal _UserId As Integer, ByVal SettlementID As Integer, ByVal dataClientID As Integer)
        Dim sqlClientAlert As String = "INSERT INTO tblClientAlerts(ClientId, AlertType, AlertDescription, AlertRelationType, AlertRelationId, Created, CreatedBy) "
        sqlClientAlert += String.Format("SELECT {0}, 2, ('Waiting for client approval of settlement with ' + g.[Name] + ' #' + ", dataClientID)
        sqlClientAlert += String.Format("SUBSTRING(AccountNumber, len(AccountNumber) - 3, 4) + ' for $' + CONVERT(varchar(20), s.SettlementAmount, 1)), " & _
                                        "'tblSettlements', {0}, getdate(), {1} ", SettlementID, _UserId)
        sqlClientAlert += "FROM tblSettlements s with(nolock) inner join tblAccount a with(nolock) ON a.AccountId = s.CreditorAccountId " & _
                            "inner join tblCreditorInstance ci with(nolock) ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId " & _
                            "inner join tblCreditor c with(nolock) on c.CreditorId = ci.CreditorId " & _
                            "inner join tblCreditorGroup g with(nolock) on g.creditorgroupid = c.creditorgroupid "
        sqlClientAlert += String.Format("WHERE SettlementId = {0}", SettlementID)
        SqlHelper.ExecuteNonQuery(sqlClientAlert, CommandType.Text)
    End Sub
    Public Shared Sub ResolveMatterTask(ByVal TaskID As Integer, ByVal _UserId As Integer)
        Dim sqlResolve As String = "stp_workflow_resolveTask"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("taskid", TaskID))
        params.Add(New SqlParameter("userid", _UserId))
        params.Add(New SqlParameter("taskresolutionid", 1))
        SqlHelper.ExecuteNonQuery(sqlResolve, CommandType.StoredProcedure, params.ToArray)
    End Sub
    Public Shared Function InsertMatterTask(ByVal dataClientid As Integer, ByVal SettlementDueDate As String, ByVal TaskTypeText As String, ByVal currentMatterID As Integer, ByVal UserID As Integer) As Integer
        Dim TaskTypeId As Integer = DataHelper.FieldLookupIDs("tblTaskType", "TaskTypeId", String.Format("[Name] = '{0}'", TaskTypeText))(0)
        'insert task for matter

        Dim sqlTask As String = "INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,CreatedBy, LastModified, LastModifiedBy, AssignedTo,matterid) VALUES("
        sqlTask += String.Format("{0},'{1}','{2}',NULL,getdate(),{3},getdate(),{3},0,{4}); select SCOPE_IDENTITY();", TaskTypeId, TaskTypeText, SettlementDueDate, UserID, currentMatterID)
        Dim newTaskID As Integer = SqlHelper.ExecuteScalar(sqlTask, CommandType.Text)

        'associate with matter still
        Dim sqlMT As String = String.Format("Select * from tblmattertask with(nolock) where matterid = {0}", currentMatterID)
        Using dtMT As DataTable = SqlHelper.GetDataTable(sqlMT, CommandType.Text)
            If dtMT.Rows.Count > 0 Then
                Dim sqlAssoc As String = String.Format("update tblMatterTask set taskid = {0} where matterid = {1}", newTaskID, currentMatterID)
                SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
            Else
                Dim sqlAssoc As String = String.Format("INSERT INTO tblMatterTask(MatterId, TaskId) VALUES({0}, {1})", currentMatterID, newTaskID)
                SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
            End If
        End Using

        SettlementMatterHelper.UpdateMatterCurrentTaskID(currentMatterID, newTaskID)
        Return newTaskID
    End Function
    Public Shared Function ResolveAttachDocumentTask(ByVal _SettlementID As Integer, ByVal _UserId As Integer, ByVal listOfDocuments As List(Of AttachSifHelper.SettlementDocumentObject)) As Integer
        Dim ret As Integer

        Using settInfo As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(_SettlementID)
            Dim statusCodeID As Integer = 23
            Dim subStatusID As Integer = 0
            Dim taskTypeId As Integer = 0
            Dim TaskDescription As String = ""
            If settInfo.IsClientStipulation Then
                subStatusID = 87
                taskTypeId = 78
                TaskDescription = "Client Stipulation Approval"
            Else
                subStatusID = 51
                taskTypeId = 72
                TaskDescription = "Client Approval"
            End If

            Dim currentTaskId As Integer = SettlementMatterHelper.GetMatterCurrentTaskID(settInfo.SettlementMatterID)
            ResolveMatterTask(currentTaskId, _UserId)
            UpdateMatterStatus(settInfo.SettlementMatterID, statusCodeID)
            UpdateMatterSubStatus(settInfo.SettlementMatterID, subStatusID)

            Dim taskId As Integer = Settlement_InsertTask(_UserId, settInfo.SettlementDueDate, taskTypeId, TaskDescription)

            UpdateMatterCurrentTaskID(settInfo.SettlementMatterID, taskId)

            Settlement_InsertClientTask(_UserId, settInfo.SettlementClientID, taskId)

            Settlement_InsertMatterTask(settInfo.SettlementMatterID, taskId)

            Settlement_InsertClientAlert(_UserId, settInfo.SettlementID, settInfo.SettlementClientID)

            Dim noteText As String = String.Format("{0} created a task of type {1} on {2}", UserHelper.GetName(_UserId), TaskDescription, Now.ToString)
            Dim noteID As Integer = NoteHelper.InsertNote(noteText, _UserId, settInfo.SettlementClientID)
            'relate to client
            NoteHelper.RelateNote(noteID, 1, settInfo.SettlementClientID)
            'relate to matter
            NoteHelper.RelateNote(noteID, 19, settInfo.SettlementMatterID)
            'relate to creditor
            NoteHelper.RelateNote(noteID, 2, settInfo.SettlementCreditorAccountID)
            'relate to task
            TaskHelper.InsertTaskNote(taskId, noteID, _UserId)

        End Using

        Return ret
    End Function
    Public Shared Sub UpdateLexxSignStatus(ByVal matterID As Integer, Optional ByVal CurrentStatus As String = "Completed")

        Dim ssql As String = String.Format("Update tbllexxsigndocs set CurrentStatus = '{0}', Completed = getdate() where relationtypeid = 21 and " & _
                                           "relationid = (select settlementid from tblsettlements where matterid = {1})", CurrentStatus, matterID)

        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

    End Sub
    Public Shared Function ResolveClientStipulation(ByVal MatterID As Integer, ByVal UserId As Integer, ByVal dateFormat As String, ByVal docId As String, ByVal subFolder As String, ByVal DocTypeId As String) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@MatterID", SqlDbType.Int)
        param.Value = MatterID
        params.Add(param)

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        If dateFormat.Trim.Length > 0 Then
            param = New SqlParameter("@DateString", SqlDbType.VarChar)
            param.Value = dateFormat.Trim
            params.Add(param)
        End If

        If docId.Trim.Length > 0 Then
            param = New SqlParameter("@DocId", SqlDbType.VarChar)
            param.Value = docId.Trim
            params.Add(param)
        End If

        If DocTypeId.Trim.Length > 0 Then
            param = New SqlParameter("@DocTypeId", SqlDbType.VarChar)
            param.Value = DocTypeId.Trim
            params.Add(param)
        End If

        If subFolder.Trim.Length > 0 Then
            param = New SqlParameter("@SubFolder", SqlDbType.VarChar)
            param.Value = subFolder.Trim
            params.Add(param)
        End If

        Return SqlHelper.ExecuteScalar("stp_ResolveClientStipulation", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub ChangeDeliveryPhoneNumber(ByVal SettlementID As Integer, ByVal PhoneNumber As String)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblSettlements_DeliveryAddresses Set ContactNumber = '{1}' Where SettlementId = {0}", SettlementID, PhoneNumber), CommandType.Text)
    End Sub

    Public Shared Sub ChangeDeliveryEmailAddress(ByVal SettlementID As Integer, ByVal EmailAddress As String)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblSettlements_DeliveryAddresses Set EmailAddress= '{1}' Where SettlementId = {0}", SettlementID, EmailAddress), CommandType.Text)
    End Sub

    Public Shared Function GetChecksByEmailHistory(ByVal MatterId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("exec stp_PaymentArrangement_GetChecksByEmail {0}", MatterId), CommandType.Text)
    End Function

    Public Shared Function GetChecksByEmailLog(ByVal LogId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("exec stp_PaymentArrangement_GetCheckByEmail {0}", LogId), CommandType.Text)
    End Function

    Public Shared Function GetCreditorAddress(ByVal SettlementId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("exec stp_PaymentArrangement_GetCreditorAddress {0}", SettlementId), CommandType.Text)
    End Function

    Public Shared Function IsPAByClient(ByVal SettlementId As Integer) As Boolean
        Return SqlHelper.ExecuteScalar(String.Format("Select PAByClient from tblsettlements Where settlementid = {0}", SettlementId), CommandType.Text)
    End Function

    Public Shared Sub UpdatePAByCLient(ByVal SettlementId As Integer, ByVal ClientPaysCreditor As Boolean)
        SqlHelper.ExecuteNonQuery(String.Format("update tblsettlements set PAByClient = {1} Where settlementid = {0}", SettlementId, IIf(ClientPaysCreditor, "1", "0")), CommandType.Text)
    End Sub

    Public Shared Function GetPAByClientSettKittToPrint() As DataTable
        Return SqlHelper.GetDataTable(String.Format("exec stp_LetterTemplates_getPrintQueue 12"), CommandType.Text)
    End Function

    Public Shared Function GetPAByClientSettKittToPrintCount() As Integer
        Return SqlHelper.GetDataTable(String.Format("exec stp_LetterTemplates_getPrintQueue 12"), CommandType.Text).Rows.Count
    End Function
End Class
