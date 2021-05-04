Option Explicit On

Imports Drg.Util.DataAccess

Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Partial Class admin_attorneys
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
    Public StatePrime As Boolean
#End Region

#Region "Structures"
    Public Structure Attorney
        Public AttorneyID As Integer
        Public States As String
        Public FirstName As String
        Public MiddleName As String
        Public LastName As String
        Public Suffix As String
        Public Relation As String
        Public Company As String
        Public RelationID As Integer
        Public StatePrimary As Boolean
        Public AttyUserID As Integer
        Public StatePrimaryImg As String

        Public Sub New(ByVal id As Integer, ByVal abbrs As String, ByVal first As String, ByVal middle As String, ByVal last As String, ByVal suf As String, ByVal rel As String, ByVal compName As String, ByVal relID As Integer, ByVal user As Integer, ByVal sPrime As Boolean)
            Me.AttorneyID = id
            Me.States = abbrs
            Me.FirstName = first
            Me.MiddleName = middle
            Me.LastName = last
            Me.Suffix = suf
            Me.Relation = rel
            Me.Company = compName
            Me.RelationID = relID
            Me.StatePrimary = sPrime
            Me.AttyUserID = user
            If sPrime Then
                Me.StatePrimaryImg = "<img alt='' border='0' src='../images/16x16_check.png' />"
            Else
                Me.StatePrimaryImg = "<img alt='' border='0' src='../images/16x16_empty.png' />"
            End If
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = CInt(Page.User.Identity.Name)

        If Not IsPostBack Then
            LoadCompanies()

            If Not Request.QueryString("company") Is Nothing Then
                ddlCompanyMain.SelectedValue = CInt(Request.QueryString("company"))

                GetAttorneys()

                ddlCompanyMain.Items.RemoveAt(ddlCompanyMain.Items.IndexOf(ddlCompanyMain.Items.FindByValue(-1)))
            End If
        End If
    End Sub

    Protected Sub ddlCompanyMain_OnSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCompanyMain.SelectedIndexChanged
        If ddlCompanyMain.SelectedValue > 0 Then
            GetAttorneys()

            If Not ddlCompanyMain.Items.FindByValue(-1) Is Nothing Then
                ddlCompanyMain.Items.RemoveAt(ddlCompanyMain.Items.IndexOf(ddlCompanyMain.Items.FindByValue(-1)))
            End If
        End If
    End Sub

    Protected Sub lnkRemove_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemove.Click
        If hdnAttorney.Value.Length > 0 Then
            RemoveAttorney(CInt(hdnAttorney.Value))
        End If
    End Sub

    Protected Sub lnkUpdatePrimary_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUpdatePrimary.Click
        'A current state primary is already assigned, user selected to assign a new state primary
        UpdateAttyStateStatus(CType(ViewState("AttorneyID"), Integer))
        GetAttorneys()
    End Sub

    Private Sub RemoveAttorney(ByVal id As Integer)
        Using cmd As New SqlCommand("SELECT count(*) FROM tblAttyRelation WHERE AttyPivotID = " + id.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Integer.Parse(cmd.ExecuteScalar()) = 1 Then
                    cmd.CommandText = "DELETE tblAttorney WHERE AttorneyID = (SELECT AttorneyID1 FROM tblAttyRelation WHERE AttyPivotID = " + _
                    id.ToString() + ")"

                    cmd.ExecuteNonQuery()

                    If hdnAttyUserID.Value.Length > 0 Then
                        cmd.CommandText = "DELETE tblUser WHERE UserID = " + hdnAttyUserID.Value

                        cmd.ExecuteNonQuery()
                    End If
                End If

                cmd.CommandText = "DELETE tblAttyRelation WHERE AttyPivotID = " + id.ToString()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Response.Redirect("attorneys.aspx?company=" + ddlCompanyMain.SelectedValue.ToString())
    End Sub

    Private Sub GetAttorneys()
        Dim attorneys As New List(Of Attorney)
        Dim intUserID As Integer

        rptAttorneys.DataSource = Nothing
        rptAttorneys.DataBind()

        Dim cmdStr As String = "SELECT a.LastName, a.AttorneyID, States, a.FirstName, isnull(a.MiddleName, '') as MiddleName, r.AttyPivotID, " + _
        "a.LastName, isnull(a.Suffix, '') as Suffix, isnull(r.AttyRelation, 'NA') as Relation, a.UserID, " + _
        "(SELECT ShortCoName FROM tblCompany WHERE tblCompany.CompanyID = r.CompanyID) as Company, a.StatePrimary FROM tblAttorney as a inner join " + _
        "tblAttyRelation as r on r.AttorneyID1 = a.AttorneyID WHERE r.CompanyID = " + ddlCompanyMain.SelectedValue.ToString() + _
        " ORDER BY States, a.LastName ASC"

        Dim ckValue As Boolean = False
        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        If reader("StatePrimary") Is DBNull.Value Then
                            ckValue = False
                        Else
                            ckValue = CType(reader("StatePrimary"), Boolean)
                        End If
                        If reader("UserID") Is DBNull.Value Then
                            intUserID = 0
                        Else
                            intUserID = CType(reader("UserID"), Integer)
                        End If
                        attorneys.Add(New Attorney(CInt(reader("AttorneyID")), reader("States").ToString(), reader("FirstName").ToString(), reader("MiddleName").ToString(), reader("LastName").ToString(), reader("Suffix").ToString(), reader("Relation").ToString(), StrConv(reader("Company").ToString(), vbProperCase), reader("AttyPivotID").ToString(), intUserID, ckValue))
                    End While
                End Using
            End Using
        End Using

        rptAttorneys.DataSource = attorneys
        rptAttorneys.DataBind()
    End Sub

    Protected Sub lnkAddAttorney_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddAttorney.Click
        AddAttorney()

        GetAttorneys()
    End Sub

    Protected Sub lnkUpdateAttorney_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUpdateAttorney.Click
        UpdateAttorney()

        GetAttorneys()
    End Sub

    Private Sub AddAttorney()

        If LookForAddDups() Then
            Exit Sub 'Do not add attorney, name already exists for the selected state
        End If

        Dim strIsPrimary As String = "0"

        If hdnPrimary.Value.ToLower = "true" Then
            If LookForUpdateDups(True) Then
                'No state primary currently exists for this state, okay to set this attorney
                strIsPrimary = "1"
            End If
        End If

        Using cmd As New SqlCommand("SELECT AttorneyID FROM tblAttorney WHERE FirstName = '" + hdnFirstName.Value + _
        "' and MiddleName " + IIf(hdnMiddleName.Value.Length > 0, "= '" + hdnMiddleName.Value + "'", "is null") + " and LastName = '" + hdnLastName.Value + _
        "' and Suffix " + IIf(hdnSuffix.Value.Length > 0, "= '" + hdnSuffix.Value + "'", "is null") + _
        " and States = '" + hdnStates.Value + "' and CompanyID = " + hdnCompanyID.Value, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Dim AttorneyID As Integer = DataHelper.Nz_int(cmd.ExecuteScalar(), 0)

                If AttorneyID = 0 Then
                    Dim RecordUserID As Integer
                    Dim StateID As Integer = Integer.Parse(DataHelper.FieldLookup("tblState", "StateID", "Abbreviation = '" + hdnStates.Value.SubString(0, IIf(hdnStates.Value.IndexOf(",", 0) > 0, hdnStates.Value.IndexOf(",", 0), hdnStates.Value.Length)) + "'"))

                    cmd.CommandText = "INSERT INTO tblUser (FirstName, LastName, EmailAddress, SuperUser, Locked, Temporary, LastModified, " + _
                    "LastModifiedBy, Created, CreatedBy, UserTypeID, UserGroupID, Password, CommRecID, UserName) VALUES ('" + _
                    hdnFirstName.Value + "', '" + hdnLastName.Value + "', '', 0, 0, 1, getdate(), " + UserID.ToString() + ", getdate(), " + _
                    UserID.ToString() + ", 1, 3, '" + DataHelper.GenerateSHAHash("12345") + "', null, '" + _
                    GetUserName(hdnFirstName.Value, hdnMiddleName.Value, hdnLastName.Value, hdnSuffix.Value) + "') SELECT scope_identity()"

                    RecordUserID = cmd.ExecuteScalar()

                    cmd.CommandText = "INSERT INTO tblAttorney (CompanyID, States, StateID, FirstName, LastName, MiddleName, Suffix, Created, " + _
                    "CreatedBy, LastModified, LastModifiedBy, UserID, StatePrimary) VALUES (" + hdnCompanyID.Value + ", '" + hdnStates.Value + "', " + _
                    StateID.ToString() + ", '" + hdnFirstName.Value + "', '" + hdnLastName.Value + "', " + _
                    IIf(hdnMiddleName.Value.Length > 0, "'" + hdnMiddleName.Value + "'", "null") + ", " + _
                    IIf(hdnSuffix.Value.Length > 0, "'" + hdnSuffix.Value + "'", "null") + ", getdate(), " + UserID.ToString() + _
                    ", getdate(), " + UserID.ToString() + ", " + RecordUserID.ToString() + ", " + strIsPrimary + ") SELECT scope_identity()"

                    AttorneyID = Integer.Parse(cmd.ExecuteScalar())
                End If

                cmd.CommandText = "INSERT INTO tblAttyRelation (AttorneyID1, CompanyID, AttyRelation) VALUES (" + AttorneyID.ToString() + ", " + _
                hdnCompanyID.Value + ", '" + hdnRelations.Value + "')"

                cmd.ExecuteNonQuery()
                Me.ViewState("AttorneyID") = AttorneyID.ToString
            End Using
        End Using
    End Sub

    Private Function GetUserName(ByVal first As String, ByVal middle As String, ByVal last As String, ByVal suffix As String) As String
        Dim userNames As New List(Of String)

        For i As Integer = 1 To first.Length
            userNames.Add(CStr(first.Substring(0, i) + last).ToLower().Replace(" ", ""))
        Next

        If middle.Trim.Length > 0 Then
            userNames.Add(CStr(first + middle.Substring(0, 1) + last).ToLower().Replace(" ", ""))
            userNames.Add(CStr(first + middle.Substring(0, 1) + last + suffix).ToLower().Replace(" ", ""))
        End If
        userNames.Add(CStr(first + middle + last).ToLower().Replace(" ", ""))
        userNames.Add(CStr(first + middle + last + suffix).ToLower().Replace(" ", ""))

        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                For Each name As String In userNames
                    cmd.CommandText = "SELECT count(*) FROM tblUser WHERE UserName = '" + name + "'"

                    If DataHelper.Nz_int(cmd.ExecuteScalar(), 0) = 0 Then
                        Return name
                    End If
                Next

                For i As Integer = 1 To 10000
                    For Each name As String In userNames
                        name += "_" + i.ToString()

                        cmd.CommandText = "SELECT count(*) FROM tblUser WHERE UserName = '" + name + "'"

                        If DataHelper.Nz_int(cmd.ExecuteScalar(), 0) = 0 Then
                            Return name
                        End If
                    Next
                Next
            End Using
        End Using
    End Function

    Private Sub UpdateAttorney()
        Dim AttorneyID As Integer = DataHelper.FieldLookup("tblAttyRelation", "AttorneyID1", "AttyPivotID =" + hdnAttyRelationID.Value)
        Dim strIsPrimary As String = "0"

        If hdnPrimary.Value.ToLower = "true" Then
            If LookForUpdateDups(False) Then
                'No state primary currently exists for this state, okay to set this attorney
                strIsPrimary = "1"
            End If
        End If

        Using cmd As New SqlCommand("UPDATE tblAttyRelation SET CompanyID = " + hdnCompanyID.Value + ", AttyRelation = '" + hdnRelations.Value + "' WHERE AttyPivotID = " + hdnAttyRelationID.Value, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Dim StateID As Integer = Integer.Parse(DataHelper.FieldLookup("tblState", "StateID", "Abbreviation = '" + hdnStates.Value.Substring(0, IIf(hdnStates.Value.IndexOf(",", 0) > 0, hdnStates.Value.IndexOf(",", 0), hdnStates.Value.Length)) + "'"))
                cmd.CommandText = "UPDATE tblAttorney SET CompanyID = " + hdnCompanyID.Value + ", States = '" + hdnStates.Value + "', StateID = " + StateID.ToString() + ", FirstName = '" + hdnFirstName.Value + "', LastName = '" + hdnLastName.Value + "', MiddleName = " + IIf(hdnMiddleName.Value.Length > 0, "'" + hdnMiddleName.Value + "'", "null") + ", Suffix = " + IIf(hdnSuffix.Value.Length > 0, "'" + hdnSuffix.Value + "'", "null") + ", LastModified = getdate(), LastModifiedBy = " + UserID.ToString() + ", StatePrimary = " + strIsPrimary & " WHERE AttorneyID = " + hdnAttorneyID.Value
                cmd.ExecuteNonQuery()
                Me.ViewState("AttorneyID") = hdnAttorneyID.Value
            End Using
        End Using
    End Sub

    Private Sub LoadCompanies()
        ddlCompanyMain.Items.Add(New ListItem("Please Select", -1))

        Using cmd As New SqlCommand("SELECT CompanyID, ShortCoName FROM tblCompany ORDER BY ShortCoName ASC", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlCompanyMain.Items.Add(New ListItem(StrConv(reader("ShortCoName").ToString(), vbProperCase), CInt(reader("CompanyID"))))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Function LookForAddDups() As Boolean
        Dim x As SqlDataReader
        Dim AttyID As Integer = 0
        Dim AttyID2 As Integer = 0
        Dim PrimeExists As String = "True"
        Dim Answer As Long = 0

        'Check for plane old duplicates
        Using cmd As New SqlCommand("SELECT AttorneyID FROM tblAttorney WHERE States LIKE '%" + hdnStates.Value.ToString + "%' AND CompanyID = " + hdnCompanyID.Value + " AND FirstName = '" + hdnFirstName.Value + "' AND LastName = '" + hdnLastName.Value + "'", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                x = cmd.ExecuteReader
                If x.HasRows Then 'we are trying to enter a duplicate attorney
                    'do something and show the duplicate
                    x.Read()
                    Me.ClientScript.RegisterClientScriptBlock(Me.GetType, "OpenDialog", "showModalDialog('" & Me.ResolveUrl("~/util/pop/messageholder.aspx") & "?t=Duplicate Attorney&m=This attorney is a duplication of an existing attorney for this state. So it will not be added.', window, 'status:off;help:off;dialogWidth:325px;dialogHeight:175px;');", True)
                    x.Close()
                    Return True
                Else
                    x.Close()
                    Return False
                End If
            End Using
        End Using

    End Function

    Private Function LookForUpdateDups(ByVal Adding As Boolean) As Boolean
        Dim x As SqlDataReader
        Dim PrimeExists As String = "True"

        'First check for State Primary duplicates
        Using cmd As New SqlCommand("SELECT AttorneyID,  FirstName, LastName FROM tblAttorney WHERE States LIKE '%" + hdnStates.Value.ToString + "%' AND CompanyID = " + hdnCompanyID.Value + " AND StatePrimary = '" + PrimeExists + "'" & IIf(Adding, "", " AND AttorneyID <> " & hdnAttorneyID.Value), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                x = cmd.ExecuteReader
                If x.HasRows Then 'we will have more than one primary for this state
                    'do something and show the duplicate
                    Dim sb As New System.Text.StringBuilder

                    x.Read()
                    sb.Append("<script> " & vbCrLf)
                    sb.Append("function CallUpdatePrimary() { " & vbCrLf)
                    sb.Append(ClientScript.GetPostBackEventReference(lnkUpdatePrimary, "Click") & "; " & vbCrLf)
                    sb.Append("return false; } " & vbCrLf)
                    sb.Append("</script>")
                    Me.ClientScript.RegisterClientScriptBlock(Me.GetType, "CallUpdatePrimary", sb.ToString)
                    Me.ClientScript.RegisterClientScriptBlock(Me.GetType, "OpenDialog", "showModalDialog('" & Me.ResolveUrl("~/util/pop/confirmholder.aspx") & "?f=CallUpdatePrimary&t=Replace State Primary&m=Currently there is a State Primay attorney for this state. It is: " & x.Item("FirstName").ToString & " " & x.Item("LastName").ToString & ". Would you like to replace this attorney as the State Primary with your new one?', window, 'status:off;help:off;dialogWidth:325px;dialogHeight:175px;');", True)
                    x.Close()
                    Return False 'Set state primary to 0 initially
                End If
                Return True
            End Using
        End Using
    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Private Sub UpdateAttyStateStatus(ByVal AttyID As Integer)
        Dim sbSQL As New System.Text.StringBuilder

        With sbSQL
            .Append("declare @StateID int " & vbCrLf)
            .Append("select @StateID = StateID from tblAttorney where AttorneyID = " & AttyID.ToString & " " & vbCrLf)
            .Append("update tblAttorney SET LastModified = getdate(), LastModifiedBy = " & UserID.ToString & ", StatePrimary = 0 WHERE StatePrimary = 1 AND StateID = @StateID AND AttorneyID <> " & AttyID.ToString & " " & vbCrLf)
            .Append("update tblAttorney SET StatePrimary = 1 where AttorneyID = " & AttyID.ToString)
        End With

        Using cmd As New SqlCommand(sbSQL.ToString, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Sub ddlCompanyMain_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCompanyMain.TextChanged

    End Sub
End Class
