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

Partial Class mediatorassignment
    Inherits System.Web.UI.Page
    Implements System.Web.UI.ICallbackEventHandler

    Private Const PageSize As Integer = 20
    Protected dt As New DataTable

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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Requery()
        LoadPlannedGrid()
        SetAttributes()
        If Not IsPostBack And Not IsCallback Then
            Setting("MediatorTable") = Nothing
        End If
    End Sub
    Private Sub SetAttributes()
        opEqualize.Attributes("childControls") = chkDontReassign.ClientID + "," + opSmallestFirst.ClientID + "," + opEvenly.ClientID
    End Sub

    Private Sub LoadPlannedGrid()
        Dim sb As New StringBuilder()

        Dim dtPlanned As New DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Report_AccountsOverPercentage_Fulfillment_PlannedGrid")
        Dim da As New SqlDataAdapter(cmd)
        da.Fill(dtPlanned)

        For Each dr As DataRow In dtPlanned.Rows
            sb.Append("<tr UserID=""" & dr("UserID") & """>")
            sb.Append("<td><input type=""checkbox"" checked/></td><td><input type=""checkbox"" checked/></td>")
            sb.Append("<td>" & dr("FullName") & "</td>")
            sb.Append("<td>" & dr("Has") & "</td>")
            sb.Append("<td style=""width:5;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-repeat:repeat-y;background-position:right top;""><img width=""1"" height=""1"" src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" /></td>")
            sb.Append("<td></td>")
            sb.Append("<td></td>")
            sb.Append("<td></td>")
            sb.Append("</tr>")
        Next

        ltrPlannedGrid.Text = sb.ToString()
    End Sub
    Private Sub Requery()

        Dim strIds As String = Request.QueryString("clientids")
        If Not String.IsNullOrEmpty(strIds) Then
            Dim cmdtxt As String = "select clientid,assignedmediator from tblclient where clientid in (" & strIds & ")"
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = cmdtxt
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        Else
            Dim cmd As IDbCommand = CommandHelper.DeepClone(CType(Setting("cmd"), IDbCommand))
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End If

    End Sub

    Dim CallBackResult As String = ""
    Public Function GetCallbackResult() As String Implements System.Web.UI.ICallbackEventHandler.GetCallbackResult
        Return CallBackResult
    End Function

    Public Function GetMediatorTable() As DataTable
        Dim drs() As DataRow = dt.Select("not assignedmediator is null")
        Dim SelectedClientIDs As String = ""
        For Each dr As DataRow In drs
            If SelectedClientIDs.Length > 0 Then SelectedClientIDs += ","
            SelectedClientIDs += dr("ClientID").ToString
        Next

        Dim dtPlanned As New DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Report_AccountsOverPercentage_Fulfillment_PlannedGrid")
        If SelectedClientIDs.Length > 0 Then DatabaseHelper.AddParameter(cmd, "SelectedClientIDs", SelectedClientIDs)
        Dim da As New SqlDataAdapter(cmd)
        da.Fill(dtPlanned)
        dtPlanned.Columns.Add("Add", GetType(Boolean))
        dtPlanned.Columns.Add("Remove", GetType(Boolean))
        dtPlanned.Columns.Add("Added", GetType(Integer))
        dtPlanned.Columns.Add("Removed", GetType(Integer))
        dtPlanned.Columns.Add("Final", GetType(Integer))

        For Each dr As DataRow In dtPlanned.Rows
            dr("Added") = 0
            dr("Removed") = 0
            dr("Final") = 0
        Next

        Return dtPlanned
    End Function
    Public Sub SetCriteria(ByVal eventArgument As String, ByRef Method As Integer, ByRef NoReassign As Boolean, ByRef NoReassignMethod As Integer, ByRef dtMediators As DataTable)
        Dim args() As String = eventArgument.Split("|")
        Dim MainCriteria() As String = args(0).Split(",")
        Dim MediatorCriteria() As String = args(1).Split(",")

        'Get main criteria
        Method = Integer.Parse(MainCriteria(0))
        If Method = 0 Then 'equalize
            NoReassign = Boolean.Parse(MainCriteria(1))
            If NoReassign Then
                NoReassignMethod = Integer.Parse(MainCriteria(2))
            End If
        End If

        'Setup the add/remove criteria in the data table
        For i As Integer = 0 To MediatorCriteria.Length - 1 Step 3
            Dim UserID As String = MediatorCriteria(i)
            Dim Add As Boolean = Boolean.Parse(MediatorCriteria(i + 1))
            Dim Remove As Boolean = Boolean.Parse(MediatorCriteria(i + 2))

            Dim dr As DataRow = dtMediators.Select("userid=" & UserID)(0)
            dr("Add") = Add
            dr("Remove") = Remove
            dr("Added") = 0
            dr("Removed") = 0
        Next
    End Sub
    Public Sub Increment(ByVal Mediators() As DataRow, ByVal NumToAssign As Integer)
        Dim NumMediators As Integer = Mediators.Length

        If NumMediators > 0 Then
            Dim EachGets As Integer = NumToAssign \ NumMediators
            Dim Leftovers As Integer = NumToAssign Mod NumMediators

            Increment(Mediators, EachGets, Leftovers)
        End If
    End Sub
    Public Sub Increment(ByVal Mediators() As DataRow, ByVal EachGets As Integer, ByVal LeftOvers As Integer)
        For i As Integer = 0 To Mediators.Length - 1
            Dim dr As DataRow = Mediators(i)
            If dr("Added") Is Nothing Or IsDBNull(dr("Added")) Then dr("Added") = 0
            dr("Added") = EachGets
            If i < LeftOvers Then dr("Added") += 1
        Next
    End Sub
    Public Sub RaiseCallbackEvent(ByVal eventArgument As String) Implements System.Web.UI.ICallbackEventHandler.RaiseCallbackEvent
        Dim sb As New StringBuilder

        Dim dtMediators As DataTable = GetMediatorTable()

        'user-defined criteria
        Dim Method As Integer
        Dim NoReassign As Boolean
        Dim NoReassignMethod As Integer

        SetCriteria(eventArgument, Method, NoReassign, NoReassignMethod, dtMediators)

        'calculate adds/removes
        If Method = 1 Then 'increment
            Increment(dtMediators.Select("add=1"), dt.Select("assignedmediator is null").Length)
        ElseIf Method = 0 Then 'equalize
            'first, assign the new ones
            Dim NumUnassigned As Integer = dt.Select("assignedmediator is null").Length

            If Not NoReassign Or NoReassignMethod = 0 Then
                'perform the 'assign to smallest first' method
                For i As Integer = 1 To NumUnassigned
                    'find smallest mediator, and assign one to him
                    Dim dr As DataRow = dtMediators.Select("add=1", "has asc")(0)
                    dr("Added") += 1
                    dr("Has") += 1
                Next
            ElseIf NoReassignMethod = 1 Then
                'perform the 'add evenly to all but largest' method
                While NumUnassigned > 0
                    Dim Largest As Integer = dtMediators.Select("add=1", "has desc")(0)("has")
                    Dim OtherRows As DataRow() = dtMediators.Select("add=1 and has<" & Largest)
                    If OtherRows.Length = 0 Then OtherRows = dtMediators.Select("add=1")
                    If OtherRows.Length > 0 Then
                        'add 1 to each of these
                        For Each dr As DataRow In OtherRows
                            If NumUnassigned > 0 Then
                                dr("has") += 1
                                dr("added") += 1
                                NumUnassigned -= 1
                            End If
                        Next
                    End If
                End While
            End If

            'second, reassign to continue equalizing
            If Not NoReassign Then
                Dim Largest As Integer = dtMediators.Select("remove=1", "has desc")(0)("has")
                Dim Smallest As Integer = dtMediators.Select("add=1", "has asc")(0)("has")
                While Largest - Smallest > 1
                    'find smallest and largest mediator
                    Dim drLargest As DataRow = dtMediators.Select("remove=1", "has desc")(0)
                    Dim drSmallest As DataRow = dtMediators.Select("add=1", "has asc")(0)

                    'remove from largest and add to smallest
                    drSmallest("Added") += 1
                    drSmallest("Has") += 1

                    drLargest("Removed") += 1
                    drLargest("Has") -= 1

                    Largest = dtMediators.Select("remove=1", "has desc")(0)("has")
                    Smallest = dtMediators.Select("add=1", "has asc")(0)("has")
                End While
            End If
        End If

        Setting("MediatorTable") = dtMediators

        'Output definition:  userid|Added|Removed|userid|Added|Removed...
        For Each dr As DataRow In dtMediators.Rows
            If Not sb.Length = 0 Then sb.Append("|")
            sb.Append(dr("userid"))
            sb.Append("|")
            sb.Append(dr("Added"))
            sb.Append("|")
            sb.Append(dr("Removed"))
        Next

        CallBackResult = sb.ToString
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
        If WorkingIDs.Length > 1000 Then SelectedClientIDs.Add(WorkingIDs)

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

    Protected Sub lnkSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSubmit.Click

        Dim Mediators As DataTable = CType(Setting("MediatorTable"), DataTable)
        If Not Mediators Is Nothing Then
            Dim updates As New DataTable
            updates.Columns.Add("ClientID")
            updates.Columns.Add("UserID")

            'add the new rows to the assignment pool
            For Each r As DataRow In dt.Select("assignedmediator is null")
                Dim dr As DataRow = updates.NewRow
                dr("ClientID") = r("ClientID")
                updates.Rows.Add(dr)
            Next

            'add any reassignments to the assignment pool
            For Each r As DataRow In Mediators.Rows
                Dim Removed As Integer = r("Removed")
                If Removed > 0 Then
                    'add this amount of his clients to the assignment pool
                    Dim UserID As Integer = r("UserID")
                    Dim UsersRows() As DataRow = dt.Select("assignedmediator=" & UserID)
                    For i As Integer = 0 To Removed - 1
                        Dim dr As DataRow = updates.NewRow
                        dr("ClientID") = UsersRows(i)("ClientID")
                        updates.Rows.Add(dr)
                    Next
                End If
            Next


            Dim Commands As New List(Of String)

            'match UserIDs to all the client ids in the assignment pool
            Dim UpdateIndex As Integer = 0
            For Each r As DataRow In Mediators.Rows
                Dim Added As Integer = r("Added")
                If Added > 0 Then
                    Dim sb As New StringBuilder
                    sb.Append("update tblclient set assignedmediator=" & r("userid") & " where clientid in (")
                    For i As Integer = 1 To Added
                        If i > 1 Then sb.Append(",")
                        sb.Append(updates.Rows(UpdateIndex)("ClientID"))

                        updates.Rows(UpdateIndex)("UserID") = r("UserID")
                        UpdateIndex += 1
                    Next
                    sb.Append(")")
                    Commands.Add(sb.ToString())
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
        End If
    End Sub




End Class
