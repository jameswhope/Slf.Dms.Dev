Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Linq
Partial Class processing_popups_AccountingPAApproval
    Inherits System.Web.UI.Page
    Public UserID As Integer
    Public PaymentId As Integer


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Request.QueryString("pmtid") Is Nothing Then
            Throw New Exception("A payment id is required")
        Else
            PaymentId = Integer.Parse(Request.QueryString("pmtid"))
        End If

        If Not Page.IsPostBack Then
            Me.SettCalcs.LoadSettlementInfo(PaymentId)
        End If

    End Sub

End Class
