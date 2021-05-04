Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_queries_clients_duplicates_default
    Inherits PermissionPage

#Region "Variables"
    Dim AllDupSets As New Dictionary(Of String, DupSet)
    Private Const PageSize As Integer = 20

    Dim pager As PagerWrapper

    Private UserID As Integer
    Private qs As QueryStringCollection

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pager = New PagerWrapper(lnkFirst, lnkPrev, lnkNext, lnkLast, imgFirst, imgPrev, imgNext, imgLast, txtPageNumber, lblPageCount, Context, "p")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            If Not IsPostBack Then

                LoadValues(GetControls(), Me)
                LoadCriteriaSelector()

            End If
            SetAttributes()

        End If

    End Sub
    Private Sub LoadCriteriaSelector()
        Dim l As New List(Of Criteria)

        Dim arr() As String = txtCriteria.Value.Split("|")
        For Each s As String In arr
            Dim parts() As String = s.Split(",")

            If parts.Length = 3 Then
                Dim c As New Criteria
                c.val1 = parts(0)
                c.val2 = parts(1)
                c.val3 = parts(2)
                l.Add(c)
            End If
        Next

        rpCriteria.DataSource = l
        rpCriteria.DataBind()
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
        Save()
        Refresh()

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()
        Refresh()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If imCreatedDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "imCreatedDate1", "value", _
                imCreatedDate1.Text)
        End If

        If imCreatedDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "imCreatedDate2", "value", _
                imCreatedDate2.Text)
        End If

        If txtCriteria.Value.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtCriteria.ID, "value", _
                txtCriteria.Value)
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
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Queries-Clients-Demographics-Duplicates")
    End Sub
    Protected Sub lnkFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirst.Click
        pager.First()
    End Sub
    Protected Sub lnkLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLast.Click
        pager.Last()
    End Sub
    Protected Sub lnkNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNext.Click
        pager.Next()
    End Sub
    Protected Sub lnkPrev_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrev.Click
        pager.Previous()
    End Sub
    Protected Sub txtPageNumber_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtPageNumber.TextChanged
        pager.SetPage(DataHelper.Nz_int(txtPageNumber.Text))
    End Sub
