Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client
    Inherits PermissionMasterPage
    Implements IClientPage

#Region "Variables"

    Private _views As List(Of String)
    Private _commontasks As List(Of String)
    Private _relatedlinks As List(Of String)
    Public AccountNumber As String

#End Region

#Region "Properties"

    Public ReadOnly Property UserEdit() As Boolean
        Get
            Return Permission.UserEdit(IsMy)
        End Get
    End Property
    Public ReadOnly Property MasterNavigator() As Navigator
        Get
            Return CType(Master, Site).Navigator
        End Get
    End Property
    Public ReadOnly Property Views() As List(Of String)
        Get

            If _views Is Nothing Then
                _views = New List(Of String)
            End If

            Return _views

        End Get
    End Property
    Public ReadOnly Property CommonTasks() As List(Of String)
        Get

            If _commontasks Is Nothing Then
                _commontasks = New List(Of String)
            End If

            Return _commontasks

        End Get
    End Property
    Public ReadOnly Property RelatedLinks() As List(Of String)
        Get

            If _relatedlinks Is Nothing Then
                _relatedlinks = New List(Of String)
            End If

            Return _relatedlinks

        End Get
    End Property
    Public ReadOnly Property DataClientID() As Integer Implements IClientPage.DataClientID
        Get
            '*******************************************************************
            'BUG ID: 560
            'Fixed By: Bereket S. Data
            'Validate Id before proceeding with subsequent operation.
            '*******************************************************************
            If (IsNumeric(Request.QueryString("id")) = True) Then
                Return DataHelper.Nz_int(Request.QueryString("id"))
            Else
                Return 0
            End If
        End Get
    End Property
    Public ReadOnly Property UserID() As Integer
        Get
            Return DataHelper.Nz_int(Page.User.Identity.Name)
        End Get
    End Property
    Private _IsMy As Nullable(Of Boolean)
    Public ReadOnly Property IsMy() As Integer
        Get
            If Not _IsMy.HasValue Then
                _IsMy = (DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CreatedBy", "Clientid=" & DataClientID)) = UserID)
            End If
            Return _IsMy
        End Get
    End Property
#End Region

    '#Region "QuickInfo"
    '    Protected strSSN As String
    '    Protected strName As String
    '    Protected strAddress As String
    '    Protected strAccountNumber As String
    '    Protected strStatus As String
    '    Protected strSDABalance As String
    '    Protected strSDAColor As String

    '    Protected Sub LoadQuickInfo()

    '        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

    '            cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

    '            DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(DataClientId))

    '            Using cmd.Connection

    '                cmd.Connection.Open()
    '                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

    '                    If rd.Read() Then

    '                        Dim SSN As String = DatabaseHelper.Peel_string(rd, "SSN")
    '                        Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")

    '                        Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)
    '                        Dim AccountNumber As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & DataClientId)

    '                        strName = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
    '                            DatabaseHelper.Peel_string(rd, "LastName"), _
    '                            DatabaseHelper.Peel_string(rd, "SSN"), _
    '                            DatabaseHelper.Peel_string(rd, "EmailAddress"))

    '                        strAddress = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
    '                            DatabaseHelper.Peel_string(rd, "Street2"), _
    '                            DatabaseHelper.Peel_string(rd, "City"), State, _
    '                            DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

    '                        If SSN.Length > 0 Then
    '                            strSSN = "SSN: " & StringHelper.PlaceInMask(SSN, "___-__-____", "_", StringHelper.Filter.NumericOnly) & "<br>"
    '                        End If

    '                        If AccountNumber.Length > 0 Then
    '                            strAccountNumber = AccountNumber & "<br>"
    '                        End If

    '                    Else
    '                        strName = "No Applicant"
    '                        strAddress = "No Address"
    '                    End If
    '                End Using

    '                strStatus = ClientHelper.GetStatus(DataClientId, Now)

    '            End Using

    '        End Using



    '        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetStatsOverviewForClient")

    '            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientId)

    '            Using cmd.Connection

    '                cmd.Connection.Open()
    '                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

    '                    If rd.Read() Then
    '                        Dim RegisterBalance As Double = DatabaseHelper.Peel_double(rd, "RegisterBalance")

    '                        strSDABalance = RegisterBalance.ToString("$#,##0.00")

    '                        If RegisterBalance < 0 Then
    '                            strSDAColor = "rgb(255,0,0)"
    '                        Else
    '                            If RegisterBalance > 0 Then
    '                                strSDAColor = "rgb(0,139,0)"
    '                            End If
    '                        End If
    '                    End If
    '                End Using
    '            End Using
    '        End Using

    '    End Sub
    '#End Region


    Public Overrides Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control))
        AddControl(pnlMenu, c, "Clients-Client Single Record")
        AddControl(pnlBody, c, "Clients-Client Single Record")

        AddControl(phComms, c, "Clients-Client Single Record-Communication-Sidebar")
        AddControl(pnlSearch, c, "Client Search")

        AddControl(trTabApplicants, c, "Clients-Client Single Record-Applicants")
        AddControl(trTabCommunication, c, "Clients-Client Single Record-Communication")
        AddControl(trTabCreditors, c, "Clients-Client Single Record-Creditors")
        AddControl(trTabDocs, c, "Clients-Client Single Record-Docs")
        AddControl(trTabFinances, c, "Clients-Client Single Record-Finances")
        AddControl(trTabReports, c, "Clients-Client Single Record-Reports")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetTabAndRollup()

        'load search and visit logs
        If Not Request.QueryString("id") Is Nothing AndAlso IsNumeric(Request.QueryString("id")) Then
            'redo search records
            ClientHelper.LoadSearch(DataClientID)

            Dim Display As String = ClientHelper.GetDefaultPersonName(DataClientID)

            If Not Display Is Nothing AndAlso Display.Length > 0 Then

                'redo user visit log
                UserHelper.StoreVisit(UserID, "Client", DataClientID, Display)

            End If

            'LoadQuickInfo()

            AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + DataClientId.ToString())
        End If

        ucComms.MyPage = Me
    End Sub
    Private Sub SetTabAndRollup()

        Dim path As String = Page.Request.Url.LocalPath.Remove(0, ResolveUrl("~").Length)

        Dim segments() As String = path.Split("/")

        Dim segment As String = Nothing
        Dim subsegment As String = Nothing

        If segments.Length = 3 Then

            segment = segments(1).ToLower()
            subsegment = segments(2).ToLower()

        Else

            segment = segments(2).ToLower()
            subsegment = segments(3).ToLower()

        End If

        Dim tabTableCells As New List(Of HtmlTableCell)
        Dim tabTables As New List(Of HtmlTable)
        Dim tabImages As New List(Of HtmlImage)

        tabTableCells.Add(tdTabOverview)
        tabTableCells.Add(tdTabApplicants)
        tabTableCells.Add(tdTabFinances)
        tabTableCells.Add(tdTabCreditors)
        tabTableCells.Add(tdTabCommunication)
        tabTableCells.Add(tdTabDocs)
        tabTableCells.Add(tdTabReports)

        tabTables.Add(tblTabOverview)
        tabTables.Add(tblTabApplicants)
        tabTables.Add(tblTabFinances)
        tabTables.Add(tblTabCreditors)
        tabTables.Add(tblTabCommunication)
        tabTables.Add(tblTabDocs)
        tabTables.Add(tblTabReports)

        tabImages.Add(imgTabOverview)
        tabImages.Add(imgTabApplicants)
        tabImages.Add(imgTabFinances)
        tabImages.Add(imgTabCreditors)
        tabImages.Add(imgTabCommunication)
        tabImages.Add(imgTabDocs)
        tabImages.Add(imgTabReports)

        Dim qsb As New QueryStringBuilder()

        qsb("id") = New QueryStringBuilder(Request.Url.Query).Item("id")

        Dim qs As String = qsb.QueryString

        If qs.Length > 0 Then
            qs = "?" & qs
        End If

        For i As Integer = 0 To tabTableCells.Count - 1

            Dim td As HtmlTableCell = tabTableCells(i)

            Dim tdsegment As String = tabTableCells(i).ID.ToLower.Remove(0, "tdtab".Length)

            If tdsegment = segment Or (tdsegment = "overview" And segment = "client") Then

                tabTableCells(i).Attributes("class") = "sideTabCellSel"
                tabTables(i).Attributes("class") = "sideTabTableSel"
                tabImages(i).Src = "~/images/16x16_arrowright_clear.png"

            Else
                '*****************************************
                '11.13.07.ug
                'commented out to point to web1 instead of nas02
                'If tdsegment = "reports" Then
                '    Dim encod As Encoding = Encoding.Default
                '    tabTables(i).Attributes("onclick") = "javascript:window.navigate(""http://report02/Slf.Dms.Client/login.aspx?user=" & Convert.ToBase64String(encod.GetBytes(UserID.ToString())) & "&ReturnUrl=%2fslf.dms.client%2fclients%2fclient%2freports%2f%3fid%3d" & DataClientID & """);"
                'Else
                '   tabTables(i).Attributes("onclick") = "javascript:window.navigate(""" & ResolveUrl("~/clients/client/" _
                '    & IIf(tdsegment = "overview", String.Empty, tdsegment & "/") & qs) & """);"
                'End If

                'stay on web1
                tabTables(i).Attributes("onclick") = "javascript:window.navigate(""" & ResolveUrl("~/clients/client/" _
                    & IIf(tdsegment = "overview", String.Empty, tdsegment & "/") & qs) & """);"
                '*****************************************

                tabTables(i).Attributes("onmouseover") = "javascript:sideTab_OnMouseOver(this);"
                tabTables(i).Attributes("onmouseout") = "javascript:sideTab_OnMouseOut(this);"

                td.Attributes("class") = "sideTabCellUns"
                tabTables(i).Attributes("class") = "sideTabTableUns"
                tabImages(i).Src = "~/images/16x16_arrowright_clearlight.png"

            End If

            'cycle table and set any additional rows 
            For r As Integer = 1 To tabTables(i).Rows.Count - 1

                If tdsegment = segment Or (tdsegment = "overview" And segment = "client") Then 'sel

                    tabTables(i).Rows(r).Attributes.Remove("class")

                    Dim tdc As HtmlTableCell = tabTables(i).Rows(r).Cells(0)

                    If tdc.Controls.Count > 0 Then

                        If TypeOf tdc.Controls(0) Is HtmlAnchor Then

                            Dim lnk As HtmlAnchor = tdc.Controls(0)

                            Dim lnksegment As String = lnk.ID.ToLower.Remove(0, "lnktab".Length)

                            If lnksegment = subsegment Then

                                lnk.Attributes("class") = "sideTabLnkSel"
                                lnk.HRef = String.Empty

                            Else

                                lnk.Attributes("class") = "sideTabLnkUns"
                                lnk.HRef = ResolveUrl("~/clients/client/" & tdsegment & "/" & lnksegment & "/") & qs

                            End If

                        End If

                    End If

                Else 'uns

                    tabTables(i).Rows(r).Attributes("class") = "sideTabTrUns"

                End If

            Next

        Next

        'fill out the rollups

        For Each t As String In Views

            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()

            c.InnerHtml = t

            r.Cells.Add(c)

            tblRollupViews.Rows.Add(r)

        Next

        For Each t As String In CommonTasks

            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()

            c.InnerHtml = t

            r.Cells.Add(c)

            tblRollupCommonTasks.Rows.Add(r)

        Next

        For Each l As String In RelatedLinks
            tdRollupRelatedLinks.InnerHtml += l
        Next

        pnlRollupViews.Visible = Views.Count > 0
        pnlRollupCommonTasks.Visible = CommonTasks.Count > 0
        pnlRollupRelatedLinks.Visible = RelatedLinks.Count > 0

    End Sub
End Class
