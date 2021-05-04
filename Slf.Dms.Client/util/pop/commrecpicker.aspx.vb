Imports System.Data
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class util_pop_commrecpicker
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim ids() As String = Request.QueryString("ids").Split(",")
            Dim i As Integer
            Dim li As ListItem

            cblCommRecs.Items.Add(New ListItem("ALL", -99))

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT CommRecID, Display FROM tblCommRec WHERE IsTrust = 0 order by Display"
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                        While rd.Read()
                            cblCommRecs.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Display"), DatabaseHelper.Peel_int(rd, "CommRecID")))
                        End While
                    End Using
                End Using
            End Using

            For i = 0 To ids.Length - 1
                li = cblCommRecs.Items.FindByValue(ids(i))
                If Not li Is Nothing Then
                    li.Selected = True
                End If
            Next
        End If
    End Sub

    Protected Sub lnkDone_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDone.Click
        Dim li As ListItem
        Dim names As String = "None"
        Dim ids As String = "-1"

        For Each li In cblCommRecs.Items
            If li.Selected Then
                If li.Value = "-99" Then
                    ids = li.Value
                    names = li.Text
                    Exit For
                Else
                    If ids = "-1" Then
                        ids = li.Value
                    Else
                        ids &= "," & li.Value
                    End If
                    If names = "None" Then
                        names = li.Text
                    Else
                        names &= "<br>" & li.Text
                    End If
                End If
            End If
        Next

        ScriptManager.RegisterStartupScript(Me, Me.GetType, "Done", "window.opener.SelectCommRecs_Back('" & names & "','" & ids & "'); window.close();", True)
    End Sub
End Class
