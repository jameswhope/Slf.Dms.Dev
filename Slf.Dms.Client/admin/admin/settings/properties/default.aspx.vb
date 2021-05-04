Option Explicit On

Imports Slf.Dms.Controls
Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_settings_properties_default
    Inherits System.Web.UI.Page

#Region "Variables"

    Protected WithEvents grdProperties As New PropertyGrid

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            BindPropertiesGrid()

            SetRollups()

        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Print();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ align=""absmiddle""/>Print these properties</a>")

    End Sub
    Private Sub BindPropertiesGrid()

        Dim rd As IDataReader
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetProperties")

        Try

            cmd.Connection.Open()

            rd = cmd.ExecuteReader

            While rd.Read

                Dim PropertyCategoryID As Integer = DatabaseHelper.Peel_int(rd, "PropertyCategoryID")
                Dim PropertyCategoryName As String = DatabaseHelper.Peel_string(rd, "PropertyCategoryName")

                Dim PropertyID As Integer = DatabaseHelper.Peel_int(rd, "PropertyID")
                Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                Dim Display As String = DatabaseHelper.Peel_string(rd, "Display")
                Dim Multi As Boolean = DatabaseHelper.Peel_bool(rd, "Multi")
                Dim Value As String = DatabaseHelper.Peel_string(rd, "Value")
                Dim Type As String = DatabaseHelper.Peel_string(rd, "Type")
                Dim Description As String = DatabaseHelper.Peel_string(rd, "Description")
                Dim Created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim CreatedBy As Integer = DatabaseHelper.Peel_int(rd, "CreatedBy")
                Dim CreatedByName As String = DatabaseHelper.Peel_string(rd, "CreatedByName")
                Dim LastModified As DateTime = DatabaseHelper.Peel_date(rd, "LastModified")
                Dim LastModifiedBy As Integer = DatabaseHelper.Peel_int(rd, "LastModifiedBy")
                Dim LastModifiedByName As String = DatabaseHelper.Peel_string(rd, "LastModifiedByName")

                grdProperties.AddProperty(PropertyCategoryID, PropertyCategoryName, PropertyID, Name, _
                    Display, Multi, Value, Type, Description, Created, CreatedBy, CreatedByName, _
                    LastModified, LastModifiedBy, LastModifiedByName)

            End While

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        pnlProperties.Controls.Add(grdProperties)

    End Sub
End Class