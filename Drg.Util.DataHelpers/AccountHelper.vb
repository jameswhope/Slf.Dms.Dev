
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class AccountHelper

   Public Shared Function GetSummary(ByVal AccountID As Integer) As String

      Dim CreditorName As String = GetCreditorName(AccountID)
      Dim OriginalCreditorInstanceID As Integer = GetOriginalCreditorInstanceID(AccountID)

      Dim AccountNumber As String = DataHelper.FieldLookup("tblCreditorInstance", "AccountNumber", _
          "CreditorInstanceID = " & OriginalCreditorInstanceID)

      If AccountNumber.Length > 0 Then
         If AccountNumber.Length > 3 Then
            Return CreditorName & " ****" & AccountNumber.Substring(AccountNumber.Length - 4)
         Else
            Return CreditorName & " ****" & AccountNumber
         End If
      Else
         Return CreditorName
      End If

   End Function
   Public Shared Function GetCreditorName(ByVal AccountID As Integer) As String

      Dim OriginalCreditorID As Integer = GetOriginalCreditorID(AccountID)

      Return DataHelper.FieldLookup("tblCreditor", "Name", "CreditorID = " & OriginalCreditorID).Trim()

   End Function

   Public Shared Function GetCurrentCreditorName(ByVal AccountID As Integer) As String
      Return DataHelper.FieldLookup("tblCreditor", "Name", "CreditorID = " & AccountHelper.GetCurrentCreditorID(AccountID)).Trim()
   End Function

   Public Shared Sub LockVerification(ByVal AccountID As Integer, ByVal UnverifiedAmount As Double, _
       ByVal UnverifiedRetainerFee As Double, ByVal Verified As DateTime, ByVal VerifiedBy As Integer, _
       ByVal VerifiedAmount As Double, ByVal VerifiedRetainerFee As Double)

      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
         Using cmd.Connection

            DatabaseHelper.AddParameter(cmd, "UnverifiedAmount", UnverifiedAmount)
            DatabaseHelper.AddParameter(cmd, "UnverifiedRetainerFee", UnverifiedRetainerFee)
            DatabaseHelper.AddParameter(cmd, "Verified", Verified)
            DatabaseHelper.AddParameter(cmd, "VerifiedBy", VerifiedBy)
            DatabaseHelper.AddParameter(cmd, "VerifiedAmount", VerifiedAmount)
            DatabaseHelper.AddParameter(cmd, "VerifiedRetainerFee", VerifiedRetainerFee)

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblAccount", "AccountID = " & AccountID)

            cmd.Connection.Open()
            cmd.ExecuteNonQuery()

         End Using
      End Using

   End Sub
   Public Shared Function GetCurrentAmount(ByVal AccountID As Integer) As Double
      Return StringHelper.ParseDouble(DataHelper.FieldLookup("tblAccount", "CurrentAmount", "AccountID = " & AccountID))
   End Function
   Public Shared Function GetNumRetainerOrAdditionalAccountFees(ByVal AccountID As Integer) As Integer
      Return DataHelper.FieldCount("tblRegister", "RegisterID", "EntryTypeID IN (2,19, 42) AND AccountID = " & AccountID)
   End Function
   Public Shared Function GetSumRetainerOrAdditionalAccountFees(ByVal AccountID As Integer) As Double
      Return Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID IN (2,19, 42) AND AccountID = " & AccountID))
   End Function
   Public Shared Function GetNumRetainerFees(ByVal AccountID As Integer) As Integer
      Return DataHelper.FieldCount("tblRegister", "RegisterID", "EntryTypeID IN (2, 42) AND AccountID = " & AccountID)
   End Function
   Public Shared Function GetSumRetainerFees(ByVal AccountID As Integer) As Double
      Return Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID IN (2, 42) AND Void IS NULL AND AccountID = " & AccountID))
   End Function
   Public Shared Function GetNumAdditionalAccountFees(ByVal AccountID As Integer) As Integer
      Return DataHelper.FieldCount("tblRegister", "RegisterID", "EntryTypeID = 19 AND AccountID = " & AccountID)
   End Function
   Public Shared Function GetSumAdditionalAccountFees(ByVal AccountID As Integer) As Double
      Return Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID = 19 AND AccountID = " & AccountID))
   End Function
   Public Shared Function GetRetainerFee(ByVal AccountID As Integer) As Integer
      Return StringHelper.ParseInt(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID IN (2, 42) AND AccountID = " & AccountID))
   End Function
   Public Shared Function GetAdditionalAccountFee(ByVal AccountID As Integer) As Integer
      Return StringHelper.ParseInt(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 19 AND AccountID = " & AccountID))
   End Function
   Public Shared Sub AdjustRetainerFeesOriginal(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean)
      Dim AccountIDs As New List(Of Integer)

      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
         cmd.CommandText = "SELECT * FROM tblAccount WHERE ClientID = @ClientID"

         DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

         Using cn As IDbConnection = cmd.Connection
            cn.Open()
            Using rd As IDataReader = cmd.ExecuteReader()

               While rd.Read()
                  AccountIDs.Add(DatabaseHelper.Peel_int(rd, "AccountID"))
               End While
            End Using
         End Using
      End Using

      For Each acctID As Integer In AccountIDs
         AdjustRetainerFee(acctID, ClientID, UserID, DoCleanUp, 0, 0)
      Next
   End Sub
   Public Shared Sub AdjustRetainerFeeOriginal(ByVal AccountID As Integer, ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanup As Boolean)
      DataHelper.FieldUpdate("tblClient", "SetupFeePercentage", DataHelper.Nz_double(PropertyHelper.Value("EnrollmentRetainerPercentage")) + DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0), "ClientID = " + ClientID.ToString())

      Dim Verified As String = DataHelper.FieldLookup("tblAccount", "Verified", "AccountID = " & AccountID)
      Dim Underwriting As String = ""
      Dim Percentage As Double = 0

      Dim EntryTypeID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", _
                  "EntryTypeID", "[Name] = 'Fee Adjustment'"))

      If Verified.Length = 0 Then 'NOT already locked
         Dim NumRetainers As Integer = GetNumRetainerFees(AccountID)
         Dim SumRetainers = GetSumRetainerFees(AccountID)

         Dim NumAdditional As Integer = GetNumAdditionalAccountFees(AccountID)
         Dim SumAdditional = GetSumAdditionalAccountFees(AccountID)

         Dim Amount As Double = Math.Abs(GetCurrentAmount(AccountID))
         Percentage = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblAccount", _
             "SetupFeePercentage", "AccountID = " & AccountID)) - DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0))

         Dim MinimumAdditionalAccountFee As Double = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
             "AdditionalAccountFee", "ClientID = " & ClientID)))

         If NumRetainers = 0 And NumAdditional = 0 Then 'no fee ever taken
            Underwriting = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)

            Dim FeeAmount As Double = Math.Abs((Amount * Percentage))

            If MinimumAdditionalAccountFee > FeeAmount And Underwriting.Length > 0 Then
               FeeAmount = MinimumAdditionalAccountFee
            End If

            If Underwriting.Length = 0 Then 'underwriting verification has NOT finished for this client
               'insert new retainer fee
               RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                   Math.Round(FeeAmount * -1, 2), 2, Nothing, Nothing, Nothing, UserID, DoCleanup)
            Else
               Dim tempAdditional As Double = 0

               If (Double.TryParse(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), tempAdditional) And Not tempAdditional = 0) Then
                  FeeAmount += Amount * tempAdditional
               End If

               'insert new additional account fee
               RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                   Math.Round(FeeAmount * -1, 2), 19, Nothing, Nothing, Nothing, UserID, DoCleanup)
            End If
         Else
            Dim RegisterID As Integer = 0
            Dim Adjustment As Double = 0

            If Not NumRetainers = 0 Then 'retainer fee was already taken
               'adjust current retainer fee as needed
               Adjustment = ((Amount * Percentage) - SumRetainers)
               RegisterID = GetRetainerFee(AccountID)
            Else 'additional account fee was already taken
               'adjust current additional account fee as needed
               Adjustment = ((Amount * Percentage) - SumAdditional)
               RegisterID = GetAdditionalAccountFee(AccountID)
            End If

            If Not Adjustment = 0 And Not EntryTypeID = 0 And Not RegisterID = 0 Then
               RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID, DateTime.Now, String.Empty, _
                   Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, DoCleanup)
            End If
         End If
      End If

      Dim InitialAgencyPercentage As Double

      Underwriting = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)

      If Underwriting.Length = 0 And Verified.Length = 0 And Double.TryParse(DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0), InitialAgencyPercentage) AndAlso InitialAgencyPercentage > 0 Then
         Dim InitialAgencyRegisterID As Integer
         Dim InitialAgencyAmount As Double

         InitialAgencyAmount = Math.Abs(Double.Parse(DataHelper.FieldLookup("tblAccount", "CurrentAmount", "AccountID = " + AccountID.ToString() + " and ClientID = " + ClientID.ToString())))

         If Not Integer.TryParse(DataHelper.FieldLookup("tblRegister", "RegisterID", "Void is null and EntryTypeID = 42 and AccountID = " + AccountID.ToString() + " and ClientID = " + ClientID.ToString()), InitialAgencyRegisterID) Then
            RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                Math.Round(Math.Abs(InitialAgencyAmount * InitialAgencyPercentage) * -1, 2), 42, _
                Nothing, Nothing, Nothing, UserID, DoCleanup)
         Else
            Dim InitialAgencyAdjustment As Double = 0
            Dim InitialAgencyOldAmount As Double = Math.Abs(Double.Parse(DataHelper.FieldLookup("tblRegister", "Amount", "RegisterID = " + InitialAgencyRegisterID.ToString())))

            RegisterHelper.InsertFeeAdjustment(ClientID, InitialAgencyRegisterID, DateTime.Now, String.Empty, _
            Math.Round((Math.Abs(InitialAgencyAmount * InitialAgencyPercentage) - InitialAgencyOldAmount) * -1, 2), EntryTypeID, UserID, DoCleanup)
         End If
      End If
   End Sub
   Public Shared Sub ClientRetainerMake10(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean)
      Using cmd As New SqlCommand("SELECT rp.RegisterPaymentID FROM tblRegister as r inner join " + _
      "tblRegisterPayment as rp on rp.FeeRegisterID = r.RegisterID WHERE rp.Voided = 0 and r.EntryTypeID = 2 and r.ClientID = " + _
      ClientID.ToString(), ConnectionFactory.Create())
         Using cmd.Connection
            cmd.Connection.Open()

            Dim VWDEResolved As DateTime
            Dim VWDEResolvedBy As Integer
            Dim VWUWResolved As DateTime
            Dim VWUWResolvedBy As Integer

            Dim RegisterPaymentIDs As New List(Of Integer)

            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  RegisterPaymentIDs.Add(Integer.Parse(reader("RegisterPaymentID")))
               End While
            End Using

            For Each regPayID As Integer In RegisterPaymentIDs
               cmd.CommandText = "exec stp_DoRegisterPaymentVoid " + regPayID.ToString() & ", 0, " & UserID

               cmd.ExecuteNonQuery()
            Next

            cmd.CommandText = "SELECT VWDEResolved, VWDEResolvedBy, VWUWResolved, VWUWResolvedBy FROM tblClient WHERE ClientID = " + ClientID.ToString()

            Using reader As SqlDataReader = cmd.ExecuteReader()
               If reader.Read() Then
                  VWDEResolved = DataHelper.Nz_date(reader("VWDEResolved"), New DateTime(9999, 1, 1))
                  VWDEResolvedBy = DataHelper.Nz_int(reader("VWDEResolvedBy"), 0)
                  VWUWResolved = DataHelper.Nz_date(reader("VWUWResolved"), New DateTime(9999, 1, 1))
                  VWUWResolvedBy = DataHelper.Nz_int(reader("VWUWResolvedBy"), 0)
               End If
            End Using

            cmd.CommandText = "UPDATE tblClient SET InitialAgencyPercent = 0.02, VWDEResolved = null, VWDEResolvedBy = null, VWUWResolved = null, VWUWResolvedBy = null WHERE ClientID = " + ClientID.ToString()

            cmd.ExecuteNonQuery()

            AdjustRetainerFees(ClientID, UserID, DoCleanUp, 0, 0)

            cmd.CommandText = "UPDATE tblClient SET VWDEResolved = " + IIf(VWDEResolved.Year = 9999, "null", "'" + _
            VWDEResolved.ToString() + "'") + ", VWDEResolvedBy = " + IIf(VWDEResolvedBy = 0, "null", VWDEResolvedBy.ToString()) + _
            ", VWUWResolved = " + IIf(VWUWResolved.Year = 9999, "null", "'" + VWUWResolved.ToString() + "'") + _
            ", VWUWResolvedBy = " + IIf(VWUWResolvedBy = 0, "null", VWUWResolvedBy.ToString()) + " WHERE ClientID = " + _
            ClientID.ToString()

            cmd.ExecuteNonQuery()
         End Using
      End Using
   End Sub

