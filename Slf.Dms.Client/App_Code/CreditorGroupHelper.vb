Imports Microsoft.VisualBasic
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Public Class CreditorGroupHelper

    Public Structure Creditor
        Public Name As String
        Public Street As String
        Public Street2 As String
        Public City As String
        Public StateID As Integer
        Public ZipCode As String
    End Structure

    Public Shared Function GetCreditorGroups(ByVal creditor As String, ByVal street As String, ByVal street2 As String, ByVal city As String, ByVal stateid As String, Optional ByVal blnReturnNewAdress As Boolean = True) As DataSet
        Dim sqlDA As SqlDataAdapter
        Dim dsCreditors As New DataSet

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCreditorGroups")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "creditor", creditor)
                DatabaseHelper.AddParameter(cmd, "returnnewaddress", blnReturnNewAdress)

                If street.Trim.Length > 0 Then
                    DatabaseHelper.AddParameter(cmd, "street", street.Trim)
                End If
                If street2.Trim.Length > 0 Then
                    DatabaseHelper.AddParameter(cmd, "street2", street2.Trim)
                End If
                If city.Trim.Length > 0 Then
                    DatabaseHelper.AddParameter(cmd, "city", city.Trim)
                End If
                If CInt(stateid) > 0 Then
                    DatabaseHelper.AddParameter(cmd, "stateid", CInt(stateid))
                End If

                sqlDA = New SqlDataAdapter(cmd)
                sqlDA.Fill(dsCreditors)
                dsCreditors.Relations.Add("Relation1", dsCreditors.Tables(0).Columns("creditorgroupid"), dsCreditors.Tables(1).Columns("creditorgroupid"))
            End Using
        End Using

        Return dsCreditors
    End Function

    Public Shared Function GetPotentialGroups(ByVal creditor As String) As DataTable
        Dim sqlDA As SqlDataAdapter
        Dim dsCreditors As New DataSet

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPotentialCreditorGroups")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "creditor", creditor)

                sqlDA = New SqlDataAdapter(cmd)
                sqlDA.Fill(dsCreditors)
            End Using
        End Using

        Return dsCreditors.Tables(0)
    End Function

    Public Shared Function GetPendingValidations() As Data.DataTable
        Dim cmd As New Data.SqlClient.SqlCommand()

        Try
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.CommandText = "stp_GetPendingValidations"
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function GetAccounts(ByVal CreditorID As Integer) As String
        Dim sqlDA As SqlDataAdapter
        Dim ds As New DataSet
        Dim tbl As DataTable
        Dim sb As New Text.StringBuilder

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAccountsByCreditorID")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "creditorid", CreditorID)
                sqlDA = New SqlDataAdapter(cmd)
                sqlDA.Fill(ds)
                tbl = ds.Tables(0)
                For Each row As DataRow In tbl.Rows
                    sb.Append(String.Format("<a href='../../clients/client/creditors/accounts/account.aspx?id={0}&aid={1}'>{2}</a><br/>", row("clientid"), row("accountid"), row("accountnumber")))
                Next
            End Using
        End Using

        Return sb.ToString
    End Function

    Public Shared Sub UseExistingCreditor(ByVal oldCreditorID As Integer, ByVal newCreditorID As Integer, ByVal userID As Integer)
        AddCreditorValidationTasks(oldCreditorID, userID)
        UpdateCreditorHistory(oldCreditorID, False, False, True, userID)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UseExistingCreditor")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "OldCreditorID", oldCreditorID)
                DatabaseHelper.AddParameter(cmd, "NewCreditorID", newCreditorID)
                DatabaseHelper.AddParameter(cmd, "UserID", userID)
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Public Shared Sub ValidateCreditor(ByVal creditorID As Integer, ByVal userID As Integer)
        AddCreditorValidationTasks(creditorID, userID)
        UpdateCreditorHistory(creditorID, True, False, False, userID)
        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            Using cmd.Connection
                cmd.CommandText = String.Format("update tblcreditor set validated = 1, lastmodified = getdate(), lastmodifiedby = {0} where creditorid = {1}", userID, creditorID)
                cmd.CommandType = CommandType.Text
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Public Shared Sub ValidateWithChanges(ByVal creditorID As Integer, ByVal creditorGroupID As Integer, ByVal street As String, ByVal street2 As String, ByVal city As String, ByVal stateID As Integer, ByVal zipcode As String, ByVal userID As Integer, ByVal validated As Boolean, ByVal name As String)
        AddCreditorValidationTasks(creditorID, userID)
        If validated Then
            UpdateCreditorHistory(creditorID, True, False, False, userID)
        Else
            UpdateCreditorHistory(creditorID, False, True, False, userID)
        End If
        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            Using cmd.Connection
                cmd.CommandText = String.Format("update tblcreditor set validated={0}, lastmodified=getdate(), lastmodifiedby={1}, creditorgroupid={2}, street='{3}', street2='{4}', city='{5}', stateid={6}, zipcode='{7}', name='{8}' where creditorid={9}", IIf(validated, "1", "null"), userID, creditorGroupID, street.Replace("'", "''"), street2.Replace("'", "''"), city.Replace("'", "''"), stateID, zipcode, name.Replace("'", "''"), creditorID)
                cmd.CommandType = CommandType.Text
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Private Shared Sub UpdateCreditorHistory(ByVal creditorID As Integer, ByVal validated As Boolean, ByVal approved As Boolean, ByVal duplicate As Boolean, ByVal userID As Integer)
        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            Using cmd.Connection
                If validated Then
                    cmd.CommandText = String.Format("update tblcreditorhistory set validated = 1, lastmodified=getdate(), lastmodifiedby={0} where creditorid = {1}", userID, creditorID)
                ElseIf approved Then
                    cmd.CommandText = String.Format("update tblcreditorhistory set approved = 1, lastmodified=getdate(), lastmodifiedby={0} where creditorid = {1}", userID, creditorID)
                ElseIf duplicate Then
                    cmd.CommandText = String.Format("update tblcreditorhistory set duplicate = 1, lastmodified=getdate(), lastmodifiedby={0} where creditorid = {1}", userID, creditorID)
                End If
                cmd.CommandType = CommandType.Text
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Public Shared Sub CleanupCreditorGroup(ByVal creditorGroupID As Integer)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_CleanupCreditorGroup")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "CreditorGroupID", creditorGroupID)
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Public Shared Function InsertCreditorGroup(ByVal Name As String, ByVal UserID As Integer) As Integer
        Dim intCreditorGroupID As Integer

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertCreditorGroup")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "Name", Name.Trim.Replace("&nbsp;", ""))
                DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                cmd.Connection.Open()
                intCreditorGroupID = CInt(cmd.ExecuteScalar())
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using

        Return intCreditorGroupID
    End Function

    Private Shared Sub AddCreditorValidationTasks(ByVal CreditorID As Integer, ByVal UserID As Integer)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AddCreditorValidationTasks")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)
                DatabaseHelper.AddParameter(cmd, "UserID", UserID)
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Public Shared Sub UpdateCreditorGroup(ByVal CreditorGroupID As Integer, ByVal Name As String, ByVal ModifiedBy As Integer)
        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            Using cmd.Connection
                cmd.CommandType = CommandType.Text
                cmd.Connection.Open()
                cmd.CommandText = String.Format("update tblcreditorgroup set name='{0}', lastmodified=getdate(), lastmodifiedby={1} where creditorgroupid={2}", Name.Replace("'", "''"), ModifiedBy, CreditorGroupID)
                cmd.ExecuteNonQuery()
                cmd.CommandText = String.Format("update tblcreditor set name='{0}', lastmodified=getdate(), lastmodifiedby={1} where creditorgroupid={2}", Name.Replace("'", "''"), ModifiedBy, CreditorGroupID)
                cmd.ExecuteNonQuery()
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Using
        End Using
    End Sub

    Public Shared Function GetCreditor(ByVal CreditorID As Integer) As Creditor
        Dim rec As New Creditor
        Dim sqlDA As SqlDataAdapter
        Dim dsCreditor As New DataSet

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
            Using cmd.Connection
                cmd.CommandType = CommandType.Text
                cmd.CommandText = String.Format("select g.name, c.street, c.street2, c.city, c.stateid, c.zipcode from tblcreditor c join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid where c.creditorid={0}", CreditorID)
                sqlDA = New SqlDataAdapter(cmd)
                sqlDA.Fill(dsCreditor)
            End Using
        End Using

        If dsCreditor.Tables(0).Rows.Count > 0 Then
            With dsCreditor.Tables(0)
                rec.Name = .Rows(0)("name").ToString
                rec.Street = .Rows(0)("street").ToString
                rec.Street2 = .Rows(0)("street2").ToString
                rec.City = .Rows(0)("city").ToString
                rec.ZipCode = .Rows(0)("zipcode").ToString
                If Not IsDBNull(.Rows(0)("stateid")) Then
                    rec.StateID = CInt(.Rows(0)("stateid"))
                End If
            End With
        End If

        Return rec
    End Function

    Public Shared Function GetCreditorName(ByVal AccountID As Integer) As String
        Dim cmdText As String = String.Format("select isnull(g.name,c.name)[name] from tblaccount a join tblcreditorinstance ci on ci.creditorinstanceid = a.currentcreditorinstanceid join tblcreditor c on c.creditorid = ci.creditorid left join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid where a.accountid = {0}", AccountID)
        Return CStr(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Public Shared Function GetOrigCreditorName(ByVal AccountID As Integer) As String
        Dim OriginalCreditorID As Integer = Drg.Util.DataHelpers.AccountHelper.GetOriginalCreditorID(AccountID)
        Return CStr(SqlHelper.ExecuteScalar("select isnull(g.name,c.name) from tblcreditor c left join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid where c.creditorid = " & OriginalCreditorID, CommandType.Text))
    End Function

End Class
