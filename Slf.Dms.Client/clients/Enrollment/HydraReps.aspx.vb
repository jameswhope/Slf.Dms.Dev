
Partial Class Clients_Enrollment_HydraReps
    Inherits System.Web.UI.Page

    Public SupID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        For Each li As ListItem In lbAvailable.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("insert tblhydrareps (userid) values ({0})", li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailable.DataBind()
        lbHydra.DataBind()
    End Sub

    Protected Sub btnAddRGR_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddRGR.Click
        For Each li As ListItem In lbAvailableRGR.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("insert tblrgrreps (userid) values ({0})", li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailableRGR.DataBind()
        lbRGR.DataBind()
    End Sub

    Protected Sub btnAddSup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSup.Click
        For Each li As ListItem In lbAvailableSup.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("insert tblsupreps (userid) values ({0})", li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailableSup.DataBind()
        lbSup.DataBind()
        lbTeam.DataSource = SqlHelper.GetDataTable("select firstname+' '+lastname[name],u.userid from tbluser u join tblsupteam t on t.repid = u.userid and t.supid = -1 order by [name]")
        lbTeam.DataBind()
        hTeam.InnerHtml = "(No supervisor selected)"
        btnAddToTeam.Enabled = False
        btnRemoveFromTeam.Enabled = False
    End Sub

    Protected Sub btnAddToTeam_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddToTeam.Click
        For Each li As ListItem In lbAvailableSup.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("insert tblsupteam (supid,repid) values ({0},{1})", lbSup.SelectedItem.Value, li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailableSup.DataBind()
        lbTeam.DataSource = SqlHelper.GetDataTable(String.Format("select firstname+' '+lastname[name],u.userid from tbluser u join tblsupteam t on t.repid = u.userid and t.supid = {0} order by [name]", lbSup.SelectedItem.Value))
        lbTeam.DataBind()
    End Sub

    Protected Sub btnRemove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemove.Click
        Dim count As Integer

        For Each li As ListItem In lbHydra.Items
            If li.Selected Then
                count += 1
            End If
        Next

        If count = lbHydra.Items.Count Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType, "hydra1", "alert('At least 1 Hydra rep must exist.');", True)
        Else
            For Each li As ListItem In lbHydra.Items
                If li.Selected Then
                    SqlHelper.ExecuteNonQuery(String.Format("delete from tblhydrareps where userid={0}", li.Value), Data.CommandType.Text)
                End If
            Next
        End If

        lbAvailable.DataBind()
        lbHydra.DataBind()
    End Sub

    Protected Sub btnRemoveRGR_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveRGR.Click
        'Dim count As Integer

        'For Each li As ListItem In lbRGR.Items
        '    If li.Selected Then
        '        count += 1
        '    End If
        'Next

        'If count = lbRGR.Items.Count Then
        '    ScriptManager.RegisterStartupScript(Me, Me.GetType, "rgr1", "alert('At least 1 RGR rep must exist.');", True)
        'Else
        For Each li As ListItem In lbRGR.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("delete from tblrgrreps where userid={0}", li.Value), Data.CommandType.Text)
            End If
        Next
        'End If

        lbAvailableRGR.DataBind()
        lbRGR.DataBind()
    End Sub

    Protected Sub btnRemoveSup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveSup.Click
        SqlHelper.ExecuteNonQuery(String.Format("delete from tblsupreps where userid={0}", lbSup.SelectedItem.Value), Data.CommandType.Text)
        SqlHelper.ExecuteNonQuery(String.Format("delete from tblsupteam where supid={0}", lbSup.SelectedItem.Value), Data.CommandType.Text)
        lbAvailableSup.DataBind()
        lbSup.DataBind()
        lbTeam.DataSource = SqlHelper.GetDataTable("select firstname+' '+lastname[name],u.userid from tbluser u join tblsupteam t on t.repid = u.userid and t.supid = -1 order by [name]")
        lbTeam.DataBind()
        hTeam.InnerHtml = "(No supervisor selected)"
        btnAddToTeam.Enabled = False
        btnRemoveFromTeam.Enabled = False
    End Sub

    Protected Sub btnRemoveFromTeam_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveFromTeam.Click
        For Each li As ListItem In lbTeam.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("delete from tblsupteam where repid={0}", li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailableSup.DataBind()
        lbTeam.DataSource = SqlHelper.GetDataTable(String.Format("select firstname+' '+lastname[name],u.userid from tbluser u join tblsupteam t on t.repid = u.userid and t.supid = {0} order by [name]", lbSup.SelectedItem.Value))
        lbTeam.DataBind()
    End Sub

    Protected Sub lbSup_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbSup.DataBound
        If Not Page.IsPostBack Then
            If lbSup.Items.Count > 0 Then
                lbSup.Items(0).Selected = True
                hTeam.InnerHtml = lbSup.Items(0).Text & "'s Team"
                lbTeam.DataSource = SqlHelper.GetDataTable(String.Format("select firstname+' '+lastname[name],u.userid from tbluser u join tblsupteam t on t.repid = u.userid and t.supid = {0} order by [name]", lbSup.Items(0).Value))
                lbTeam.DataBind()
            End If
        End If
    End Sub

    Protected Sub lbSup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbSup.SelectedIndexChanged
        Dim li As ListItem = lbSup.SelectedItem
        hTeam.InnerHtml = li.Text & "'s Team"
        lbTeam.DataSource = SqlHelper.GetDataTable(String.Format("select firstname+' '+lastname[name],u.userid from tbluser u join tblsupteam t on t.repid = u.userid and t.supid = {0} order by [name]", li.Value))
        lbTeam.DataBind()
        btnAddToTeam.Enabled = True
        btnRemoveFromTeam.Enabled = True
    End Sub

    Protected Sub btnAddCloser_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddCloser.Click
        For Each li As ListItem In lbAvailReps.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery("update tbluser set usergroupid = 25 where userid = " & li.Value, Data.CommandType.Text)
            End If
        Next
        lbAvailReps.DataBind()
        lbClosers.DataBind()
    End Sub

    Protected Sub btnRemoveCloser_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveCloser.Click
        Dim count As Integer

        For Each li As ListItem In lbClosers.Items
            If li.Selected Then
                count += 1
            End If
        Next

        If count = lbClosers.Items.Count Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType, "closer1", "alert('At least 1 closer must exist.');", True)
        Else
            For Each li As ListItem In lbClosers.Items
                If li.Selected Then
                    SqlHelper.ExecuteNonQuery("update tbluser set usergroupid = 1 where userid = " & li.Value, Data.CommandType.Text)
                End If
            Next
        End If

        lbAvailReps.DataBind()
        lbClosers.DataBind()
    End Sub

    Protected Sub btnAddTest_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTest.Click
        For Each li As ListItem In lbAvailTest.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("insert tbltestreps (userid) values ({0})", li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailTest.DataBind()
        lbTest.DataBind()
    End Sub

    Protected Sub btnRemoveTest_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRemoveTest.Click
        For Each li As ListItem In lbTest.Items
            If li.Selected Then
                SqlHelper.ExecuteNonQuery(String.Format("delete from tbltestreps where userid={0}", li.Value), Data.CommandType.Text)
            End If
        Next
        lbAvailTest.DataBind()
        lbTest.DataBind()
    End Sub
End Class
