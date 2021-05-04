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

Partial Class research_queries_financial_commission_batchpayments
    Inherits PermissionPage

#Region "Variables"

    Private Const PageSize As Integer = 20

    Private UserID As Integer
    Private qs As QueryStringCollection

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            LoadClients()

            If Not IsPostBack Then

                LoadValues(GetControls(), Me)

            End If
            Requery(False)
            SetAttributes()

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
        Save()
        Requery(True)

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()
        grdResults.Reset(True)
        'reload page
        Refresh()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optRecipientChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optRecipientChoice.ID, "value", _
                optRecipientChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csCommRecID.ID, "store", csCommRecID.SelectedStr)

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If

        If txtAmount1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtAmount1.ID, "value", _
                txtAmount1.Text)
        End If

        If txtAmount2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtAmount2.ID, "value", _
                txtAmount2.Text)
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
    Private Sub SetAttributes()

        txtAmount1.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtAmount2.Attributes("onkeypress") = "AllowOnlyNumbers();"

    End Sub
    Private Sub LoadClients()

        csCommRecID.Items.Clear()
        csCommRecID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT CommRecId, Abbreviation FROM tblCommRec"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim CommRecId As Integer = DatabaseHelper.Peel_int(rd, "CommRecId")
                        Dim Display As String = DatabaseHelper.Peel_string(rd, "Abbreviation")

                        csCommRecID.AddItem(New ListItem(Display, CommRecId))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csCommRecID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csCommRecID.ID + "'")
        End If
    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optRecipientChoice.ID, optRecipientChoice)
        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)
        c.Add(txtAmount1.ID, txtAmount1)
        c.Add(txtAmount2.ID, txtAmount2)
        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)

        Return c

    End Function
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

        AddControl(pnlBody, c, "Research-Queries-Financial-Commission-Batch Payments")

    End Sub
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
    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        If txtTransDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
        If txtTransDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))
        DatabaseHelper.AddParameter(cmd, "Where", GetCriteria())
    End Sub
    Private Sub Requery(ByVal Reset As Boolean)

        Dim grd As QueryGrid = grdResults

        'Setup misc settings
        grd.IconSrcURL = "~/images/16x16_cheque.png"
        grd.PageSize = PageSize
        grd.SortOptions.Allow = True
        grd.SortOptions.DefaultSortField = "BatchDate"

        'Setup Click settings
        grd.ClickOptions.Clickable = False
        grd.NoWrap = True

        'Setup the DataCommand
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryGetCommissionBatches")
        AddStdParams(cmd)
        cmd.CommandTimeout = 180
        grd.DataCommand = cmd

        Session("rptcmd_query_commission_batchpayments") = cmd

        'Setup the Fields
        grd.Fields.Clear()
        grd.Fields.Add(New QueryGrid.GridField("Batch", QueryGrid.eFieldType.Text, Nothing, "CommBatchId", SqlDbType.Int, True, "tblCommBatch.CommBatchId"))
        grd.Fields.Add(New QueryGrid.GridField("Batch Date", QueryGrid.eFieldType.DateTime, Nothing, "BatchDate", SqlDbType.DateTime, True, "BatchDate"))
        grd.Fields.Add(New QueryGrid.GridField("From", QueryGrid.eFieldType.Text, Nothing, "ParentCommRecName", SqlDbType.VarChar, True, "ParentCommRecName"))
        grd.Fields.Add(New QueryGrid.GridField("Recipient", QueryGrid.eFieldType.Text, Nothing, "CommRecName", SqlDbType.VarChar, True, "CommRecName"))
        grd.Fields.Add(New QueryGrid.GridField("Transfer Amt.", QueryGrid.eFieldType.Currency, Nothing, "TransferAmount", SqlDbType.Money, True, "TransferAmount"))
        grd.Fields.Add(New QueryGrid.GridField("Total Amount", QueryGrid.eFieldType.Currency, Nothing, "Amount", SqlDbType.Money, True, "Amount"))
        grd.Fields.Add(New QueryGrid.GridField("ACH Tries", QueryGrid.eFieldType.Text, Nothing, "ACHTries", SqlDbType.Int, True, "ACHTries"))
        grd.Fields.Add(New QueryGrid.GridField("Check #", QueryGrid.eFieldType.Text, Nothing, "CheckNumber", SqlDbType.VarChar, True, "CheckNumber"))
        grd.Fields.Add(New QueryGrid.GridField("Check Date", QueryGrid.eFieldType.DateTime, Nothing, "CheckDate", SqlDbType.DateTime, True, "CheckDate"))
        If (Reset) Then grd.Reset(True)

        Session("xls_" & Me.GetType.Name) = grd.GetXlsHtml()
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
    Private Function GetCriteria() As String

        Dim Where As String = String.Empty

        If csCommRecID.SelectedList.Count > 0 Then
            Where = AddCriteria(Where, csCommRecID.GenerateCriteria("tblCommBatchTransfer.CommRecId"), optRecipientChoice.SelectedValue = 0)
        End If

        If Not String.IsNullOrEmpty(txtAmount1.Text) Then
            Where = AddCriteria(Where, "tblCommBatchTransfer.Amount >= " & txtAmount1.Text)
        End If

        If Not String.IsNullOrEmpty(txtAmount2.Text) Then
            Where = AddCriteria(Where, "tblCommBatchTransfer.Amount <= " & txtAmount2.Text)
        End If

        If Where.Length > 0 Then
            Where = "AND " & Where
        End If

        Return Where

    End Function
#End Region
End Class