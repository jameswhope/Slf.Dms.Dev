Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls
Imports system.Data.SqlClient
Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class mediatorassignment_alph
    Inherits System.Web.UI.Page
    Implements System.Web.UI.ICallbackEventHandler

#Region "Property"
    Public Property dt() As DataTable
        Get
            If (Not IsPostBack And Not IsCallback) OrElse Setting("dt") Is Nothing Then
                Dim strIds As String = Request.QueryString("clientids")
                If Not String.IsNullOrEmpty(strIds) Then
                    Dim dtTmp As New DataTable
                    Dim cmdtxt As String = "select c.clientid,assignedmediator,lastname from tblclient c inner join tblperson p on c.primarypersonid=p.personid where c.clientid in (" & strIds & ")"
                    Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    cmd.CommandText = cmdtxt
                    Dim da As New SqlDataAdapter(cmd)
                    da.Fill(dtTmp)
                    Setting("dt") = dtTmp
                Else
                    Dim dtTmp As New DataTable
                    Dim cmd As IDbCommand = CommandHelper.DeepClone(CType(Setting("cmd"), IDbCommand))
                    Dim da As New SqlDataAdapter(cmd)
                    da.Fill(dtTmp)
                    Setting("dt") = dtTmp
                End If
            End If
            Return Setting("dt")
        End Get
        Set(ByVal value As DataTable)
            Setting("dt") = value
        End Set
    End Property
    Protected ReadOnly Property Identity() As String
        Get
            Return Me.Page.GetType.Name & "_" & Me.ID
        End Get
    End Property
    Protected Property Setting(ByVal s As String) As Object
        Get
            Return Session(Identity & "_" & s)
        End Get
        Set(ByVal value As Object)
            Session(Identity & "_" & s) = value
        End Set
    End Property
    Protected ReadOnly Property Setting(ByVal s As String, ByVal d As Object) As Object
        Get
            Dim o As Object = Setting(s)
            If o Is Nothing Then
                Return d
            Else
                Return o
            End If
        End Get
    End Property
    Protected Sub RemoveSetting(ByVal s As String)
        Session.Remove(Identity & "_" & s)
    End Sub
    Private UserID As Integer
#End Region
#Region "Event"
    Private Function GetCriteria() As String
        Dim result As String = ""

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            cmd.CommandText = "select [value] from tblquerysetting where classname=@classname and userid=@userid and object=@object"
            DatabaseHelper.AddParameter(cmd, "classname", Me.GetType.Name)
            DatabaseHelper.AddParameter(cmd, "userid", UserID)
            DatabaseHelper.AddParameter(cmd, "object", txtCriteria.ID)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    If rd.Read Then
                        result = rd.GetString(0)
                    End If
                End Using
            End Using
        End Using

        Return result
    End Function
    Private Sub Save()

        'blow away current stuff first
        Clear()

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkReassign.ID, "value", chkReassign.Checked)
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtCriteria.ID, "custom", txtCriteria.Value)

    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(chkReassign.ID, chkReassign)

        Return c

    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CType(Page.User.Identity.Name, Integer)
        If Not IsPostBack And Not IsCallback Then
            LoadValues(GetControls(), Me)
            SetAttributes()
            LoadGrid()
            LoadMediators()
        End If
    End Sub
    Private Sub SetAttributes()
        chkReassign.Attributes.Add("onclick", "UpdateAll();")
        lstMediators.BorderColor = System.Drawing.Color.Gray
        lstMediators.BorderStyle = BorderStyle.Solid
        lstMediators.BorderWidth = 1
    End Sub
    Protected Sub lnkUnassignAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnassignAll.Click
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.CommandText = "update tblclient set assignedmediator=null"
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Protected Sub lnkUnassignSelected_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnassignSelected.Click
        Dim drs() As DataRow = dt.Select("not assignedmediator is null")

        Dim SelectedClientIDs As New List(Of String)
        Dim WorkingIDs As String = ""
        For Each dr As DataRow In drs
            If WorkingIDs.Length > 1000 Then
                SelectedClientIDs.Add(WorkingIDs)
                WorkingIDs = ""
            End If
            If WorkingIDs.Length > 0 Then WorkingIDs += ","
            WorkingIDs += dr("ClientID").ToString
        Next
        If WorkingIDs.Length > 0 Then SelectedClientIDs.Add(WorkingIDs)

        If drs.Length > 0 Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.Connection.Open()

                    For Each s As String In SelectedClientIDs
                        cmd.CommandText = "update tblclient set assignedmediator=null where clientid in (" & s & ")"
                        cmd.ExecuteNonQuery()
                    Next

                End Using
            End Using
        End If
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Protected Sub lnkReset_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkReset.Click
        Clear()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Protected Sub lnkSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSubmit.Click
        Save()

        Dim Commands As New List(Of String)

        Dim criteria() As String = txtCriteria.Value.Split("|")

        Dim crReassign As String = ""
        If chkReassign.Checked = False Then crReassign = " assignedmediator is null and "

        For Each s As String In criteria
            Dim parts() As String = s.Split(",")
            Dim UserID As String = parts(0)
            Dim First As String = parts(1)
            Dim Last As String = parts(2)

            Dim rows() As DataRow = dt.Select(crReassign & "substring(lastname,1,2) >= '" & First & "' and substring(lastname,1,2) <= '" & Last & "'")

            Dim cmdStart As String = "update tblclient set assignedmediator=" & UserID & " where clientid in ("
            Dim cmdEnd As String = ")"
            Dim cmdMiddle As String = ""
            For Each dr As DataRow In rows
                Dim ClientID As Integer = dr("ClientID")

                If cmdMiddle.Length > 0 Then cmdMiddle += ","
                cmdMiddle += ClientID.ToString

                If cmdMiddle.Length > 1000 Then
                    Commands.Add(cmdStart + cmdMiddle + cmdEnd)
                    cmdMiddle = ""
                End If
            Next
            If cmdMiddle.Length > 0 Then
                Commands.Add(cmdStart + cmdMiddle + cmdEnd)
            End If
        Next


        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.Connection.Open()
                For Each s As String In Commands
                    cmd.CommandText = s
                    cmd.ExecuteNonQuery()
                Next
            End Using
        End Using

        Response.Write("<script>window.close();</script>")
    End Sub
