Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Partial Class processing_popups_EmailCheckByPhone
    Inherits System.Web.UI.Page

#Region "Declaration"
    Public SettlementID As Integer = 0
    Public PaymentID As Integer = 0
#End Region

#Region "Events"
    ''' <summary>
    ''' Loads the content of the page
    ''' </summary>    
    ''' <remarks>sid is the settlementId</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.QueryString("sid") Is Nothing Then
            SettlementID = Integer.Parse(Request.QueryString("sid"))
        End If
        If Not Request.QueryString("pmtid") Is Nothing Then
            PaymentID = Integer.Parse(Request.QueryString("pmtid"))
        End If
    End Sub

#End Region



End Class
