Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Array

Imports Microsoft.VisualBasic

Public Class RtrFeeAdjustmentHelper

   Public CorrectRetainerFees As New Dictionary(Of Integer, Double)
   Public CurrentRetainerFees As New Dictionary(Of Integer, Double)
   Public RetainerFeesToAdjust As New List(Of Integer)
   Public EntryTypeID As Integer
   Public NewAccounts As New Dictionary(Of Integer, Double)

   Private Sub GetRtrFeeAmounts(ByVal ClientID As Integer)
      'Need this to determine the value to set for the select statement
      Dim strSQL As String

      'Get the clients fees that should be charged
      Dim dblRtrPct As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
                        "SetUpFeePercentage", "ClientID = " + ClientID.ToString()), 0)

        strSQL = "SELECT AccountID, CurrentAmount, Verified FROM tblAccount WHERE ClientId = " & ClientID
      ' Get the client accounts and the current account balance
      With CorrectRetainerFees
         Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
            Using cmd.Connection
               cmd.Connection.Open()
               Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            'If reader(2) Is DBNull.Value Then
                            .Add(reader(0), (Math.Round((reader(1) * dblRtrPct), 2)))
                            'End If
                        End While
               End Using
            End Using
         End Using
      End With

      'Get all the current fees per tblRegister
      strSQL = "EXEC stp_GetClientRtrFees " & ClientID
      With CurrentRetainerFees
         Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
            Using cmd.Connection
               cmd.Connection.Open()
               Using reader As SqlDataReader = cmd.ExecuteReader()
                  While reader.Read
                     .Add(reader(0), Math.Round(reader.Item(1) * -1, 2))
                  End While
               End Using
            End Using
         End Using
      End With

      'Is there a new account?
      If CurrentRetainerFees.Count <> CorrectRetainerFees.Count Then
         For Each kvp As KeyValuePair(Of Integer, Double) In CorrectRetainerFees
            If Not CurrentRetainerFees.ContainsKey(kvp.Key) Then
               NewAccounts.Add(kvp.Key, kvp.value)
            End If
         Next
        End If

   End Sub

   Public Function ShouldRtrFeeChange(ByVal ClientID As Integer, ByVal UserID As Integer,Optional ByVal DueDate As Date = #01/01/1900#) As Boolean
      Dim SumCurrent As Double = 0
        Dim SumCorrect As Double = 0
        Dim Resolved As Date = #1/1/1900#

      CorrectRetainerFees.Clear()
      CurrentRetainerFees.Clear()
      RetainerFeesToAdjust.Clear()
        NewAccounts.Clear()

        If Not DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID) Is DBNull.Value Then
            If DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID).ToString <> "" Then
                Resolved = DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID)
                Resolved = DateAdd(DateInterval.Month, 1, Resolved)
            End If
        End If

        If DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", "SetUpFeePercentage", _
                          "ClientID = " + ClientID.ToString()), 0) > 0 Then
            'Should we adjust the retainer fees? Only if the client has not finished verification can we adjust the retainer fee(s).
            If Resolved >= #1/1/1900# Then
                If Resolved >= Now Or Resolved = #1/1/1900# Then
                    GetRtrFeeAmounts(ClientID)
                    'What are they now
                    For Each kvp As KeyValuePair(Of Integer, Double) In CurrentRetainerFees
                        SumCurrent += Math.Round(kvp.Value, 2)
                    Next
                    'What should they be
                    For Each kvp As KeyValuePair(Of Integer, Double) In CorrectRetainerFees
                        SumCorrect += Math.Round(kvp.Value, 2)
                    Next
                    'Now for the overall test
                    If Math.Round(SumCurrent, 2) <> Math.Round(SumCorrect, 2) Then
                        AdjustWhichFees(ClientID, UserID)
                        'Is there a new account here
                        If NewAccounts.Count > 0 Then
                            AddNewRetainerFee(ClientID, NewAccounts, DueDate, UserID, CurrentRetainerFees)
                        End If
                        Return True
                    End If
                End If
            Else
                Return False
            End If
        End If
        Return False
    End Function

   Private Sub AdjustWhichFees(ByVal ClientID As Integer, ByVal UserID As Integer)
      'Determine which fees need to be adjusted
      'Verify this is not a new account first
      For Each kvp As KeyValuePair(Of Integer, Double) In CurrentRetainerFees
         If CorrectRetainerFees.ContainsKey(kvp.Key) Then
            'This account currently exists and has a fee, now match it up
            If CorrectRetainerFees.Item(kvp.Key) <> CurrentRetainerFees.Item(kvp.Key) Then
               'Ok they're different and these retainer fees need to be adjusted
               RetainerFeesToAdjust.Add(kvp.Key)
            End If
         End If
      Next
      If RetainerFeesToAdjust.Count > 0 Then
         'Need to make some adjustments
         AdjustRetainerFees(RetainerFeesToAdjust, ClientID, UserID)
      End If
   End Sub

   Private Sub AdjustRetainerFees(ByVal AdjustmentIDs As List(Of Integer), _
                              ByVal ClientID As Integer, ByVal UserID As Integer)
      Dim Adjustment As Double
      Dim i As Int32
        Dim RegisterID As New List(Of Integer)

      'Get the basics
      EntryTypeID = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", "EntryTypeID", _
                                     "[Name] = 'Fee Adjustment'"))
      Dim dblRtrPct As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
                                    "SetUpFeePercentage", "ClientID = " + ClientID.ToString()), 0)

      'Now what have we got
      If dblRtrPct > 0.099 Then
         'This one has two entries an 8% and a 2% so both may need to be adjusted
         'Has a deposit been made?
         If Not DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 3 AND Bounce IS NULL AND Void IS NULL AND ClientID = " & ClientID) Is DBNull.Value Then
            'Need to make 2 adjustments here. Must find both instances of the retainer fee 2 and 42
            Dim TwoPct As Double
            Dim EightPct As Double
                For i = 0 To AdjustmentIDs.Count - 1
                    RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 2 AND AccountID = " & AdjustmentIDs(i)))
                    RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 42 AND AccountID = " & AdjustmentIDs(i)))
                    'Calculate the proper fees based on the Entry Type ID (RegisterID(0) is 2 - 8% and RegisterID(1) is 42 - 2%)
                    Adjustment = CorrectRetainerFees.Item(AdjustmentIDs(i)) - CurrentRetainerFees.Item(AdjustmentIDs(i))
                    EightPct = Adjustment * 0.8
                    TwoPct = Adjustment * 0.2
                    If EightPct > 0.01 Or EightPct < -0.01 Then
                        RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(0), DateTime.Now, String.Empty, _
                                        Math.Round(EightPct * -1, 2), EntryTypeID, UserID, 1)
                    End If
                    If TwoPct > 0.01 Or TwoPct < -0.01 Then
                        RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(1), DateTime.Now, String.Empty, _
                                        Math.Round(TwoPct * -1, 2), EntryTypeID, UserID, 1)
                    End If
                    RegisterID.Clear()
                Next
         Else 'A deposit has been made so just adjust the 8% with no regard for the Agent initial payout amount, assume it's already done via the initial deposit
            For i = 0 To AdjustmentIDs.Count - 1
                    RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID IN (2, 42) AND AccountID = " & AdjustmentIDs(i)))
               Adjustment = CorrectRetainerFees.Item(AdjustmentIDs(i)) - CurrentRetainerFees.Item(AdjustmentIDs(i))
               If Adjustment > 0.01 Or Adjustment < -0.01 Then
                        RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(i), DateTime.Now, String.Empty, _
                                        Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, 1)
               End If
            Next i
         End If
      Else
         'This is pretty straight forward, get the difference between the actual amount and the correct amount and post it. This is for anything but 10%
         For i = 0 To AdjustmentIDs.Count - 1
            RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "AccountID = " & AdjustmentIDs(i)))
            Adjustment = CorrectRetainerFees.Item(AdjustmentIDs(i)) - CurrentRetainerFees.Item(AdjustmentIDs(i))
            If Adjustment > 0.01 Or Adjustment < -0.01 Then
                    RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(i), DateTime.Now, String.Empty, _
                                     Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, 1)
            End If
         Next i
      End If

   End Sub

    Private Sub AddNewRetainerFee(ByVal ClientID As Integer, ByVal NewRtrFees As Dictionary(Of Integer, Double), ByVal DueDate As Date, ByVal UserID As Integer, ByVal CurrentFees As Dictionary(Of Integer, Double))

        Dim strSQL As String
        Dim dblRtrPct As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
                                      "SetUpFeePercentage", "ClientID = " + ClientID.ToString()), 0)

        Dim i As Integer = 0
        Dim PFOBal As Double
        Dim SDABal As Double
        Dim Balance As Double

        If Not DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID) Is DBNull.Value Then

        End If

        If dblRtrPct > 0.0 And dblRtrPct < 0.1 Then 'Less than 10%
            For Each cvp As KeyValuePair(Of Integer, Double) In NewRtrFees
                If Not CurrentFees.ContainsKey(cvp.Key) Then
                    If DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        PFOBal = DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        PFOBal = cvp.Value
                    End If
                    If DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        SDABal = DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        SDABal = 0.0
                    End If
                    If DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        Balance = DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        Balance = cvp.Value
                    End If
                    strSQL = "INSERT INTO tblRegister (" _
                    & "ClientID, " _
                    & "AccountID, " _
                    & "TransactionDate, " _
                    & "Amount, " _
                    & "Balance, " _
                    & "EntryTypeID, " _
                    & "IsFullyPaid, " _
                    & "Created, " _
                    & "CreatedBy, " _
                    & "PFOBalance, " _
                    & "SDABalance) " _
                    & "VALUES (" _
                    & ClientID & ", " _
                    & cvp.Key & ", " _
                    & "'" & Now & "', " _
                    & cvp.Value * -1 & ", " _
                    & Balance & ", " _
                    & 2 & ", " _
                    & 0 & ", " _
                    & "'" & Now & "', " _
                    & UserID & ", " _
                    & PFOBal & ", " _
                    & SDABal & ")"
                    Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                End If
            Next

            'For Each kvp As KeyValuePair(Of Integer, Double) In NewRtrFees
            '    'Sort out the incorrect fees
            '    AccountHelper.Insert(ClientID, kvp.Key, kvp.Value, dblRtrPct, Now, UserID)
            '    ClientHelper.CleanupRegister(ClientID)
            'Next

        Else '10% need to split it into 2 fees.
            'Get the fees, the lowest is the 2% seperate that one.
            Dim The2Values As New Dictionary(Of Integer, Double)
            Dim The42Values As New Dictionary(Of Integer, Double)
            For Each pct As KeyValuePair(Of Integer, Double) In NewRtrFees
                The2Values.Add(pct.Key, pct.Value * 0.8)
                The42Values.Add(pct.Key, pct.Value * 0.2)
            Next

            '2% fee
            For Each val As KeyValuePair(Of Integer, Double) In The2Values
                If Not CurrentFees.ContainsKey(val.Key) Then
                    If DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        PFOBal = DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        PFOBal = val.Value
                    End If
                    If DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        SDABal = DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        SDABal = 0.0
                    End If
                    If DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        Balance = DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        Balance = val.Value
                    End If
                    strSQL = "INSERT INTO tblRegister (" _
                    & "ClientID, " _
                    & "AccountID, " _
                    & "TransactionDate, " _
                    & "Amount, " _
                    & "Balance, " _
                    & "EntryTypeID, " _
                    & "IsFullyPaid, " _
                    & "Created, " _
                    & "CreatedBy, " _
                    & "PFOBalance, " _
                    & "SDABalance) " _
                    & "VALUES (" _
                    & ClientID & ", " _
                    & val.Key & ", " _
                    & "'" & Now & "', " _
                    & val.Value * -1 & ", " _
                    & Balance & ", " _
                    & 2 & ", " _
                    & 0 & ", " _
                    & "'" & Now & "', " _
                    & UserID & ", " _
                    & PFOBal & ", " _
                    & SDABal & ")"
                    Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                End If
            Next

            '8% fee
            For Each val As KeyValuePair(Of Integer, Double) In The42Values
                If Not CurrentFees.ContainsKey(val.Key) Then
                    If DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        PFOBal = DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        PFOBal = val.Value
                    End If
                    If DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        SDABal = DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        SDABal = 0.0
                    End If
                    If DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
                        Balance = DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC")
                    Else
                        Balance = val.Value
                    End If
                    strSQL = "INSERT INTO tblRegister (" _
                    & "ClientID, " _
                    & "AccountID, " _
                    & "TransactionDate, " _
                    & "Amount, " _
                    & "Balance, " _
                    & "EntryTypeID, " _
                    & "IsFullyPaid, " _
                    & "Created, " _
                    & "CreatedBy, " _
                    & "PFOBalance, " _
                    & "SDABalance) " _
                    & "VALUES (" _
                    & ClientID & ", " _
                    & val.Key & ", " _
                    & "'" & Now & "', " _
                    & val.Value * -1 & ", " _
                    & Balance & ", " _
                    & 42 & ", " _
                    & 0 & ", " _
                    & "'" & Now & "', " _
                    & UserID & ", " _
                    & PFOBal & ", " _
                    & SDABal & ")"
                    Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                End If
            Next
        End If
    End Sub

    Private Sub AdjustRetainerFee(ByVal AdjustmentID As Integer, _
                              ByVal ClientID As Integer, ByVal UserID As Integer)
        Dim Adjustment As Double
        Dim i As Int32
        Dim RegisterID As New List(Of Integer)

        'Get the basics
        EntryTypeID = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", "EntryTypeID", _
                                       "[Name] = 'Fee Adjustment'"))
        Dim dblRtrPct As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblClient", _
                                      "SetUpFeePercentage", "ClientID = " + ClientID.ToString()), 0)

        'Now what have we got
        If dblRtrPct > 0.099 Then
            'This one has two entries an 8% and a 2% so both may need to be adjusted
            'Has a deposit been made?
            If Not DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 3 AND Bounce IS NULL AND Void IS NULL AND ClientID = " & ClientID) Is DBNull.Value Then
                'Need to make 2 adjustments here. Must find both instances of the retainer fee 2 and 42
                Dim TwoPct As Double
                Dim EightPct As Double
                RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 2 AND AccountID = " & AdjustmentID))
                RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 42 AND AccountID = " & AdjustmentID))
                'Calculate the proper fees based on the Entry Type ID (RegisterID(0) is 2 - 8% and RegisterID(1) is 42 - 2%)
                Adjustment = CorrectRetainerFees.Item(AdjustmentID) - CurrentRetainerFees.Item(AdjustmentID)
                EightPct = Adjustment * 0.8
                TwoPct = Adjustment * 0.2
                If EightPct > 0.01 Or EightPct < -0.01 Then
                    RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(0), DateTime.Now, String.Empty, _
                                    Math.Round(EightPct * -1, 2), EntryTypeID, UserID, 1)
                End If
                If TwoPct > 0.01 Or TwoPct < -0.01 Then
                    RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(1), DateTime.Now, String.Empty, _
                                    Math.Round(TwoPct * -1, 2), EntryTypeID, UserID, 1)
                End If
                RegisterID.Clear()
            Else 'A deposit has been made so just adjust the 8% with no regard for the Agent initial payout amount, assume it's already done via the initial deposit
                RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 2 AND AccountID = " & AdjustmentID))
                Adjustment = CorrectRetainerFees.Item(AdjustmentID) - CurrentRetainerFees.Item(AdjustmentID)
                If Adjustment > 0.01 Or Adjustment < -0.01 Then
                    RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(0), DateTime.Now, String.Empty, _
                                    Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, 1)
                End If
            End If
        Else
            'This is pretty straight forward, get the difference between the actual amount and the correct amount and post it. This is for anything but 10%
            RegisterID.Add(DataHelper.FieldLookup("tblRegister", "RegisterID", "AccountID = " & AdjustmentID))
            Adjustment = CorrectRetainerFees.Item(AdjustmentID) - CurrentRetainerFees.Item(AdjustmentID)
            If Adjustment > 0.01 Or Adjustment < -0.01 Then
                RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID(0), DateTime.Now, String.Empty, _
                                 Math.Round(Adjustment * -1, 2), EntryTypeID, UserID, 1)
            End If
        End If

    End Sub

End Class
