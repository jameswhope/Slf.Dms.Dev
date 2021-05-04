Imports System.IO
Imports System.Net
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml

Public Class CakeHelper

    Public Shared Function POSTLead(ByVal LeadID As Integer, ByVal OfferID As LeadHelper.OfferType, ByRef ResultDesc As String, ByVal SubmittedBy As Integer, Optional ByRef SubmittedOfferID As Integer = -1, Optional ByVal BuyerID As Integer = -1, Optional ByVal CallTransfer As Boolean = False) As Boolean
        Dim valid As Boolean
        Dim tbl As DataTable
        Dim row As DataRow
        Dim reqUri As String
        Dim req As HttpWebRequest
        Dim postData As String
        Dim CakeLeadId As String = ""
        Dim xmlDoc As New XmlDocument
        Dim node As XmlNode
        Dim ResultCode As String = ""
        Dim name() As String
        Dim CakeId As Integer
        Dim PostKey As String = ""
        Dim OfferFields As String = ""
        Dim rep As String
        Dim CampaignID As Integer = 100 'Identifyle(default)
        Dim email As String

        Try
            tbl = LeadHelper.LeadOfferDetail(LeadID, OfferID)
            row = tbl.Rows(0)

            If Not IsDBNull(row("campaignid")) Then
                CampaignID = CInt(row("campaignid"))
            End If

            GetPostKeys(OfferID, BuyerID, CampaignID, CakeId, PostKey)

            If PostKey = "" Then
                Throw New Exception("Cake Campaign not setup!")
            End If

            rep = CampayneHelper.FirstNameLastInitial(SubmittedBy)

            Select Case OfferID
                Case LeadHelper.OfferType.Bankruptcy
                    OfferFields = "&total_debt=" & row("TotalDebt")

                Case LeadHelper.OfferType.Debt
                    OfferFields = "&cc_debt=" & row("TotalDebt")

                Case LeadHelper.OfferType.Education
                    OfferFields = "&rep_id=" & SubmittedBy _
                        & "&edu_level=" & row("EduLevel").ToString _
                        & "&program=" & row("Program").ToString _
                        & "&subject=" & row("Subject").ToString _
                        & "&goal=" & row("Goal").ToString _
                        & "&grad_year=" & row("GradYear").ToString _
                        & "&start_date=" & row("StartDate").ToString

                    If Not IsDBNull(row("DOB")) Then
                        OfferFields &= "&birthdate=" & Format(CDate(row("DOB")), "yyyy-MM-dd")
                    End If

                Case LeadHelper.OfferType.LoanMod
                    OfferFields = "&house_type=" & row("HouseType").ToString _
                        & "&house_value=" & row("HouseValue").ToString _
                        & "&mortgage_balance=" & row("MortgageBal").ToString _
                        & "&mortgage_payment=" & row("MortgagePayment").ToString _
                        & "&credit_status=" & row("CreditStatus").ToString _
                        & "&interest_rate=" & row("CurIntRate").ToString _
                        & "&loan_type=" & row("DesiredLoanType").ToString _
                        & "&property_use=" & row("PropertyUse").ToString _
                        & "&late_payments=" & row("LatePayments").ToString _
                        & "&annual_income=" & row("AnnualIncome").ToString _
                        & "&lender=" & row("Lender").ToString

                Case LeadHelper.OfferType.Tax
                    OfferFields = "&tax_debt=" & row("TaxDebt")

                Case Else 'LeadHelper.OfferType.CreditRepair, LeadHelper.OfferType.EduSearch, LeadHelper.OfferType.EduGED
                    'no offer specific fields to add

                    'Case Else
                    'Throw New Exception("Offer Type not setup!")
            End Select

            name = Split(row("fullname").ToString, " ")
            email = CStr(row("Email"))

            If BuyerID = LeadHelper.Buyer.Plattform Then
                Dim cnt As Integer = LeadHelper.ValidBuyerSubmissions(LeadID, BuyerID)
                If cnt > 0 Then
                    'need to create a unqiue email addy since we are posting dup leads into Cake
                    'this data is not being posted to the buyer in Cake so this is okay
                    email = Replace(email, "@", CStr(cnt + 1) & "@")
                End If
            End If

            postData = "&ckm_key=" & PostKey _
                & "&ckm_subid=" & rep _
                & "&first_name=" & name(0) _
                & "&last_name=" & name(name.Length - 1) _
                & "&email_address=" & email _
                & "&phone_home=" & row("Phone") _
                & "&address=" & row("address") _
                & "&city=" & row("city") _
                & "&state=" & row("StateCode") _
                & "&zip_code=" & row("ZipCode") _
                & OfferFields _
                & "&ckm_test=1"

            '**need to pass in as a vertical field
            'If Len(row("adsrc").ToString.Replace("NA", "")) > 0 Then
            '    postData &= "&s2=" & row("adsrc").ToString.Replace("NA", "")
            'End If

            reqUri = String.Concat(AppSettings("CakePOST"), "?ckm_campaign_id=", CakeId)
            req = WebRequest.Create(reqUri)
            req.Method = "POST"
            req.ContentType = "application/x-www-form-urlencoded"
            req.ContentLength = postData.Length

            Dim encoding As New ASCIIEncoding
            Dim data() As Byte = encoding.GetBytes(postData)
            Dim stream As IO.Stream = req.GetRequestStream
            stream.Write(data, 0, data.Length) 'send the data
            stream.Close()

            Dim resp As HttpWebResponse = req.GetResponse
            Dim sr As New StreamReader(resp.GetResponseStream)
            Dim results As String = sr.ReadToEnd
            sr.Close()

            xmlDoc.LoadXml(results)
            ResultCode = xmlDoc.SelectSingleNode("result/code").InnerText

            Select Case ResultCode
                Case "0" 'success
                    CakeLeadId = xmlDoc.SelectSingleNode("result/leadid").InnerText
                    LeadHelper.UpdateCakeId(LeadID, CakeLeadId)
                    ResultDesc = "Lead transferred successfully."
                    valid = True
                Case "1" 'error
                    For Each node In xmlDoc.SelectNodes("result/errors/error")
                        ResultDesc &= String.Concat(node.InnerText, ". ")
                    Next
            End Select

            If BuyerID = -1 Then
                'dunno who the buyer is (data only), Cake will figure that out
                BuyerID = LeadHelper.Buyer.Cake
            End If

            SubmittedOfferID = LeadHelper.InsertSubmittedOffer(LeadID, OfferID, BuyerID, ResultCode, ResultDesc, CakeLeadId, valid, SubmittedBy, CallTransfer)
        Catch ex As Exception
            LeadHelper.LogError("CakeHelper.SendLead", ex.Message, ex.StackTrace, LeadID)
            ResultDesc = "There was an error transferring this offer. Please notify support."
        End Try

        Return valid
    End Function

    Private Shared Sub GetPostKeys(ByVal OfferId As Integer, ByVal BuyerID As Integer, ByVal CampaignID As Integer, ByRef CakeId As Integer, ByRef PostKey As String)
        Dim params As New List(Of SqlParameter)
        Dim tbl As DataTable

        params.Add(New SqlParameter("offerid", OfferId))
        params.Add(New SqlParameter("buyerid", BuyerID))
        params.Add(New SqlParameter("campaignid", CampaignID))

        tbl = SqlHelper.GetDataTable("stp_GetCakePostKeys", CommandType.StoredProcedure, params.ToArray)

        If tbl.Rows.Count = 1 Then
            CakeId = CInt(tbl.Rows(0)("CakeId"))
            PostKey = CStr(tbl.Rows(0)("PostKey"))
        End If
    End Sub

    Public Shared Function GetCakeCampaignToSync() As DataTable
        Dim sb As New StringBuilder
        sb.AppendLine("select distinct k.CampaignId, c.Campaign, k.BuyerID, b.Buyer, k.OfferID, o.Offer ")
        sb.AppendLine("from tblCakeCampaignDefaultLog k ")
        sb.AppendLine("inner join tblCampaigns c on c.CampaignID = k.CampaignID ")
        sb.AppendLine("inner join tblBuyers b on b.BuyerID = k.BuyerID ")
        sb.AppendLine("inner join tblOffers o on o.OfferID = k.OfferID ")
        sb.AppendLine("order by c.Campaign, b.Buyer, o.offer ")
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text, Nothing)
    End Function

    Public Shared Sub InsertCakeCampaignSync(ByVal CampaignId As Integer, ByVal BuyerId As Integer, ByVal OfferId As Integer, ByVal CakeId As Integer, ByVal PostKey As String)
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@CampaignId", SqlDbType.Int)
        param.Value = CampaignId
        params.Add(param)

        param = New SqlParameter("@BuyerId", SqlDbType.Int)
        param.Value = BuyerId
        params.Add(param)

        param = New SqlParameter("@OfferId", SqlDbType.Int)
        param.Value = OfferId
        params.Add(param)

        param = New SqlParameter("@CakeId", SqlDbType.Int)
        param.Value = CakeId
        params.Add(param)

        param = New SqlParameter("@PostKey", SqlDbType.VarChar)
        param.Value = PostKey.Trim
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_InsertCakeCampaigns", CommandType.StoredProcedure, params.ToArray)

    End Sub

End Class