#End Region
#Region "Util"
    Private Sub SetAttributes()

        'txtAmount1.Attributes("onkeypress") = "AllowOnlyNumbers();"
        'txtAmount2.Attributes("onkeypress") = "AllowOnlyNumbers();"

        'register jscript for "printResults" popup
        WebHelper.RegisterPopup(Page, ResolveUrl("~/reports/interface/frame.aspx"), "?rpt=checkstoprint", _
            "printResults", 850, 600, 75, 50, "no", "no", "no", "yes", "no", "yes", "yes")

    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(imCreatedDate1.ID, imCreatedDate1)
        c.Add(imCreatedDate2.ID, imCreatedDate2)
        c.Add(txtCriteria.ID, txtCriteria)
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
#End Region
#Region "Query"
    Protected Function GetSelect(ByVal type As String, ByVal selectedValue As String) As String
        Dim FieldOptions() As String = {"First Name", "Last Name", "SSN", "Gender", "Agency", "Street", "City", "State", "Zip"}
        Dim OperatorOptions() As String = {"Equal", "Similar", "Null or Equal", "First _ Equal", "Last _ Equal"}
        Dim sb As New StringBuilder
        sb.Append("<select style=""font-family:Tahoma;font-size:11"">")
        Select Case type
            Case "Field"
                For i As Integer = 0 To FieldOptions.Length - 1
                    sb.Append("<option value=""" & i & """ " & IIf(i = Integer.Parse(selectedValue), "selected", "") & ">" & FieldOptions(i) & "</option>")
                Next
            Case "Operator"
                For i As Integer = 0 To OperatorOptions.Length - 1
                    sb.Append("<option value=""" & i & """ " & IIf(i = Integer.Parse(selectedValue), "selected", "") & ">" & OperatorOptions(i) & "</option>")
                Next
        End Select
        sb.Append("</select>")
        Return sb.ToString
    End Function
    Protected Function GetRows(ByVal ds As DupSet) As String
        Dim ID As String = ds.DupSetID.Replace(",", "").Replace(" ", "").Replace("~", "")

        Dim sb As New StringBuilder
        sb.Append("<tr hover=""false"" style=""height:3px"">")
        sb.Append("<td align=""center"" style=""cursor:default;font-size:2px;background-color:rgb(200,200,200);border-bottom:none"" rowspan=""" & (ds.Dups.Count + 1) & """>")
        sb.Append("&nbsp;&nbsp;<a href=""#"" onclick=""Resolve(document.getElementById('" & ID & "'))""><img border=""0"" src=""" & ResolveUrl("~/images/16x16_publish.png") & """/></a>&nbsp;&nbsp;")
        sb.Append("</td>")
        sb.Append("<td style=""cursor:default;font-size:2px;background-color:rgb(200,200,200);border-bottom:none"" colspan=""21"">")
        sb.Append("</td></tr>")

        sb.Append("<span id=""" & ID & """>")
        For Each r1 As Result In ds.Dups.Values
            sb.Append("<a href=""" & ResolveUrl("~/clients/client/?id=" & r1.ClientID) & """><tr>")
            sb.Append("<td style=""width:25;"" align=""center""><input ClientID=""" & r1.ClientID & """ onpropertychange=""Grid_CheckOrUncheck(this, '" & ds.DupSetID & "~" & r1.ClientID & "');"" type=""checkbox"" /></td>")
            sb.Append("<td align=""center""><img src=""" & ResolveUrl("~/images/16x16_person.png") & """/></td>")
            sb.Append("<td align=""left"">" & r1.ClientID & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.FirstName & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.LastName & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.SSN & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.Gender & "&nbsp;</td>")
            sb.Append("<td align=""left"" nowrap=""true"" style=""widtd:75;"">" & r1.AccountNumber & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.ClientStatusName & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.AgencyAbbreviation & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.City & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.StateName & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.ZipCode & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.Notes & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.PhoneCalls & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.accounts & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.Registers & "&nbsp;</td>")
            sb.Append("<td align=""right"">" & r1.Balance.ToString("c") & "&nbsp;</td>")
            sb.Append("<td align=""center"">" & LocalHelper.GetBoolString(r1.CompletedDE, Me) & "&nbsp;</td>")
            sb.Append("<td align=""center"">" & LocalHelper.GetBoolString(r1.CompletedUW, Me) & "&nbsp;</td>")
            sb.Append("<td align=""left"">" & r1.Created.ToString("MM/dd/yyyy") & "&nbsp;</td>")
            sb.Append("</tr></a>")
        Next
        sb.Append("</span>")
        Return sb.ToString
    End Function
    Private Sub Requery()
        If CType(Session(Me.GetType.Name & "_reset"), Boolean) = True Or Session(Me.GetType.Name & "_reset") Is Nothing Then
            Dim NoDups As New List(Of Pair(Of Integer))

            Dim sb As New StringBuilder

            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Query_Duplicates")
                If AddStdParams(cmd) Then
                    cmd.CommandTimeout = 180
                    Using cmd.Connection
                        cmd.Connection.Open()
                        Using rd As IDataReader = cmd.ExecuteReader
                            While rd.Read()
                                Dim r As New Result

                                r.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                                r.AccountNumber = DatabaseHelper.Peel_string(rd, "AccountNumber")
                                r.ClientStatusID = DatabaseHelper.Peel_int(rd, "ClientStatusID")
                                r.ClientStatusName = DatabaseHelper.Peel_string(rd, "ClientStatusName")
                                r.AgencyID = DatabaseHelper.Peel_int(rd, "AgencyID")
                                r.AgencyName = DatabaseHelper.Peel_string(rd, "AgencyName")
                                r.AgencyAbbreviation = DatabaseHelper.Peel_string(rd, "AgencyAbbreviation")
                                r.Notes = DatabaseHelper.Peel_int(rd, "Notes")
                                r.PhoneCalls = DatabaseHelper.Peel_int(rd, "PhoneCalls")
                                r.accounts = DatabaseHelper.Peel_int(rd, "Accounts")
                                r.Registers = DatabaseHelper.Peel_int(rd, "Registers")
                                r.Balance = DatabaseHelper.Peel_float(rd, "Balance")
                                r.Created = DatabaseHelper.Peel_date(rd, "Created")
                                r.CompletedDE = DatabaseHelper.Peel_bool(rd, "CompletedDE")
                                r.CompletedUW = DatabaseHelper.Peel_bool(rd, "CompletedUW")

                                r.PersonID = DatabaseHelper.Peel_int(rd, "PersonID")
                                r.FirstName = DatabaseHelper.Peel_string(rd, "FirstName")
                                r.LastName = DatabaseHelper.Peel_string(rd, "LastName")
                                r.SSN = DatabaseHelper.Peel_string(rd, "SSN")
                                r.Gender = DatabaseHelper.Peel_string(rd, "Gender")
                                r.Street = DatabaseHelper.Peel_string(rd, "Street")
                                r.Street2 = DatabaseHelper.Peel_string(rd, "Street2")
                                r.City = DatabaseHelper.Peel_string(rd, "City")
                                r.StateID = DatabaseHelper.Peel_int(rd, "StateID")
                                r.StateAbbreviation = DatabaseHelper.Peel_string(rd, "StateAbbreviation")
                                r.StateName = DatabaseHelper.Peel_string(rd, "StateName")
                                r.ZipCode = DatabaseHelper.Peel_string(rd, "ZipCode")
                                r.RowIndex = DatabaseHelper.Peel_string(rd, "RowIndex")

                                'AllResults.Add(r.ClientID, r)
                                Dim theDS As DupSet = Nothing
                                If Not AllDupSets.TryGetValue(r.RowIndex, theDS) Then
                                    theDS = New DupSet
                                    theDS.RowIndex = r.RowIndex
                                    theDS.DupSetID = GetNextDSID(r.RowIndex)
                                    AllDupSets.Add(theDS.DupSetID, theDS)
                                End If

                                theDS.Dups.Add(r.ClientID, r)
                            End While

                            rd.NextResult()

                            While rd.Read()
                                Dim p As New Pair(Of Integer)
                                p.First = DatabaseHelper.Peel_int(rd, "ClientID1")
                                p.Second = DatabaseHelper.Peel_int(rd, "ClientID2")
                                NoDups.Add(p)
                            End While

                        End Using
                    End Using
                End If
            End Using

            Dim NoDupQueue As New List(Of DupSet)
            NoDupQueue = LocalHelper.ConvertToList(Of DupSet)(AllDupSets)

            'take care of nodups
            While NoDupQueue.Count > 0
                Dim ds As DupSet = NoDupQueue(0)
                Dim NoChange As Boolean = True

                For Each p As Pair(Of Integer) In NoDups
                    If ds.Dups.Count < 2 Then
                        AllDupSets.Remove(ds.DupSetID)
                        NoDupQueue.Remove(ds)
                        NoChange = False
                    ElseIf ds.Dups.ContainsKey(p.First) And ds.Dups.ContainsKey(p.Second) Then
                        If ds.Dups.Count <= 2 Then 'only two in the set. just delete the dup set
                            AllDupSets.Remove(ds.DupSetID)
                            NoDupQueue.Remove(ds)
                            NoChange = False
                        Else 'more than 2. have to break out into another set

                            'create new set
                            Dim ds2 As New DupSet
                            ds2.RowIndex = ds.RowIndex
                            ds2.DupSetID = GetNextDSID(ds2.RowIndex)
                            AllDupSets.Add(ds2.DupSetID, ds2)
                            NoDupQueue.Add(ds2)

                            'move result1 into new set
                            Dim r1 As Result = ds.Dups(p.First)
                            ds.Dups.Remove(p.First)
                            ds2.Dups.Add(r1.ClientID, r1)

                            'add any third-parties into new set
                            For Each otherResult As Result In ds.Dups.Values
                                If Not otherResult.ClientID = p.First And Not otherResult.ClientID = p.Second And Not PairsContain(NoDups, r1.ClientID, otherResult.ClientID) Then
                                    ds2.Dups.Add(otherResult.ClientID, otherResult)
                                End If
                            Next

                            NoChange = False 'leave in queue
                        End If
                    End If
                Next
                If NoChange Then NoDupQueue.Remove(ds)
            End While

            Dim hr As PagerHelper.HandleResult = PagerHelper.Handle(LocalHelper.SortToList(Of DupSet)(AllDupSets), rpResults, pager, PageSize)
            Session(Me.GetType.Name & "_AllDupSets") = AllDupSets
        Else
            AllDupSets = CType(Session(Me.GetType.Name & "_AllDupSets"), Dictionary(Of String, DupSet))
        End If
    End Sub
    Private Function GetNextDSID(ByVal RowIndex As String) As String
        If Not AllDupSets.ContainsKey(RowIndex) Then
            Return RowIndex
        End If

        Dim i As Integer = 2
        While AllDupSets.ContainsKey(RowIndex & "_" & i)
            i += 1
        End While
        Return RowIndex & "_" & i
    End Function
    Private Function PairsContain(ByVal l As List(Of Pair(Of Integer)), ByVal x As Integer, ByVal y As Integer) As Boolean
        For Each p As Pair(Of Integer) In l
            If p.First = x And p.Second = y Then Return True
            If p.Second = x And p.First = y Then Return True
        Next
        Return False
    End Function
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
    Private Function TakeSection(ByVal field As String, ByVal [end] As Boolean, ByVal length As Integer) As String
        If [end] Then
            Return "substring(" & field & "len(" & field & ")-1," & length & ")"
        Else
            Return "substring(" & field & ",1," & length & ")"
        End If
    End Function
    Private Function AddStdParams(ByVal cmd As IDbCommand) As Boolean
        Dim where As String = ""
        where = AddDateCriteria(where, imCreatedDate1, imCreatedDate2, "c.created")
        If where.Length > 0 Then DatabaseHelper.AddParameter(cmd, "where", where)

        Dim l As New List(Of Criteria)
        Dim arr() As String = txtCriteria.Value.Split("|")
        For Each s As String In arr
            Dim parts() As String = s.Split(",")
            If parts.Length = 3 Then
                Dim c As New Criteria
                c.val1 = parts(0)
                c.val2 = parts(1)
                c.val3 = parts(2)
                l.Add(c)
            End If
        Next

        Dim Fields() As String = {"firstname", "lastname", "ssn", "gender", "agencyid", "street", "city", "stateid", "zipcode"}
        Dim Tables() As String = {"p", "p", "p", "p", "c", "p", "p", "p", "p"}
        Dim TablesN() As String = {"np", "np", "np", "np", "nc", "np", "np", "np", "np"}
        Dim sel As String = ""
        Dim group As String = ""
        Dim join As String = ""
        Dim val As String = ""

        For Each c As Criteria In l
            Dim fieldIndex As Integer = Integer.Parse(c.val1)
            Dim Field As String = Fields(fieldIndex)
            Dim Table As String = Tables(fieldIndex)
            Dim TableN As String = TablesN(fieldIndex)
            Dim operatorIndex As Integer = Integer.Parse(c.val2)
            Dim Length As Integer = DataHelper.Nz_int(c.val3)
            If sel.Length > 0 Then sel += ","
            If group.Length > 0 Then group += ","
            If join.Length > 0 Then join += " and " Else join = " on "
            If val.Length > 0 Then val += " + "

            Select Case operatorIndex
                Case 0 'equal
                    sel += "[" & TableN & "].[" & Field & "]"
                    group += "[" & TableN & "].[" & Field & "]"
                    join += "[" & Table & "].[" & Field & "] = [tmp].[" & Field & "]"
                    val += "CONVERT(varchar, [tmp].[" + Field + "])"
                Case 1 'similar
                    sel += "soundex([" & TableN & "].[" & Field & "]) as [" & Field & "_1]"
                    group += "soundex([" & TableN & "].[" & Field & "])"
                    join += "soundex([" & Table & "].[" & Field & "]) = [tmp].[" & Field & "_1]"
                    val += "[tmp].[" + Field + "_1]"
                Case 2 'null/equal
                    sel += "[" & TableN & "].[" & Field & "]"
                    group += "[" & TableN & "].[" & Field & "]"
                    join += "([" & Table & "].[" & Field & "] is null or [" & Table & "].[" & Field & "] = [tmp].[" & Field & "])"
                    val += "CONVERT(varchar, isnull([tmp].[" + Field + "],''))"
                Case 3 'first _ equal
                    sel += TakeSection("[" & TableN & "].[" & Field & "]", False, Length) & " as [" & Field & "_2]"
                    group += TakeSection("[" & TableN & "].[" & Field & "]", False, Length)
                    join += TakeSection("[" & Table & "].[" & Field & "]", False, Length) & " = [tmp].[" & Field & "_2]"
                    val += "[tmp].[" + Field + "_2]"
                Case 4 'last _ equal
                    sel += TakeSection("[" & TableN & "].[" & Field & "]", True, Length) & " as [" & Field & "_3]"
                    group += TakeSection("[" & TableN & "].[" & Field & "]", True, Length)
                    join += TakeSection("[" & Table & "].[" & Field & "]", True, Length) & " = [tmp].[" & Field & "_3]"
                    val += "[tmp].[" + Field + "_3]"
                Case Else

            End Select
        Next
        If String.IsNullOrEmpty(val) Then
            Return False
        Else
            DatabaseHelper.AddParameter(cmd, "select", sel)
            DatabaseHelper.AddParameter(cmd, "group", group)
            DatabaseHelper.AddParameter(cmd, "join", join)
            DatabaseHelper.AddParameter(cmd, "value", val)
            Return True
        End If

    End Function
#End Region

    

#Region "Classes"
    Public Structure Criteria
        Dim val1 As String
        Dim val2 As String
        Dim val3 As String
    End Structure
    Protected Class DupSet
        Dim _Dups As Dictionary(Of Integer, Result)
        Dim _RowIndex As String
        Dim _DupSetID As String


        Public Property DupSetID() As String
            Get
                Return _DupSetID
            End Get
            Set(ByVal value As String)
                _DupSetID = value
            End Set
        End Property
        Public Property RowIndex() As String
            Get
                Return _RowIndex
            End Get
            Set(ByVal value As String)
                _RowIndex = value
            End Set
        End Property

        Public Property Dups() As Dictionary(Of Integer, Result)
            Get
                If _Dups Is Nothing Then _Dups = New Dictionary(Of Integer, Result)
                Return _Dups
            End Get
            Set(ByVal value As Dictionary(Of Integer, Result))
                _Dups = value
            End Set
        End Property
    End Class

    Protected Structure Result
        Dim RowIndex As String

        Dim ClientID As Integer
        Dim AccountNumber As String
        Dim ClientStatusID As Integer
        Dim ClientStatusName As String
        Dim AgencyID As Integer
        Dim AgencyName As String
        Dim AgencyAbbreviation As String
        Dim Notes As Integer
        Dim PhoneCalls As Integer
        Dim accounts As Integer
        Dim Registers As Integer
        Dim Balance As Single
        Dim Created As DateTime
        Dim CompletedDE As Boolean
        Dim CompletedUW As Boolean

        Dim PersonID As Integer
        Dim FirstName As String
        Dim LastName As String
        Dim SSN As String
        Dim Gender As String
        Dim Street As String
        Dim Street2 As String
        Dim City As String
        Dim StateID As Integer
        Dim StateAbbreviation As String
        Dim StateName As String
        Dim ZipCode As String
    End Structure
#End Region

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Dim arr() As String = txtSelected.Value.Split(",")
        For Each s As String In arr
            Dim ClientID As Integer = Integer.Parse(s)
            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeleteClient")
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                Using cmd.Connection
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Next
        Session(Me.GetType.Name & "_reset") = True
        Refresh()
    End Sub

    Protected Sub lnkUnique_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnique.Click
        AllDupSets = CType(Session(Me.GetType.Name & "_AllDupSets"), Dictionary(Of String, DupSet))
        Dim arr() As String = txtSelected.Value.Split(",")
        For Each s As String In arr
            Dim parts() As String = s.Split("~")
            Dim DupSetID As String = parts(0)
            Dim ClientID As Integer = Integer.Parse(parts(1))

            'find dupset
            Dim ds As DupSet = AllDupSets(DupSetID)

            For Each r As Result In ds.Dups.Values
                If Not r.ClientID = ClientID Then
                    'set as nodup
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        DatabaseHelper.AddParameter(cmd, "KeyId1", ClientID)
                        DatabaseHelper.AddParameter(cmd, "KeyId2", r.ClientID)
                        DatabaseHelper.AddParameter(cmd, "Table", "tblClient")
                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.BuildInsertCommandText(cmd, "tblDuplicateExclude")
                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                End If
            Next
        Next
        Session(Me.GetType.Name & "_reset") = True
        Refresh()

    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        Requery()
    End Sub
End Class