#Region "Adjust Retainer fees from 8 to 10 or 5 and visa versa"
   'Modified by Jim Hope 9/27/2007 to handle 8 and 10 changes.
   'if it's a 10% an 8% or whatever then the pct flag will flag it as such 
   'This is a temporary fix and the changes for 5% or whatever were made by
   'Jim Hope on 01/03/2008

   Public Shared Sub ClientRetainerCorrect(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean, ByVal Pct As Integer, ByVal OldPct As Integer)

      'Public Shared Sub ClientRetainerCorrect(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean, Optional ByVal Pct As Integer = 0, Optional ByVal OldPct As Integer = 0)

      Dim CurrentFeeBase As Double = DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " & ClientID)
      Dim PctOfFee As Double = Pct / 100

      Dim strSQL As String = "SELECT rp.RegisterPaymentID FROM tblRegister as r inner join " + _
                        "tblRegisterPayment as rp on rp.FeeRegisterID = r.RegisterID WHERE rp.Voided = 0 " + _
                        "and r.EntryTypeID IN (2, 42) and r.ClientID = " + ClientID.ToString()

      Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
         Console.WriteLine("Connecting to Database.")
         Using cmd.Connection
            cmd.Connection.Open()

            Dim VWDEResolved As DateTime
            Dim VWDEResolvedBy As Integer
            Dim VWUWResolved As DateTime
            Dim VWUWResolvedBy As Integer

            '****************validate this***************
            'If Pct <> 10 Then 'void the payments, but only if you're going from a 10% to an 8%
            'all payments need to be reallocated at a different percent
            Dim RegisterPaymentIDs As New List(Of Integer)

            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  RegisterPaymentIDs.Add(Integer.Parse(reader("RegisterPaymentID")))
               End While
            End Using

            'Void the payments if it's got payments against it.
            For Each regPayID As Integer In RegisterPaymentIDs
               cmd.CommandText = "exec stp_DoRegisterPaymentVoid " & regPayID.ToString() & ", 0, " & UserID
               cmd.ExecuteNonQuery()
            Next
            'End If
            '*************************************

            cmd.CommandText = "SELECT VWDEResolved, VWDEResolvedBy, VWUWResolved, VWUWResolvedBy FROM tblClient WHERE ClientID = " + ClientID.ToString()

            Using reader As SqlDataReader = cmd.ExecuteReader()
               If reader.Read() Then
                  VWDEResolved = DataHelper.Nz_date(reader("VWDEResolved"), New DateTime(9999, 1, 1))
                  VWDEResolvedBy = DataHelper.Nz_int(reader("VWDEResolvedBy"), 0)
                  VWUWResolved = DataHelper.Nz_date(reader("VWUWResolved"), New DateTime(9999, 1, 1))
                  VWUWResolvedBy = DataHelper.Nz_int(reader("VWUWResolvedBy"), 0)
               End If
            End Using

            Select Case Pct
               Case 10
                  cmd.CommandText = "UPDATE tblClient SET InitialAgencyPercent = 0.02, SetupFeePercentage = 0.10, VWDEResolved = null, VWDEResolvedBy = null, VWUWResolved = null, VWUWResolvedBy = null WHERE ClientID = " + ClientID.ToString()
                  cmd.ExecuteNonQuery()
                  cmd.CommandText = "UPDATE tblAccount SET SetupFeePercentage = 0.10 WHERE ClientID = " + ClientID.ToString
                  cmd.ExecuteNonQuery()
               Case Else
                  'update the client
                  cmd.CommandText = "UPDATE tblClient SET SetupFeePercentage = " & PctOfFee & ", InitialAgencyPercent = null, VWDEResolved = null, VWDEResolvedBy = null, VWUWResolved = null, VWUWResolvedBy = null WHERE ClientID = " + ClientID.ToString()
                  cmd.ExecuteNonQuery()
                  'update the accounts
                  cmd.CommandText = "UPDATE tblAccount SET SetupFeePercentage = " & PctOfFee & " WHERE ClientID = " + ClientID.ToString
                  cmd.ExecuteNonQuery()
                  'Void the 42's in the register - could I delete them probably
                  'cmd.CommandText = "Update tblRegister SET Void = 1, VoidBy = " & UserID & " WHERE EntryTypeID = 42 AND ClientID = " + ClientID.ToString
                  'cmd.ExecuteNonQuery()
            End Select

            AdjustRetainerFees(ClientID, UserID, DoCleanUp, Pct, OldPct)

            'Assigning values to re-resolve the client
            cmd.CommandText = "UPDATE tblClient SET VWDEResolved = " + IIf(VWDEResolved.Year = 9999, "null", "'" + _
            VWDEResolved.ToString() + "'") + ", VWDEResolvedBy = " + IIf(VWDEResolvedBy = 0, "null", VWDEResolvedBy.ToString()) + _
            ", VWUWResolved = " + IIf(VWUWResolved.Year = 9999, "null", "'" + VWUWResolved.ToString() + "'") + _
            ", VWUWResolvedBy = " + IIf(VWUWResolvedBy = 0, "null", VWUWResolvedBy.ToString()) + " WHERE ClientID = " + _
            ClientID.ToString()

            cmd.ExecuteNonQuery()

            'Post the reason for the change to the reasons table
            cmd.CommandText = "INSERT INTO tblReasons (Value, ValueType, ReasonsDescID, Created, CreatedBy) " _
            & "VALUES (" & ClientID.ToString & ", " & "'ClientID', 138, '" & Now & "', " & UserID & ")"

            cmd.ExecuteNonQuery()

            If DoCleanUp Then
               'Rebalance the account so the UI makes sense after the change
               cmd.CommandText = "exec stp_DoRegisterCleanup " + ClientID.ToString() & ", " & UserID
               cmd.ExecuteNonQuery()
            End If
         End Using
      End Using

   End Sub

   Public Shared Sub AdjustRetainerFees(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean, ByVal Pct As Integer, ByVal OldPct As Integer)
      'Public Shared Sub AdjustRetainerFees(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean, Optional ByVal Pct As Integer = 0, Optional ByVal OldPct As Integer = 0)
      Dim AccountIDs As New List(Of Integer)

      Using cmd As SqlCommand = ConnectionFactory.Create().CreateCommand()
         cmd.CommandText = "SELECT * FROM tblAccount WHERE ClientID = @ClientID"

         DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

         Using cn As SqlConnection = cmd.Connection
            cn.Open()
            Using rd As IDataReader = cmd.ExecuteReader()

               While rd.Read()
                  AccountIDs.Add(DatabaseHelper.Peel_int(rd, "AccountID"))
               End While
            End Using
         End Using
      End Using

      For Each acctID As Integer In AccountIDs
         AdjustRetainerFee(acctID, ClientID, UserID, DoCleanUp, Pct, OldPct)
      Next
   End Sub

   Public Shared Sub AdjustRetainerFee(ByVal AccountID As Integer, ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean, ByVal Pct As Integer, ByVal OldPct As Integer)
      'Public Shared Sub AdjustRetainerFee(ByVal AccountID As Integer, ByVal ClientID As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Boolean, Optional ByVal Pct As Integer = 0, Optional ByVal OldPct As Integer = 0)
      'The data has been updated already (ClientRetainerCorrect) and is being passed, if needed by the routines in Pct
      'DataHelper.FieldUpdate("tblClient", "SetupFeePercentage", DataHelper.Nz_double(PropertyHelper.Value("EnrollmentRetainerPercentage")) + DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0), "ClientID = " + ClientID.ToString())

      Dim Verified As String = DataHelper.FieldLookup("tblAccount", "Verified", "AccountID = " & AccountID)
      Dim Underwriting As String = ""
      Dim Percentage As Double = 0
      Dim InitialAgencyPercentage As Double = 0
      Dim NumRetainers As Integer = 0
      Dim NumCreditors As Integer = 0
      Dim SumRetainers As Double = 0
      Dim NumAdditional As Integer = 0
      Dim SumAdditional As Double = 0
      Dim Amount As Double = 0
      Dim MinimumAdditionalAccountFee As Double = 0
      Dim FeeAmount As Double = 0
      Dim TempAdditional As Double = 0
      Dim RegisterID As Integer = 0
      Dim Adjustment As Double = 0
      Dim InitialAgencyAdjustment As Double = 0
      Dim InitialAgencyOldAmount As Double = 0
      Dim InitialAgencyRegisterID As Integer = 0
      Dim InitialAgencyAmount As Double = 0


      Dim EntryTypeID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", _
                  "EntryTypeID", "[Name] = 'Fee Adjustment'"))

      If Pct > 8 Then 'Anything more that 8 Percent is a new rate 
         If Verified.Length = 0 Then 'NOT already locked and we are making a change
            NumRetainers = GetNumRetainerFees(AccountID)
            SumRetainers = GetSumRetainerFees(AccountID)

            NumAdditional = GetNumAdditionalAccountFees(AccountID)
            SumAdditional = GetSumAdditionalAccountFees(AccountID)

            Amount = Math.Abs(GetCurrentAmount(AccountID))
            Percentage = CDbl(Pct / 100) - DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0)
            'Percentage = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblAccount", _
            '    "SetupFeePercentage", "AccountID = " & AccountID)) - DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0))

            MinimumAdditionalAccountFee = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
                "AdditionalAccountFee", "ClientID = " & ClientID)))

            If NumRetainers = 0 And NumAdditional = 0 Then 'no fee ever taken
               Underwriting = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)

               FeeAmount = Math.Abs((Amount * Percentage))

               If MinimumAdditionalAccountFee > FeeAmount Then
                  FeeAmount = MinimumAdditionalAccountFee
               End If

               If Underwriting.Length = 0 Then 'underwriting verification has NOT finished for this client
                  'insert new retainer fee if there is one
                  RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                          Math.Round(FeeAmount * -1, 2), 2, Nothing, Nothing, Nothing, UserID, DoCleanUp)
               Else
                  TempAdditional = 0

                  If (Double.TryParse(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), TempAdditional) And Not TempAdditional = 0) Then
                     FeeAmount += Amount * TempAdditional
                  End If

                  'insert new additional account fee if their is one
                  RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                      Math.Round(FeeAmount * -1, 2), 19, Nothing, Nothing, Nothing, UserID, DoCleanUp)
               End If
            Else
               RegisterID = 0
               Adjustment = 0

               If Not NumRetainers = 0 Then 'retainer fee was already taken
                  'adjust current retainer fee as needed
                  Adjustment = ((Amount * Percentage) - SumRetainers)
                  RegisterID = GetRetainerFee(AccountID)
               Else 'additional account fee was already taken
                  'adjust current additional account fee as needed
                  Adjustment = ((Amount * Percentage) - SumAdditional)
                  RegisterID = GetAdditionalAccountFee(AccountID)
               End If

               If Not Adjustment = 0 And Not EntryTypeID = 0 And Not RegisterID = 0 Then
                  RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID, DateTime.Now, String.Empty, _
                      Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, DoCleanUp)
               End If
            End If
         End If

         Underwriting = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)

         If Underwriting.Length = 0 And Verified.Length = 0 And Double.TryParse(DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0), InitialAgencyPercentage) AndAlso InitialAgencyPercentage > 0 Then
            InitialAgencyAmount = Math.Abs(Double.Parse(DataHelper.FieldLookup("tblAccount", "CurrentAmount", "AccountID = " + AccountID.ToString() + " and ClientID = " + ClientID.ToString())))

            If Not Integer.TryParse(DataHelper.FieldLookup("tblRegister", "RegisterID", "Void is null and EntryTypeID = 42 and AccountID = " + AccountID.ToString() + " and ClientID = " + ClientID.ToString()), InitialAgencyRegisterID) Then
               RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                   Math.Round(Math.Abs(InitialAgencyAmount * InitialAgencyPercentage) * -1, 2), 42, _
                   Nothing, Nothing, Nothing, UserID, DoCleanUp)
            Else
               InitialAgencyAdjustment = 0
               InitialAgencyOldAmount = Math.Abs(Double.Parse(DataHelper.FieldLookup("tblRegister", "Amount", "RegisterID = " + InitialAgencyRegisterID.ToString())))

               RegisterHelper.InsertFeeAdjustment(ClientID, InitialAgencyRegisterID, DateTime.Now, String.Empty, _
               Math.Round((Math.Abs(InitialAgencyAmount * InitialAgencyPercentage) - InitialAgencyOldAmount) * -1, 2), EntryTypeID, UserID, DoCleanUp)
            End If
         End If
      End If

      'Eight percent and 5 percent old rates
      If Pct <= 8 And Pct > 0 Then
         If Verified.Length = 0 Then 'NOT already locked
            NumRetainers = GetNumRetainerFees(AccountID)
            SumRetainers = GetSumRetainerFees(AccountID)

            NumAdditional = GetNumAdditionalAccountFees(AccountID)
            SumAdditional = GetSumAdditionalAccountFees(AccountID)

            Amount = Math.Abs(GetCurrentAmount(AccountID))
            Percentage = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblAccount", _
            "SetupFeePercentage", "AccountID = " & AccountID)))
            'Percentage = CDbl(Pct / 100) - DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientID = " + ClientID.ToString()), 0)

            MinimumAdditionalAccountFee = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
                "AdditionalAccountFee", "ClientID = " & ClientID)))

            If NumRetainers = 0 And NumAdditional = 0 Then 'no fee ever taken

               Underwriting = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)

               FeeAmount = Math.Abs((Amount * Percentage))

               If MinimumAdditionalAccountFee > FeeAmount Then
                  FeeAmount = MinimumAdditionalAccountFee
               End If

               If Underwriting.Length = 0 Then 'underwriting verification has NOT finished for this client

                  'insert new retainer fee
                  RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                        Math.Round(FeeAmount * -1, 2), 2, Nothing, Nothing, Nothing, UserID, DoCleanUp)

               Else

                  'insert new additional account fee
                  RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                      Math.Round(FeeAmount * -1, 2), 19, Nothing, Nothing, Nothing, UserID, DoCleanUp)

               End If

            Else

               RegisterID = 0
               Adjustment = 0

               EntryTypeID = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", _
                   "EntryTypeID", "[Name] = 'Fee Adjustment'"))

               If Not NumRetainers = 0 Then 'retainer fee was already taken

                  'adjust current retainer fee as needed
                  Adjustment = ((Amount * Percentage) - SumRetainers)
                  RegisterID = GetRetainerFee(AccountID)

               Else 'additional account fee was already taken

                  'adjust current additional account fee as needed
                  Adjustment = ((Amount * Percentage) - SumAdditional)
                  RegisterID = GetAdditionalAccountFee(AccountID)

               End If

               If Not Adjustment = 0 And Not EntryTypeID = 0 And Not RegisterID = 0 Then

                  RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID, DateTime.Now, String.Empty, _
                      Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, DoCleanUp)
               End If
            End If
         End If
      End If

      If Pct <= 0 Then 'With a retainer rate of 0% the only thing we charge for is additional accounts
         'added after underwriting has resolved the client
         MinimumAdditionalAccountFee = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
    "AdditionalAccountFee", "ClientID = " & ClientID)))
         Underwriting = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)
         NumAdditional = GetNumAdditionalAccountFees(AccountID)
         If NumAdditional = 0 And Underwriting.Length <> 0 Then 'No additional account fee has been charged for this creditor
            'insert new additional account fee since underwriting has already resolved this client.
            RegisterHelper.InsertFee(Nothing, ClientID, AccountID, DateTime.Now, String.Empty, _
                Math.Round(MinimumAdditionalAccountFee * -1, 2), 19, Nothing, Nothing, Nothing, UserID, DoCleanUp)
         End If
      End If

   End Sub

