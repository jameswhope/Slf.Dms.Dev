Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Slf.Dms.Records
Imports Slf.Dms.Controls
Imports AssistedSolutions.WebControls
Imports System.Data
Imports System.IO
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports LocalHelper
Imports MCN.WebControls


Partial Class research_queries_financial_servicefees_allmatters
    Inherits PermissionPage

#Region "Variables"

    Public Const PageSize As Integer = 20
    Private reset As Boolean = False
    Private UserID As Integer
    Private qs As QueryStringCollection
    Private strSortExp As String = String.Empty
    Private strSortDir As String = String.Empty

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            LoadClients()
            LoadLocalCounsel()
            LoadMatterStatusCodes()
            LoadLocalCounselStates()
            LoadLocalCounselCity()

            If Not IsPostBack Then
                Session("Exp1") = String.Empty
                Session("Exp2") = String.Empty
                Session("Exp3") = String.Empty
                Session("Exp4") = String.Empty
                Session("Exp5") = String.Empty
                Session("Exp6") = String.Empty
                LoadValues(GetControls(), Me)
                Requery(False)
            End If

        End If
    End Sub

    Protected Sub lnkShowFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowFilter.Click
        If lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        Else 'is NOT selected

            'just delete the settings  - which will select on refresh
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name _
                & "' AND [Object] IN ('tdFilter', 'lnkShowFilter')")

        End If
        Refresh()
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        'insert settings to table
        'Save()
        Requery(True)
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        'blow away all settings in table
        Session("Exp1") = String.Empty
        Session("Exp2") = String.Empty
        Session("Exp3") = String.Empty
        Session("Exp4") = String.Empty
        Session("Exp5") = String.Empty
        Session("Exp6") = String.Empty

        Clear()
        ' grdResults.Reset(True)
        'reload page
        Refresh()
        'Requery(True)
    End Sub

    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optClientChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optClientChoice.ID, "value", _
                optClientChoice.SelectedValue)
        End If

        'If optFeeTypeChoice.SelectedValue = 0 Then
        '    QuerySettingHelper.Insert(Me.GetType().Name, UserID, optFeeTypeChoice.ID, "value", _
        '        optFeeTypeChoice.SelectedValue)
        'End If

        If optAttorneyChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optAttorneyChoice.ID, "value", _
                optAttorneyChoice.SelectedValue)
        End If

        If optMatterStatus.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optMatterStatus.ID, "value", _
                optMatterStatus.SelectedValue)
        End If

        If optLCState.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optLCState.ID, "value", _
                optLCState.SelectedValue)
        End If

        If optLCCity.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optLCCity.ID, "value", _
                optLCCity.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csClientID.ID, "store", csClientID.SelectedStr)

        'QuerySettingHelper.Insert(Me.GetType().Name, UserID, csEntryTypeID.ID, "store", csEntryTypeID.SelectedStr)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csAttorneyID.ID, "store", csAttorneyID.SelectedStr)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csMatterStatus.ID, "store", csMatterStatus.SelectedStr)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csLCState.ID, "store", csLCState.SelectedStr)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csLCCity.ID, "store", csLCCity.SelectedStr)

        If txtMatterDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtMatterDate1.ID, "value", _
                txtMatterDate1.Text)
        End If

        If txtMatterDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtMatterDate2.ID, "value", _
                txtMatterDate2.Text)
        End If
    End Sub

    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If Not lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        End If
    End Sub

