Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Data

Partial Class tasks_task_propagations
    Inherits System.Web.UI.Page

#Region "Variables"

    Private TaskID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            TaskID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then

                LoadTaskTypes(cboTaskType, 0)
                'LoadPropagations()

            End If

        End If

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
    Private Sub LoadTaskTypes(ByRef cboTaskType As DropDownList, ByVal SelectedTaskTypeID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskType"

        cboTaskType.Items.Clear()

        cboTaskType.Items.Add(New ListItem(" -- Ad Hoc -- ", 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskTypeID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboTaskType, SelectedTaskTypeID)

    End Sub
End Class