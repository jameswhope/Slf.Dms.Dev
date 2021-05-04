Imports Drg.Util.DataAccess

Imports SharedFunctions

Imports System.Data.SqlClient

Partial Class reports_scanning_default
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private UserGroupID As String
    Private ClientID As Integer
    Private RelationType As String
    Private RelationID As Integer
    Public WasRelated As Boolean
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        'UserGroupID = DataHelper.FieldLookup("tblUser", "UserGroupID", "UserID = " + UserID.ToString())
        ClientID = Integer.Parse(Request.QueryString("id"))
        RelationType = Request.QueryString("type").ToString()
        RelationID = Request.QueryString("rel").ToString()

        If Not IsPostBack Then
            FillDocumentTypes()
            pnlPrint.Visible = False
            pnlRegenerate.Visible = False
            WasRelated = False
        End If
    End Sub

    Private Sub FillDocumentTypes()
        Dim cmdStr As String = "SELECT DisplayName, TypeID FROM tblDocumentType " '+ IIf(UserGroupID.Length > 0, "WHERE substring(TypeID, 1, 2) in (SELECT DocGroupID FROM tblDocGroupPermission WHERE UserGroupID = " + UserGroupID + ") ", "") + "ORDER BY DisplayName ASC"

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlDocument.Items.Add(New ListItem(TruncateString(reader("DisplayName").ToString(), 85), reader("TypeID").ToString()))
                    End While
                End Using
            End Using
        End Using

        ddlDocument.Items.Add(New ListItem("-- SELECT --", "SELECT"))
        ddlDocument.SelectedValue = "SELECT"
        hdnCurrent.Value = ddlDocument.Items.IndexOf(ddlDocument.Items.FindByValue("SELECT"))
    End Sub

    Private Function TruncateString(ByVal str As String, ByVal length As Integer)
        If str.Length > length Then
            str = str.Substring(0, length - 3) + "..."
        End If

        Return str
    End Function

    Protected Sub lnkRelateDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRelateDocument.Click
        SharedFunctions.DocumentAttachment.AttachDocument(RelationType, RelationID, lblFileName.Text, UserID.ToString())
        WasRelated = True
    End Sub

    Protected Sub lnkGenerate_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGenerate.Click
        lblPath.Text = "\\nas02\ClientStorage\" + DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString()) + _
            "\" + DataHelper.FieldLookup("tblDocumentType", "DocFolder", "TypeID = '" + ddlDocument.SelectedValue.ToString() + "'")
        lblFilename.Text = GetUniqueDocumentName(ClientID, ddlDocument.SelectedValue)

        pnlPrint.Visible = True
        pnlRegenerate.Visible = True
        WasRelated = False
    End Sub

    Private Function GetUniqueDocumentName(ByVal ClientID As Integer, ByVal docTypeID As String) As String
        Dim ret As String
        Dim docID As String

        Using conn As SqlConnection = ConnectionFactory.Create()
            conn.Open()
            docID = GetDocID(conn)
            ret = GetAccountNumber(conn, ClientID) + "_" + docTypeID + "_" + docID + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        lblDocID.Text = docID

        Return ret
    End Function

    Private Function GetDocID(ByVal conn As SqlConnection) As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", conn)
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function

    Private Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class