#End Region
#Region "Util"

    Private Sub LoadClients()

        csClientID.Items.Clear()
        csClientID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT distinct tblClient.ClientId, tblPerson.FirstName, tblPerson.LastName FROM tblClient INNER JOIN tblPerson ON tblPerson.PersonId=tblClient.PrimaryPersonId ORDER BY tblPerson.LastName"
                cmd.CommandText = "SELECT distinct tblClient.ClientId,tblPerson.ClientId as[PersonClientId],tblPerson.FirstName, tblPerson.LastName FROM dbo.tblClient INNER JOIN dbo.tblPerson ON tblPerson.PersonId=tblClient.PrimaryPersonId INNER JOIN dbo.tblMatter on dbo.tblMatter.ClientId=tblclient.ClientId WHERE dbo.tblMatter.IsDeleted=0 ORDER BY tblPerson.FirstName"

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim ClientID As Integer = DatabaseHelper.Peel_int(rd, "ClientID")
                        Dim FirstName As String = DatabaseHelper.Peel_string(rd, "FirstName")
                        Dim LastName As String = DatabaseHelper.Peel_string(rd, "LastName")

                        csClientID.AddItem(New ListItem(FirstName & ", " & LastName, ClientID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csClientID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csClientID.ID + "'")
        End If
    End Sub

    Private Sub LoadMatterStatusCodes()
        csMatterStatus.Items.Clear()
        csMatterStatus.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblMatterStatus"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "MatterStatusId")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "MatterStatus")

                        csMatterStatus.AddItem(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csMatterStatus.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csMatterStatus.ID + "'")
        End If
    End Sub

    Private Sub LoadLocalCounsel()
        csAttorneyID.Items.Clear()
        csAttorneyID.AddItem(New ListItem(" -- Select --", 0))
        csAttorneyID.AddItem(New ListItem("--NONE--", 99999))
        csAttorneyID.AddItem(New ListItem("--TBD--", 99998))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT A.AttorneyID, A.FirstName, A.LastName FROM tblAttorney A, tblMatter M Where A.AttorneyID=M.AttorneyID order by FirstName"
                cmd.CommandText = "SELECT distinct A.AttorneyID, A.FirstName, A.LastName FROM tblAttorney A order by A.FirstName"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "AttorneyID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName")

                        csAttorneyID.AddItem(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csAttorneyID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csAttorneyID.ID + "'")
        End If
    End Sub

    Private Sub LoadLocalCounselStates()
        csLCState.Items.Clear()
        csLCState.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT Distinct S.StateID, S.Name FROM tblAttorney A, tblMatter M, tblState S Where M.AttorneyID=A.AttorneyID and A.State=S.Name order by S.Name"
                cmd.CommandText = "SELECT Distinct S.StateID, S.Name FROM tblState S Order by S.Name"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As String = DatabaseHelper.Peel_int(rd, "StateID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")

                        csLCState.AddItem(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csLCState.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csLCState.ID + "'")
        End If
    End Sub

    Private Sub LoadLocalCounselCity()
        csLCCity.Items.Clear()
        csLCCity.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT Distinct A.City FROM tblAttorney A, tblMatter M Where A.AttorneyID=M.AttorneyID order by A.City"
                cmd.CommandText = "SELECT Distinct A.City FROM tblAttorney A Order by A.City"
                cmd.Connection.Open()
                Dim intI As Integer = 0
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        intI = intI + 1
                        Dim EntryTypeID As Integer = intI 'DatabaseHelper.Peel_int(rd, "AttorneyID")
                        'Dim EntryTypeID As String = DatabaseHelper.Peel_string(rd, "City")

                        Dim Name As String = DatabaseHelper.Peel_string(rd, "City")

                        csLCCity.AddItem(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csLCCity.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csLCCity.ID + "'")
        End If
    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        'c.Add(optFeeTypeChoice.ID, optFeeTypeChoice)
        c.Add(optClientChoice.ID, optClientChoice)
        c.Add(optAttorneyChoice.ID, optAttorneyChoice)
        c.Add(optMatterStatus.ID, optMatterStatus)
        c.Add(optLCState.ID, optLCState)
        c.Add(optLCCity.ID, optLCCity)
        c.Add(txtMatterDate1.ID, txtMatterDate1)
        c.Add(txtMatterDate2.ID, txtMatterDate2)
        'c.Add(txtTransDate1.ID, txtTransDate1)
        'c.Add(txtTransDate2.ID, txtTransDate2)
        'c.Add(txtHireDate1.ID, txtHireDate1)
        'c.Add(txtHireDate2.ID, txtHireDate2)
        'c.Add(txtAmount1.ID, txtAmount1)
        'c.Add(txtAmount2.ID, txtAmount2)
        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)
        Return c
    End Function

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
#End Region

