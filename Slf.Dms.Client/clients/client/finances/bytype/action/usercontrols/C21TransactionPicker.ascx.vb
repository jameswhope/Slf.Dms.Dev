Imports Infragistics.WebUI.UltraWebGrid
Imports System.Configuration
Imports System.Data
Imports Drg.Util.DataAccess

Partial Class Clients_client_finances_bytype_action_usercontrols_C21TransactionPicker
    Inherits System.Web.UI.UserControl

    Public ReadOnly Property SelectedTransactionId() As String
        Get
            If Me.ug_C21Transactions.DisplayLayout.ActiveRow Is Nothing Then
                Return ""
            Else
                Return Me.ug_C21Transactions.DisplayLayout.ActiveRow.GetCellValue(Me.ug_C21Transactions.Columns(0)).ToString()
            End If
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.hdnImagePath.Value = ConfigurationManager.AppSettings("C21ImageVirtualPath").ToString

        If Not Me.IsPostBack Then
            Me.ug_C21Transactions.DataBind()
            ShowHidden()
        End If
    End Sub

    Private Sub ShowHidden()
        For Each r As Infragistics.WebUI.UltraWebGrid.UltraGridRow In ug_C21Transactions.Rows
            If r.Cells.FromKey("Hide").Value = True Then
                r.Hidden = True
            End If
        Next
    End Sub

    Protected Sub lnkHideC21_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkHideC21.Click
        Dim args As String() = Me.hdnHideTransArgs.Value.Split("|")
        Try
            'Write to DB
            HideTransaction(args(1), args(0))
        Catch ex As Exception
            'Ignore Error
        End Try
    End Sub

    Private Sub HideTransaction(ByVal TransactionId As String, ByVal Hide As Integer)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = String.Format("Update tblC21BatchTransaction Set Hide = {1} WHERE TransactionId= '{0}' ", TransactionId, Hide)
            Using cn As IDbConnection = cmd.Connection
                cn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

End Class