#End Region
#Region "Query"
    Private Sub LoadMediators()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMediators")

        lstMediators.Items.Clear()

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()

                    Dim UserID As Integer = DatabaseHelper.Peel_int(rd, "UserID")
                    Dim FirstName As String = DatabaseHelper.Peel_string(rd, "FirstName")
                    Dim LastName As String = DatabaseHelper.Peel_string(rd, "LastName")

                    Dim li As New ListItem(FirstName & " " & LastName, UserID)

                    lstMediators.Items.Add(li)

                End While

            End Using
        End Using

    End Sub
    Private Sub LoadGrid()
        Dim dtPlanned As New DataTable
        dtPlanned.Columns.Add("Start")
        dtPlanned.Columns.Add("End")
        dtPlanned.Columns.Add("FullName")
        dtPlanned.Columns.Add("UserID")

        Dim cr As String = GetCriteria()
        If cr.Length > 0 Then
            Dim parts() As String = cr.Split("|")
            For Each s As String In parts
                Dim criteria() As String = s.Split(",")
                Dim UserID As Integer = Integer.Parse(criteria(0))
                Dim Start As String = criteria(1)
                Dim sEnd As String = criteria(2)
                Dim Mediator As String = ""

                Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
                    cmd.CommandText = "select (firstname + ' ' + lastname) as fullname from tbluser where userid=" & criteria(0)
                    Using cmd.Connection
                        cmd.Connection.Open()
                        Using rd As IDataReader = cmd.ExecuteReader
                            If rd.Read Then
                                Mediator = rd.GetString(0)
                            End If
                        End Using
                    End Using
                End Using

                If Mediator.Length > 0 Then
                    Dim dr As DataRow = dtPlanned.NewRow
                    dr("Start") = Start
                    dr("End") = sEnd
                    dr("FullName") = Mediator
                    dr("UserID") = UserID
                    dtPlanned.Rows.Add(dr)
                End If
            Next
        Else
            Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Report_AccountsOverPercentage_Fulfillment_PlannedGrid")
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dtPlanned)
        End If

        Dim sb As New StringBuilder()
        For i As Integer = 0 To dtPlanned.Rows.Count - 1
            Dim dr As DataRow = dtPlanned.Rows(i)
            Dim disabled1 As String = IIf(i = 0, " disabled=""true"" ", "")
            Dim disabled2 As String = IIf(i = dtPlanned.Rows.Count - 1, " disabled=""true"" ", "")

            Dim value1 As String = ""
            If i = 0 Then
                value1 = " value=""Aa"" "
            ElseIf Not IsDBNull(dr("Start")) Then
                value1 = " value=""" & dr("Start") & """"
            End If

            Dim value2 As String = ""
            If i = dtPlanned.Rows.Count - 1 Then
                value2 = " value=""Zz"" "
            ElseIf Not IsDBNull(dr("End")) Then
                value2 = " value=""" & dr("End") & """"
            End If

            sb.Append("<tr UserID=""" & dr("UserID") & """>")
            sb.Append("<td><input onkeypress=""AllowOnlyLetters(event);"" onblur=""LinkValues(this, 0)"" UserID=""" & dr("UserID") & """ type=""textbox"" maxlength=""2"" style=""width:30px;font-family:tahoma;font-size:11px""" + disabled1 + value1 + "/></td>")
            sb.Append("<td><input onkeypress=""AllowOnlyLetters(event);"" onblur=""LinkValues(this, 1)"" UserID=""" & dr("UserID") & """ type=""textbox"" maxlength=""2"" style=""width:30px;font-family:tahoma;font-size:11px""" + disabled2 + value2 + "/></td>")
            sb.Append("<td>0</td>")
            sb.Append("<td>0</td>")
            sb.Append("<td>$0.00</td>")
            sb.Append("<td UserID=""" & dr("UserID") & """>" & dr("FullName") & "</td>")

            sb.Append("</tr>")
        Next

        ltrGrid.Text = sb.ToString()
    End Sub
#End Region
#Region "Callback"
    Dim CallBackResult As String = ""
    Public Function GetCallbackResult() As String Implements System.Web.UI.ICallbackEventHandler.GetCallbackResult
        Return CallBackResult
    End Function
    Public Sub RaiseCallbackEvent(ByVal eventArgument As String) Implements System.Web.UI.ICallbackEventHandler.RaiseCallbackEvent
        Dim parts As String() = eventArgument.Split(",")
        Dim Reassign As Boolean = Boolean.Parse(parts(2))
        Dim crReassign As String = ""
        If Reassign = False Then crReassign = " assignedmediator is null and "
        Dim crName = "substring(lastname,1,2) >= '" & parts(0) & "' and substring(lastname,1,2) <= '" & parts(1) & "'"

        'Clients
        CallBackResult = dt.Compute("count(clientid)", crReassign & crName).ToString()

        'Creditor accounts
        CallBackResult += "|"
        CallBackResult += IsNull(dt.Compute("sum(accounts)", crReassign & crName), 0).ToString()

        'SDA Balances Sum
        CallBackResult += "|"
        CallBackResult += GetCurrencyString(dt.Compute("sum(sdabalance)", crReassign & crName))

    End Sub
#End Region



End Class
