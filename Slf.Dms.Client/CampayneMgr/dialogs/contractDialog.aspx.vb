Imports System.Data

Partial Class dialogs_contractDialog
    Inherits System.Web.UI.Page

#Region "Fields"

    Private _ContractID As Integer
    Private _buyerid As Integer
    Public UserID As Integer
#End Region 'Fields

#Region "Properties"

    Public Property Buyerid() As Integer
        Get
            Return _buyerid
        End Get
        Set(ByVal value As Integer)
            _buyerid = value
        End Set
    End Property

    Public Property ContractID() As Integer
        Get
            Return _ContractID
        End Get
        Set(ByVal value As Integer)
            _ContractID = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    Protected Sub dialogs_contractDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Page.User.Identity.Name

        If Not IsNothing(Request.QueryString("bxid")) Then
            ContractID = Request.QueryString("bxid").ToString
        End If

        Using bxo As BuyerHelper.BuyerContractObject = BuyerHelper.BuyerContractObject.getBuyerContract(ContractID)
            Buyerid = bxo.BuyerID
            txtContractName.Text = bxo.ContractName
            txtServiceTelNum.Text = bxo.ServicePhoneNumber
            txtDailyCap.Text = bxo.DailyCap
            txtInstructions.Text = bxo.Instructions
            txtPrice.Text = bxo.Price
            ddlPriority.SelectedValue = bxo.Priority
            txtWeight.Text = bxo.Weight
            ddlSortField.SelectedValue = bxo.DataSortField
            ddlSortDir.SelectedValue = bxo.DataSortDir
            ddlContractType.SelectedValue = bxo.ContractTypeID
            ddlWebsiteType.SelectedValue = bxo.WebsiteTypeid
            ddlDupAttempt.SelectedValue = bxo.DupAttempt
            txtPointValue.Text = bxo.PointValue
            chkExclusive.Checked = bxo.Exclusive
            chkContractActive.Checked = bxo.Active
            'chkdocakepost.Checked = bxo.DoCakePost 'Obsolete
            chkthrottle.Checked = bxo.Throttle
            chkCallCenter.Checked = bxo.CallCenter
            chkDataTransfer.Checked = bxo.DataTransfer
            chkCallTransfer.Checked = bxo.CallTransfer
            chkNoScrub.Checked = bxo.NoScrub
            txtInvoicePrice.Text = bxo.InvoicePrice
            rdoExcludeDNC.Checked = bxo.ExcludeDNC
            rdoWirelessOnly.Checked = bxo.WirelessOnly
            rdoLandlineOnly.Checked = bxo.LandlineOnly
            LoadOffers(bxo.OfferID, bxo.Offer)
            LoadDataQueries(bxo.OfferID, bxo.DataSQL)
            LoadTime(bxo.RealTimeMinutes, bxo.AgedMinutes)
        End Using

        Dim tooltipStr As String
        tooltipStr = "Used for both Call Center and Data contracts:" & vbCrLf
        tooltipStr += "•  For Call Center contracts, check if buyer needs the lead posted to them." & vbCrLf
        tooltipStr += "•  For Data contracts, this option MUST be checked."
        imgDataTrans.ToolTip = tooltipStr
    End Sub

    Private Sub LoadOffers(OfferID As Integer, Offer As String)
        Dim tblOffers As DataTable = SqlHelper.GetDataTable("SELECT OfferID, Offer FROM tblOffers WHERE Active = 1 and Tag in ('Data','Live Transfer','List Management') ORDER BY Offer")

        If tblOffers.Select("OfferID = " & OfferID).Length = 0 Then
            Dim row As DataRow
            row = tblOffers.NewRow
            row("OfferID") = OfferID
            row("Offer") = Offer
            tblOffers.Rows.Add(row)
            tblOffers.AcceptChanges()
        End If

        With ddlOffers
            .DataSource = tblOffers
            .DataBind()
        End With

        Dim li As ListItem = ddlOffers.Items.FindByValue(OfferID)
        If Not IsNothing(li) Then
            li.Selected = True
        End If
    End Sub

    Private Sub LoadDataQueries(OfferID As Integer, DataSql As String)
        Dim d As List(Of String()) = OfferHelper.GetDataQueries(OfferID)

        For Each s() As String In d
            ddlDataSql.Items.Add(New ListItem(s(0), s(1)))
        Next

        Dim li As ListItem = ddlDataSql.Items.FindByValue(DataSql)
        If Not IsNothing(li) Then
            li.Selected = True
        End If
    End Sub

    Private Sub LoadTime(RealTime As Integer, Aged As Integer)

        Dim li As ListItem = ddlRealTimeMinutes.Items.FindByValue(RealTime)
        If Not IsNothing(li) Then
            li.Selected = True
        Else
            ddlRealTimeMinutes.SelectedIndex = 0
        End If

        Dim lis As ListItem = ddlAgedMinutes.Items.FindByValue(Aged)
        If Not IsNothing(li) Then
            lis.Selected = True
        Else
            ddlAgedMinutes.SelectedIndex = 0
        End If

    End Sub

    Protected Sub chkTrafficTypes_DataBound(sender As Object, e As System.EventArgs) Handles chkTrafficTypes.DataBound
        Dim tbl As DataTable = BuyerHelper.GetTrafficTypes(ContractID)
        Dim li As ListItem

        For Each row As DataRow In tbl.Rows
            li = Nothing
            li = chkTrafficTypes.Items.FindByValue(row("TrafficTypeID"))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
        Next
    End Sub

    Protected Sub chkQuestions_DataBound(sender As Object, e As System.EventArgs) Handles chkQuestions.DataBound
        Dim tbl As DataTable = BuyerHelper.GetQuestions(ContractID)
        Dim li As ListItem

        For Each row As DataRow In tbl.Rows
            li = Nothing
            li = chkQuestions.Items.FindByText(row("Question"))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
        Next
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Shared Sub SaveQuestions(BuyerOfferXrefID As Integer, Questions As String)
        Dim q() As String = Split(Questions, "|")
        Dim cmdText As New Text.StringBuilder

        cmdText.Append("delete from tblQuestionBuyerXref where BuyerOfferXrefID = " & BuyerOfferXrefID & "; ")

        For i As Integer = 0 To q.Length - 2
            Dim s() As String = Split(q(i), " - ")
            cmdText.Append(String.Format("insert tblQuestionBuyerXref (BuyerOfferXrefID,QuestionPlainText,OptionText) values ({0},'{1}','{2}'); ", BuyerOfferXrefID, s(0), s(1)))
        Next

        SqlHelper.ExecuteNonQuery(cmdText.ToString, CommandType.Text)
    End Sub

    Protected Sub chkWebsites_DataBound(sender As Object, e As System.EventArgs) Handles chkWebsites.DataBound
        Dim tbl As DataTable = BuyerHelper.GetWebsites(ContractID)
        Dim li As ListItem

        For Each row As DataRow In tbl.Rows
            li = Nothing
            li = chkWebsites.Items.FindByValue(row("WebsiteID"))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
        Next
    End Sub

    Protected Sub ddlWebsiteType_DataBound(sender As Object, e As System.EventArgs) Handles ddlWebsiteType.DataBound
        With chkWebsites
            .DataSource = SqlHelper.GetDataTable(String.Format("SELECT WebsiteID, Name FROM tblWebsites where Type = {0} ORDER BY Name", ddlWebsiteType.SelectedItem.Value))
            .DataBind()
        End With
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Shared Function GetDeliveryMethodFields() As String
        Dim tbl As DataTable = SqlHelper.GetDataTable("select FieldID, DisplayText from tblDeliveryMethodFields order by DisplayText")
        Return jsonHelper.ConvertDataTableToJSON(tbl)
    End Function

#End Region 'Methods

End Class