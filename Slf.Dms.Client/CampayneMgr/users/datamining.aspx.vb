Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Linq
Imports System.Xml

Imports DataMiningHelper

Imports SurveyHelper

Partial Class admin_datamining
    Inherits System.Web.UI.Page

    #Region "Properties"

    Public Property DataBatchID() As Integer
        Get
            Return ViewState("DataBatchID")
        End Get
        Set(ByVal value As Integer)
            ViewState("DataBatchID") = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return ViewState("_userid")
        End Get
        Set(ByVal value As Integer)
            ViewState("_userid") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub admin_datamining_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)

        BindGrid()

        ddlSurvey.Attributes.Add("onchange", "return LoadQuestionsAjax();")
    End Sub

    Protected Sub gvBatch_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvBatch.RowCommand
        Select Case e.CommandName.ToLower
            Case "select", "edit", "add"
                DataBatchID = e.CommandArgument
                Dim lnk As LinkButton = tdQuestions.FindControl("lnkAddQuestion")
                lnk.OnClientClick = String.Format("return ShowQuestions('{0}');", DataBatchID)
        End Select
    End Sub

    Protected Sub gvBatch_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvBatch.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim dbid As String = rowView("databatchid").ToString

                'Dim ds As SqlDataSource = e.Row.FindControl("dsQuestions")
                'Dim gv As GridView = e.Row.FindControl("gvQuestions")
                'ds.SelectParameters("batchid").DefaultValue = dbid
                'ds.DataBind()
                'gv.DataBind()

                Dim lnkE As LinkButton = e.Row.FindControl("lnkEdit")
                Dim lnkV As LinkButton = e.Row.FindControl("lnkView")
                Dim lnkA As LinkButton = e.Row.FindControl("lnkAddQuestion")
                If Not IsNothing(lnkE) Then
                    lnkE.OnClientClick = String.Format("return ShowEditBatch({0},'{1}','{2}');", dbid, rowView("batchname").ToString, rowView("active").ToString)
                End If
                If Not IsNothing(lnkV) Then
                    lnkV.OnClientClick = String.Format("return viewData({0});", dbid)
                End If
                If Not IsNothing(lnkA) Then
                    lnkA.OnClientClick = String.Format("return showAddQuestion({0});", dbid)
                End If

        End Select
    End Sub
    Private Sub BindGrid()
        dsBatch.DataBind()
        gvBatch.DataBind()
    End Sub
    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvBatch.DataBind()
        gvQuestions.DataBind()
    End Sub
    #End Region 'Methods

    
End Class