#Region "Query"
    Private Function GetData() As DataView
        ''Setup the DataCommand
        'cmd.CommandTimeout = 180
        Dim ds As New DataSet
        If IsNothing(Session("Matter_Report")) Then
            Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_MatterReport")
            Dim sqlDA As New SqlDataAdapter(cmd)
            sqlDA.Fill(ds)
        Else
            ds = CType(Session("Matter_Report"), DataSet)
        End If

        Dim dv As DataView = ds.Tables(0).DefaultView

        Dim strExp1 As String = String.Empty
        Dim itemCount As Int32 = 0
        If optAttorneyChoice.Items(0).Selected Then
            For itemCount = 0 To csAttorneyID.SelectedList.Count - 1
                If strExp1 = String.Empty Then
                    If csAttorneyID.SelectedList.Item(itemCount) = 99999 Then
                        strExp1 = " AttorneyId IS NOT NULL "
                    ElseIf csAttorneyID.SelectedList.Item(itemCount) = 99998 Then
                        strExp1 = " AttorneyId <> 0 "
                    Else
                        strExp1 = " AttorneyId <> " & csAttorneyID.SelectedList.Item(itemCount)
                    End If
                    'strExp1 = " AttorneyId <> " & csAttorneyID.SelectedList.Item(itemCount)
                Else
                    If csAttorneyID.SelectedList.Item(itemCount) = 99999 Then
                        strExp1 = strExp1 & " and  AttorneyId IS NOT NULL "
                    ElseIf csAttorneyID.SelectedList.Item(itemCount) = 99998 Then
                        strExp1 = strExp1 & " and  AttorneyId <> 0 "
                    Else
                        strExp1 = strExp1 & " and  AttorneyId <> " & csAttorneyID.SelectedList.Item(itemCount)
                    End If
                    'strExp1 = strExp1 & " and  AttorneyId = " & csAttorneyID.SelectedList.Item(itemCount)
                End If
            Next itemCount
        ElseIf optAttorneyChoice.Items(1).Selected Then
            For itemCount = 0 To csAttorneyID.SelectedList.Count - 1
                If strExp1 = String.Empty Then
                    If csAttorneyID.SelectedList.Item(itemCount) = 99999 Then
                        strExp1 = " AttorneyId IS NULL "
                    ElseIf csAttorneyID.SelectedList.Item(itemCount) = 99998 Then
                        strExp1 = " AttorneyId = 0 "
                    Else
                        strExp1 = " AttorneyId = " & csAttorneyID.SelectedList.Item(itemCount)
                    End If
                    'strExp1 = " AttorneyId = " & csAttorneyID.SelectedList.Item(itemCount)
                Else
                    If csAttorneyID.SelectedList.Item(itemCount) = 99999 Then
                        strExp1 = strExp1 & " or  AttorneyId IS NULL "
                    ElseIf csAttorneyID.SelectedList.Item(itemCount) = 99998 Then
                        strExp1 = strExp1 & " or  AttorneyId = 0 "
                    Else
                        strExp1 = strExp1 & " or  AttorneyId = " & csAttorneyID.SelectedList.Item(itemCount)
                    End If
                    'strExp1 = strExp1 & " or  AttorneyId = " & csAttorneyID.SelectedList.Item(itemCount)
                End If
            Next itemCount
        End If
        If strExp1 <> String.Empty Then
            'ss dv.RowFilter = strExp1
            Session("Exp1") = strExp1
        Else
            Session("Exp1") = String.Empty
        End If


        Dim strExp2 As String = String.Empty
        itemCount = 0
        If optLCState.Items(0).Selected Then
            For itemCount = 0 To csLCState.SelectedList.Count - 1
                If strExp2 = String.Empty Then
                    strExp2 = " PersonStateId <> '" & csLCState.SelectedList.Item(itemCount) & "'"
                Else
                    strExp2 = strExp2 & " and  PersonStateId = '" & csLCState.SelectedList.Item(itemCount) & "'"
                End If
            Next itemCount
        ElseIf optLCState.Items(1).Selected Then
            For itemCount = 0 To csLCState.SelectedList.Count - 1
                If strExp2 = String.Empty Then
                    strExp2 = " PersonStateId = '" & csLCState.SelectedList.Item(itemCount) & "'"
                Else
                    strExp2 = strExp2 & " or  PersonStateId = '" & csLCState.SelectedList.Item(itemCount) & "'"
                End If
            Next itemCount
        End If
        If strExp2 <> String.Empty Then
            'dv.RowFilter = strExp2
            Session("Exp2") = strExp2
        Else
            Session("Exp2") = String.Empty
        End If


        Dim strExp3 As String = String.Empty
        itemCount = 0
        If optMatterStatus.Items(0).Selected Then
            For itemCount = 0 To csMatterStatus.SelectedList.Count - 1
                If strExp3 = String.Empty Then
                    strExp3 = " MatterStatusId <> '" & csMatterStatus.SelectedList.Item(itemCount) & "'"
                Else
                    strExp3 = strExp3 & " and  MatterStatusId = '" & csMatterStatus.SelectedList.Item(itemCount) & "'"
                End If
            Next itemCount
        ElseIf optMatterStatus.Items(1).Selected Then
            For itemCount = 0 To csMatterStatus.SelectedList.Count - 1
                If strExp3 = String.Empty Then
                    strExp3 = " MatterStatusId = '" & csMatterStatus.SelectedList.Item(itemCount) & "'"
                Else
                    strExp3 = strExp3 & " or  MatterStatusId = '" & csMatterStatus.SelectedList.Item(itemCount) & "'"
                End If
            Next itemCount
        End If
        If strExp3 <> String.Empty Then
            'dv.RowFilter = strExp3
            Session("Exp3") = strExp3
        Else
            Session("Exp3") = String.Empty
        End If



        Dim strExp4 As String = String.Empty
        itemCount = 0
        If optClientChoice.Items(0).Selected Then
            For itemCount = 0 To csClientID.SelectedList.Count - 1
                If strExp4 = String.Empty Then
                    strExp4 = " ClientId <> '" & csClientID.SelectedList.Item(itemCount) & "'"
                Else
                    strExp4 = strExp4 & " and  ClientId = '" & csClientID.SelectedList.Item(itemCount) & "'"
                End If
            Next itemCount
        ElseIf optClientChoice.Items(1).Selected Then
            For itemCount = 0 To csClientID.SelectedList.Count - 1
                If strExp4 = String.Empty Then
                    strExp4 = " ClientId = '" & csClientID.SelectedList.Item(itemCount) & "'"
                Else
                    strExp4 = strExp4 & " or  ClientId = '" & csClientID.SelectedList.Item(itemCount) & "'"
                End If
            Next itemCount
        End If
        If strExp4 <> String.Empty Then
            'dv.RowFilter = strExp4
            Session("Exp4") = strExp4
        Else
            Session("Exp4") = String.Empty
        End If

        Dim strExp5 As String = String.Empty
        itemCount = 0
        If optLCCity.Items(0).Selected Then
            For itemCount = 0 To csLCCity.SelectedList.Count - 1
                Dim strOptionText As String = String.Empty
                Dim iOptionCount As Int32 = 0
                For iOptionCount = 0 To csLCCity.Items.Count - 1
                    If csLCCity.Items(iOptionCount).Value = csLCCity.SelectedList.Item(itemCount) Then
                        strOptionText = csLCCity.Items(iOptionCount).Text
                        Exit For
                    End If
                Next iOptionCount

                If strExp5 = String.Empty Then
                    strExp5 = " City <> '" & strOptionText & "'"
                Else
                    strExp5 = strExp5 & " and  City = '" & strOptionText & "'"
                End If
            Next itemCount
        ElseIf optLCCity.Items(1).Selected Then
            For itemCount = 0 To csLCCity.SelectedList.Count - 1
                Dim strOptionText As String = String.Empty
                Dim iOptionCount As Int32 = 0
                For iOptionCount = 0 To csLCCity.Items.Count - 1
                    If csLCCity.Items(iOptionCount).Value = csLCCity.SelectedList.Item(itemCount) Then
                        strOptionText = csLCCity.Items(iOptionCount).Text
                        Exit For
                    End If
                Next iOptionCount

                If strExp5 = String.Empty Then
                    strExp5 = " City = '" & strOptionText & "'"
                Else
                    strExp5 = strExp5 & " or  City = '" & strOptionText & "'"
                End If
            Next itemCount
        End If
        If strExp5 <> String.Empty Then
            'dv.RowFilter = strExp5
            Session("Exp5") = strExp5
        Else
            Session("Exp5") = String.Empty
        End If
        Dim strExp6 As String = String.Empty
        If txtMatterDate1.Text <> "" And txtMatterDate2.Text <> "" Then
            'strExp = "matterdate BETWEEN  '" & txtMatterDate1.Text & "' AND '" & txtMatterDate2.Text & "' "
            strExp6 = "matterdate >=  '" & txtMatterDate1.Text & "' AND matterdate <='" & txtMatterDate2.Text & "' "

        ElseIf txtMatterDate1.Text <> "" Then
            strExp6 = "matterdate >= '" & txtMatterDate1.Text & "'"
        ElseIf txtMatterDate2.Text <> "" Then
            strExp6 = "matterdate <= '" & txtMatterDate2.Text & "'"
        End If
        If strExp6 <> String.Empty Then
            'dv.RowFilter = strExp6
            Session("Exp6") = strExp6
        Else
            Session("Exp6") = String.Empty
        End If


        Dim strExp As String = String.Empty
        If strExp1 <> String.Empty Then
            strExp = " ( " & strExp1 & " ) "
        End If
        If strExp2 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp2 & " ) "
        End If

        If strExp3 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp3 & " ) "
        End If
        If strExp4 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp4 & " ) "
        End If
        If strExp5 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp5 & " ) "
        End If
        If strExp6 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp6 & " ) "
        End If

        If strExp <> String.Empty Then
            dv.RowFilter = strExp
        End If

        If Not IsNothing(ViewState("strSortExp")) Then
            strSortExp = ViewState("strSortExp")
        End If
        If Not IsNothing(ViewState("strSortDir")) Then
            strSortDir = ViewState("strSortDir")
        End If
        If strSortExp <> "" Then
            dv.Sort = strSortExp & IIf(strSortDir = "0", " asc", " desc")
        End If
        Return dv
    End Function

    Private Sub Requery(ByVal Reset As Boolean)
        If Reset = True Then
            gvResults.PageIndex = 0
            gvResults.DataSource = GetData()
            'requery build query process
        Else
            ''get the conditions from session and build the command
            'Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_MatterReport")
            ''cmd.CommandTimeout = 180
            'Dim ds As New DataSet
            'Dim sqlDA As New SqlDataAdapter(cmd)
            'sqlDA.Fill(ds)
            Dim ds As New DataSet
            If IsNothing(Session("Matter_Report")) Then
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_MatterReport")
                Dim sqlDA As New SqlDataAdapter(cmd)
                sqlDA.Fill(ds)
            Else
                ds = CType(Session("Matter_Report"), DataSet)
            End If

            Dim dv As DataView = ds.Tables(0).DefaultView
            Dim strExp1 As String = String.Empty
            If Not IsNothing(Session("Exp1")) Then
                strExp1 = Session("Exp1").ToString()
                ' If strExp <> String.Empty Then dv.RowFilter = strExp
            End If
            Dim strExp2 As String = String.Empty
            If Not IsNothing(Session("Exp2")) Then
                strExp2 = Session("Exp2").ToString()
                ' If strExp <> String.Empty Then dv.RowFilter = strExp
            End If
            Dim strExp3 As String = String.Empty
            If Not IsNothing(Session("Exp3")) Then
                strExp3 = Session("Exp3").ToString()
                ' If strExp <> String.Empty Then dv.RowFilter = strExp
            End If
            Dim strExp4 As String = String.Empty
            If Not IsNothing(Session("Exp4")) Then
                strExp4 = Session("Exp4").ToString()
                'If strExp <> String.Empty Then dv.RowFilter = strExp
            End If
            Dim strExp5 As String = String.Empty
            If Not IsNothing(Session("Exp5")) Then
                strExp5 = Session("Exp5").ToString()
                ' If strExp <> String.Empty Then dv.RowFilter = strExp
            End If
            Dim strExp6 As String = String.Empty
            If Not IsNothing(Session("Exp6")) Then
                strExp6 = Session("Exp6").ToString()
                'If strExp <> String.Empty Then dv.RowFilter = strExp
            End If

            Dim strExp As String = String.Empty
            If strExp1 <> String.Empty Then
                strExp = " ( " & strExp1 & " ) "
            End If
            If strExp2 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp2 & " ) "
            End If

            If strExp3 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp3 & " ) "
            End If
            If strExp4 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp4 & " ) "
            End If
            If strExp5 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp5 & " ) "
            End If
            If strExp6 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp6 & " ) "
            End If

            If strExp <> String.Empty Then
                dv.RowFilter = strExp
            End If

            If Not IsNothing(ViewState("strSortExp")) Then
                strSortExp = ViewState("strSortExp")
            End If
            If Not IsNothing(ViewState("strSortDir")) Then
                strSortDir = ViewState("strSortDir")
            End If
            If strSortExp <> "" Then
                dv.Sort = strSortExp & IIf(strSortDir = "0", " asc", " desc")
            End If
            gvResults.DataSource = dv
        End If
        gvResults.DataBind()
        If gvResults.Rows.Count = 0 Then
            pnlNoTasks.Visible = True ' Not (gvResults.Rows.Count > 0)
        Else
            pnlNoTasks.Visible = False ' Not (gvResults.Rows.Count > 0)

        End If
    End Sub

    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        'If txtMatterDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtMatterDate1.Text))
        'If txtMatterDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtMatterDate2.Text))
        DatabaseHelper.AddParameter(cmd, "Where", GetCriteria())
        DatabaseHelper.AddParameter(cmd, "OrderBy", "m.MatterDate")
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        'Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
        ExportToExcel()
    End Sub
    Private Sub ExportToExcel()

        Response.Clear()

        Response.AddHeader("content-disposition", "attachment;filename=Taskreport.xls")

        Response.Charset = ""

        Response.Cache.SetCacheability(HttpCacheability.NoCache)

        Response.ContentType = "application/vnd.xls"

        Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter

        Dim htmlWrite As System.Web.UI.HtmlTextWriter = New HtmlTextWriter(stringWrite)

        Dim dv As DataView = GetData()
        gvResults.AllowPaging = False
        gvResults.AllowSorting = False
        gvResults.DataSource = dv
        gvResults.DataBind()
        gvResults.Columns(0).Visible = False
        gvResults.RenderControl(htmlWrite)

        gvResults.AllowPaging = True
        gvResults.AllowSorting = True
        Requery(False)

        Response.Write(stringWrite.ToString())

        Response.End()

        'Dim dv As DataView = GetData()
        'Try
        '    'column index of the dataview result
        '    Dim index As Integer() = {2, 3, 6, 8, 11, 12, 16, 19, 21, 4}
        '    Dim sw As New StringWriter
        '    Dim htw As New HtmlTextWriter(sw)
        '    Dim table As New System.Web.UI.WebControls.Table
        '    Dim tr As New System.Web.UI.WebControls.TableRow
        '    Dim cell As TableCell

        '    For i As Integer = 0 To index.Length - 1 'dv.Table.Columns.Count - 1
        '        cell = New TableCell
        '        cell.Text = dv.Table.Columns(index(i)).ColumnName
        '        tr.Cells.Add(cell)
        '    Next
        '    table.Rows.Add(tr)


        '    Dim irowindex As Integer = 0
        '    For irowindex = 0 To dv.Count - 1 ' As DataRow In dv.Table.Rows
        '        tr = New TableRow
        '        For i As Integer = 0 To index.Length - 1 'dv.Table.Columns.Count - 1
        '            cell = New TableCell
        '            cell.Attributes.Add("class", "text")
        '            cell.Text = dv(irowindex)(index(i)) '  row.Item(index(i)).ToString
        '            tr.Cells.Add(cell)
        '        Next
        '        table.Rows.Add(tr)
        '    Next irowindex

        '    table.RenderControl(htw)

        '    HttpContext.Current.Response.Clear()
        '    Response.Charset = ""
        '    Response.Cache.SetCacheability(HttpCacheability.NoCache)
        '    HttpContext.Current.Response.ContentType = "application/ms-excel"
        '    HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=matter_report.xls")
        '    HttpContext.Current.Response.Write(sw.ToString)
        '    HttpContext.Current.Response.End()

        'Finally
        '    'DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        'End Try
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub
    Private Function GetCriteria() As String

        Dim Where As String = String.Empty

        If csClientID.SelectedList.Count > 0 Then
            Where = AddCriteria(Where, csClientID.GenerateCriteria("c.ClientID"), optClientChoice.SelectedValue = 0)
        End If

        If csAttorneyID.SelectedList.Count > 0 Then
            Where = AddCriteria(Where, csAttorneyID.GenerateCriteria("a.AttorneyId"), optAttorneyChoice.SelectedValue = 0)
        End If

        If csMatterStatus.SelectedList.Count > 0 Then
            Where = AddCriteria(Where, csMatterStatus.GenerateCriteria("msc.MatterStatusId"), optMatterStatus.SelectedValue = 0)
        End If

        If csLCState.SelectedList.Count > 0 Then
            Where = AddCriteria(Where, csLCState.GenerateCriteria("t.StateID"), optLCState.SelectedValue = 0)
        End If

        'If csLCCity.SelectedList.Count > 0 Then
        '    Where = AddCriteria(Where, csLCCity.GenerateCriteria("a.City"), optLCCity.SelectedValue = 0)
        'End If

        If Not String.IsNullOrEmpty(txtMatterDate1.Text) Then
            Where = AddCriteria(Where, "m.MatterDate >= '" & txtMatterDate1.Text & "'")
        End If

        If Not String.IsNullOrEmpty(txtMatterDate2.Text) Then
            Where = AddCriteria(Where, "m.MatterDate <= '" & txtMatterDate2.Text & "'")
        End If

        If Where.Length > 0 Then
            Where = " AND " & Where
        End If

        Return Where

    End Function
