Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Data

Namespace App_Code

    Public Class StatsHelper

        Private sql As New SqlHelper

        Public Structure SourceData
            Public CampaignID As Integer
            Public SourceID As Integer
            Public OfferID As Integer
            Public UserID As Integer
            Public NewLeads As Integer
            Public Called As Integer
            Public Contacted As Integer
            Public PctContacted As Double
            Public NotContacted As Integer
            Public Dials As Integer
            Public DialsPerContact As Double
            Public CallTransfers As Integer
            Public PctCallTransfers As Double
            Public DataTransfers As Integer
            Public PctDataTransfers As Double
            Public TotalSales As Integer
        End Structure

        Public Sub New()

        End Sub


        Public Shared Function GetCounterTable(ByVal TableType As String, ByVal StartDate As DateTime, Optional ByVal EndDate As DateTime = #1/1/2050#, Optional ByVal CampaignID As Integer = -1, Optional ByVal OfferID As Integer = -1, Optional ByVal AssociateID As Integer = -1, Optional ByVal dsMaster As DataSet = Nothing) As DataTable
            Dim params As New List(Of SqlParameter)
            Dim strSQL As String = ""
            Dim dt As New DataTable
            Dim dr() As DataRow = Nothing
            Dim row As DataRow

            params.Add(New SqlParameter("@StartDate", StartDate))
            params.Add(New SqlParameter("@EndDate", EndDate))
            CampaignID = 150
            Select Case TableType.ToLower
                Case "todaysleadsonly"

                Case "summary"
                    strSQL = "stp_GetStatsCounter"
                    Return SqlHelper.GetDataTable(strSQL, CommandType.StoredProcedure, params.ToArray)
                Case "source"
                    dt = App_Code.StatsHelper.createCountDataTable()
                    For Each row In dsMaster.Tables("Counter").Select("CampaignID = " & CampaignID)
                        Dim nr As DataRow = dt.NewRow
                        nr("CampaignID") = row.Item(0).ToString
                        nr("Campaign") = row.Item(1).ToString
                        nr("OfferID") = row.Item(2).ToString
                        nr("SubmittedOfferID") = row.Item(3).ToString
                        nr("LeadID") = row.Item(4).ToString
                        nr("LeadName") = row.Item(5).ToString
                        nr("LeadOfferID") = row.Item(6).ToString
                        nr("UserID") = row.Item(7).ToString
                        nr("AgentName") = row.Item(8).ToString
                        nr("TransferType") = row.Item(9).ToString
                        nr("Buyer") = row.Item(10).ToString
                        nr("Offer") = row.Item(11).ToString
                        dt.Rows.Add(nr)
                    Next
                    'strSQL = "stp_GetSourceCounter"
                    'params.Add(New SqlParameter("@CampaignID", CampaignID))
                Case "offers"
                    dt = App_Code.StatsHelper.createCountDataTable()
                    For Each row In dsMaster.Tables("Counter").Select("CampaignID = " & CampaignID & " and OfferID = " & OfferID)
                        Dim nr As DataRow = dt.NewRow
                        nr("CampaignID") = row.Item(0).ToString
                        nr("Campaign") = row.Item(1).ToString
                        nr("OfferID") = row.Item(2).ToString
                        nr("SubmittedOfferID") = row.Item(3).ToString
                        nr("LeadID") = row.Item(4).ToString
                        nr("LeadName") = row.Item(5).ToString
                        nr("LeadOfferID") = row.Item(6).ToString
                        nr("UserID") = row.Item(7).ToString
                        nr("AgentName") = row.Item(8).ToString
                        nr("TransferType") = row.Item(9).ToString
                        nr("Buyer") = row.Item(10).ToString
                        nr("Offer") = row.Item(11).ToString
                        dt.Rows.Add(nr)
                    Next
                    'strSQL = "stp_GetOfferCounter"
                    'params.Add(New SqlParameter("@CampaignID", CampaignID))
                    'params.Add(New SqlParameter("@OfferID", OfferID))
                Case "associate"
                    params.Add(New SqlParameter("@AssociateID", AssociateID))
                Case Else

            End Select

            Return dt

        End Function

        Public Shared Function GetCampaignIDs() As DataTable
            Dim strSQL As String = "SELECT CampaignID, Campaign FROM tblCampaigns ORDER BY Campaign"
            Return SqlHelper.GetDataTable(strSQL, CommandType.Text)
        End Function

        Public Shared Function GetOfferIDs() As DataTable
            Dim strSQL As String = "SELECT OfferID, Offer FROM tblOffers ORDER BY Offer"
            Return SqlHelper.GetDataTable(strSQL, CommandType.Text)
        End Function

        Public Shared Function GetCampaignName(ByVal FilterCampaignID As Integer) As String
            Return SqlHelper.ExecuteScalar("SELECT Campaign FROM tblCampaigns WHERE CampaignID = " & FilterCampaignID, CommandType.Text)
        End Function

        Public Shared Function GetBaseData(ByVal TableType As String, ByVal StartDate As DateTime, Optional ByVal EndDate As DateTime = #1/1/2050#, Optional ByVal CampaignID As Integer = -1, Optional ByVal OfferID As Integer = -1, Optional ByVal AssociateID As Integer = -1) As DataTable
            Dim params As New List(Of SqlParameter)
            Dim strSQL As String = ""
            Dim dt As DataTable = Nothing

            params.Add(New SqlParameter("@StartDate", StartDate))
            params.Add(New SqlParameter("@EndDate", EndDate))

            Select Case TableType.ToLower
                Case "todaysleadsonly"

                Case "summary"
                    strSQL = "stp_GetBaseData"
                Case "source"
                    strSQL = "stp_GetSourceBaseData"
                    params.Add(New SqlParameter("@CampaignID", CampaignID))
                Case "offers"
                    strSQL = "stp_GetOfferBaseData"
                    params.Add(New SqlParameter("@CampaignID", CampaignID))
                    params.Add(New SqlParameter("@OfferID", OfferID))
                Case "associate"
                    params.Add(New SqlParameter("@AssociateID", AssociateID))
                Case Else

            End Select

            dt = SqlHelper.GetDataTable(strSQL, CommandType.StoredProcedure, params.ToArray)

            Return dt
        End Function

        Public Shared Function CreatePercentages(ByVal Divisor As Double, ByVal Dividend As Double) As Double
            Dim Quotent As Double
            If Divisor <= 0 Or Dividend <= 0 Then
                Return 0
            Else
                Quotent = Dividend / Divisor
            End If
            Return Quotent
        End Function

        Public Shared Function createLeadDataTable2() As DataTable
            Dim dt As New DataTable
            dt.Columns.Add("CampaignID")
            dt.Columns.Add("Lead Source")
            dt.Columns.Add("Offer")
            dt.Columns.Add("New Leads")
            dt.Columns.Add("Called")
            dt.Columns.Add("Contacted")
            dt.Columns.Add("% Contacted")
            dt.Columns.Add("No Contact")
            dt.Columns.Add("Dials")
            dt.Columns.Add("Dials per Contact")
            dt.Columns.Add("Call Transfers")
            dt.Columns.Add("% Call Transfers")
            dt.Columns.Add("Data Transfers")
            dt.Columns.Add("% Data Transfers")
            dt.Columns.Add("Total Sales")
            Return dt
        End Function

        Public Shared Function createCountDataTable() As DataTable
            Dim dt As New DataTable
            dt.Columns.Add("CampaignID")
            dt.Columns.Add("Campaign")
            dt.Columns.Add("OfferID")
            dt.Columns.Add("SubmittedOfferID")
            dt.Columns.Add("LeadID")
            dt.Columns.Add("LeadName")
            dt.Columns.Add("LeadOfferID")
            dt.Columns.Add("UserID")
            dt.Columns.Add("AgentName")
            dt.Columns.Add("TransferType")
            dt.Columns.Add("Buyer")
            dt.Columns.Add("Offer")
            Return dt
        End Function
        

    End Class
    Public Class DetailData

#Region "Fields"

        Private _GridCaption As String
        Private _GridViewName As String
        Private _GridviewData As String

#End Region 'Fields

#Region "Properties"

        Public Property GridCaption() As String
            Get
                Return _GridCaption
            End Get
            Set(ByVal value As String)
                _GridCaption = value
            End Set
        End Property

        Public Property GridViewName() As String
            Get
                Return _GridViewName
            End Get
            Set(ByVal value As String)
                _GridViewName = value
            End Set
        End Property

        Public Property GridviewData() As String
            Get
                Return _GridviewData
            End Get
            Set(ByVal value As String)
                _GridviewData = value
            End Set
        End Property

#End Region 'Properties

    End Class
End Namespace