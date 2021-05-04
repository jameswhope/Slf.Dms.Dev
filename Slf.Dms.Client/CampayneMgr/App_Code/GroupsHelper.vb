Imports System.Collections.Generic
Imports System.Data

Imports Microsoft.VisualBasic

Public Class GroupsHelper

    #Region "Enumerations"

    Public Enum enumMsgType
        msgError = 0
        msgInfo = 1
    End Enum

    #End Region 'Enumerations

    #Region "Methods"

    Public Shared Function FormatMsgText(ByVal msgText As String, ByVal msgType As enumMsgType) As String
        Select Case msgType
            Case enumMsgType.msgError
                Return String.Format("<div class=""ui-state-error ui-corner-all"" style=""padding: 0 .7em;""><p><span class=""ui-icon ui-icon-alert"" style=""float: left; margin-right: .3em;""></span> <strong>Alert:</strong> {0}</p></div>", msgText)
            Case Else
                Return String.Format("<div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;""><p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>{0}</p></div>", msgText)
        End Select
    End Function
    Public Shared Function getCampaigns(ByVal groupID As Integer) As DataTable
        Dim ssql As String = String.Format("stp_groups_getCampaigns {0}", groupID)
        Return SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
    End Function
    Public Shared Function getProducts(ByVal groupID As Integer) As DataTable
        Dim ssql As String = "select distinct gx.groupid, gx.ProductID, c.Campaign + ' \ ' + ProductCode [ProductCode] "
        ssql += "from tblgroupproductxref gx WITH(NOLOCK) "
        ssql += "inner join tblProducts p WITH(NOLOCK) ON gx.productid = p.ProductID "
        ssql += "inner join tblCampaigns c WITH(NOLOCK) ON c.CampaignID = p.CampaignID "
        ssql += String.Format("where gx.groupid = {0}", groupID)

        Return SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
    End Function

    Public Shared Function getUsers(ByVal groupID As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select userid, firstname + ' ' + Lastname[user] from tbluser where groupid = {0} order by firstname", groupID), Data.CommandType.Text)
    End Function

    Public Shared Function getBatches(ByVal groupID As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select gbx.DataBatchID, db.BatchName from tblGroupsDataBatchXref gbx WITH(NOLOCK) inner JOIN tblDataBatch db WITH(NOLOCK) on gbx.databatchid = db.DataBatchID where gbx.groupid = {0}", groupID), Data.CommandType.Text)
    End Function

    Public Shared Function getOffers(ByVal groupID As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select o.OfferID, o.Offer from tblGroupOfferXref x join tblOffers o on o.OfferID = x.OfferID where x.GroupID = {0} order by Offer", groupID), Data.CommandType.Text)
    End Function

    #End Region 'Methods

End Class