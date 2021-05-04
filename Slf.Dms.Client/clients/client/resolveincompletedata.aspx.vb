Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_resolveincompletedata
    Inherits System.Web.UI.Page

#Region "Variables"

    Private DataClientID As Integer
    Private ClientStatusID As Integer
    Private UserID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        DataClientID = DataHelper.Nz_int(Request.QueryString("id"))
        ClientStatusID = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID=" & DataClientID))
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not ClientStatusID = 24 Then
            tdInfoInvalid.Visible = True
            tdInfoValid.Visible = False
            phBody.Visible = False
        Else
            SetRollups()
            If Not IsPostBack Then
                LoadNotes()


                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(DataClientID)
                lnkClient.HRef = "~/clients/client/?id=" & DataClientID
            End If
        End If
    

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, clients_client).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""javascript:Record_Save();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Submit Resolution</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
    End Sub
    Private Sub LoadNotes()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotes2")
            Using cmd.Connection
                cmd.Connection.Open()

                DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
                DatabaseHelper.AddParameter(cmd, "OrderBy", "n.created desc")

                Using rd As IDataReader = cmd.ExecuteReader()
                    rpNotes.DataSource = rd
                    rpNotes.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Private Sub Close()
        Response.Redirect("~/clients/client/?id=" & DataClientID)
    End Sub

    Protected Sub lnkAction_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAction.Click
        If txtComment.Text.Length = 0 Then
            txtComment.BorderColor = Color.Red
            txtComment.BorderStyle = BorderStyle.Solid
            txtComment.BorderWidth = 2
        Else
            Dim pRoadmapID = DataHelper.Nz_int(DataHelper.FieldLookup("tblRoadmap", "RoadmapID", "ClientID=" & DataClientID & " and clientstatusid=21"))
            RoadmapHelper.InsertRoadmap(DataClientID, 23, pRoadmapID, txtComment.Text, UserID)
            NoteHelper.InsertNote(txtComment.Text, UserID, DataClientID)
            Close()
        End If
    End Sub

    
End Class