#End Region

   Public Shared Function GetOriginalCreditorID(ByVal AccountID As Integer) As Integer

      Dim OriginalCreditorInstanceID As Integer = GetOriginalCreditorInstanceID(AccountID)

      Return DataHelper.Nz_int(DataHelper.FieldLookup("tblCreditorInstance", _
          "CreditorID", "CreditorInstanceID = " & OriginalCreditorInstanceID))

   End Function
   Public Shared Function GetCurrentCreditorID(ByVal AccountID As Integer) As Integer

      Dim CurrentCreditorInstanceID As Integer = GetCurrentCreditorInstanceID(AccountID)

      Return DataHelper.Nz_int(DataHelper.FieldLookup("tblCreditorInstance", _
          "CreditorID", "CreditorInstanceID = " & CurrentCreditorInstanceID))

   End Function
   Public Shared Function SetWarehouseValues(ByVal AccountID As Integer) As Integer

      Dim OriginalCreditorInstanceID As Integer = DataHelper.FieldTop1("tblCreditorInstance", "CreditorInstanceID", "AccountID=" & AccountID, "acquired, creditorinstanceid")
      Dim CurrentCreditorInstanceID As Integer = DataHelper.FieldTop1("tblCreditorInstance", "CreditorInstanceID", "AccountID=" & AccountID, "acquired desc, creditorinstanceid desc")
      Dim OriginalAmount As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblCreditorInstance", "OriginalAmount", "CreditorInstanceID = " & OriginalCreditorInstanceID))
      Dim CurrentAmount As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblCreditorInstance", "Amount", "CreditorInstanceID = " & CurrentCreditorInstanceID))

      'update account fields
      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

         DatabaseHelper.AddParameter(cmd, "OriginalCreditorInstanceID", OriginalCreditorInstanceID)
         DatabaseHelper.AddParameter(cmd, "CurrentCreditorInstanceID", CurrentCreditorInstanceID)
         DatabaseHelper.AddParameter(cmd, "OriginalAmount", OriginalAmount)
         DatabaseHelper.AddParameter(cmd, "CurrentAmount", CurrentAmount)

         DatabaseHelper.BuildUpdateCommandText(cmd, "tblAccount", "AccountID = " & AccountID)

         Using cn As IDbConnection = cmd.Connection

            cn.Open()
            cmd.ExecuteNonQuery()

         End Using
      End Using

   End Function
   Public Shared Function GetOriginalCreditorInstanceID(ByVal AccountID As Integer) As Integer

      Return DataHelper.Nz_int(DataHelper.FieldLookup("tblAccount", _
          "OriginalCreditorInstanceID", "AccountID = " & AccountID))

   End Function
   Public Shared Function GetCurrentCreditorInstanceID(ByVal AccountID As Integer) As Integer

      Return DataHelper.Nz_int(DataHelper.FieldLookup("tblAccount", _
          "CurrentCreditorInstanceID", "AccountID = " & AccountID))

   End Function
   Public Shared Function Exists(ByVal AccountID As Integer) As Boolean
      Return DataHelper.RecordExists("tblAccount", "AccountID = " & AccountID)
   End Function
   Public Shared Function Insert(ByVal ClientID As Integer, ByVal OriginalAmount As Double, _
       ByVal CurrentAmount As Double, ByVal SetupFeePercentage As Double, _
       ByVal OriginalDueDate As DateTime, ByVal UserID As Integer) As Integer

      Dim rd As IDataReader = Nothing
      Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

      DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
      DatabaseHelper.AddParameter(cmd, "OriginalAmount", OriginalAmount)
      DatabaseHelper.AddParameter(cmd, "CurrentAmount", CurrentAmount)
      DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", SetupFeePercentage)
      DatabaseHelper.AddParameter(cmd, "OriginalDueDate", OriginalDueDate)

      DatabaseHelper.AddParameter(cmd, "Created", Now)
      DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
      DatabaseHelper.AddParameter(cmd, "LastModified", Now)
      DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

      DatabaseHelper.BuildInsertCommandText(cmd, "tblAccount", "AccountID", SqlDbType.Int)

      Try

         cmd.Connection.Open()
         cmd.ExecuteNonQuery()

      Finally
         DatabaseHelper.EnsureReaderClosed(rd)
         DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
      End Try

      Return DataHelper.Nz_int(cmd.Parameters("@AccountID").Value)

   End Function
   Public Shared Sub Delete(ByVal AccountId As Integer)

      '(1) get and delete all related creditorinstance records
      Dim CurrentCreditorInstanceIDs() As Integer = DataHelper.FieldLookupIDs("tblCreditorInstance", _
          "CreditorInstanceID", "AccountID = " & AccountId)

      CreditorInstanceHelper.Delete(CurrentCreditorInstanceIDs)

      '(2) delete the account record
      DataHelper.Delete("tblAccount", "AccountId = " & AccountId)

   End Sub
   Public Shared Sub Delete(ByVal AccountIds() As Integer)

      'loop through and delete each one
      For Each AccountId As Integer In AccountIds
         Delete(AccountId)
      Next

   End Sub
End Class