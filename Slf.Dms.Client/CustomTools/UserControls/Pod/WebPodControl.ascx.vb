Imports System.Data

Partial Class CustomTools_UserControls_WebPodControl
    Inherits System.Web.UI.UserControl

    #Region "Fields"

    Private _UserID As Integer
    Private _myData As String = ""

    #End Region 'Fields

    #Region "Enumerations"

    Public Enum enumMsgType
        Success = 0
        Warning = 1
        Info = 3
        Other = 4
    End Enum

    #End Region 'Enumerations

    #Region "Properties"

    Public Property UserID() As Integer
        Get
            Return _UserID
        End Get
        Set(ByVal value As Integer)
            _UserID = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As System.Web.UI.WebControls.Label = TryCast(gvPagerRow.FindControl("lblNumber"), System.Web.UI.WebControls.Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                gv.DataBind()
            End If
        End Using
    End Sub

    Public Sub showMsg(ByVal msgText As String, ByVal msgType As enumMsgType)
        Dim msgClass As String = msgType.ToString
        If msgType = enumMsgType.Other Then
            msgClass = "error"
        End If
        divMsg.Attributes("class") = msgClass
        divMsg.InnerHtml = msgText
    End Sub

    Protected Sub CustomTools_UserControls_WebPodControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        If Not IsPostBack Then

        End If
    End Sub

    Protected Sub gvNegotiators_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNegotiators.RowCommand
        Select Case e.CommandName.ToLower
            Case "update".ToLower
                Try
                    Dim ddl As DropDownList = gvNegotiators.Rows(e.CommandArgument).FindControl("ddlGroups")
                    Dim pid As Integer = ddl.SelectedItem.Value
                    Dim uid As Integer = gvNegotiators.DataKeys(e.CommandArgument)(1)
                    Dim bSup As Integer = TryCast(gvNegotiators.Rows(e.CommandArgument).Cells(5).Controls(0), CheckBox).Checked
                    Dim negname As String = gvNegotiators.Rows(e.CommandArgument).Cells(4).Text

                    Dim sqlupdate As New StringBuilder
                    sqlupdate.Append("update tblnegotiationentity set ")
                    sqlupdate.AppendFormat("ParentNegotiationEntityID = {0},", pid)
                    sqlupdate.AppendFormat("IsSupervisor={0} ", bSup)
                    sqlupdate.AppendFormat("where NegotiationEntityID = {0}", uid)

                    SqlHelper.ExecuteNonQuery(sqlupdate.ToString, CommandType.Text)
                    showMsg(String.Format("Team updated to {0} for {1}!", ddl.SelectedItem.Text, negname), enumMsgType.Success)
                Catch ex As Exception
                    showMsg(String.Format("Ooops! <br>{0}", ex.Message.ToString), enumMsgType.Other)
                End Try
            Case "delete".ToLower
                Try
                    Dim uid As Integer = gvNegotiators.DataKeys(e.CommandArgument)(1)
                    Dim negname As String = gvNegotiators.Rows(e.CommandArgument).Cells(4).Text
                    Dim sqlupdate As New StringBuilder
                    sqlupdate.AppendFormat("update tblnegotiationentity set deleted = 1 where NegotiationEntityID = {0}", uid)
                    SqlHelper.ExecuteNonQuery(sqlupdate.ToString, CommandType.Text)
                    showMsg(String.Format("{0} deleted!", negname), enumMsgType.Success)
                Catch ex As Exception
                    showMsg(String.Format("Ooops! <br>{0}", ex.Message.ToString), enumMsgType.Other)
                End Try

        End Select
    End Sub

    Protected Sub gvNegotiators_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNegotiators.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvNegotiators, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvNegotiators_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNegotiators.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")


        End Select
    End Sub

    Protected Sub lnkSaveNeg_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveNeg.Click
        Try
            Dim sqlTeam As New StringBuilder
            sqlTeam.Append("INSERT INTO [tblNegotiationEntity] ([Type],[Name],[ParentNegotiationEntityID],[ParentType],[UserID],[ClientX],[ClientY],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[Deleted],[LastRefresh])")
            sqlTeam.AppendFormat("VALUES ('Person','{0}',", ddlNewNegotiatorName.SelectedItem.Text)
            sqlTeam.AppendFormat("{0},'Group',{1},Null,Null,getdate(),{2},getdate(),{2},0,getdate())", ddlNewNegTeam.SelectedItem.Value, ddlNewNegotiatorName.SelectedItem.Value, UserID)
            SqlHelper.ExecuteNonQuery(sqlTeam.ToString, CommandType.Text)

            showMsg(String.Format("{0} sucessfully created in team {1}!", ddlNewNegotiatorName.SelectedItem.Text, ddlNewNegTeam.SelectedItem.Text), enumMsgType.Success)

        Catch ex As Exception
            showMsg(String.Format("Ooops! <br>{0}", ex.Message.ToString), enumMsgType.Other)
        End Try
    End Sub

    Protected Sub lnkSaveTeam_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveTeam.Click
        Try
            Dim sqlTeam As New StringBuilder
            sqlTeam.Append("INSERT INTO [tblNegotiationEntity] ([Type],[Name],[ParentNegotiationEntityID],[ParentType],[UserID],[ClientX],[ClientY],[Created],[CreatedBy],[LastModified],[LastModifiedBy],[Deleted],[LastRefresh])")
            sqlTeam.AppendFormat("VALUES ('Group','{0}',139,'Person',Null,Null,Null,getdate(),{1},getdate(),{1},0,getdate())", txtNewTeamName.Text, UserID)
            SqlHelper.ExecuteNonQuery(sqlTeam.ToString, CommandType.Text)
            showMsg(String.Format("{0} sucessfully created!", txtNewTeamName.Text), enumMsgType.Success)
        Catch ex As Exception
            showMsg(String.Format("Ooops! <br>{0}", ex.Message.ToString), enumMsgType.Other)
        End Try
    End Sub

    #End Region 'Methods

    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click
      
        dsNegotiators.DataBind()
        gvNegotiators.DataBind()


    End Sub

    Protected Sub dsNegotiators_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles dsNegotiators.Selecting
        Dim searchTerm As String = txtSearch.Text
        If searchTerm <> "" Then
            dsNegotiators.FilterExpression = String.Format("name like '%{0}%' or ParentName like '%{0}%'", searchTerm)
        End If

    End Sub

    Protected Sub lnkResetSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResetSearch.Click
        txtSearch.Text = ""
        dsNegotiators.DataBind()
        gvNegotiators.DataBind()

    End Sub
End Class