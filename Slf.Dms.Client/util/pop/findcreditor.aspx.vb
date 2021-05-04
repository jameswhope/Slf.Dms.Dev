Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class util_pop_findcreditor
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer

    Private _creditor As String
    Private _street As String
    Private _street2 As String
    Private _city As String
    Private _stateid As Integer
    Private _zipcode As String

    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()
        If Not qs Is Nothing Then
            _creditor = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("creditor")).Trim)).Trim
            _street = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("street")).Trim))
            _street2 = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("street2")).Trim))
            _city = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("city")).Trim))
            _stateid = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_int(DataHelper.Nz_string(qs("stateid")).Trim)))
            _zipcode = Server.HtmlDecode(Server.UrlDecode(DataHelper.Nz_string(qs("zipcode")).Trim))

            If Not IsPostBack Then
                LoadRecord()
                SetAttributes()
            End If
        End If
    End Sub

    Private Sub LoadRecord()

        LoadStates(_stateid)

        txtCreditor.Text = _creditor
        txtStreet.Text = _street
        txtStreet2.Text = _street2
        txtCity.Text = _city
        txtZipCode.Text = _zipcode

        ListHelper.SetSelected(cboStateID, _stateid)

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
    Private Sub SetAttributes()

        'set events for input restriction
        'txtZipCode.Attributes("onkeypress") = "AllowOnlyNumbers();" 'Removed per Chris 10/25/2007

        'set events for querying
        txtCreditor.Attributes("onkeyup") = "Requery();"
        txtStreet.Attributes("onkeyup") = "Requery();"
        txtStreet2.Attributes("onkeyup") = "Requery();"
        txtCity.Attributes("onkeyup") = "Requery();"
        cboStateID.Attributes("onchange") = "Requery();"
        txtZipCode.Attributes("onkeyup") = "Requery();"

        aOk.Attributes("imgText") = "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absMiddle""/>"
    End Sub
    Private Sub LoadStates(ByVal SelectedStateID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblState ORDER BY Abbreviation"

        cboStateID.Items.Clear()
        cboStateID.Items.Add(New ListItem(String.Empty, 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboStateID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Abbreviation"), DatabaseHelper.Peel_int(rd, "StateID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
End Class