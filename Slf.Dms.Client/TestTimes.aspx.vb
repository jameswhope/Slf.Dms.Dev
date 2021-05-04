
Partial Class TestTimes
    Inherits System.Web.UI.Page

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        SqlHelper.ExecuteNonQuery("insert tblServerTimes values ('" & Now & "',getdate())", Data.CommandType.Text)
    End Sub
End Class