#End Region

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        'Requery(reset)
    End Sub

    Protected Sub gvResults_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvResults.PageIndexChanging
        gvResults.PageIndex = e.NewPageIndex
        Requery(False)
    End Sub

    Protected Sub gvResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResults.RowDataBound
        If e.Row.RowType = DataControlRowType.Header Then
            If Not IsNothing(ViewState("strSortExp")) Then
                strSortExp = ViewState("strSortExp")
            End If
            If Not IsNothing(ViewState("strSortDir")) Then
                strSortDir = ViewState("strSortDir")
            End If
            Dim field As DataControlField
            Dim cellIndex As Integer = -1
            For Each field In gvResults.Columns
                If field.SortExpression = strSortExp Then
                    cellIndex = gvResults.Columns.IndexOf(field)
                    Exit For
                End If
            Next
            If cellIndex > -1 Then
                'this is a header row,set the sort style
                e.Row.Cells(cellIndex).CssClass += IIf(strSortDir = "0", " sortasc", " sortdesc")
            End If
        End If
        'Dim gridView As DataPagerGridView = CType(sender, DataPagerGridView)
        'If gridView.SortExpression.Length > 0 Then
        '    Dim cellIndex As Integer = -1
        '    Dim field As DataControlField
        '    For Each field In gridView.Columns
        '        If field.SortExpression = gridView.SortExpression Then
        '            cellIndex = gridView.Columns.IndexOf(field)
        '            Exit For
        '        End If
        '    Next
        '    If cellIndex > -1 Then
        '        If e.Row.RowType = DataControlRowType.Header Then
        '            'this is a header row,set the sort style
        '            e.Row.Cells(cellIndex).CssClass += IIf(gridView.SortDirection = SortDirection.Ascending, " sortasc", " sortdesc")
        '        End If
        '    End If
        'End If
    End Sub

    Protected Sub gvResults_Sorted(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvResults.Sorted
        'Requery(False)
    End Sub

    Protected Sub gvResults_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvResults.Sorting
        ViewState("strSortExp") = e.SortExpression
        If Not IsNothing(ViewState("strSortDir")) Then
            If ViewState("strSortDir") = "0" Then
                ViewState("strSortDir") = "1"
            Else
                ViewState("strSortDir") = "0"
            End If
        Else
            ViewState("strSortDir") = "0"
        End If
        Requery(False)
    End Sub
End Class