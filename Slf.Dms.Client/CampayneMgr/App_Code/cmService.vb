Imports System.Data
Imports System.Data.SqlClient
Imports System.Security.Permissions
Imports System.Web
Imports System.Web.Script.Serialization
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml
Imports AdminHelper
Imports BuyerHelper
Imports DataManagerHelper
Imports DataMiningHelper
Imports SchoolFormControl
Imports SchoolFormControl.SchoolCampaignHelper
Imports SurveyHelper
Imports jqGridObjects

<WebService(Namespace:="http://CampayneMgr.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
<System.Web.Script.Services.ScriptService()> _
Public Class cmService
    Inherits System.Web.Services.WebService

#Region "Enumerations"

    Public Enum enumDocumentType
        BuyerDocument = 0
        AdvertiserDocument = 1
        AffiliateDocument = 2
    End Enum

#End Region 'Enumerations


#Region "Methods"

    <System.Web.Services.WebMethod()> _
    Public Function AddConversions(ByVal CampaignID As Integer, ByVal SrcCampaignID As Integer, ByVal NumToAdd As Integer, ByVal ConversionDate As String) As String
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CampaignID", CampaignID))
        params.Add(New SqlParameter("SrcCampaignID", SrcCampaignID))
        params.Add(New SqlParameter("ConversionDate", ConversionDate))
        params.Add(New SqlParameter("Num", NumToAdd))
        SqlHelper.ExecuteNonQuery("stp_AddConversions", , params.ToArray)
        Return "Conversions Added!"
    End Function

    Private Function BuildEmailString(ByVal dm As DeliveryMethodObject, cols As DataColumnCollection, row As DataRow, ByRef uriData As String) As String
        Dim htmlData As String = "<html><head>"
        Dim found As Boolean
        Dim value As String
        Dim pfLst As New List(Of String)
        Dim rqLst As New List(Of String)
        Dim nxLst As New List(Of String)

        'styling
        htmlData += "<style type=""text/css"">"
        'htmlData += "body{padding:0;margin:0;font-style:Verdana, sans-serif;background-color:#f3f3f3;}"
        'htmlData += "#logo{height:67px;width:100%;text-align:center;background-color:#e8e8e8;padding:13px 0px 0px 0px;}"
        'htmlData += "#bar{height:10px;width:100%;background-color:#d0d0d0;}"
        htmlData += "#container{text-align:center;}"
        htmlData += "#smallContainer{text-align:left;width:500px;}"
        htmlData += "#details{padding:15px 0px 15px 10px;margin:0;font-weight:bold;color:#f89828;font-size:18px;background-color:#fff;}"
        htmlData += "h2{padding:15px 0px 0px 0px;margin:0;font-weight:normal;color:#f89828;font-size:22px;}"
        htmlData += "h3{padding:10px 0px 15px 0px;margin:0;font-weight:normal;font-size:15px;}"
        htmlData += "h4{padding:25px 0px 15px 0px;margin:0;font-weight:bold;font-size:15px;}"
        htmlData += "h5{padding:0px;margin:0;font-weight:normal;font-size:15px;font-style:oblique;}"
        htmlData += ".parameter{width:125px;padding:10px 0px;margin:0;font-weight:bold;font-size:16px;text-align:right;height:20px;}"
        htmlData += ".value{width:375px;padding:10px 0px 10px 10px;margin:0;font-weight:normal;font-size:16px;text-align:left;}"
        htmlData += ".altrow {background-color:#fff;border-width:0px;display:block;}"
        htmlData += "tr{border-color:#fff;border-width:0px;}"
        htmlData += "table{cellspacing:0;}"
        htmlData += "</style>"
        'body
        htmlData += "</head>"
        htmlData += "<body style=""padding:0;margin:0;font-style:Verdana, sans-serif;background-color:#f3f3f3;"">"
        htmlData += "<div id=""container"">"
        htmlData += "<div id=""logo"" style=""height:67px;width:100%;text-align:center;background-color:#e8e8e8;padding:13px 0px 0px 0px;"">"
        htmlData += "<img src=""http://identifyle.com/images/identifyle-logo-email.gif"" alt=""Logo""/>"
        htmlData += "</div>"
        htmlData += "<div id=""bar"" style=""height:10px;width:100%;background-color:#d0d0d0;""></div>"
        htmlData += "<div id=""smallContainer"">"
        htmlData += "<div id=""header"">"
        htmlData += String.Format("<h2>Dear {0},</h2>", dm.BuyerName)
        htmlData += "<h3>You have received a new prospect from our network.<br/>The prospect's details are listed below.</h3>"
        htmlData += "</div>"
        htmlData += "<div id=""details"">Prospect Details</div>"
        htmlData += "<table cellspacing=""0"">"

        For Each pf As PostDataFieldObject In dm.PostDataFields
            If String.IsNullOrEmpty(pf.Field) Then
                If pf.Query Then 'include in url
                    rqLst.Add(pf.Parameter)
                Else
                    pfLst.Add(pf.Parameter)
                End If
            Else
                found = False
                value = ""

                For i As Integer = 0 To cols.Count - 1
                    If cols(i).ColumnName.ToLower.Equals(pf.Field.ToLower) Then
                        value = row(i).ToString
                        found = True
                        Exit For
                    End If
                Next

                If Not found Then
                    value = GetFormattedValue(pf.Field, row)
                End If

                If pf.Query Then 'include in url
                    rqLst.Add(String.Format("{0}={1}", pf.Parameter, value))
                    'ElseIf Left(pf.Parameter, 1).Equals("<") Then 'nested xml
                    '    nxLst.Add(System.Web.HttpUtility.UrlEncode(pf.Parameter & value))
                Else
                    pfLst.Add(String.Format("{0}={1}", pf.Parameter, value))
                End If
            End If
        Next

        If pfLst.Count > 0 Then
            Dim count As Integer = 2
            For Each str As String In pfLst.ToArray
                Dim reqUri As String() = str.Split("=")
                Dim param As String = reqUri(0)
                Dim val As String = reqUri(1)
                If count Mod 2 = 0 Then
                    htmlData += String.Format("<tr><td class=""parameter"">{0}:</td><td class=""value"">{1}</td></tr>", param, val)
                Else
                    htmlData += String.Format("<tr class=""altrow""><td class=""parameter"">{0}:</td><td class=""value"">{1}</td></tr>", param, val)
                End If
                count += 1
            Next
        End If
        If nxLst.Count > 0 Then
            Dim count As Integer = 2
            For Each str As String In nxLst.ToArray
                Dim reqUri As String() = str.Split("=")
                Dim param As String = reqUri(0)
                Dim val As String = reqUri(1)
                If count Mod 2 = 0 Then
                    htmlData += String.Format("<tr><td class=""parameter"">{0}:</td><td class=""value"">{1}</td></tr>", param, val)
                Else
                    htmlData += String.Format("<tr class=""altrow""><td class=""parameter"">{0}:</td><td class=""value"">{1}</td></tr>", param, val)
                End If
                count += 1
            Next
        End If
        If rqLst.Count > 0 Then
            Dim count As Integer = 2
            For Each str As String In rqLst.ToArray
                Dim reqUri As String() = str.Split("=")
                Dim param As String = reqUri(0)
                Dim val As String = reqUri(1)
                If count Mod 2 = 0 Then
                    htmlData += String.Format("<tr><td class=""parameter"">{0}:</td><td class=""value"">{1}</td></tr>", param, val)
                Else
                    htmlData += String.Format("<tr class=""altrow""><td class=""parameter"">{0}:</td><td class=""value"">{1}</td></tr>", param, val)
                End If
                count += 1
            Next
        End If

        htmlData += "</table>"
        htmlData += "<div id=""footer"">"
        htmlData += "<h4>Thank you for using Identifyle to grow your business.</h4>"
        htmlData += "<h5>Regards,<br/>Identifyle.</h5>"
        htmlData += "</div>"
        htmlData += "</div></div></body></html>"

        Return htmlData
    End Function

    Private Function BuildPostString(ByVal dm As DeliveryMethodObject, cols As DataColumnCollection, row As DataRow, ByRef uriData As String) As String
        Dim postData As String = ""
        Dim xtype = Nothing ''dm.PostDataFields.Find(Function(p As PostDataFieldObject) p.Field.ToLower = "xmlroot")
        Dim xmlData As String = "<?xml version=""1.0"" encoding=""utf-8"" ?>"
        Dim xmlrootNode As String = ""
        Dim isXml As Boolean
        Dim found As Boolean
        Dim value As String
        Dim pfLst As New List(Of String)
        Dim rqLst As New List(Of String)
        Dim nxLst As New List(Of String)

        If Not IsNothing(xtype) Then
            isXml = True
        End If

        For Each pf As PostDataFieldObject In dm.PostDataFields
            If String.IsNullOrEmpty(pf.Field) And Not isXml Then
                If pf.Query Then 'include in url
                    rqLst.Add(pf.Parameter)
                Else
                    pfLst.Add(pf.Parameter)
                End If
            Else
                found = False
                value = ""

                For i As Integer = 0 To cols.Count - 1
                    If cols(i).ColumnName.ToLower.Equals(pf.Field.ToLower) Then
                        value = row(i).ToString
                        found = True
                        Exit For
                    End If
                Next

                If Not found Then
                    value = GetFormattedValue(pf.Field, row)
                End If

                If isXml Then
                    If pf.Parameter.IndexOf("=") <> -1 Then
                        Dim hardValue As String() = pf.Parameter.Split(New Char() {"="})
                        pfLst.Add(String.Format("<{0}>{1}</{0}>", hardValue(0), hardValue(1)))
                    ElseIf pf.Parameter.Contains("<") Then
                        pfLst.Add(pf.Parameter)
                    Else
                        pfLst.Add(String.Format("<{0}>{1}</{0}>", pf.Parameter, value))
                    End If
                Else
                    If pf.Query Then 'include in url
                        rqLst.Add(String.Format("{0}={1}", pf.Parameter, System.Web.HttpUtility.UrlEncode(value)))
                    ElseIf Left(pf.Parameter, 1).Equals("<") Then 'nested xml
                        nxLst.Add(System.Web.HttpUtility.UrlEncode(pf.Parameter & value))
                    Else
                        pfLst.Add(String.Format("{0}={1}", pf.Parameter, System.Web.HttpUtility.UrlEncode(value)))
                    End If
                End If
            End If
        Next

        If pfLst.Count > 0 Then
            postData = Join(pfLst.ToArray, IIf(isXml, "", "&"))
            'If dm.BuyerOfferXrefID = 423 Or dm.BuyerOfferXrefID = 422 Then
            If dm.BuyerID = 686 Then
                postData = "xmlData=" & postData
            End If
        End If
        If nxLst.Count > 0 Then
            postData &= Join(nxLst.ToArray, "")
        End If

        If rqLst.Count > 0 Then
            uriData = String.Concat("?", Join(rqLst.ToArray, "&"))
        End If
        Return postData
        'End If
    End Function

    <WebMethod()> _
    Public Function BuildSchoolForm(ByVal schoolformid As Integer) As String
        Dim result As SchoolCampaignsFormDefinitionObject = SchoolCampaignsFormDefinitionObject.LoadFormDefinition(schoolformid)
        Dim ld As leaddata = SchoolCampaignHelper.GetTestLead(schoolformid)

        Return SchoolCampaignsFormDefinitionObject.CreateHTMLFormUseDiv(result, ld, "../service/cmService.asmx", True, True, True, False, Nothing, _
                                                                        "schoolForm", "Send Test Form", 2, False, 0, "", _
                                                                        "Congratulations on Test Submission!!", "Sending Information...<br/><img src=""../images/loading.gif""/>")
    End Function

    <WebMethod()> _
    Public Function BuildSchoolFormCampaign(ByVal zipcode As String) As String
        'Dim result As PostingInstructionsObject = LoadPostingInstructions(schoolcampaignid)
        Dim ld As New leaddata With {.Firstname = "Sam", .lastname = "sneed", .email = "samsneed@plattformad.com", .Leadid = 12345}
        'Return CreateHTMLFormUseTable(result, ld, "../service/cmService.asmx", True, True, True, Nothing, "schoolForm", "Send Test Form", 2)
        Dim ca As New SchoolCampaignsFormDefinitionObject.createSchoolFormArgumentsObject

        With ca
            .ZipCode = zipcode
            .LeadDataHolder = ld
            .ApplicationServicePath = "../service/cmService.asmx"
            .ShowOnlyRequiredFields = True
            .FinishUrl = ""
            .AreWeTesting = True
            .ShowHiddenFields = True
            .excludedFieldsCommaSeparated = "Preferred Location:"
            .formCSSClassName = "schoolForm"
            .SubmitButtonText = "Send Test Form"
            .NumberOfQuestionsPerPages = 4
            .UseDefaultCSS = True
            .ProgramName = Nothing
            .SubjectCategoryID = Nothing
            .DegreeType = Nothing
        End With

        Return SchoolCampaignsFormDefinitionObject.CreateTabFormCampaignWithPages(ca)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function CheckSurvey(surveyid As Integer) As String
        Dim result As String = String.Empty
        Try
            Dim results As List(Of String) = SurveyHelper.CheckSurvey(surveyid)
            If Not IsNothing(results) AndAlso results.Count > 0 Then
                result += vbCrLf & Join(results.ToArray, "<br/>")
            Else
                result += "<br/><strong>SUCCESS:</strong>  At Least 1 Question is Active Check!"
                result += "<br/><strong>SUCCESS:</strong>  All Questions have answers!"
                result += "<br/><strong>SUCCESS:</strong>  All answers have types set!<br/>"
            End If
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function CopySurvey(ByVal surveyID As String) As String
        Dim result As String = "Survey Copied!!!"
        If Not String.IsNullOrEmpty(surveyID) Then
            Try
                SurveyHelper.CopySurvey(surveyID)
            Catch ex As Exception
                result = ex.Message.ToString
            End Try
        Else
            result = "No survey to copy!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function CreateContract(ByVal buyerid As String) As String
        Dim result As String = "Contract created!"
        Try
            If Not String.IsNullOrEmpty(buyerid) Then
                Dim ssql As String = "stp_datamgr_InsertUpdateContract"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("boxid", -1))
                params.Add(New SqlParameter("BuyerID", buyerid))
                params.Add(New SqlParameter("ContractName", "New Contract"))
                params.Add(New SqlParameter("ServiceTel", ""))
                params.Add(New SqlParameter("dailycap", 0))
                params.Add(New SqlParameter("instructions", ""))
                params.Add(New SqlParameter("price", 0))
                params.Add(New SqlParameter("priority", 2))
                params.Add(New SqlParameter("offerid", 80))
                params.Add(New SqlParameter("exclusive", False))
                params.Add(New SqlParameter("active", False))
                params.Add(New SqlParameter("weight", 100))
                params.Add(New SqlParameter("dataSQL", ""))
                params.Add(New SqlParameter("docakepost", False))
                params.Add(New SqlParameter("throttle", False))

                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            End If
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteAd(ByVal adID As String) As String
        Dim result As String = ""
        Try
            If Not String.IsNullOrEmpty(adID) AndAlso adID <> 0 Then
                result = "Ad deleted!"
                Dim ssql As String = "stp_adrotator_deleteAd"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("adID", adID))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Else
                result = "Ad is required, Please retry!"
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteCategoryData(itemid As String) As String
        Dim result As String = "Item Deleted!"
        Try
            Dim ssql As String = String.Format("UPDATE tblSchoolCampaigns_LocationCurriculumItems SET CurriculumCategoryID = null where ItemValue = '{0}'", itemid)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    <System.Web.Script.Services.ScriptMethod()> _
    Public Function DeleteContact(ByVal conType As enumDocumentType, ByVal uniqueID As String) As String
        Dim result As String = "Contact Deleted!"
        Try

            Dim tblName As String = Nothing
            Select Case conType
                Case enumDocumentType.BuyerDocument
                    tblName = "tblBuyerContacts"
                Case enumDocumentType.AdvertiserDocument
                    tblName = "tblAdvertiserContacts"
                Case enumDocumentType.AffiliateDocument
                    tblName = "tblAffiliateContacts"
            End Select
            If Not IsNothing(tblName) Then
                Dim ssql As String = String.Format("UPDATE {0} set deleted = 1 WHERE contactid = {1}", tblName, uniqueID)
                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
            End If
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    <System.Web.Script.Services.ScriptMethod()> _
    Public Function DeleteContract(ByVal contractid As String) As String
        Dim result As String = "Contract Deleted!"
        Try
            Dim dmid As String = SqlHelper.ExecuteScalar(String.Format("select deliverymethodid FROM tblDeliveryMethod where BuyerOfferXrefID = {0}", contractid), CommandType.Text)
            Dim ssql As String = String.Format("DELETE FROM tblDeliveryMethodResponses where deliverymethodid = {0}", dmid)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

            ssql = String.Format("DELETE FROM tblDeliveryPostFields where deliverymethodid = {0}", dmid)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

            ssql = String.Format("DELETE FROM tblDeliveryMethod where BuyerOfferXrefID = {0}", contractid)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteCurriculumItem(locationcurriculumitemid As String) As String
        Dim result As String = "Curriculum item deleted successfully!"
        Try

            SchoolFormControl.SOAPLocationCurriculumObject.DeleteCurriculumItem(locationcurriculumitemid)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteDocument(ByVal docType As enumDocumentType, ByVal uniqueID As String) As String
        Dim result As String = "Document deleted!"
        Try

            Dim ssql As String = Nothing
            Dim fpath As String = Nothing
            Dim tblName As String = Nothing
            Select Case docType
                Case enumDocumentType.BuyerDocument
                    tblName = "tblBuyerDocuments"
                Case enumDocumentType.AdvertiserDocument
                    tblName = "tblAdvertiserDocuments"
                Case enumDocumentType.AffiliateDocument
                    tblName = "tblAffiliateDocuments"
            End Select

            If Not IsNothing(tblName) Then
                fpath = SqlHelper.ExecuteScalar(String.Format("select documentpath from {0} where documentid = {1}", tblName, uniqueID), CommandType.Text)
                ssql = String.Format("delete from {0} where documentid = {1}", tblName, uniqueID)
                Try
                    IO.File.Delete(fpath)
                Catch ex As Exception
                Finally
                    SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.Text)
                End Try

            End If

        Catch ex As Exception
            result = "ERROR<br/>"
            result += ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteFieldItem(ByVal schoolformid As String, itemname As String, itemvalue As String) As String
        Dim result As String = "Field item deleted successfully!"
        Try
            SchoolFormControl.FieldsObject.DeleteFieldItem(schoolformid, itemname, itemvalue)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function DeleteGroup(ByVal groupID As String) As String
        Dim result As String = GroupsHelper.FormatMsgText("Group Deleted!!!", GroupsHelper.enumMsgType.msgInfo)
        Try
            If Not String.IsNullOrEmpty(groupID) Then
                Dim ssql As String = String.Format("delete from tblgroups where groupid = {0}", groupID)
                SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.Text)

                ssql = String.Format("update tbluser set groupid = null where groupid = {0}", groupID)
                SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.Text)

            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteOffer(ByVal adOfferID As String) As String
        Dim result As String = ""
        Try
            If Not String.IsNullOrEmpty(adOfferID) Then
                result = "Offer deleted!"
                Dim ssql As String = "stp_adrotator_deleteOffer"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("adOfferID", adOfferID))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Else
                result = "Offer is required, Please retry!"
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeletePostingInformation(ByVal schoolformid As String) As String
        Dim result As String = "School form deleted successfully!!"
        Try
            If Not String.IsNullOrEmpty(schoolformid) AndAlso schoolformid <> 0 Then
                SchoolCampaignsFormDefinitionObject.DeleteForm(schoolformid)
            Else
                result = "school form id is required, Please retry!"
            End If

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteQuestionOption(ByVal optionid As String) As String
        Dim result As String = ""
        Try
            If Not String.IsNullOrEmpty(optionid) AndAlso optionid <> 0 Then
                result = "Item deleted!"
                Dim ssql As String = "delete from tblOptions where optionid = @optionid"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("optionid", optionid))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text, params.ToArray)
            Else
                result = "Item is required, Please retry!"
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteSurvey(ByVal surveyID As String) As String
        Dim result As String = "Survey Deleted"
        If Not String.IsNullOrEmpty(surveyID) Then
            Try
                Dim ssql As String = String.Format("DELETE FROM tblSurvey WHERE (SurveyID = {0})", surveyID)
                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
            Catch ex As Exception
                result = ex.Message.ToString
            End Try
        Else
            result = "No survey to delete!"
        End If
        Return result
    End Function

    <WebMethod()> _
    Public Function DeleteWebsite(websiteid As String) As String
        Dim result As String = "Website marked as deleted!"
        Try
            Dim ssql As String = "stp_websites_delete"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("websiteid", websiteid))
            params.Add(New SqlParameter("UserID", HttpContext.Current.User.Identity.Name))
            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DeleteZipcodes(locationid As String) As String
        Dim result As String = "Zipcodes deleted!"
        Try
            SOAPLocationCurriculumObject.DeleteLocationZipcodes(locationid)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Sub EmailRevReport(html As String)
        Dim css As String = "<style type=""text/css""> .revcat td { background-color:#fff; border-bottom: 1px solid } .revcat th { background-color:#000; color:#fff; text-align:left } .sub td { background-color: #FFF1CD; border-bottom: 1px solid } .sub2 td { background-color: #FFF1CD; border-bottom: 2px solid } .leads td { background-color: #D4EBF0 } </style>"
        Dim sendto As String = CampayneHelper.GetConfigValue("REVEMAILS")
        html = String.Concat(css, Server.UrlDecode(html))
        emailHelper.SendMessage("no_reply@identifyle.com", sendto, "Revenue Snapshot", html)
    End Sub

    Private Function ExcludeBasedOnCap(Cap As Integer, BuyerOfferXrefId As Integer) As Boolean
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerOfferXrefId", BuyerOfferXrefId))
        Dim obj As Object = Nothing
        Dim Sold As Integer = Cap
        Try
            obj = SqlHelper.ExecuteScalar("stp_GetDailySold", CommandType.StoredProcedure, params.ToArray)
            If Not obj Is Nothing Then
                Sold = CInt(obj)
            End If
        Catch ex As Exception
            LeadHelper.LogError("cmService_ExcludeBasedOnCap", ex.Message, ex.StackTrace)
        End Try
        If Cap > Sold Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Function ExcludeBasedOnExclusions(ByVal BuyerOfferXrefId As String, LeadInfo As DataTable) As Boolean

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerOfferXrefId", BuyerOfferXrefId))
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetContractExclusions", CommandType.StoredProcedure, params.ToArray)

        For Each dr As DataRow In dt.Rows
            Dim columnName As String = String.Format("{0}", dr("ColumnName"))
            Dim dr1 As DataRow = LeadInfo(0)
            Dim amount As String = LeadInfo(0)(columnName).ToString

            Select Case dr("Operator")
                Case "<"
                    If Not (CInt(LeadInfo(0)(columnName).ToString) < CInt(dr("Value"))) Then
                        Return True
                    End If
                Case ">"
                    If Not (CInt(LeadInfo(0)(columnName).ToString) > CInt(dr("Value"))) Then
                        Return True
                    End If
                Case "<="
                    If Not (CInt(LeadInfo(0)(columnName).ToString) <= CInt(dr("Value"))) Then
                        Return True
                    End If
                Case ">="
                    If Not (CInt(LeadInfo(0)(columnName).ToString) >= CInt(dr("Value"))) Then
                        Return True
                    End If
                Case "="
                    If LeadInfo(0)(columnName).ToString() = dr("Value") Then
                        Return True
                    End If
                Case Else

            End Select
        Next
        Return False
    End Function

    Private Function ExcludeBasedOnSchedule(ByVal scheduleObjects As List(Of DeliveryScheduleObject)) As Boolean
        Dim todayName As String = WeekdayName(Weekday(Now), False)
        Dim todayTime As String = Now.ToShortTimeString

        For Each dms As DeliveryScheduleObject In scheduleObjects
            If todayName.ToLower = dms.Weekday.ToLower AndAlso TimeValue(dms.FromHour) <= TimeValue(todayTime) AndAlso TimeValue(dms.ToHour) > TimeValue(todayTime) Then
                Return False
            End If
        Next

        Return True
    End Function

    Private Function ExcludeBasedOnDate(DateLastSold As Date, MaxDifference As Integer) As Boolean
        Dim ActualDifference As Integer = 0
        ActualDifference = (Today - DateLastSold).Days
        If MaxDifference < ActualDifference Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Function ExcludeBasedOnStateCode(BuyerOfferXrefId As String, StateCode As String) As Boolean
        Dim obj As Object = Nothing
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("buyerofferxrefid", BuyerOfferXrefId))
        Try
            obj = SqlHelper.ExecuteScalar("stp_GetExcludedStatesByContract", CommandType.StoredProcedure, params.ToArray)
            If Not obj Is Nothing Then
                Dim listofStates As String = CStr(obj)
                Dim separators() As String = {","}
                Dim ExcludedStates() As String = listofStates.Split(separators, StringSplitOptions.RemoveEmptyEntries)
                For Each state In ExcludedStates
                    If state = StateCode Then
                        Return True
                    End If
                Next
                Return False
            End If
            Return False
        Catch ex As Exception
            LeadHelper.LogError("cmService_ExcludeBasedOnStateCode", ex.Message, ex.StackTrace)
            Return True
        End Try

    End Function

    Private Function ExcludeBasedOnWebsite(website As String) As Boolean
        Dim params As New List(Of SqlParameter)
        Dim obj As Object = Nothing
        Dim ResultingWebsite As String = ""
        params.Add(New SqlParameter("website", website))
        Try
            obj = SqlHelper.ExecuteScalar("GetWebsiteFromContract", CommandType.StoredProcedure, params.ToArray)
            If Not obj Is Nothing Then
                ResultingWebsite = CStr(obj)
            End If
        Catch ex As Exception
            LeadHelper.LogError("cmService_ExcludeBasedOnWebsite", ex.Message, ex.StackTrace)
        End Try

        If website = ResultingWebsite Then
            Return False
        Else
            Return True
        End If

    End Function

    <System.Web.Services.WebMethod()> _
    Public Function FindReturn(ByVal buyerid As String, ByVal leadid As String) As String
        Dim returnDate As String = Nothing
        Dim params As New List(Of SqlParameter)
        params = New List(Of SqlParameter)
        params.Add(New SqlParameter("leadid", leadid))
        params.Add(New SqlParameter("buyerid", buyerid))
        returnDate = SqlHelper.ExecuteScalar("stp_returns_getReturnStatus", CommandType.StoredProcedure, params.ToArray)

        Return returnDate
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function FixSurvey(ByVal surveyid As String, fixtype As String) As String
        Dim result As String = Nothing
        Dim params As New List(Of SqlParameter)
        params = New List(Of SqlParameter)
        params.Add(New SqlParameter("surveyid", surveyid))
        params.Add(New SqlParameter("bfix", 1))
        Select Case fixtype.ToLower
            Case "questionseq"
                SqlHelper.ExecuteNonQuery("stp_survey_fixquestionsequence", CommandType.StoredProcedure, params.ToArray)
                result = "Sequence Fixed!"
            Case Else
                result = "No Fix Chosen!"
        End Select

        Return result
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function GetBuyersByOffer(ByVal offerid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal tag As String, ByVal fromhr As String, ByVal tohr As String) As String
        Dim result As String = ""
        Try
            Using dt As DataTable = OfferHelper.GetBuyerSummary(offerid, startdate, enddate, tag, fromhr, tohr)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem"" align=""left"">Offer</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">Buyer</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">Conversions</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">Cap</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">Pct</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">RPT</th>")
                    tbl.Append("<th class=""headitem"" align=""right"">Revenue</th>")
                    tbl.Append("</tr>")
                    Dim i As Integer = 0
                    Dim tdCSSClass As String = ""
                    Dim convTot As Double = 0, revTot As Double = 0
                    For Each dr As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            If Val(dr("pct")) >= 1 Then
                                tbl.Append("<tr style='color:blue'>")
                            Else
                                tbl.Append("<tr>")
                            End If
                        Else
                            If Val(dr("pct")) >= 1 Then
                                tbl.Append("<tr style=""background-color:#f9f9f9; color:blue"">")
                            Else
                                tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                            End If
                        End If
                        tdCSSClass = "griditem"
                        tbl.AppendFormat("<td class=""{1}"">{0}</td>", dr("Offer").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"">{0}</td>", dr("Buyer").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", dr("conversions").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", dr("CAP").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", FormatPercent(dr("pct").ToString, 2), tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", IIf(IsDBNull(dr("RPT").ToString), 0, FormatCurrency(Val(dr("RPT")), 2)), tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""right"">{0}</td>", FormatCurrency(IIf(IsDBNull(dr("revenue")), 0, dr("revenue").ToString), 2, TriState.True, TriState.False, TriState.True), tdCSSClass)
                        tbl.Append("</tr>")

                        convTot += CInt(dr("conversions").ToString)
                        revTot += IIf(IsDBNull(dr("revenue")), 0, Val(dr("revenue")))

                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("<th class=""headitem"" align=""left"">Total</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">&nbsp;</th>")
                    tbl.AppendFormat("<th class=""headitem"" align=""center"">{0}</th>", convTot)
                    tbl.Append("<th class=""headitem"" align=""left"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">&nbsp;</th>")
                    tbl.AppendFormat("<th class=""headitem"" align=""right"">{0}</th>", FormatCurrency(revTot, 2, TriState.True, TriState.False, TriState.True))
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No buyers were found for this offer.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetCampaigns(ByVal affiliateid As String) As String
        Dim result As String = ""
        Dim gv As New GridView
        gv.ID = "gvCampaigns"
        gv.AutoGenerateColumns = False
        gv.CssClass = "ui-widget-content"

        Dim cols As String() = {"Active", "Campaign", "MediaTypeID", "OfferID", "Price", "Priority"}
        For Each c As String In cols
            Dim bc As New BoundField
            bc.HeaderStyle.CssClass = "ui-widget-header"
            bc.HeaderText = StrConv(c, VbStrConv.ProperCase)
            With bc.HeaderStyle
                '.Width = New Unit(200)
                .CssClass = "ui-widget-header"
                .HorizontalAlign = HorizontalAlign.Left
            End With

            With bc.ItemStyle
                '.Width = New Unit(200)
                .CssClass = "ui-widget-content"
                .HorizontalAlign = HorizontalAlign.Left
            End With
            Select Case c.ToLower
                Case "Active".ToLower
                    bc.HeaderText = ""
                Case Else
                    bc.Visible = True
            End Select

            bc.DataField = c
            gv.Columns.Add(bc)

        Next

        Try
            gv.Width = New Unit(97, UnitType.Percentage)
            gv.PageSize = 20
            gv.EmptyDataText = "<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;""><p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>No Campaigns!</p></div></div>"
            gv.DataSource = AffiliateObject.getCampaignsByAffiliateID(affiliateid)
            gv.DataBind()

            gv.AllowPaging = True
        Catch ex As Exception
            result = ex.Message
        End Try

        result = ControlToHTML(gv)

        result = result.Replace("True", "<img src=""../images/16-circle-green.png"" />")
        result = result.Replace("False", "<img src=""../images/16-circle-red.png"" />")

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetCampaignsByOffer(ByVal offerid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String, ByVal tag As String) As String
        Dim result As String = ""
        Try

            Using dt As DataTable = OfferHelper.GetCampaignSummary(offerid, startdate, enddate, fromhr, tohr, tag)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem3"">&nbsp;</th>")
                    'tbl.Append("<th class=""headitem3"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""3"">Online</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""3"">Live Transfer</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""3"">Data</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""2"">Revisits</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"" colspan=""4"">All</th>")
                    tbl.Append("</tr>")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem2"" align=""left"">ID</th>")
                    tbl.Append("<th class=""headitem2"" align=""left"">Campaign</th>")
                    'tbl.Append("<th class=""headitem2"" align=""left"">Offer</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Clicks</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"">Revisits</th>")
                    'tbl.Append("<th class=""headitem3"" align=""center"">Conv %</th>")
                    'Online
                    tbl.Append("<th class=""headitem2"" align=""right"">New</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Revisit</th>")
                    'tbl.Append("<th class=""headitem2"" align=""right"">Total</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Live transfer
                    tbl.Append("<th class=""headitem2"" align=""right"">New</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Revisit</th>")
                    'tbl.Append("<th class=""headitem2"" align=""right"">Total</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Data
                    tbl.Append("<th class=""headitem2"" align=""right"">New</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Revisit</th>")
                    'tbl.Append("<th class=""headitem2"" align=""right"">Total</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Revisits
                    tbl.Append("<th class=""headitem2"" align=""right"">Rev</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Totals
                    tbl.Append("<th class=""headitem2"" align=""right"">Cost</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Rev</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Net</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">RPU</th>")
                    tbl.Append("</tr>")

                    Dim i As Integer = 0
                    Dim clickTot As Integer, convTot As Integer, total As Double
                    Dim onlineNew As Double, onlineRevisit As Double, onlineTotal As Double
                    Dim ltNew As Double, ltRevisit As Double, ltTotal As Double
                    Dim dataNew As Double, dataRevisit As Double, dataTotal As Double
                    Dim revisitTotal As Double, revisits As Integer
                    Dim costTotal As Double, netTotal As Double

                    For Each dr As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                        End If
                        tbl.AppendFormat("<td class=""griditem2"">{0}</td>", dr("CampaignID").ToString)
                        tbl.AppendFormat("<td class=""griditem2""><img onclick=""return clickReport({1},'{2}');"" src='../images/pointer.png' style='cursor:pointer' title='Download click report' /><a href=""#"" onclick=""ShowSubID({1},'{0}');"" style='text-decoration:underline'>{0}</a></td>", dr("Campaign").ToString, dr("CampaignID").ToString, tag)
                        'tbl.AppendFormat("<td class=""griditem2"">{0}</td>", dr("Offer").ToString)
                        tbl.AppendFormat("<td class=""griditem2"" align=""center"">{0}</td>", dr("Clicks").ToString)
                        tbl.AppendFormat("<td class=""griditem2"" align=""center"">{0}</td>", dr("Conversions").ToString)
                        tbl.AppendFormat("<td class=""griditem3"" align=""center"">{0}</td>", dr("Revisits").ToString)
                        'tbl.AppendFormat("<td class=""griditem3"" align=""center"">{0}</td>", FormatPercent(Val(dr("ConvPct")), 1))
                        'Online
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("OnlineNew")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("OnlineRevisit")), 0))
                        'tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("Online")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("OnlineRPU")), 2))
                        'Live transfer
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransferNew")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransferRevisit")), 0))
                        'tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransfer")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransferRPU")), 2))
                        'Data
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("DataNew")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("DataRevisit")), 0))
                        'tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("Data")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("DataRPU")), 2))
                        'Revisits
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("TotalRevisit")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("RPURV")), 2))
                        'Totals
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("TotalCost")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("Total")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("TotalNet")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("RPU")), 2))
                        tbl.Append("</tr>")
                        clickTot += CInt(dr("Clicks"))
                        convTot += CInt(dr("Conversions"))
                        onlineNew += Val(dr("OnlineNew"))
                        onlineRevisit += Val(dr("OnlineRevisit"))
                        onlineTotal += Val(dr("Online"))
                        ltNew += Val(dr("LiveTransferNew"))
                        ltRevisit += Val(dr("LiveTransferRevisit"))
                        ltTotal += Val(dr("LiveTransfer"))
                        dataNew += Val(dr("DataNew"))
                        dataRevisit += Val(dr("DataRevisit"))
                        dataTotal += Val(dr("Data"))
                        total += Val(dr("Total"))
                        revisitTotal += Val(dr("TotalRevisit"))
                        revisits += CInt(dr("Revisits"))
                        costTotal += Val(dr("TotalCost"))
                        netTotal += Val(dr("TotalNet"))
                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("<th class=""headitem2"" align=""left"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"" align=""left"">&nbsp;</th>")
                    'tbl.Append("<th class=""headitem2"" align=""left"">&nbsp;</th>")
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", clickTot)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", convTot)
                    tbl.AppendFormat("<th class=""headitem3"" align=""center"">{0}</th>", revisits)
                    'tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", FormatPercent(convTot / clickTot, 1))
                    'Online
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(onlineNew, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(onlineRevisit, 0))
                    'tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(onlineTotal, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(onlineTotal / convTot)) 'RPU
                    'Live Transfer
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(ltNew, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(ltRevisit, 0))
                    'tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(ltTotal, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(ltTotal / convTot)) 'RPU
                    'Data
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(dataNew, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(dataRevisit, 0))
                    'tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(dataTotal, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(dataTotal / convTot)) 'RPU
                    'Revisits
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(revisitTotal, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(revisitTotal / revisits)) 'RPU
                    'Totals
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(costTotal, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(total, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(netTotal, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(total / convTot)) 'RPU
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No campaigns were found for this offer.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    Private Function GetCategoryFromOfferID(Offerid As String) As String

        Dim str As String = "-1"
        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("OfferID", Offerid))
        Try
            Dim obj As Object = SqlHelper.ExecuteScalar("GetCategoryTableByOfferID", CommandType.StoredProcedure, params.ToArray)
            If Not obj Is Nothing Then
                str = CStr(obj)
            End If
        Catch ex As Exception
            LeadHelper.LogError("cmService_GetCategoryFromOfferID", ex.Message, ex.StackTrace)
        End Try

        Return str

    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetChartData(ByVal chartParamObject As chartParameter) As String
        Dim result As String = String.Empty
        Try
            Dim chartData As New List(Of chartSeriesData)

            Dim ssql As String = chartParamObject.ChartDataProcedureName
            Dim params As New List(Of SqlParameter)

            For Each cp As String In chartParamObject.ChartDataProcParams.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
                Dim cps As String() = cp.Split(New Char() {"="}, StringSplitOptions.RemoveEmptyEntries)
                params.Add(New SqlParameter(cps(0), cps(1)))
            Next

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                Dim contractData = From dr In dt.Rows _
                                   Group dr By key = dr(chartParamObject.GroupByFieldName) Into Group _
                                   Select ContractName = key, chartDataGroup = Group

                For Each c In contractData
                    Dim cdata As New chartSeriesData With {.SeriesName = c.ContractName}

                    Dim dayData As New List(Of String)
                    For Each g As DataRow In c.chartDataGroup
                        dayData.Add(String.Format("{0}={1}", g(chartParamObject.XAxisFieldName).ToString, g(chartParamObject.YAxisFieldName).ToString))
                    Next
                    cdata.SeriesData = Join(dayData.ToArray, ",")
                    chartData.Add(cdata)
                Next
            End Using

            Dim oSerialize As New JavaScriptSerializer
            result = oSerialize.Serialize(chartData)
        Catch ex As Exception

        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetContacts(ByVal conType As cmService.enumDocumentType, ByVal uniqueID As String) As String
        Dim oSerialize As New JavaScriptSerializer
        Dim lst As List(Of ContactObject) = Nothing

        Select Case conType
            Case enumDocumentType.BuyerDocument
                lst = BuyersObject.GetContacts(uniqueID)
            Case enumDocumentType.AdvertiserDocument
                lst = AdvertiserObject.GetContacts(uniqueID)
            Case enumDocumentType.AffiliateDocument
                lst = AffiliateObject.GetContacts(uniqueID)
        End Select

        Dim contactsHTML As New StringBuilder
        If lst.Count > 0 Then
            For Each co As ContactObject In lst
                contactsHTML.AppendLine("<div style=""width:250px;display:block;position:relative; float:left;background-color:#1380C4;margin:2px; color:white"">")
                contactsHTML.AppendLine("<table border=""0"" style=""width:280px"" >")
                contactsHTML.AppendLine("<tr valign=""top"">")
                contactsHTML.AppendLine("<td rowspan=""4"" style=""width:51px;""><img src=""../images/avatar.png"" height=""50px"" width=""50px"" />")
                If co.Billing Then
                    contactsHTML.AppendLine("<img style=""padding-top:5px;"" src=""../images/billing.png"" height=""30px"" width=""30px"" alt=""Designated as billing contact."" />")
                End If
                contactsHTML.AppendLine("</td>")
                contactsHTML.AppendFormat("<td>{0}</td>", co.FullName)
                contactsHTML.AppendLine("</tr>")

                contactsHTML.AppendLine("<tr valign=""top""><td>")
                contactsHTML.AppendLine("<a style=""text-decoration:underline!important; color:white;"" href=mailto:""" & co.Email & """>" & co.Email & "&nbsp;</td></tr>")
                contactsHTML.AppendLine("<tr valign=""top""><td>" & co.Phone & "&nbsp;</td></tr>")
                contactsHTML.AppendLine("<tr valign=""top""><td style=""height:50px;overflow-y:scroll""><b>Notes:</b> " & co.Notes & "</td></tr>")
                contactsHTML.AppendLine("<tr><td colspan=""2"">")
                contactsHTML.AppendLine("<button title=""Delete contact from system."" id=""btnDelete" & co.ContactID & """ class=""fg-button ui-state-default ui-corner-all"" onclick=""DeleteContact(" & co.ContactID & ")"">")
                contactsHTML.AppendLine("<span class=""ui-icon ui-icon-trash""></span></button>")
                contactsHTML.AppendLine("<button title=""Change contact information."" id=""btnEdit" & co.ContactID & """ class=""fg-button ui-state-default ui-corner-all"" ")
                contactsHTML.AppendLine(String.Format("onclick=""EditContact({0},'{1}','{2}','{3}','{4}','{5}')"">", co.ContactID, co.FullName, co.Email, co.Phone, co.Notes, co.Billing.ToString.ToLower))
                contactsHTML.AppendLine("<span class=""ui-icon ui-icon-pencil""></span></button>")

                contactsHTML.AppendLine("</td></tr></table></div>")
            Next
            contactsHTML.AppendLine("<div style=""clear:both""/>")
        Else
            contactsHTML.AppendLine("<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;""><p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>No Contacts!</p></div></div>")
        End If

        Return contactsHTML.ToString 'oSerialize.Serialize(lst)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetContractWebsites(buyerofferxrefid As String) As String
        Dim result As String = String.Empty
        Try
            Dim lst As New List(Of String)
            Dim ssql As String = "select websiteid from tblbuyerwebsites where BuyerOfferXrefID = @BuyerOfferXrefID"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BuyerOfferXrefID", buyerofferxrefid))
            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text, params.ToArray)

                For Each w As DataRow In dt.Rows
                    lst.Add(w("websiteid").ToString)
                Next
            End Using

            result = Join(lst.ToArray, ",")

        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetContracts(ByVal buyerid As String) As String
        Dim result As String = ""
        Dim gv As New GridView
        gv.ID = "gvCOntracts"
        gv.AutoGenerateColumns = False
        gv.CssClass = "ui-widget-content"

        Dim cols As String() = {"Active", "BuyerID", "BuyerOfferXrefID", "ContractName", "Created", "DailyCap", "Offer", "Vertical", "Weight"}
        For Each c As String In cols
            Dim bc As New BoundField
            bc.HeaderStyle.CssClass = "ui-widget-header"
            bc.HeaderText = StrConv(c, VbStrConv.ProperCase)
            With bc.HeaderStyle
                '.Width = New Unit(200)
                .CssClass = "ui-widget-header"
                .HorizontalAlign = HorizontalAlign.Left
            End With

            With bc.ItemStyle
                '.Width = New Unit(200)
                .CssClass = "ui-widget-content"
                .HorizontalAlign = HorizontalAlign.Left
            End With
            Select Case c.ToLower
                Case "buyerid".ToLower, "BuyerOfferXrefID".ToLower
                    bc.Visible = False
                Case "Active".ToLower
                    bc.HeaderText = ""
                Case "ContractName".ToLower
                    bc.HeaderText = "Name"
                    bc.ItemStyle.Wrap = False
                Case "DailyCap".ToLower
                    bc.HeaderText = "Daily Cap"
                Case Else
                    bc.Visible = True
            End Select

            bc.DataField = c
            gv.Columns.Add(bc)

        Next

        Try
            gv.Width = New Unit(97, UnitType.Percentage)
            gv.PageSize = 20
            gv.EmptyDataText = "<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;""><p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>No Contracts!</p></div></div>"
            gv.DataSource = BuyerContractObject.getBuyerContracts(buyerid, -1, -1, -1)

            gv.DataBind()

            gv.AllowPaging = True
        Catch ex As Exception
            result = ex.Message
        End Try

        result = ControlToHTML(gv)

        result = result.Replace("True", "<img src=""../images/16-circle-green.png"" />")
        result = result.Replace("False", "<img src=""../images/16-circle-red.png"" />")

        Return result
    End Function

    Private Function GetContractsByOfferId(ByVal offerid As String, ByVal leadID As String) As DataTable
        Dim dt As DataTable = Nothing
        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("offerid", offerid))
        Try
            dt = SqlHelper.GetDataTable("stp_GetContractsByOfferId", CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            LeadHelper.LogError("cmService_GetContractsByOfferId", ex.Message, ex.StackTrace, leadID)
        End Try

        Return dt

    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetCurriculumItems(ByVal locationid As String) As String
        Dim result As New StringBuilder
        Dim btns As String = "&nbsp;"

        Try
            Using dt As DataTable = SchoolFormControl.SOAPLocationCurriculumObject.FindCurriculumByLocation(locationid)
                dt.DefaultView.Sort = "outcome asc"
                'add column to replace with button text for javascript
                dt.Columns.Add("ActionColumn")
                'For Each dr As DataRow In dt.Rows
                '    dr("ActionColumn") = "AddDeleteButton AddEditButton "
                '    dr.AcceptChanges()
                'Next
                dt.AcceptChanges()
                dt.Columns("ActionColumn").ReadOnly = True

                result.Append("<table id=""LocationItemTable"" style=""width:100%;"" cellpadding=""0"" cellspacing=""0"" >")
                result.Append("<thead><tr>")
                For Each dc As DataColumn In dt.Columns
                    Select Case dc.ColumnName.ToLower
                        Case "ActionColumn".ToLower
                            result.Append("<th class=""ui-widget-header"">&nbsp;</th>")
                        Case Else
                            result.AppendFormat("<th class=""ui-widget-header"">{0}</th>", dc.ColumnName)
                    End Select

                Next
                result.Append("</tr></thead><tbody> ")

                For Each dr As DataRow In dt.Rows
                    result.Append("<tr>")
                    For Each dc As DataColumn In dt.Columns

                        Select Case dc.ColumnName.ToLower
                            Case "ActionColumn".ToLower
                                result.Append("<td class=""ui-widget-content"">")
                                result.AppendFormat("<img src=""../images/16x16_delete.png"" onclick=""return DeleteCurriculum('{0}')"" onmouseover=""this.style.cursor='pointer';"" />", dr("LocationCurriculumItemID").ToString)
                                result.Append("<img src=""../images/16x16_edit.gif"" ")
                                result.AppendFormat("onclick=""return EditCurriculum('{0}','{1}','{2}','{3}')"" ", _
                                                    dr("LocationCurriculumItemID").ToString, _
                                                    dr("itemname").ToString, _
                                                    dr("itemvalue").ToString, _
                                                    dr("outcome").ToString)
                                result.Append("onmouseover=""this.style.cursor='pointer';"" /></td>")

                            Case Else
                                result.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr(dc.ColumnName).ToString)
                        End Select
                    Next
                    result.Append("</tr>")
                Next
                result.Append("</tbody></table>")

                result.Append("<br/>")
                result.Append("<table width=""100%"">")
                result.Append("<tr><td colspan=""3"" class=""ui-widget-header"">Create new curriculum</td></tr>")
                result.Append("<tr><td style=""width:50%;"">Name</td><td>Value</td><td>Outcome</td><td>&nbsp;</td></tr>")
                result.Append("<tr><td style=""width:50%;""><input type=""hidden"" id=""hdnItemID""/><input type=""text"" id=""txtname"" style=""width:300px;""/></td><td><input type=""text"" id=""txtvalue""/></td><td><input type=""text"" id=""txtoutcome""/></td><td><img src=""../images/16x16_save.png"" onclick=""return AddCurriculum(this)"" /></td></tr>")
                result.Append("</table>")

            End Using

        Catch ex As Exception
            Return ex.Message
        End Try

        Return result.ToString
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function GetDataQueries(OfferID As Integer) As List(Of String())
        Return OfferHelper.GetDataQueries(OfferID)
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function GetDeliveryMethod(ByVal boxid As String) As String
        Dim result As DeliveryMethodObject = Nothing

        Try
            result = DeliveryMethodObject.GetDeliveryMethod(boxid)

        Catch ex As Exception
            result = New DeliveryMethodObject
            result.PostUrl = ex.Message
        End Try

        Return jsonHelper.SerializeObjectIntoJson(result)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetDeliverySchedule(ByVal boxid As String) As String
        Dim dso As List(Of DataManagerHelper.DeliveryScheduleObject) = BuyerHelper.getBuyerDeliverySchedule(boxid)
        Dim result As String = ""

        Dim dv As New HtmlGenericControl("div")
        Try
            Dim tbl As New HtmlTable
            With tbl
                .Attributes("class") = "ui-widget-content"
                .CellPadding = 0
                .CellSpacing = 0
                .Border = 1
                .Style("width") = "98%"
                .Style("border-collapse") = "collapse"
            End With

            Dim tr As New HtmlTableRow
            tr.Height = 30
            Dim td As HtmlTableCell
            Dim cols As String() = {"Weekday", "Fromhour", "Tohour"}
            For Each col As String In cols
                td = New HtmlTableCell("th")
                td.Align = "left"
                td.Attributes("class") = "ui-widget-header"
                td.InnerHtml = StrConv(col, VbStrConv.ProperCase).Replace("hour", " Hour")
                tr.Cells.Add(td)
            Next

            tbl.Rows.Add(tr)

            For Each ds As DeliveryScheduleObject In dso
                tr = New HtmlTableRow
                tr.Height = 20

                td = New HtmlTableCell
                td.Attributes("class") = "ui-widget-content"
                Dim txt As New TextBox
                txt.Height = New Unit(15)
                txt.Text = ds.Weekday
                txt.Attributes("Style") = "border: none; background-color: Transparent; color: Black;" ';
                td.Controls.Add(txt)
                tr.Cells.Add(td)

                td = New HtmlTableCell
                td.Attributes("class") = "ui-widget-content"
                txt = New TextBox
                txt.Height = New Unit(15)
                txt.Text = ds.FromHour
                txt.Attributes("onclick") = "EnableControl(this);"
                txt.Attributes("onblur") = "DisableControl(this);"
                txt.Attributes("Style") = "border: none; background-color: Transparent; color: Black;" ';
                td.Controls.Add(txt)
                tr.Cells.Add(td)

                td = New HtmlTableCell
                td.Attributes("class") = "ui-widget-content"
                txt = New TextBox
                txt.Height = New Unit(15)
                txt.Text = ds.ToHour
                txt.Attributes("onclick") = "EnableControl(this);"
                txt.Attributes("onblur") = "DisableControl(this);"
                txt.Attributes("Style") = "border: none; background-color: Transparent; color: Black;" ';
                td.Controls.Add(txt)
                tr.Cells.Add(td)

                tbl.Rows.Add(tr)
            Next
            dv.Controls.Add(tbl)
        Catch ex As Exception
            result = ex.Message
        End Try

        'result = ControlToHTML(gv)
        result = ControlToHTML(dv)

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetDispositionLeadsBySubId(ByVal CampaignID As Integer, SubId1 As String, IdentStatus As String, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As String
        Dim result As String = ""
        Dim i As Integer
        Dim tbl As New StringBuilder

        SubId1 = Replace(SubId1, "NA", "")

        Try
            Using dt As DataTable = ReportsHelper.DispositionLeadsBySubId(CampaignID, SubId1, IdentStatus, startdate, enddate, fromhr, tohr)
                If dt.Rows.Count > 0 Then
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    For c As Integer = 0 To dt.Columns.Count - 1
                        tbl.AppendFormat("<th class='headitem2' align='left'>{0}</th>", dt.Columns(c).ColumnName)
                    Next
                    tbl.Append("</tr>")

                    For Each row As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                        End If
                        For c As Integer = 0 To dt.Columns.Count - 1
                            tbl.AppendFormat("<td class='griditem2'>{0}</td>", row(c))
                        Next
                        i += 1
                    Next
                    tbl.Append("</table>")
                Else
                    tbl.Append("<p>No leads found for this Sub Id and Status</p>")
                End If

                result = tbl.ToString
            End Using
        Catch ex As Exception
            result = String.Concat("<p>", ex.Message, "</p>")
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetDispositionsBySubId(ByVal CampaignID As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As String
        Dim result As String = ""
        Dim align As String
        Dim i As Integer
        Dim pct As Double
        Dim leads As Integer
        Dim tbl As New StringBuilder

        Try
            Using dt As DataTable = ReportsHelper.DispositionBySubId(CampaignID, startdate, enddate, fromhr, tohr)
                If dt.Rows.Count > 0 Then
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    For c As Integer = 0 To dt.Columns.Count - 2
                        If c = 0 Then
                            align = "left"
                        Else
                            align = "center"
                        End If
                        tbl.AppendFormat("<th class='headitem2' align='{0}'>{1}</th>", align, dt.Columns(c).ColumnName)
                    Next
                    tbl.Append("</tr>")

                    For Each row As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                        End If
                        leads = CInt(row("Leads"))
                        For c As Integer = 0 To dt.Columns.Count - 3
                            Select Case c
                                Case 0
                                    tbl.AppendFormat("<td class='griditem2'>{0}</td>", row(c))
                                Case 1 To dt.Columns.Count - 6 'status codes
                                    pct = Val(row(c)) / leads
                                    tbl.AppendFormat("<td class='griditem2' align='center'><a href='#' onclick=""ShowLeads({2},'{3}','{4}')""><u>{0} ({1})</u></a></td>", row(c), FormatPercent(pct, 0), CampaignID, row("SubID1"), dt.Columns(c).ColumnName)
                                Case Else
                                    pct = Val(row(c)) / leads
                                    tbl.AppendFormat("<td class='griditem2' align='center'>{0} ({1})</td>", row(c), FormatPercent(pct, 0))
                            End Select
                        Next
                        tbl.AppendFormat("<td class='griditem2' align='center'>{0}</td>", row("Leads"))
                        i += 1
                    Next
                    tbl.Append("</table>")
                Else
                    tbl.Append("<p>No sub ids available for this campaign</p>")
                End If

                result = tbl.ToString
            End Using
        Catch ex As Exception
            result = String.Concat("<p>", ex.Message, "</p>")
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetDocuments(ByVal docType As enumDocumentType, ByVal uniqueID As String) As String
        Dim result As String = ""
        Try
            Dim cols As String() = {"Fileid", "Filename", "DateAdded"}
            Dim lst As List(Of DocumentObject) = Nothing
            Dim relativeFolder As String = ""

            Select Case docType
                Case enumDocumentType.BuyerDocument
                    lst = BuyersObject.GetDocuments(uniqueID)
                    relativeFolder = "buyers"
                Case enumDocumentType.AdvertiserDocument
                    lst = AdvertiserObject.GetDocuments(uniqueID)
                    relativeFolder = "pub"
                Case enumDocumentType.AffiliateDocument
                    lst = AffiliateObject.GetDocuments(uniqueID)
                    relativeFolder = "pub"
            End Select

            If Not IsNothing(lst) AndAlso lst.Count > 0 Then
                result = "<table id=""tblDocumentTable"" style=""width:100%;"" cellpadding=""0"" cellspacing=""0"">"
                result &= "<thead><tr>"
                result &= "<th align=""left"" style=""display:block;padding:2px;"">File</th>"
                result &= "<th align=""left"" style=""display:block;padding:2px;"">Date Added</th>"
                result &= "<th style=""display:block;padding:2px;"">&nbsp;</th>"
                result &= "</thead></tr>"
                result &= "<tbody style=""height:20px;overflow:auto;display:block;"">"
                For Each dobj As DocumentObject In lst
                    Dim docName As String = Server.HtmlEncode(dobj.Filename)
                    Dim docPath As String = IO.Path.GetFileName(dobj.FilePath)
                    result &= "<tr>"
                    result &= String.Format("<td align=""left"" class=""ui-widget-content"" onclick=""ViewDocument('../{0}/docs/{1}');"" onmouseover=""this.style.cursor='hand';"">{2}</td>", relativeFolder, docPath, docName)
                    result &= String.Format("<td align=""left"" class=""ui-widget-content"">{0}</td>", dobj.DateAdded)
                    result &= String.Format("<td class=""ui-widget-content"" style=""text-align:center""><small><button ID=""btnDeleteDocument_""  style=""cursor:pointer;"" class=""ui-state-default ui-corner-all"" onclick=""return DeleteDocument({0});""><span class=""ui-icon ui-icon-trash""></span></button></small></td>", dobj.DocumentID)
                    result &= "</tr>"
                Next
                result &= "</tbody>"
                result &= "</table>"
            Else
                result &= "<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;""><p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>No Documents!</p></div></div>"
            End If

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetFieldItems(ByVal schoolformid As Integer) As String
        Dim result As List(Of FieldsObject.FieldsItemObject)

        Try
            result = SchoolCampaignsFormDefinitionObject.GetFormFieldItems(schoolformid)
            'tblSchoolCampaigns_LocationCurriculum
        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(New PagedList(result, result.Count, 1, result.Count))
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetFilters(ByVal BuyerOfferXrefID As String) As String
        'List(Of DataManagerHelper.DeliveryScheduleObject)
        Dim dso As List(Of DataManagerHelper.FilterObject) = BuyerHelper.getBuyerFilters(BuyerOfferXrefID)
        Dim result As String = ""
        Dim gv As New GridView
        gv.Width = New Unit(95, UnitType.Percentage)
        gv.AutoGenerateColumns = False
        gv.CssClass = "ui-widget-content"
        Dim cols As String() = {"FilterDescription", "FilterValue"}
        For Each c As String In cols
            Dim bc As New BoundField
            bc.HeaderStyle.CssClass = "ui-widget-header"
            bc.HeaderText = StrConv(c, VbStrConv.ProperCase)

            Select Case c.ToLower
                Case "FilterDescription".ToLower
                    bc.HeaderText = "Filter"
                    With bc.HeaderStyle
                        .Width = New Unit(200)
                        .CssClass = "ui-widget-header"
                        .HorizontalAlign = HorizontalAlign.Left
                    End With
                    With bc.ItemStyle
                        .Width = New Unit(200)
                        .CssClass = "ui-widget-content"
                        .HorizontalAlign = HorizontalAlign.Left
                    End With
                Case "FilterValue".ToLower
                    With bc.HeaderStyle
                        .Width = New Unit(100)
                        .CssClass = "ui-widget-header"
                        .HorizontalAlign = HorizontalAlign.Center
                    End With
                    With bc.ItemStyle
                        .Width = New Unit(100)
                        .CssClass = "ui-widget-content"
                        .HorizontalAlign = HorizontalAlign.Center
                    End With
                    bc.HeaderText = "Value(s)"
            End Select

            bc.Visible = True

            bc.DataField = c
            gv.Columns.Add(bc)

        Next

        Dim cf As New CommandField
        cf.ShowDeleteButton = True

        cf.DeleteImageUrl = "../images/16x16_delete.png"
        cf.ButtonType = ButtonType.Image
        With cf.HeaderStyle
            .CssClass = "ui-widget-header"
            .HorizontalAlign = HorizontalAlign.Center
        End With
        With cf.ItemStyle
            .CssClass = "ui-widget-content"
            .HorizontalAlign = HorizontalAlign.Center
        End With
        gv.Columns.Add(cf)

        Try
            gv.EmptyDataText = "No Filters."
            gv.DataSource = dso
            gv.DataBind()

        Catch ex As Exception
            result = ex.Message
        End Try

        result = ControlToHTML(gv)

        Dim imgDel As String = "<input type=""image"" src=""../images/16x16_delete.png"" alt=""Delete"" style=""border-width:0px;"" />"

        Dim btnDel As String = "<small><button ID=""btnDeletePostField_""  style=""cursor:pointer;"" class=""ui-state-default ui-corner-all"" onclick=""return UpdateInsertFilter(this,'d');""><span class=""ui-icon ui-icon-trash""></span</button></small>"

        result = result.Replace(imgDel, btnDel)

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function DailyLeadsRemaining(schoolformid As Integer) As String
        Dim tbl As DataTable = SqlHelper.GetDataTable("select OnlineDailyRemaining, CallCenterDailyRemaining from tblSchoolCampaigns_FormDefinitions where SchoolFormID = " & schoolformid)
        Return jsonHelper.ConvertDataTableToJSON(tbl)
    End Function

    Private Function GetFormattedValue(field As String, row As DataRow) As String
        Dim value As String = ""

        Select Case field
            Case "VisitDate"
                value = Format(CDate(row("created")), "yyyy-MM-dd hh:mm:ss")
            Case "VisitDateOnly"
                value = Format(CDate(row("created")), "MM/dd/yyyy")
            Case "VisitDateUnix"
                value = CInt((CDate(row("created")) - New DateTime(1970, 1, 1, 0, 0, 0, 0)).TotalSeconds)
            Case "CurrentDateTimeStamp"
                value = Format(Now, "yyyy-MM-dd hh:mm:ss")
            Case "CurrentDateTimeStampUnix"
                value = CInt((Now - New DateTime(1970, 1, 1, 0, 0, 0, 0)).TotalSeconds)
            Case "PhoneWithDashes"
                value = String.Format("{0}-{1}-{2}", Left(row("Phone"), 3), row("Phone").ToString.Substring(3, 3), Right(row("Phone"), 4))
            Case "PhoneArea"
                value = Left(row("Phone"), 3)
            Case "PhonePrefix"
                value = row("Phone").ToString.Substring(3, 3)
            Case "PhoneSuffix"
                value = Right(row("Phone"), 4)
            Case "MoveMonth"
                value = Month(CDate(row("MoveDate")))
            Case "MoveDay"
                value = Day(CDate(row("MoveDate")))
            Case "MoveYear"
                value = Year(CDate(row("MoveDate")))
        End Select

        Return value
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetForm(ByVal schoolformid As Integer) As String
        Dim result As String = ""

        Try
            Dim fd As SchoolCampaignsFormDefinitionObject = SchoolCampaignsFormDefinitionObject.LoadFormDefinition(schoolformid)
            result = jsonHelper.SerializeObjectIntoJson(fd)
        Catch ex As Exception
            Return ex.Message
        End Try

        Return result
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function GetForms(ByVal schoolcampaignid As Integer) As String
        Dim result As New List(Of String())

        Try

            Dim sco As SchoolCampaignObject = SchoolFormControl.SchoolCampaignObject.GetSchoolCampaign(schoolcampaignid)
            For Each fo As SchoolCampaignsFormDefinitionObject In sco.SchoolForms
                result.Add(New String() {fo.SchoolFormID, fo.Name})
            Next
        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(result) 'jsonHelper.SerializeObjectIntoJson(result)
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function GetHistory(ByVal BuyerOfferXrefID As String) As String
        Dim result As String = ""
        Dim tbl As New StringBuilder
        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_datamgr_getContractHistory {0}", BuyerOfferXrefID), CommandType.Text)

            If dt.Rows.Count > 0 Then
                tbl.Append("<table id=""tblHistoryTable"" style=""width:100%"" cellpadding=""0"" cellspacing=""0"">")
                tbl.Append("<thead><tr>")
                For Each dc As DataColumn In dt.Columns
                    Select Case dc.ColumnName.ToLower
                        Case "buyerid".ToLower, "ContractName".ToLower, "buyer".ToLower
                        Case Else
                            tbl.AppendFormat("<th class=""ui-widget-header"">{0}</th>", dc.ColumnName)
                    End Select
                Next
                tbl.Append("</tr></thead>")

                For Each dr As DataRow In dt.Rows
                    tbl.Append("<tr>")
                    tbl.AppendFormat("<td width=""150px"" class=""ui-widget-content"">{0}</td>", dr("Submitted").ToString)
                    tbl.AppendFormat("<td width=""100px"" class=""ui-widget-content"">{0}</td>", dr("ResultCode").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("ResultDesc").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("FullName").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("Offer").ToString)
                    tbl.Append("</tr>")
                Next
                tbl.Append("</table>")
            Else
                tbl.Append("No History.")
            End If

        End Using
        result = tbl.ToString

        Return result
    End Function

    Private Function GetLeadInfo(ByVal LeadID As String, ByVal CategoryId As String) As DataTable
        Dim dt As DataTable = Nothing
        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("LeadID", LeadID))
        Dim query As String = ""
        Select Case CategoryId
            Case -1
                query = "stp_GetLead"
            Case 2
                query = "stp_GetLeadDebt"
            Case 5
                query = "stp_GetLeadRentToOwn"
            Case 7
                query = "stp_GetLeadStudentLoan"
        End Select
        Try
            dt = SqlHelper.GetDataTable(query, CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            LeadHelper.LogError("cmService_GetLeadInfo", ex.Message, ex.StackTrace, LeadID)
        End Try
        Return dt

    End Function

    Private Function GetLastDateSold(Leadid As String, OfferId As String, BuyerId As String) As Date
        'create a default value allowing lead to sell to this offer if never sold before
        Dim dateLastSold As Date = Today.AddYears(-1)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadID", Leadid))
        params.Add(New SqlParameter("OfferId", OfferId))
        params.Add(New SqlParameter("BuyerId", BuyerId))

        Try
            Dim obj As Object = SqlHelper.ExecuteScalar("stp_GetLastDateSold", CommandType.StoredProcedure, params.ToArray)
            If Not obj Is Nothing Then
                dateLastSold = CDate(obj)
            End If
        Catch ex As Exception
            LeadHelper.LogError("cmService_GetLastDateSold", ex.Message, ex.StackTrace, Leadid)
        End Try
        Return dateLastSold
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetLocationCurriculumItems(ByVal schoolformid As Integer) As String
        Dim result As New List(Of SOAPLocationCurriculumObject.CurriculumItem)

        Try
            Dim locs As List(Of SOAPLocationCurriculumObject) = SchoolCampaignsFormDefinitionObject.GetFormLocations(schoolformid)
            For Each l As SOAPLocationCurriculumObject In locs
                result.AddRange(l.CurriculumItems)
            Next

        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(New PagedList(result, result.Count, 1, result.Count))
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetOffers(ByVal advertiserid As String) As String
        Dim result As String = ""
        Dim gv As New GridView
        gv.ID = "gvCOntracts"
        gv.AutoGenerateColumns = False
        gv.CssClass = "ui-widget-content"

        Dim cols As String() = {"Active", "Offer", "Created", "VerticalName"}
        For Each c As String In cols
            Dim bc As New BoundField
            bc.HeaderStyle.CssClass = "ui-widget-header"
            bc.HeaderText = StrConv(c, VbStrConv.ProperCase)
            With bc.HeaderStyle
                '.Width = New Unit(200)
                .CssClass = "ui-widget-header"
                .HorizontalAlign = HorizontalAlign.Left
            End With

            With bc.ItemStyle
                '.Width = New Unit(200)
                .CssClass = "ui-widget-content"
                .HorizontalAlign = HorizontalAlign.Left
            End With
            Select Case c.ToLower
                Case "Active".ToLower
                    bc.HeaderText = ""
                Case Else
                    bc.Visible = True
            End Select

            bc.DataField = c
            gv.Columns.Add(bc)

        Next

        Try
            gv.Width = New Unit(97, UnitType.Percentage)
            gv.PageSize = 20
            gv.EmptyDataText = "<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;""><p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>No Contracts!</p></div></div>"
            gv.DataSource = AdvertiserObject.getAdvertiserOffers(advertiserid)
            gv.DataBind()

            gv.AllowPaging = True
        Catch ex As Exception
            result = ex.Message
        End Try

        result = ControlToHTML(gv)

        result = result.Replace("True", "<img src=""../images/16-circle-green.png"" />")
        result = result.Replace("False", "<img src=""../images/16-circle-red.png"" />")

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetOffersByTag(ByVal tag As String, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As String
        Dim result As String = ""

        Try
            Using dt As DataTable = OfferHelper.GetOfferSummary(tag, startdate, enddate, fromhr, tohr)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem3"">&nbsp;</th>")
                    'tbl.Append("<th class=""headitem3"">&nbsp;</th>") 'Vertical
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""4"">New Leads</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""4"">Revisits</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"" colspan=""5"">All</th>")
                    tbl.Append("</tr>")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem2"" align=""left"">ID</th>")
                    tbl.Append("<th class=""headitem2"" align=""left"">Offer</th>")
                    tbl.Append("<th class=""headitem3"" align=""left"">Advertiser</th>")
                    'tbl.Append("<th class=""headitem3"" align=""left"">Vertical</th>")
                    'New leads
                    tbl.Append("<th class=""headitem2"" align=""center"">Clicks</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv %</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">Rev</th>")
                    'Revisits
                    tbl.Append("<th class=""headitem2"" align=""center"">Clicks</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv %</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">Rev</th>")
                    'Total
                    tbl.Append("<th class=""headitem2"" align=""center"">Clicks</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv %</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Rev</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">EPC</th>")
                    tbl.Append("</tr>")

                    Dim i As Integer = 0
                    Dim newClicks As Integer, newConv As Integer, newRev As Double
                    Dim revisitClicks As Integer, revisitConv As Integer, revisitRev As Double
                    Dim clickTot As Integer, convTot As Integer, recTot As Double

                    For Each dr As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                        End If
                        tbl.AppendFormat("<td class='griditem2'>{0}</td>", dr("offerid").ToString)
                        If tag.ToLower = "online" Then
                            tbl.AppendFormat("<td class='griditem2'><img onclick=""return clickReport({0},'{2}');"" src='../images/pointer.png' style='cursor:pointer' title='Download click report' /><a href=""#"" onclick=""ShowSrcCampaigns({0},'{1}');"" style='text-decoration:underline'>{1}</a></td>", dr("offerid").ToString, dr("offer").ToString, tag)
                        Else
                            tbl.AppendFormat("<td class='griditem2'><a href=""#"" onclick=""ShowCampaigns({0},'{1}');"" style='text-decoration:underline'>{1}</a></td>", dr("offerid").ToString, dr("offer").ToString)
                        End If
                        tbl.AppendFormat("<td class='griditem3'>{0}</td>", dr("advertiser").ToString)
                        'tbl.AppendFormat("<td class='griditem3'>{0}</td>", dr("vertical").ToString)
                        'New leads
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", dr("newclicks").ToString)
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", dr("newconv").ToString)
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", FormatPercent(Val(dr("newconvpct")), 1))
                        tbl.AppendFormat("<td class='griditem3' align=""right"">{0}</td>", FormatCurrency(Val(dr("newreceived")), 0))
                        'Revisits
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", dr("revisitclicks").ToString)
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", dr("revisitconv").ToString)
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", FormatPercent(Val(dr("revisitconvpct")), 1))
                        tbl.AppendFormat("<td class='griditem3' align=""right"">{0}</td>", FormatCurrency(Val(dr("revisitreceived")), 0))
                        'Total
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", dr("clicks").ToString)
                        If CInt(dr("conversions")) = 0 Then
                            tbl.AppendFormat("<td class='griditem2' align=""center"" style='color:red'>{0}</td>", dr("conversions").ToString)
                        Else
                            tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", dr("conversions").ToString)
                        End If
                        tbl.AppendFormat("<td class='griditem2' align=""center"">{0}</td>", FormatPercent(Val(dr("convpct")), 1))
                        tbl.AppendFormat("<td class='griditem2' align=""right"">{0}</td>", FormatCurrency(Val(dr("received")), 0))
                        tbl.AppendFormat("<td class='griditem2' align=""right"">{0}</td>", FormatCurrency(Val(dr("EPC")), 2))
                        tbl.Append("</tr>")
                        newClicks += CInt(dr("newclicks"))
                        newConv += CInt(dr("newconv"))
                        newRev += Val(dr("newreceived"))
                        revisitClicks += CInt(dr("revisitclicks"))
                        revisitConv += CInt(dr("revisitconv"))
                        revisitRev += Val(dr("revisitreceived"))
                        clickTot += CInt(dr("clicks"))
                        convTot += CInt(dr("conversions"))
                        recTot += Val(dr("received"))
                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("<th class=""headitem2"" align=""left"">&nbsp;</th>")
                    Select Case tag.ToLower
                        Case "data", "live transfer", "lead conversion"
                            tbl.Append("<th class=""headitem2"" align=""left""><a href=""#"" onclick=""ShowCampaigns(-1,'All Offers');"" style='text-decoration:underline'>All Offers</a></th>")
                        Case Else
                            tbl.Append("<th class=""headitem2"" align=""left"">&nbsp;</th>")
                    End Select
                    tbl.Append("<th class=""headitem3"" align=""left"">&nbsp;</th>")
                    'tbl.Append("<th class=""headitem3"" align=""left"">&nbsp;</th>") 'Vertical
                    'New leads
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", newClicks)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", newConv)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", FormatPercent(newConv / newClicks, 1))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(newRev, 0))
                    'Revisits
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", revisitClicks)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", revisitConv)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", FormatPercent(revisitConv / revisitClicks, 1))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(revisitRev, 0))
                    'Total
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", clickTot)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", convTot)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", FormatPercent(convTot / clickTot, 1))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(recTot, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(recTot / clickTot, 2))
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No offers were found for this tag.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetPostingFieldItems(ByVal fieldsobjectid As Integer) As String
        Dim result As New StringBuilder
        Dim btns As String = ""
        Try
            Dim fo As FieldsObject = Nothing
            fo = SchoolCampaignsFormDefinitionObject.GetFormField(fieldsobjectid)

            Dim colNames As String() = {"Name", "Value"}
            Dim thClass As String = "class=""ui-widget-header"" style=""width:170px;text-align:left!important;"" "
            Dim tdBtnClass As String = " style=""width:50px;text-align:center!important;"" "

            result.Append("<div style=""height:430px;overflow-y:scroll; overflow-x:hidden;"">")
            result.Append("<table id=""FieldItemsTable"" class=""dataTable"" border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">")
            result.Append("<thead><tr>")
            For Each col As String In colNames
                result.AppendFormat("<th {0}>{1}</th>", thClass, col)
            Next
            result.AppendFormat("<th class=""ui-widget-header"" {0}>&nbsp;</th>", tdBtnClass)
            result.Append("</tr></thead>")

            result.Append("<tbody >")
            For i As Integer = 0 To fo.AcceptedItemName.Count - 1

                btns = String.Format("<img src=""../images/16x16_delete.png"" onclick=""return DeleteFieldItem({0},'{1}','{2}','{3}');"" onmouseover=""this.style.cursor='pointer';""/>", fo.SchoolFormID, fo.AcceptedItemName(i).ToString, fo.AcceptedItemValue(i).ToString, fo.AcceptedItemID(i).ToString)
                btns += String.Format("<img src=""../images/16x16_edit.gif"" onclick=""return EditFieldItem({0},'{1}','{2}','{3}');"" onmouseover=""this.style.cursor='pointer';""/>", fo.SchoolFormID, fo.AcceptedItemName(i).ToString, fo.AcceptedItemValue(i).ToString, fo.AcceptedItemID(i).ToString)

                Dim trClass As String = "class=""ui-widget-content"" style=""height:25px; "" "
                Dim tdClass As String = "style=""width:40%;"" "
                result.AppendFormat("<tr id=""{0}"" {1}>", fo.SchoolFormID, trClass)
                result.AppendFormat("<td {1}><span>{0}</span></td>", fo.AcceptedItemName(i).ToString, tdClass)
                result.AppendFormat("<td {1}><span>{0}</span></td>", fo.AcceptedItemValue(i).ToString, tdClass)
                result.AppendFormat("<td {1}>{0}</td>", btns, tdBtnClass)
                result.AppendFormat("</tr>")
            Next
            result.Append("</tbody>")
            result.Append("</table></div>")
            result.Append("<fieldset style=""padding:5px;""><legend>Add New</legend><table width=""100%"" border=""0"" cellpadding=""0"" cellspacing=""0"">")
            result.Append("<tr class=""ui-widget-header""><th align=""left"">Name</th><th align=""left"">Value</th><th>&nbsp;</th></tr>")
            result.Append("<tr class=""ui-widget-content""><td><input type=""text"" id=""txtnewname"" width=""100%""/></td>")
            btns = String.Format("<A title=""Add"" style=""position:relative!important"" onclick=""return AddFieldItem({0},this);"" class=""Add jqAddButton ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only""><SPAN class=""ui-button-icon-primary ui-icon ui-icon-plus""></SPAN><SPAN class=ui-button-text>Delete</SPAN></A>", fo.SchoolFormID)
            result.AppendFormat("<td><input type=""text"" id=""txtnewvalue"" /></td><td align=""center"" {1}>{0}</td></tr>", btns, tdBtnClass)
            result.Append("</table></fieldset>")
            result.Append("<input type=""hidden"" id=""fieldItmid"" />")
            'result.Append("</div>")
        Catch ex As Exception
            Return ex.Message
        End Try

        Return result.ToString
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetPostingFields(ByVal schoolformid As Integer) As String
        Dim result As List(Of FieldsObject) = Nothing

        Try
            result = SchoolCampaignsFormDefinitionObject.GetFormFields(schoolformid)

        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(New PagedList(result, result.Count, 1, result.Count))
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetPostingInfo(ByVal schoolcampaignid As Integer) As String
        Dim result As SchoolCampaignsFormDefinitionObject = Nothing

        Try
            result = SchoolCampaignsFormDefinitionObject.LoadFormDefinition(schoolcampaignid)

        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(result) 'jsonHelper.SerializeObjectIntoJson(result)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetPostingLocations(ByVal schoolformid As Integer) As String
        Dim result As List(Of SchoolFormControl.SOAPLocationCurriculumObject) = Nothing

        Try
            result = SchoolCampaignsFormDefinitionObject.GetFormLocations(schoolformid)

        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(New PagedList(result, result.Count, 1, result.Count))
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetPostingRules(ByVal schoolformid As Integer) As String
        Dim result As List(Of ValidationRulesObject) = Nothing

        Try
            result = SchoolCampaignsFormDefinitionObject.GetFormRules(schoolformid)

        Catch ex As Exception
            Return ex.Message
        End Try

        Return Newtonsoft.Json.JsonConvert.SerializeObject(New PagedList(result, result.Count, 1, result.Count))
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetProgramsByLocation(schoolformid As Integer, ByVal locationid As String) As String
        Dim options As New List(Of String)

        Using dt As DataTable = SchoolFormControl.SOAPLocationCurriculumObject.FindCurriculumByLocation(schoolformid, locationid, String.Empty)
            For Each dr As DataRow In dt.Rows
                options.Add(String.Format("{0}:{1}", dr("ItemName").ToString, dr("ItemValue").ToString))
            Next
        End Using

        Return Join(options.ToArray, ";")
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetQuestionsBySurvey(ByVal surveyID As String) As DataMiningQuestion()
        Dim qBack = From q In DataMiningHelper.GetQuestions(surveyID) _
                    Select q

        Return qBack.ToArray()
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetReturns(ByVal BuyerOfferXrefID As String) As String
        Dim result As String = ""
        Dim tbl As New StringBuilder
        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_returns_GetByContractID {0}", BuyerOfferXrefID), CommandType.Text)
            If dt.Rows.Count > 0 Then
                tbl.Append("<table id=""tblReturnsTable"" style=""width:100%"" cellpadding=""0"" cellspacing=""0"">")
                tbl.Append("<thead><tr>")
                For Each dc As DataColumn In dt.Columns
                    Select Case dc.ColumnName.ToLower
                        Case "buyerid".ToLower, "ContractName".ToLower, "buyer".ToLower
                        Case Else
                            tbl.AppendFormat("<th class=""ui-widget-header"">{0}</th>", dc.ColumnName)
                    End Select
                Next
                tbl.Append("</tr></thead>")

                For Each dr As DataRow In dt.Rows
                    tbl.Append("<tr>")
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("Submitted").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("Returned").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("ReturnedReason").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("FullName").ToString)
                    tbl.AppendFormat("<td class=""ui-widget-content"">{0}</td>", dr("Offer").ToString)
                    tbl.Append("</tr>")
                Next
                tbl.Append("</table>")
            Else
                tbl.Append("No Returns.")
            End If

        End Using
        result = tbl.ToString

        Return result
    End Function

    <WebMethod()> _
    Public Function GetSchoolCampaign(ByVal schoolcampaignid As Integer) As String
        Dim sco As SchoolCampaignObject = SchoolFormControl.SchoolCampaignObject.GetSchoolCampaign(schoolcampaignid)

        Return jsonHelper.SerializeObjectIntoJson(sco)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetSrcCampaignsByAdvertiser(advertiserid As String, rto As String, vertical As String, startdate As String, enddate As String, direct As Boolean) As String

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("advertiserid", advertiserid))
        params.Add(New SqlParameter("rto", rto))
        params.Add(New SqlParameter("vertical", vertical))
        params.Add(New SqlParameter("startdate", startdate))
        params.Add(New SqlParameter("enddate", enddate & " 23:59"))

        Dim dt As DataTable = Nothing
        Dim result As String = ""
        Dim _direct As String = ""

        If direct Then
            _direct = "_direct"
        End If

        Try
            If CDate(startdate) >= Date.Today.AddDays(-7) Then
                dt = SqlHelper.GetDataTable("stp_reports_debttransfers_breakdown" & _direct, CommandType.StoredProcedure, params.ToArray)
            Else
                dt = SqlHelper.GetDataTable("stp_reports_debttransfers_breakdown" & _direct, CommandType.StoredProcedure, params.ToArray, SqlHelper.ConnectionString.IDENTIFYLEWHSE)
            End If

            If dt.Rows.Count > 0 Then
                Dim tbl As New StringBuilder
                tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                tbl.Append("<tr>")
                tbl.Append("<th class=""headitem2"" align=""left""><br/>Advertiser</th>")
                tbl.Append("<th class=""headitem2"" align=""left""><br/>Offer</th>")
                tbl.Append("<th class=""headitem2"" align=""left""><br/>SubId</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">Ttl<br/>Leads</th>")
                tbl.Append("<th class=""headitem2"" align=""right""><br/>Called</th>")
                tbl.Append("<th class=""headitem2"" align=""right""><br/>Contacted</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">%<br/>Contacted</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">Not<br/>Contacted</th>")
                tbl.Append("<th class=""headitem2"" align=""right""><br/>Dials</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">Dials/<br/>Contact</th>")
                tbl.Append("<th class=""headitem2"" align=""right""><br/>Transferred</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">%<br/>Transferred</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">Contracts<br/>Sent</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">%<br/>Sent</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">Contracts<br/>Signed</th>")
                tbl.Append("<th class=""headitem2"" align=""right"">%<br/>Signed</th>")
                tbl.Append("</tr>")
                Dim i As Integer = 0
                Dim tdCSSClass As String = ""
                Dim clickTot As Double = 0, convTot As Double = 0, recTot As Double = 0
                For Each dr As DataRow In dt.Rows
                    If i Mod 2 = 0 Then
                        tbl.Append("<tr>")
                    Else
                        tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                    End If
                    tdCSSClass = "griditem"
                    tbl.AppendFormat("<td class=""griditem"" align=""left"">{0}</td>", dr("Advertiser").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""left"">{0}</td>", dr("Offer").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""left"">{0}</td>", dr("SubId").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Ttl Leads").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Called").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Contacted").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("% Contacted").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Not Contacted").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Dials").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("DialsPerContact").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Transferred").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("% Transferred").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Contracts Sent").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("% Sent").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("Contracts Signed").ToString)
                    tbl.AppendFormat("<td class=""griditem"" align=""right"">{0}</td>", dr("% Signed").ToString)
                    i += 1
                Next
                tbl.Append("</table>")
                result = tbl.ToString
            Else
                result = "<div>No source campaigns were found for this advertiser.</div>"
            End If

        Catch ex As Exception
            LeadHelper.LogError("cmservice.asmx_GetSrcCampaignsByAdvertiser()", ex.Message, ex.StackTrace)
            result = "<div>{ERROR! - Contact IT} No source campaigns were found for this advertiser.</div>"
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetSrcCampaignsByOffer(ByVal offerid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As String
        Dim result As String = ""
        Try
            Using dt As DataTable = OfferHelper.GetSrcCampaignSummary(offerid, startdate, enddate, fromhr, tohr)
                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem"" align=""left"">Src ID</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">Source Campaign</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">Clicks</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">Conversions</th>")
                    tbl.Append("<th class=""headitem"" align=""center"">Conv %</th>")
                    tbl.Append("<th class=""headitem"" align=""right"">Received</th>")
                    tbl.Append("</tr>")
                    Dim i As Integer = 0
                    Dim tdCSSClass As String = ""
                    Dim clickTot As Double = 0, convTot As Double = 0, recTot As Double = 0
                    For Each dr As DataRow In dt.Rows
                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                        End If
                        tdCSSClass = "griditem"
                        tbl.AppendFormat("<td class=""{1}"">{0}</td>", dr("srccampaignid").ToString, tdCSSClass)
                        'tbl.AppendFormat("<td class=""{0}"" align=""left""><a href='#' onclick=""ShowAddConversions({1},'{2}',{3},'{4}',{5});"" style='text-decoration:underline'>{6}</a></td>", tdCSSClass, dr("campaignid").ToString, dr("offer").ToString, dr("srccampaignid").ToString, dr("campaign").ToString, dr("conversions").ToString, dr("Campaign").ToString)
                        tbl.AppendFormat("<td class=""{0}"" align=""left"">{0}</td>", dr("Campaign").ToString)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", dr("clicks").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", dr("conversions").ToString, tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""center"">{0}</td>", FormatPercent(dr("convpct").ToString, 2), tdCSSClass)
                        tbl.AppendFormat("<td class=""{1}"" align=""right"">{0}</td>", FormatCurrency(IIf(IsDBNull(dr("received")), 0, dr("received").ToString), 2, TriState.True, TriState.False, TriState.True), tdCSSClass)
                        tbl.Append("</tr>")
                        clickTot += CInt(dr("clicks"))
                        convTot += CInt(dr("conversions"))
                        recTot += Val(dr("received"))
                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("<th class=""headitem"" align=""left"">Total</th>")
                    tbl.Append("<th class=""headitem"" align=""left"">&nbsp;</th>")
                    tbl.AppendFormat("<th class=""headitem"" align=""center"">{0}</th>", clickTot)
                    tbl.AppendFormat("<th class=""headitem"" align=""center"">{0}</th>", convTot)
                    tbl.AppendFormat("<th class=""headitem"" align=""center"">{0}</th>", FormatPercent(convTot / clickTot, 2))
                    tbl.AppendFormat("<th class=""headitem"" align=""right"">{0}</th>", FormatCurrency(recTot, 2, TriState.True, TriState.False, TriState.True))
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No source campaigns were found for this offer.</div>"
                End If
            End Using
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetSubIDByCampaign(ByVal campaignid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal export As Boolean, ByVal mtd As Boolean, ByVal fromhr As String, ByVal tohr As String) As String
        Dim result As String = ""
        Dim dt As DataTable

        Try
            If export Then
                If mtd Then
                    Dim sd As Date = CDate(startdate)
                    dt = OfferHelper.GetCampaignSubIDSummaryMTD(campaignid, Month(sd), Year(sd))
                Else
                    dt = OfferHelper.GetCampaignSubIDSummary(campaignid, startdate, enddate, fromhr, tohr)
                End If

                result = ReportsHelper.CsvExport(dt)
            Else
                dt = OfferHelper.GetCampaignSubIDSummaryDetail(campaignid, startdate, enddate, fromhr, tohr)

                If dt.Rows.Count > 0 Then
                    Dim tbl As New StringBuilder
                    tbl.Append("<table style=""width:100%"" cellpadding=""4"" cellspacing=""0"">")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem2"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem3"">&nbsp;</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""3"">Online</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""3"">Live Transfer</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""3"">Data</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"" colspan=""2"">Revisits</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"" colspan=""4"">All</th>")
                    tbl.Append("</tr>")
                    tbl.Append("<tr>")
                    tbl.Append("<th class=""headitem2"" align=""left"">SubID1</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Clicks</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Conv</th>")
                    tbl.Append("<th class=""headitem2"" align=""center"">Bill</th>")
                    tbl.Append("<th class=""headitem3"" align=""center"">Revisits</th>")
                    'Online
                    tbl.Append("<th class=""headitem2"" align=""right"">New</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Revisit</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Live transfer
                    tbl.Append("<th class=""headitem2"" align=""right"">New</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Revisit</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Data
                    tbl.Append("<th class=""headitem2"" align=""right"">New</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Revisit</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Revisits
                    tbl.Append("<th class=""headitem2"" align=""right"">Rev</th>")
                    tbl.Append("<th class=""headitem3"" align=""right"">RPU</th>")
                    'Totals
                    tbl.Append("<th class=""headitem2"" align=""right"">Cost</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Rev</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">Net</th>")
                    tbl.Append("<th class=""headitem2"" align=""right"">RPU</th>")
                    tbl.Append("</tr>")

                    Dim i As Integer = 0
                    Dim clickTot As Integer, convTot As Integer, billableTotal As Integer, total As Double
                    Dim onlineNew As Double, onlineRevisit As Double, onlineTotal As Double
                    Dim ltNew As Double, ltRevisit As Double, ltTotal As Double
                    Dim dataNew As Double, dataRevisit As Double, dataTotal As Double
                    Dim revisitTotal As Double, revisits As Integer
                    Dim costTotal As Double, netTotal As Double

                    For Each dr As DataRow In dt.Rows

                        If i Mod 2 = 0 Then
                            tbl.Append("<tr>")
                        Else
                            tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                        End If
                        tbl.AppendFormat("<td class=""griditem2"">{0}</td>", dr("SubId").ToString)
                        tbl.AppendFormat("<td class=""griditem2"" align=""center"">{0}</td>", dr("Clicks").ToString)
                        tbl.AppendFormat("<td class=""griditem2"" align=""center"">{0}</td>", dr("Conversions").ToString)
                        tbl.AppendFormat("<td class=""griditem2"" align=""center"">{0}</td>", dr("Billable").ToString)
                        tbl.AppendFormat("<td class=""griditem3"" align=""center"">{0}</td>", dr("Revisits").ToString)
                        'Online
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("OnlineNew")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("OnlineRevisit")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("OnlineRPU")), 2))
                        'Live transfer
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransferNew")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransferRevisit")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("LiveTransferRPU")), 2))
                        'Data
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("DataNew")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("DataRevisit")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("DataRPU")), 2))
                        'Revisits
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("TotalRevisit")), 0))
                        tbl.AppendFormat("<td class=""griditem3"" align=""right"">{0}</td>", FormatCurrency(Val(dr("RPURV")), 2))
                        'Totals
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("TotalCost")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("Total")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("TotalNet")), 0))
                        tbl.AppendFormat("<td class=""griditem2"" align=""right"">{0}</td>", FormatCurrency(Val(dr("RPU")), 2))
                        tbl.Append("</tr>")
                        clickTot += CInt(dr("Clicks"))
                        convTot += CInt(dr("Conversions"))
                        billableTotal += CInt(dr("Billable"))
                        onlineNew += Val(dr("OnlineNew"))
                        onlineRevisit += Val(dr("OnlineRevisit"))
                        onlineTotal += Val(dr("Online"))
                        ltNew += Val(dr("LiveTransferNew"))
                        ltRevisit += Val(dr("LiveTransferRevisit"))
                        ltTotal += Val(dr("LiveTransfer"))
                        dataNew += Val(dr("DataNew"))
                        dataRevisit += Val(dr("DataRevisit"))
                        dataTotal += Val(dr("Data"))
                        total += Val(dr("Total"))
                        revisitTotal += Val(dr("TotalRevisit"))
                        revisits += CInt(dr("Revisits"))
                        costTotal += Val(dr("TotalCost"))
                        netTotal += Val(dr("TotalNet"))
                        i += 1
                    Next
                    tbl.Append("<tfoot>")
                    tbl.Append("<th class=""headitem2"" align=""left"">&nbsp;</th>")
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", clickTot)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", convTot)
                    tbl.AppendFormat("<th class=""headitem2"" align=""center"">{0}</th>", billableTotal)
                    tbl.AppendFormat("<th class=""headitem3"" align=""center"">{0}</th>", revisits)
                    'Online
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(onlineNew, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(onlineRevisit, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(onlineTotal / convTot)) 'RPU
                    'Live Transfer
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(ltNew, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(ltRevisit, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(ltTotal / convTot)) 'RPU
                    'Data
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(dataNew, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(dataRevisit, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(dataTotal / convTot)) 'RPU
                    'Revisits
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(revisitTotal, 0))
                    tbl.AppendFormat("<th class=""headitem3"" align=""right"">{0}</th>", FormatCurrency(revisitTotal / revisits)) 'RPU
                    'Totals
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(costTotal, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(total, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(netTotal, 0))
                    tbl.AppendFormat("<th class=""headitem2"" align=""right"">{0}</th>", FormatCurrency(total / convTot)) 'RPU
                    tbl.Append("</tfoot>")
                    tbl.Append("</table>")
                    result = tbl.ToString
                Else
                    result = "<div>No Sub Ids were found for this campaign.</div>"
                End If
            End If
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetSubIDExport(ByVal campaignid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As String
        Dim dt As DataTable = OfferHelper.GetSubIDExport(campaignid, startdate, enddate, fromhr, tohr)
        Return ReportsHelper.CsvExport(dt)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetSubIDExportMTD(ByVal campaignid As Integer, ByVal startdate As String) As String
        Dim sd As Date = CDate(startdate)
        Dim tbl As DataTable = OfferHelper.GetSubIDExportMTD(campaignid, Month(sd), Year(sd))
        Return ReportsHelper.CsvExport(tbl)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetSubIDPickleInfo(ByVal campaignid As Integer) As String
        Dim result As String = ""
        Dim dt As DataTable

        Try
            dt = OfferHelper.GetCampaignSubIDPickleDetail(campaignid)
            If dt.Rows.Count > 0 Then
                Dim tbl As New StringBuilder
                tbl.Append("<table id=""tblSubId"" width=""100%""cellpadding=""4"" cellspacing=""0"">")
                tbl.Append("<tr>")
                tbl.Append("<th class=""headitem2"" align=""center"" style=""width:25px; "">Reset</th>")
                tbl.Append("<th class=""headitem2"" align=""left"">SubId</th>")
                tbl.Append("<th class=""headitem2"" align=""center"" style=""width:50px; "">Pickle</th>")
                tbl.Append("<th class=""headitem2"" align=""center"" style=""width:50px; "">Price</th>")
                tbl.Append("<th class=""headitem2"" align=""center"" style=""width:220px; "">Last Modified</th>")
                tbl.Append("</tr>")

                Dim i As Integer = 0

                For Each dr As DataRow In dt.Rows

                    If i Mod 2 = 0 Then
                        tbl.Append("<tr>")
                    Else
                        tbl.Append("<tr style=""background-color:#f9f9f9;"">")
                    End If
                    tbl.AppendFormat("<td class=""griditem2"" style=""text-align:center; ""><input type=""checkbox"" value=""{0}""/></td>", dr("SubId").ToString)
                    tbl.AppendFormat("<td class=""griditem2 title"" style=""white-space: nowrap;"">{0}</td>", dr("SubId").ToString)
                    tbl.AppendFormat("<td class=""griditem2"" style=""text-align:center; "">{0}</td>", dr("Pickle").ToString)
                    tbl.AppendFormat("<td class=""griditem2"" style=""text-align:center; "">{0}</td>", Format("{0:$#,##0.00}", dr("Price").ToString))
                    tbl.AppendFormat("<td class=""griditem2"" style=""text-align:center; "">{0}</td>", dr("LastModified").ToString)
                    tbl.Append("</tr>")
                    i += 1
                Next
                tbl.Append("</table>")
                tbl.Append("<div style=""background-color:#d5d5d5; padding:8px; border:1px solid #bbbbbb;"">")
                tbl.Append("<button id=""btnSelectAll"" class=""jqButton"" onclick=""SelectAllBoxes(this);"" style=""color:#1c94c4; border:1px solid #cccccc;"">Select All</button>")
                tbl.Append("<button id=""btnDeselectAll"" class=""jqButton"" onclick=""DeselectAllBoxes(this);"" style=""color:#1c94c4; border:1px solid #cccccc; margin: 0 0 0 10px;"">Deselect All</button>")
                tbl.Append("<button id=""btnResetAll"" class=""jqButton"" onclick=""resetCheckboxes(this); return false;"" style=""color:#1c94c4; border:1px solid #cccccc; margin: 0 0 0 10px;"">Reset To Default Values</button>")
                tbl.Append("<div style=""clear:both;"">")
                tbl.Append("</div>")
                tbl.Append("</div>")
                result = tbl.ToString
            Else
                result = "<div>No Sub Ids were found for this campaign.</div>"
            End If
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetTemplates() As String
        Dim templates As New List(Of TemplateObject)
        Dim ssql As String = "SELECT dm.DeliveryMethodID ,box.ContractName FROM tblDeliveryMethod dm with(NOLOCK) inner join tblBuyerOfferXref box WITH(NOLOCK) on dm.BuyerOfferXrefID = box.BuyerOfferXrefID"
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            For Each dr As DataRow In dt.Rows
                templates.Add(New TemplateObject() With {.TemplateID = dr("DeliveryMethodID").ToString, .TemplateName = dr("ContractName").ToString})
            Next
        End Using

        Dim oSerialize As New JavaScriptSerializer

        Return oSerialize.Serialize(templates)
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function getTrickleAmount(ByVal BuyerOfferXrefID As Integer) As Integer
        Dim obj As Object = SqlHelper.ExecuteScalar(String.Format("SELECT Trickle FROM [tblBuyerOfferXref] where BuyerOfferXrefId = {0}", BuyerOfferXrefID), CommandType.Text)
        If Not IsNothing(obj) Then
            Return CInt(obj)
        End If

        Return 0

    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetWebsitesByType(WebSiteTypeID As Integer) As List(Of String())
        Dim tbl As DataTable = SqlHelper.GetDataTable(String.Format("SELECT [WebsiteID], [Name] FROM [tblWebsites] where Type = {0} ORDER BY [Name]", WebSiteTypeID))
        Dim d As New List(Of String())

        For Each row As DataRow In tbl.Rows
            d.Add(New String() {row("WebsiteID"), row("Name")})
        Next

        Return d
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function GetZipcodeItems(ByVal locationid As String) As String
        Dim result As String = ""
        Try
            Using dt As DataTable = SchoolFormControl.SOAPLocationCurriculumObject.FindZipcodesByLocationID(locationid)

            End Using

        Catch ex As Exception
            Return ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertGroup(ByVal groupName As String, ByVal userCreatingID As String) As String
        Dim result As String = GroupsHelper.FormatMsgText("Group Created!!!", GroupsHelper.enumMsgType.msgInfo)
        Try
            If Not String.IsNullOrEmpty(groupName) Then
                Dim ssql As String = String.Format("INSERT INTO tblGroups(Name, Created, CreatedBy) VALUES ('{0}', GETDATE(), {1})", groupName, userCreatingID)
                SqlHelper.ExecuteNonQuery(ssql, Data.CommandType.Text)
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    Private Function InsertSubmittedOffer(ByVal boxID As Integer, ByVal LeadID As Integer, ByVal OfferID As Integer, ByVal BuyerID As Integer, ByVal ResultCode As String, ByVal ResultDesc As String, ByVal ResultId As String, ByVal Valid As Boolean, ByVal CakeId As String, ByVal SellTypeID As Integer, ByVal UpdateStatusOnSuccess As Boolean, VisitDate As Date, RealTime As Boolean) As Integer
        Dim params As New List(Of SqlParameter)
        Dim cmdText As String = "stp_InsertSubmittedOffer"

        params.Add(New SqlParameter("leadid", LeadID))
        params.Add(New SqlParameter("offerid", OfferID))
        params.Add(New SqlParameter("buyerid", BuyerID))
        params.Add(New SqlParameter("resultcode", Trim(Left(ResultCode, 50))))
        params.Add(New SqlParameter("resultdesc", Trim(Left(ResultDesc, 500))))
        params.Add(New SqlParameter("selltypeid", SellTypeID))
        params.Add(New SqlParameter("boxid", boxID))
        params.Add(New SqlParameter("resultid", ResultId))
        params.Add(New SqlParameter("cakeId", CakeId))
        params.Add(New SqlParameter("valid", IIf(Valid, 1, 0)))
        params.Add(New SqlParameter("updatestatusonsuccess", IIf(UpdateStatusOnSuccess, 1, 0)))
        params.Add(New SqlParameter("realtimelead", IIf(RealTime, 1, 0)))

        If DateDiff(DateInterval.Day, VisitDate, Now) > 7 Then
            cmdText &= "Whse"
        End If

        Return CInt(SqlHelper.ExecuteScalar(cmdText, , params.ToArray))
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertQuestion(ByVal dataBatchID As String, ByVal questionQOID As String) As String
        Dim result As String = "Question added!!!"
        Try
            If Not String.IsNullOrEmpty(questionQOID) Then
                Dim dx As String() = questionQOID.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)

                Dim ssql As String = "stp_databatch_Insert_DataBatchQuestion"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("DataBatchID", dataBatchID))
                params.Add(New SqlParameter("QuestionID", dx(0)))
                params.Add(New SqlParameter("OptionID", dx(1)))

                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    Private Sub InsertRealTimePost(LeadID As String, dmo As DeliveryMethodObject, OfferID As String, Description As String)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadId", LeadID))
        params.Add(New SqlParameter("OfferId", OfferID))
        params.Add(New SqlParameter("BuyerOfferXrefId", dmo.BuyerOfferXrefID))
        params.Add(New SqlParameter("BuyerId", dmo.BuyerID))
        params.Add(New SqlParameter("Exclusive", dmo.Exclusive))
        params.Add(New SqlParameter("Description", Description))
        Try
            SqlHelper.ExecuteNonQuery("stp_InsertRealTimePost", CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            LeadHelper.LogError("cmService_InsertRealTimePost", ex.Message, ex.StackTrace, LeadID)
        End Try
    End Sub
    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateAd(ByVal adID As String, ByVal adDescription As String, ByVal adType As String, ByVal adActive As String) As String
        Dim result As String = ""
        Try
            If Not String.IsNullOrEmpty(adDescription) Then

                Select Case adID
                    Case 0      'new
                        result = "Ad Created!"

                    Case Else   'update
                        result = "Ad Updated!"
                End Select

                If adActive.ToLower = "checked" Then
                    adActive = "True"
                Else
                    adActive = "False"
                End If

                Dim ssql As String = "stp_adrotator_insertOrUpdateAd"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("adID", adID))
                params.Add(New SqlParameter("adDescription", adDescription))
                params.Add(New SqlParameter("Active", Boolean.Parse(adActive)))
                params.Add(New SqlParameter("AdTypeid", adType))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Else
                result = "Ad Description is required, Please retry!"
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateAdOffer(ByVal adID As String, ByVal adOfferID As String, ByVal offerDescription As String, ByVal offerredirecturl As String, ByVal offerweight As String, ByVal offerActive As String) As String
        Dim result As String = ""
        Try
            If Not String.IsNullOrEmpty(offerDescription) AndAlso Not String.IsNullOrEmpty(offerredirecturl) AndAlso Not String.IsNullOrEmpty(offerweight) Then
                Select Case adOfferID
                    Case 0      'new
                        result = "Offer Created!"

                    Case Else   'update
                        result = "Offer Updated!"
                End Select

                Dim ssql As String = "stp_adrotator_insertOrUpdateOffer"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("adID", adID))
                params.Add(New SqlParameter("adOfferID", adOfferID))
                params.Add(New SqlParameter("offerDescription", offerDescription))
                params.Add(New SqlParameter("offerredirecturl", offerredirecturl))
                params.Add(New SqlParameter("weight", offerweight))
                params.Add(New SqlParameter("Active", Boolean.Parse(offerActive)))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Else
                result = "Offer Description, Redirect Url and Weight are required, Please retry!"
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateAdvertiser(ByVal newadvertiser As AdvertiserObject) As String

        Dim result As String = "Advertiser "
        If newadvertiser.AdvertiserID = -1 Then
            result += "Created!"
        Else
            result += "Saved!"
        End If

        If Not String.IsNullOrEmpty(newadvertiser.Name) Then
            Try
                Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
                Dim ssql As String = "stp_advertisers_InsertUpdateAdvertiser"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("AdvertiserID", newadvertiser.AdvertiserID))
                params.Add(New SqlParameter("Name", newadvertiser.Name))
                params.Add(New SqlParameter("AccountManager", newadvertiser.AccountManager))
                params.Add(New SqlParameter("Website", newadvertiser.Website))
                params.Add(New SqlParameter("BillingCycle", newadvertiser.BillingCycle))
                params.Add(New SqlParameter("Street", newadvertiser.Street))
                params.Add(New SqlParameter("City", newadvertiser.City))
                params.Add(New SqlParameter("State", newadvertiser.State))
                params.Add(New SqlParameter("Zip", newadvertiser.Zip))
                params.Add(New SqlParameter("Country", newadvertiser.Country))
                params.Add(New SqlParameter("Notes", newadvertiser.Notes))
                params.Add(New SqlParameter("Active", newadvertiser.Active))
                params.Add(New SqlParameter("userid", currentuserid))

                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Offer name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateAdvertiserContact(ByVal newcontact As ContactObject) As String
        Dim result As String = "Contact Created!"

        If Not String.IsNullOrEmpty(newcontact.FullName) Then
            Try
                Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
                BuyerHelper.InsertContact(enumDocumentType.AdvertiserDocument, newcontact)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Contact name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateAffiliate(ByVal newaffiliate As AffiliateObject) As String

        Dim result As String = "Affiliate "
        If newaffiliate.AffiliateID = -1 Then
            result += " Created!"
        Else
            result += " Saved!"
        End If

        If Not String.IsNullOrEmpty(newaffiliate.Name) Then
            Try

                Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
                Dim ssql As String = "stp_advertisers_InsertUpdateAffiliate"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("affiliateid", newaffiliate.AffiliateID))
                params.Add(New SqlParameter("Name", newaffiliate.Name))
                params.Add(New SqlParameter("AccountManager", newaffiliate.AccountManager))
                params.Add(New SqlParameter("Website", newaffiliate.Website))
                params.Add(New SqlParameter("BillingCycle", newaffiliate.BillingCycle))
                params.Add(New SqlParameter("Street", newaffiliate.Street))
                params.Add(New SqlParameter("City", newaffiliate.City))
                params.Add(New SqlParameter("State", newaffiliate.State))
                params.Add(New SqlParameter("Zip", newaffiliate.Zip))
                params.Add(New SqlParameter("Country", newaffiliate.Country))
                params.Add(New SqlParameter("Notes", newaffiliate.Notes))
                params.Add(New SqlParameter("Active", newaffiliate.Active))
                params.Add(New SqlParameter("userid", currentuserid))

                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Affiliate name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateAffiliateContact(ByVal newcontact As ContactObject) As String
        Dim result As String = "Contact Created!"

        If Not String.IsNullOrEmpty(newcontact.FullName) Then
            Try
                Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
                BuyerHelper.InsertContact(enumDocumentType.AffiliateDocument, newcontact)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Contact name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateBatch(ByVal batchID As String, ByVal BatchName As String, ByVal batchActive As String) As String
        Dim result As String = "Batch Created!!!"
        Try
            If Not batchID = "-1" Then
                If Not String.IsNullOrEmpty(batchID) AndAlso Not String.IsNullOrEmpty(BatchName) Then
                    Dim ssql As String = "stp_databatch_UpdateBatch"
                    Dim params As New List(Of SqlParameter)
                    params.Add(New SqlParameter("DataBatchID", batchID))
                    params.Add(New SqlParameter("BatchName", BatchName))
                    params.Add(New SqlParameter("Active", Boolean.Parse(batchActive)))
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
                End If
            Else
                If Not String.IsNullOrEmpty(BatchName) Then
                    Dim ssql As String = "stp_databatch_InsertBatch"
                    Dim params As New List(Of SqlParameter)
                    params.Add(New SqlParameter("BatchName", BatchName))
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
                Else
                    result = "Batch name is required!"
                End If
            End If
        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateBuyer(ByVal newbuyer As BuyersObject) As String
        Dim result As String = "Buyer "
        If newbuyer.BuyerID = -1 Then
            result += "created !"
        Else
            result += "updated !"
        End If
        If Not String.IsNullOrEmpty(newbuyer.Buyer) Then
            Try
                Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
                BuyerHelper.InsertUpdateBuyer(newbuyer, currentuserid)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Buyer name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateBuyerContact(ByVal newcontact As ContactObject) As String
        Dim result As String = "Contact Created!"

        If Not String.IsNullOrEmpty(newcontact.FullName) Then
            Try
                Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
                BuyerHelper.InsertContact(enumDocumentType.BuyerDocument, newcontact)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Contact name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateCampaign(ByVal currentcampaign As CampaignObject) As String
        Dim result As String = "Campaign "
        Dim Userid = CInt(HttpContext.Current.User.Identity.Name)
        Dim pickle As Integer

        If Not IsNothing(currentcampaign) Then
            Try
                If currentcampaign.CampaignID = -1 Then
                    'create
                    result += "created successfully!"
                Else
                    'update
                    result += "updated successfully!"
                End If

                If currentcampaign.MediaType.Contains("|") Then
                    Dim ids() As String = Split(currentcampaign.MediaType, "|")
                    currentcampaign.MediaTypeID = ids(0)
                    currentcampaign.TrafficTypeID = ids(1)
                End If

                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("CampaignID", currentcampaign.CampaignID))
                params.Add(New SqlParameter("Campaign", currentcampaign.Campaign))
                params.Add(New SqlParameter("Priority", currentcampaign.Priority))
                params.Add(New SqlParameter("AffiliateID", currentcampaign.AffiliateID))
                params.Add(New SqlParameter("OfferID", currentcampaign.OfferID))
                params.Add(New SqlParameter("MediaTypeID", currentcampaign.MediaTypeID))
                params.Add(New SqlParameter("TrafficTypeID", currentcampaign.TrafficTypeID))
                params.Add(New SqlParameter("Price", currentcampaign.Price))
                params.Add(New SqlParameter("AffiliatePixel", currentcampaign.AffiliatePixel))
                params.Add(New SqlParameter("Active", currentcampaign.Active))
                params.Add(New SqlParameter("userid", Userid))
                SqlHelper.ExecuteNonQuery("stp_campaigns_InsertUpdate", , params.ToArray)

                pickle = Val(currentcampaign.Pickle)

                Dim sParams As New List(Of SqlParameter)
                sParams.Add(New SqlParameter("CampaignID", currentcampaign.CampaignID))
                sParams.Add(New SqlParameter("Pickle", pickle))
                sParams.Add(New SqlParameter("Price", currentcampaign.Price))
                sParams.Add(New SqlParameter("Active", IIf(pickle > 0, 1, 0)))
                sParams.Add(New SqlParameter("UserID", Userid))
                sParams.Add(New SqlParameter("SubId", ""))
                sParams.Add(New SqlParameter("IsDefault", currentcampaign.IsDefault))
                SqlHelper.ExecuteNonQuery("stp_SavePickle", , sParams.ToArray)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "There is a problem with this campaign's id"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateGroup(ByVal groupid As String, ByVal groupname As String, ByVal usercreatingid As String) As String
        Dim result As String = "Group "
        Try
            If groupid = -1 Then
                result += "created successfully!!"
            Else
                result += "updated successfully!!"
            End If
            If Not String.IsNullOrEmpty(groupname) Then
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("GroupId", groupid))
                params.Add(New SqlParameter("Name", groupname))
                params.Add(New SqlParameter("CreatedBy", usercreatingid))

                SqlHelper.ExecuteNonQuery("stp_groups_InsertUpdate", Data.CommandType.StoredProcedure, params.ToArray)
            End If

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateOffer(ByVal newoffer As OfferObject) As String
        Dim result As String = "Offer Saved!"
        If Not String.IsNullOrEmpty(newoffer.Offer) Then
            Try
                Dim CurrentUserid = CInt(HttpContext.Current.User.Identity.Name)
                Dim ssql As String = "stp_offer_InsertUpdateOffer"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("offerid", newoffer.OfferID))
                params.Add(New SqlParameter("offer", newoffer.Offer))
                params.Add(New SqlParameter("offerlink", newoffer.OfferLink))
                params.Add(New SqlParameter("active", newoffer.Active))
                'params.Add(New SqlParameter("transferdata", newoffer.TransferData)) 'obsolete
                params.Add(New SqlParameter("callcenter", newoffer.CallCenter))
                params.Add(New SqlParameter("userid", CurrentUserid))
                params.Add(New SqlParameter("advertiserid", newoffer.AdvertiserID))
                params.Add(New SqlParameter("verticalid", newoffer.VerticalID))
                params.Add(New SqlParameter("Tag", newoffer.Tag))
                params.Add(New SqlParameter("Received", newoffer.Received))

                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Offer name is required!"
        End If

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateSchoolCampaign(ByVal schoolcampaign As SchoolCampaignObject) As String
        Dim result As String = ""
        Try
            If SchoolCampaignObject.InsertUpdateSchoolCampaigns(schoolcampaign) = True Then
                result = "School campaign created successfully!"
            Else
                result = "There was a problem creating the School campaign!"
            End If
        Catch ex As Exception
            result = ex.Message.ToLower
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateSchoolFieldItem(fielditemid As String, schoolcampaignid As String, schoolformid As String, fieldname As String, name As String, value As String) As String
        Dim result As String = "Field Item Saved!"
        Try
            Dim ssql As String = "stp_schoolcampaign_InsertUpdateFieldItem"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("fielditemid", fielditemid))
            params.Add(New SqlParameter("SchoolCampaignID", schoolcampaignid))
            params.Add(New SqlParameter("schoolformid", schoolformid))
            params.Add(New SqlParameter("FieldName", fieldname))
            params.Add(New SqlParameter("name", name))
            params.Add(New SqlParameter("value", value))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)


        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function
    <System.Web.Services.WebMethod()> _
    Public Function InsertUpdateSchoolLocationCurriculum(schoolformid As String, locationid As String, curriculumitemid As String, name As String, value As String, outcome As String) As String
        Dim result As String = "Curriculum Item Saved!"
        Try

            Dim locCurID As String = SqlHelper.ExecuteScalar(String.Format("select LocationCurriculumID from tblSchoolCampaigns_LocationCurriculum where LocationID = {0}", locationid), CommandType.Text)

            If Not String.IsNullOrEmpty(locCurID) Then
                Dim ssql As String = "stp_schoolcampaign_InsertUpdateLocationCurriculumItems"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("SchoolFormID", schoolformid))
                params.Add(New SqlParameter("LocationCurriculumID", locCurID))
                params.Add(New SqlParameter("LocationCurriculumItemID", curriculumitemid))
                params.Add(New SqlParameter("ItemName", name))
                params.Add(New SqlParameter("ItemValue", value))
                params.Add(New SqlParameter("Outcome", outcome.Replace("%27", "''").Replace("%20", " ")))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            End If
        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function LoadCategoryData(ByVal schoolformid As String) As String
        Dim co As New CategoryObject
        Dim ssql As String = ""
        Dim usedItems As New List(Of String)
        Using dt As DataTable = SqlHelper.GetDataTable("select CurriculumCategoryID,CurriculumCategory from tblSchoolCampaigns_LocationCurriculumCategory order by CurriculumCategory", CommandType.Text)
            For Each dr As DataRow In dt.Rows
                ssql = "SELECT distinct lci.LocationCurriculumID,lci.ItemName,isnull(lci.ItemValue,lci.ItemName)[ItemValue],lci.Outcome,lci.CurriculumCategoryID "
                ssql += "from tblSchoolCampaigns_LocationCurriculum lc WITH(NOLOCK) inner join tblSchoolCampaigns_LocationCurriculumItems lci WITH(NOLOCK) ON lc.locationcurriculumid = lci.locationcurriculumid "
                ssql += String.Format("where lci.CurriculumCategoryID = {0} and lc.schoolformid = {1} ", dr("CurriculumCategoryID").ToString, schoolformid)
                ssql += "order by lci.ItemName"
                Using dtc As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                    'build html layout for jquery accordion
                    co.CurriculumCategories += String.Format("<h3>{0} ({1})</h3>", dr("CurriculumCategory").ToString, dtc.Rows.Count.ToString)
                    co.CurriculumCategories += String.Format("<div class=""dropCategory"" id=""{0}"" value=""{0}""  >", dr("CurriculumCategoryID").ToString)
                    co.CurriculumCategories += "<ul class=""placeholder"" style=""margin-left:-5;min-height:25px;max-height:100px;"" >"

                    For Each drc As DataRow In dtc.Rows
                        co.CurriculumCategories += String.Format("<li class=""dragCurriculum"" id=""{1}"">{0} (<img title=""Click to Remove"" src=""../images/16-em-cross.png"" onclick=""removeMe(this,'{1}');"" onmouseover=""this.style.cursor='pointer';""/>)</li>", drc("ItemName").ToString, drc("ItemValue").ToString)
                        usedItems.Add(drc("ItemValue").ToString)
                    Next
                End Using

                co.CurriculumCategories += "</ul></div>"
            Next
        End Using

        ssql = "SELECT distinct lci.LocationCurriculumID,lci.LocationCurriculumItemID,lci.ItemName,isnull(lci.ItemValue,lci.ItemName)[ItemValue],lci.Outcome,lci.CurriculumCategoryID "
        ssql += "from tblSchoolCampaigns_LocationCurriculum lc WITH(NOLOCK) inner join tblSchoolCampaigns_LocationCurriculumItems lci WITH(NOLOCK) ON lc.locationcurriculumid = lci.locationcurriculumid "
        ssql += String.Format("where lc.schoolformid = {0} order by lci.ItemName", schoolformid)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            If dt.Rows.Count > 0 Then
                'co.CurriculumItems = "<ul id=""itemList"" style=""height:300px; overflow-y:scroll"">"
                For Each dr As DataRow In dt.Rows
                    If Not usedItems.Contains(dr("ItemValue").ToString) Then
                        co.CurriculumItems += String.Format("<div class=""dragCurriculum ui-state-default"" onmouseover=""this.style.cursor='pointer';this.style.backgroundColor='#4791C5'"" id=""{1}"" ><input type=""checkbox"" id=""chk_{2}""/>{0}</div>", dr("ItemName").ToString, dr("ItemValue").ToString, dr("LocationCurriculumItemID").ToString)
                    End If
                Next
                'co.CurriculumItems += "</ul>"
            End If
        End Using

        Return jsonHelper.SerializeObjectIntoJson(co)
    End Function

    <WebMethod()> _
    Public Function LoadQuestion(questionid As String) As String
        Dim result As String = "load question"
        Try

            Dim ssql As String = "select QuestionID, Question,QuestionPlainText,QuestionType,[Options] =  (SELECT '|' + cast(optionid as varchar) + ':' + optiontext FROM tblOptions where QuestionID = q.questionid	ORDER BY LEN(optionid) FOR XML PATH('')),QuestionBranchUrl,QuestionBranchResponse,QuestionOfferID,QuestionPopUnderUrl,QuestionPopUpUrl,Active "
            ssql += "from tblQuestion q where questionid = @questionid"

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("questionid", questionid))

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text, params.ToArray)
                dt.TableName = "question"
                result = Newtonsoft.Json.JsonConvert.SerializeObject(dt)

            End Using
        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function

    <WebMethod()> _
    Public Function LoadPaths(websiteid As String) As String
        Dim html As New StringBuilder

        Dim ssql As String = "stp_Webpaths_Select"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("websiteid", websiteid))
        Using tbl As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
            For Each rw As DataRow In tbl.Rows
                html.Append("<li>")
                html.AppendFormat("<a href=""javascript:pullpath({0});"">{1}</a>", rw("WebsitePathId"), rw("Name"))
                html.Append("</li>")
            Next
        End Using

        Return html.ToString
    End Function

    <WebMethod()> _
    Public Function LoadWebPages(webpathid As String) As String
        Dim html As New StringBuilder

        Dim ssql As String = "stp_Webpage_Select"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("webpathid", webpathid))
        'Dim dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)

        Using tbl As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
            For Each rw As DataRow In tbl.Rows
                Dim checkmark As String = ""
                If rw("Active").ToString = "True" Then
                    checkmark = "checked=""checked"""
                End If

                html.Append("<li id=""gt"">")
                html.AppendFormat("<input id=""{0}"" type=""checkbox"" {2} /><a href=""#"">{1}</a>", rw("WebsitePageId"), rw("Name"), checkmark)
                html.Append("</li>")
            Next
        End Using

        Return html.ToString
    End Function

    <WebMethod()> _
    Public Function LoadWebsite(websiteid As String) As String
        Dim result As String = "load"

        Try
            Dim wo As New websiteObject
            Dim ssql As String = "stp_websites_select"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("websiteid", websiteid))
            Using tbl As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                For Each row As DataRow In tbl.Rows
                    With wo
                        .WebsiteID = websiteid
                        .Name = row("name").ToString
                        .Description = row("Description").ToString
                        .URL = row("URL").ToString
                        .WebSiteTypeID = row("type").ToString
                        .DefaultSurveyID = row("DefaultSurveyID").ToString
                        .Code = row("Code").ToString
                        .DisclosureText = row("DisclosureText").ToString
                    End With
                Next
            End Using

            result = Newtonsoft.Json.JsonConvert.SerializeObject(wo)
        Catch ex As Exception
            Return ex.Message
        End Try
        Return result
    End Function

    Private Sub LogPost(BuyerOfferXrefID As Integer, ByVal Result As String, ByVal PostString As String, Response As String, LeadID As Integer)
        Try
            Dim cmdText As String = String.Format("insert tblPostLog (Type,CampaignID,Result,RawUrl,Response,LeadID) values ('DataMgr','{0}','{1}','{2}','{3}',{4})", BuyerOfferXrefID, Result, PostString.Replace("'", ""), Response.Replace("'", ""), LeadID)
            SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Function ProcessReturns(ByVal returnfilepath As String, ByVal buyerid As String, ByVal leaddatastring As String, ByVal bundo As String) As String
        Dim bo As BuyersObject = BuyerHelper.getBuyer(buyerid)
        Dim ld As String() = leaddatastring.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
        Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
        Dim iProcessed As Integer = 0
        Dim iWarning As Integer = 0
        Dim result As String = String.Format("Buyer : {0}<br/>", bo.Buyer)
        result += "<strong>RESULTS</strong><br/><i>"
        result += String.Format("# Selected : {0}<br/>", ld.Length)

        Dim dpath As String = HttpUtility.UrlDecode(returnfilepath, System.Text.Encoding.Default())
        Dim warnings As String = ""
        For Each lead As String In ld
            Dim leadInfo As String() = lead.Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)
            If leadInfo.Length > 1 Then
                Dim ssql As String = "stp_returns_ReturnLead"
                Dim params As New List(Of SqlParameter)
                If IsNumeric(leadInfo(0)) Then
                    params.Add(New SqlParameter("LeadID", leadInfo(0)))
                    params.Add(New SqlParameter("BuyerID", buyerid))
                    params.Add(New SqlParameter("Reason", leadInfo(1)))
                    params.Add(New SqlParameter("undo", bundo))
                    Dim tr As String = SqlHelper.ExecuteScalar(ssql, CommandType.StoredProcedure, params.ToArray)
                    If Not String.IsNullOrEmpty(tr) Then
                        warnings += String.Format("{0}<br/>", tr)
                        iWarning += 1
                    Else
                        iProcessed += 1
                    End If
                End If
            End If
        Next
        result += String.Format("# Returned : {0}<br/>", iProcessed)
        result += String.Format("# Warnings : {0}<br/></i>", iWarning)
        If Not String.IsNullOrEmpty(warnings) Then
            result += String.Format("<hr/><strong>WARNINGS</strong><br/>{0}", warnings)
        End If

        If iProcessed > 0 AndAlso bundo = 0 Then
            ReturnsHelper.InsertReturn(buyerid, dpath, currentuserid)
        End If

        bo = Nothing
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveCategoryData(categoryid As String, itemid As String) As String
        Dim result As String = ""
        Try
            Dim ssql As String = String.Format("UPDATE tblSchoolCampaigns_LocationCurriculumItems SET CurriculumCategoryID = {0} where ItemValue = '{1}'", categoryid, itemid)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SetAsDefaultValue(ByVal subId As CampaignObject) As String
        Dim result As String = ""

        Dim subIds As String = subId.SubId
        Dim campaignId As Integer = subId.CampaignID

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("campaignId", campaignId))
        params.Add(New SqlParameter("subIds", subIds))

        Try
            SqlHelper.ExecuteNonQuery("stp_ResetSubIdDefaults", CommandType.StoredProcedure, params.ToArray)
            result = String.Format("{0} were set to their default values.", subIds)
        Catch ex As Exception
            result = "SubIds could not be set to their default values."
        End Try

        Return result
    End Function


    <System.Web.Services.WebMethod()> _
    Public Function SaveContractInfo(ByVal currentcontract As BuyerContractObject) As String
        Dim result As String = ""

        Try
            If Not String.IsNullOrEmpty(currentcontract.BuyerOfferXrefID) Then
                result = String.Format("Contract Saved!")
                Dim ssql As String = "stp_datamgr_InsertUpdateContract"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("boxid", currentcontract.BuyerOfferXrefID))
                params.Add(New SqlParameter("BuyerID", currentcontract.BuyerID))
                params.Add(New SqlParameter("ContractName", currentcontract.ContractName))
                params.Add(New SqlParameter("ServiceTel", currentcontract.ServicePhoneNumber))
                params.Add(New SqlParameter("dailycap", currentcontract.DailyCap))
                params.Add(New SqlParameter("instructions", currentcontract.Instructions))
                params.Add(New SqlParameter("invoiceprice", currentcontract.InvoicePrice))
                params.Add(New SqlParameter("price", currentcontract.Price))
                params.Add(New SqlParameter("priority", currentcontract.Priority))
                params.Add(New SqlParameter("offerid", currentcontract.OfferID))
                params.Add(New SqlParameter("exclusive", ConvertTextToBoolean(currentcontract.Exclusive)))
                params.Add(New SqlParameter("active", ConvertTextToBoolean(currentcontract.Active)))
                params.Add(New SqlParameter("DupAttempt", currentcontract.DupAttempt))
                params.Add(New SqlParameter("weight", currentcontract.Weight))
                params.Add(New SqlParameter("dataSQL", currentcontract.DataSQL))
                params.Add(New SqlParameter("docakepost", ConvertTextToBoolean(currentcontract.DoCakePost)))
                params.Add(New SqlParameter("throttle", ConvertTextToBoolean(currentcontract.Throttle)))
                params.Add(New SqlParameter("callcenter", ConvertTextToBoolean(currentcontract.CallCenter)))
                params.Add(New SqlParameter("datatransfer", ConvertTextToBoolean(currentcontract.DataTransfer)))
                params.Add(New SqlParameter("calltransfer", ConvertTextToBoolean(currentcontract.CallTransfer)))
                params.Add(New SqlParameter("sortfield", IIf(String.IsNullOrEmpty(currentcontract.DataSortField), DBNull.Value.ToString, currentcontract.DataSortField)))
                params.Add(New SqlParameter("sortdir", IIf(String.IsNullOrEmpty(currentcontract.DataSortDir), DBNull.Value.ToString, currentcontract.DataSortDir)))
                params.Add(New SqlParameter("contracttypeid", currentcontract.ContractTypeID))
                params.Add(New SqlParameter("pointvalue", currentcontract.PointValue))
                params.Add(New SqlParameter("WebsiteTypeid", currentcontract.WebsiteTypeid))
                params.Add(New SqlParameter("NoScrub", currentcontract.NoScrub))
                params.Add(New SqlParameter("ExcludeDNC", ConvertTextToBoolean(currentcontract.ExcludeDNC)))
                params.Add(New SqlParameter("WirelessOnly", ConvertTextToBoolean(currentcontract.WirelessOnly)))
                params.Add(New SqlParameter("LandlineOnly", ConvertTextToBoolean(currentcontract.LandlineOnly)))
                params.Add(New SqlParameter("AgedMinutes", currentcontract.AgedMinutes))
                params.Add(New SqlParameter("RealTimeMinutes", currentcontract.RealTimeMinutes))
                params.Add(New SqlParameter("Trickle", currentcontract.Trickle))

                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Else
                result = "Contract is required, Please retry!"
            End If

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try
        Return result
    End Function

    Private Function ProcessTXTResult(ByVal dm As DeliveryMethodObject, LeadID As Integer, OfferID As Integer, Created As Date, ByVal TxtResults As String, ByVal typeOfSale As Integer, postError As Boolean, Optional ByVal RtLead As Boolean = True) As Boolean
        Dim Valid As Boolean
        Dim bUpdateStatus As Boolean
        Dim ResultId As String = ""
        Dim ResultCode As String = ""

        'for contracts that return only a numeric response
        If Val(TxtResults) > 0 AndAlso dm.ResponseSuccessText.Equals("(numeric)") Then
            Valid = True
            ResultId = Trim(TxtResults)
            ResultCode = "success"
        Else
            Dim successResponses() As String = Split(dm.ResponseSuccessText, ",")

            For i As Integer = 0 To successResponses.Count - 1
                If TxtResults.ToLower.Contains(successResponses(i).ToLower) Then
                    ResultCode = "success" 'successResponses(i)
                    Valid = True
                    Exit For
                End If
            Next
        End If

        If Not Valid Then
            ResultCode = "invalid"
            If postError Then
                Valid = False 'always invalid if an error occured communicating with their server
            Else
                Valid = dm.NoScrub
            End If
        End If

        If dm.Exclusive And dm.OfferId <> 290 And dm.BuyerID <> 527 Then 'list mgt, identifyle(internal post)
            bUpdateStatus = True
        End If

        InsertSubmittedOffer(dm.BuyerOfferXrefID, LeadID, OfferID, dm.BuyerID, ResultCode, TxtResults, ResultId, Valid, "", typeOfSale, bUpdateStatus, Created, RtLead)

        Return Valid

    End Function

    Private Function ProcessXMLResult(ByVal dm As DeliveryMethodObject, LeadID As Integer, OfferID As Integer, Created As Date, ByVal XmlResults As String, ByVal typeOfSale As Integer, postError As Boolean, Optional ByVal RtLead As Boolean = True) As Boolean
        Dim Valid As Boolean
        Dim xmlDoc As New XmlDocument
        Dim ResultId As String = ""
        Dim ResultCode As String = ""
        'Dim ResultDesc As String = ""
        Dim bUpdateStatus As Boolean

        Try
            XmlResults = XmlResults.Replace("\n", "").Replace("\r", "").Trim
            xmlDoc.XmlResolver = Nothing
            xmlDoc.LoadXml(XmlResults)
            If xmlDoc.DocumentElement.NamespaceURI <> String.Empty Then
                xmlDoc.LoadXml(xmlDoc.OuterXml.Replace(xmlDoc.DocumentElement.NamespaceURI, ""))
                xmlDoc.DocumentElement.RemoveAllAttributes()
            End If
            If Not String.IsNullOrEmpty(dm.ResponseResultID_XML) Then
                If Not IsNothing(xmlDoc.SelectSingleNode(dm.ResponseResultID_XML)) Then
                    ResultId = xmlDoc.SelectSingleNode(dm.ResponseResultID_XML).InnerText
                End If
            End If
            ResultCode = xmlDoc.SelectSingleNode(dm.ResponseResultCode_XML).InnerText

            Dim successText() As String = Split(dm.ResponseSuccessText, ",") 'in case there are multiple responses that are valid

            For i As Integer = 0 To successText.Length - 1
                If ResultCode.ToLower.Contains(successText(i).ToLower) Then
                    Valid = True
                    Exit For
                End If
            Next

            If Not Valid Then
                If postError Then
                    Valid = False 'always invalid if an error occured communicating with their server
                Else
                    Valid = dm.NoScrub
                End If
            End If
        Catch ex As Exception
            ResultCode = "Error"
        End Try

        If dm.Exclusive And dm.OfferId <> 290 Then 'list mgt
            bUpdateStatus = True
        End If
        InsertSubmittedOffer(dm.BuyerOfferXrefID, LeadID, OfferID, dm.BuyerID, ResultCode, XmlResults, ResultId, Valid, "", typeOfSale, bUpdateStatus, Created, RtLead)

        Return Valid
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveContractWebsites(contractid As String, websitetypeid As Integer, websiteids As String, userid As String) As String
        Dim result As String = "Websites updated successfully!"
        Try

            Dim ssql As String = "stp_buyer_InsertUpdateWebsites"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("BuyerOfferXrefID", contractid))
            params.Add(New SqlParameter("websitetypeid", websitetypeid))
            params.Add(New SqlParameter("websiteidlist", websiteids))
            params.Add(New SqlParameter("userid", userid))

            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveCurriculumToGroup(groupName As String, curriculumIDs As String) As String
        Dim result As String = "Curriculum Added!"
        Try
            Dim idx As Integer = groupName.IndexOf("(")
            If idx > 0 Then
                Dim gname As String = groupName.Substring(0, idx - 1)
                Dim gId As String = SqlHelper.ExecuteScalar(String.Format("select CurriculumCategoryID from tblSchoolCampaigns_LocationCurriculumCategory where CurriculumCategory = '{0}'", gname), CommandType.Text)
                Dim ssql As String = String.Format("UPDATE tblSchoolCampaigns_LocationCurriculumItems SET CurriculumCategoryID = {0} where LocationCurriculumItemID in ({1})", gId, curriculumIDs)
                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
            End If

        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveForm(ByVal schoolformid As Integer, ByVal formname As String, ByVal posturl As String, ByVal leadsremaining As String, _
        dailylimit As String, ByVal schoollogourl As String, ByVal schooldescription As String, bactive As String, bmatch As String, _
        callcentermonthlyallocation As String, callcenterdailyallocation As String) As String
        Dim result As String = ""

        Try

            result = SchoolCampaignsFormDefinitionObject.SaveForm(schoolformid, formname, posturl, leadsremaining, _
                                                                  dailylimit, schoollogourl, _
                                                                  Server.UrlDecode(schooldescription).Replace("'", "''"), _
                                                                  bactive, bmatch, _
                                                                  callcentermonthlyallocation, _
                                                                  callcenterdailyallocation).ToString

        Catch ex As Exception
            Return ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveGroup(ByVal groupID As String, ByVal members As String, ByVal campaigns As String, ByVal batches As String, ByVal offers As String) As String
        Dim result As String = "Group Saved!!!"
        Try
            Dim u As String() = Nothing 'parseHTML(members).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            Dim c As String() = Nothing ' parseHTML(campaigns).Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            Dim o As String() = Nothing
            Dim b As String() = Nothing
            If offers = "null" AndAlso Not String.IsNullOrEmpty(offers) Then
                offers = Nothing
            End If
            If batches = "null" AndAlso Not String.IsNullOrEmpty(batches) Then
                batches = Nothing
            End If
            SqlHelper.ExecuteNonQuery(String.Format("update tblUser set groupid = null where groupid = {0}", groupID), Data.CommandType.Text)
            u = members.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            For Each grpUser As String In u
                If grpUser.Contains("placeholder") = False Then
                    Dim gUser As String = grpUser
                    'save group to user
                    Dim sqlUpdate As String = String.Format("update tbluser set groupid = {0} where ltrim(rtrim(firstname)) + ' ' + ltrim(rtrim(lastname)) = '{1}'", groupID, gUser.Trim)
                    SqlHelper.ExecuteNonQuery(sqlUpdate, Data.CommandType.Text)
                End If
            Next


            SqlHelper.ExecuteNonQuery(String.Format("delete FROM [tblGroupCampaignXRef] where groupid = {0}", groupID), Data.CommandType.Text)
            If Not IsNothing(campaigns) Then
                'save product to group
                'remove existing groups/products, no update or history
                c = campaigns.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                For Each grpCampaign As String In c
                    If grpCampaign.Contains("placeholder") = False Then
                        Dim campaignID As String = SqlHelper.ExecuteScalar(String.Format("SELECT CampaignID from tblCampaigns c WITH(NOLOCK) where campaign = '{0}'", grpCampaign.Trim), Data.CommandType.Text)
                        If Not IsNothing(campaignID) Then
                            Dim sqlInsert As String = String.Format("INSERT INTO [tblGroupCampaignXRef]([GroupID],[CampaignID],[Created]) VALUES({0},{1}, getdate())", groupID, campaignID)
                            SqlHelper.ExecuteNonQuery(sqlInsert, Data.CommandType.Text)
                        Else
                            result = GroupsHelper.FormatMsgText(String.Format("<strong>Alert:</strong> Problem Saving {0}!</p></div>", grpCampaign), GroupsHelper.enumMsgType.msgError)
                        End If
                    End If
                Next
            End If


            'group offers
            SqlHelper.ExecuteNonQuery(String.Format("delete FROM [tblGroupOfferXRef] where groupid = {0}", groupID), Data.CommandType.Text)
            If Not IsNothing(offers) Then
                Dim cmdText As String = ""
                o = offers.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                For Each offer As String In o
                    If Not offer.Contains("placeholder") Then
                        cmdText &= String.Format("insert tblGroupOfferXref (GroupID,OfferID) select {0},OfferID from tblOffers where Offer = '{1}' and Active = 1; ", groupID, offer.Replace("'", "''"))
                    End If
                Next
                If cmdText.Length > 0 Then
                    SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
                End If
            End If

            SqlHelper.ExecuteNonQuery(String.Format("delete FROM [tblGroupsDataBatchXref] where groupid = {0}", groupID), Data.CommandType.Text)
            If Not IsNothing(batches) Then
                b = batches.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                For Each grpBatch As String In b
                    If grpBatch.Contains("placeholder") = False Then
                        Dim batchID As String = SqlHelper.ExecuteScalar(String.Format("select DataBatchID, BatchName from tblDataBatch where BatchName = '{0}'", grpBatch.Trim), Data.CommandType.Text)
                        If Not IsNothing(batchID) Then
                            Dim sqlInsert As String = String.Format("INSERT INTO [tblGroupsDataBatchXref]([GroupID],[DataBatchID],[Created])VALUES({0},{1}, getdate())", groupID, batchID)
                            SqlHelper.ExecuteNonQuery(sqlInsert, Data.CommandType.Text)
                        Else
                            result = GroupsHelper.FormatMsgText(String.Format("<strong>Alert:</strong> Problem Saving {0}!</p></div>", grpBatch), GroupsHelper.enumMsgType.msgError)
                        End If

                    End If
                Next
            End If

        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveGroupName(ByVal groupID As String, ByVal newGroupName As String) As String
        Dim result As String = GroupsHelper.FormatMsgText(String.Format("Group name changed to {0}!", newGroupName), GroupsHelper.enumMsgType.msgInfo)
        Try
            Dim ssql As String = String.Format("UPDATE tblGroups SET Name = '{0}' WHERE (groupID = {1})", newGroupName, groupID)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

        Catch ex As Exception
            result = GroupsHelper.FormatMsgText(ex.Message, GroupsHelper.enumMsgType.msgError)
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SavePostField(ByVal action As String, ByVal boxid As String, ByVal postFldid As String, ByVal postQuery As String, ByVal postParam As String, ByVal postField As String) As String
        Dim result As String = String.Format("Post Field {0}!", StrConv(action, VbStrConv.ProperCase))
        If Not String.IsNullOrEmpty(postParam) Then
            'Note: postField is tblDeliveryMethodFields.FieldID
            Try
                If postField = "NA" Or postField = "" Then
                    postField = "1"
                Else
                    postField = String.Format("'{0}'", postField)
                End If
                If postQuery.ToLower = "true" Then
                    postQuery = "1"
                Else
                    postQuery = "0"
                End If

                Dim ssql As String = ""
                Select Case action.ToLower
                    Case "insert"
                        ssql = String.Format("insert tblDeliveryPostFields (DeliveryMethodID,Parameter,FieldID,Field,Query) select d.DeliveryMethodID,'{0}',m.FieldID,m.Field,{1} from tblDeliveryMethod d, tblDeliveryMethodFields m where d.BuyerOfferXrefID = {2} and m.FieldID = {3}", postParam, postQuery, boxid, postField)
                    Case "delete"
                        ssql = String.Format("delete from tblDeliveryPostFields where PostFieldID = {0}", postFldid)
                    Case "update"
                        ssql = String.Format("update tblDeliveryPostFields set Parameter='{0}', FieldID=m.FieldID, Field=m.Field, Query={1} from tblDeliveryPostFields d, tblDeliveryMethodFields m where d.PostFieldID = {2} and m.FieldID = {3}", postParam, postQuery, postFldid, postField)
                End Select

                SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
            Catch ex As Exception
                result = ex.Message
            End Try
        Else
            result = "Parameter is required!"
        End If
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SavePostURL(ByVal boxid As String, ByVal postURL As String) As String
        Dim result As String = "Post URL Saved!"
        Try
            Dim ssql As String = String.Format("UPDATE tblDeliveryMethod set PostUrl = '{0}' where BuyerOfferXrefID = {1}", postURL, boxid)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveQuestion(ByVal surveyID As String, ByVal questionid As String, ByVal questionhtml As String, _
        ByVal questionplain As String, ByVal responsetype As String, ByVal branchresponse As String, _
        ByVal branchurl As String, ByVal popupurl As String, ByVal popunderurl As String, _
        ByVal offerid As String, ByVal options As String, ByVal active As String) As String
        Dim result As String = "Question Saved"
        Try

            If questionid <> "-1" Then
                Dim newq As New Question
                newq.SurveyID = surveyID
                newq.QuestionID = questionid
                newq.Question = questionhtml.Trim.Replace("	", "").Replace("<p> ", "<p>")
                newq.QuestionPlainText = questionplain.Trim
                newq.QuestionBranchResponse = branchresponse
                newq.QuestionType = responsetype
                newq.QuestionBranchUrl = branchurl
                newq.QuestionPopUpUrl = popupurl
                newq.QuestionPopUnderUrl = popunderurl
                newq.QuestionOfferID = offerid
                newq.Active = CBool(active)
                SurveyHelper.UpdateQuestion(newq)

                'add options for question
                Dim i As Integer = 1
                For Each itm As String In options.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                    Dim o As String() = itm.Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)
                    SurveyHelper.CreateQuestionOption(questionid, o(1), o(0))
                    i += 1
                Next
            Else
                Dim qid As Integer = SurveyHelper.CreateQuestion(surveyID, questionhtml.Trim, responsetype, branchurl, branchresponse, offerid, popunderurl, popupurl, GetTextonly(questionhtml.Trim), active)
                'add options for question
                If qid > 0 Then
                    Dim i As Integer = 1
                    For Each itm As String In options.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                        Dim o As String() = itm.Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)
                        SurveyHelper.CreateQuestionOption(qid, o(1), o(0))
                        i += 1
                    Next
                    result = "Question created!"
                Else
                    result = "Question not created! Contact IT."
                End If
            End If

        Catch ex As Exception
            result = ex.Message.ToString
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveResponseInfo(ByVal boxid As String, ByVal successText As String, ByVal idXML As String, ByVal codeXML As String, _
        ByVal errorXML As String, ByVal responseType As String) As String
        Dim result As String = "Response Info Saved!"
        Try
            Dim ssql As String = String.Format("select top 1 deliverymethodid ,BuyerOfferXrefID, PostUrl  from tblDeliveryMethod where BuyerOfferXrefID ={0}", boxid)
            Dim dmID As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("DeliveryMethodID", dmID))
            params.Add(New SqlParameter("ResponseSuccessText", successText))
            params.Add(New SqlParameter("ResponseResultID_XML", idXML))
            params.Add(New SqlParameter("ResponseResultCode_XML", codeXML))
            params.Add(New SqlParameter("ResponseResultError_XML", errorXML))
            params.Add(New SqlParameter("responseType", responseType))

            SqlHelper.ExecuteNonQuery("stp_datamgr_InsertUpdateResponseInfo", CommandType.StoredProcedure, params.ToArray)

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Sub SaveRevTotals(_corpCost As String, Year As Integer, Month As Integer)
        'find days in month
        Dim daysInMonth As Integer = System.DateTime.DaysInMonth(Year, Month)
        'extract amount and divide by days in month
        Dim CorporateCostPerDay As Double = Math.Round(CDbl(_corpCost) / daysInMonth, 2)
        Dim startdate As String = String.Format("{0}/1/{1}", Month, Year)
        Dim enddate As String = String.Format("{0}/{1}/{2}", Month, daysInMonth, Year)
        If CDate(enddate) > Date.Today Then
            enddate = Date.Today.ToString
        End If
        'update available fields
        Dim cmdText As String = String.Format("update tblRevReport set CorporateCost = {0} where Category = 'RTO' and RevDate between '{1}' and '{2}'", CorporateCostPerDay, startdate, enddate)
        Try
            SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
        Catch ex As Exception
            LeadHelper.LogError("ReportsHelper.SaveRevTotals_UpdatingRevRecords", ex.Message, _corpCost, -1)
        End Try

        Dim cmdText2 As String = String.Format("update TblCategory set DailyCorporateCost = {0} where Category = 'RTO'", CorporateCostPerDay)
        Try
            SqlHelper.ExecuteNonQuery(cmdText2, CommandType.Text)
        Catch ex As Exception
            LeadHelper.LogError("ReportsHelper.SaveRevTotals_UpdatingDefaultValue", ex.Message, _corpCost, -1)
        End Try

    End Sub

    <System.Web.Services.WebMethod()> _
    Public Function SaveSubIdPicklePrice(ByVal subId As CampaignObject) As String
        Dim result As String = ""
        Dim params As New List(Of SqlParameter)

        'If Val(subId.Pickle) = 0 Or Val(subId.Price) = 0 Then
        '    Return "There were no values submitted for either price nor pickle."
        'End If

        Try

            'If subId.Pickle <> "" Then
            'result += String.Format("Pickle = {0}<br/>", subId.Pickle)
            params.Add(New SqlParameter("CampaignId", subId.CampaignID))
            params.Add(New SqlParameter("IsDefault", 0))
            params.Add(New SqlParameter("SubId", subId.SubId))
            params.Add(New SqlParameter("Pickle", Val(subId.Pickle)))
            params.Add(New SqlParameter("Price", Val(subId.Price)))
            params.Add(New SqlParameter("UserId", subId.UserID))
            params.Add(New SqlParameter("Active", subId.Active))

            SqlHelper.ExecuteNonQuery("stp_SavePickle", CommandType.StoredProcedure, params.ToArray)

            result = String.Format("SubId {0} saved!", subId.SubId)
            'End If

            'params.Clear()

            'If subId.Price <> "" Then
            '    result += String.Format("Price = ${0}<br/>", subId.Price)
            '    params.Add(New SqlParameter("CampaignId", subId.CampaignID))
            '    params.Add(New SqlParameter("IsDefault", 0))
            '    params.Add(New SqlParameter("SubId", subId.SubId))
            '    params.Add(New SqlParameter("Price", subId.Price))
            '    params.Add(New SqlParameter("UserId", subId.UserID))
            '    params.Add(New SqlParameter("Active", subId.Active))

            '    SqlHelper.ExecuteNonQuery("stp_SavePrice", CommandType.StoredProcedure, params.ToArray)
            'End If

        Catch ex As Exception
            result = ex.Message
        End Try

        Return result

    End Function

    <System.Web.Services.WebMethod()> _
    Public Function SaveSurvey(ByVal surveyID As String, ByVal surveyDesc As String, ByVal startingseq As String, ByVal finishtext As String) As String
        Dim result As String = "Survey Saved"
        If Not String.IsNullOrEmpty(surveyDesc) Then
            Try
                If surveyID <> "-1" Then
                    Dim ssql As String = String.Format("UPDATE tblSurvey SET Description = '{0}' WHERE (SurveyID = {1})", surveyDesc, surveyID)
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
                Else
                    SurveyHelper.CreateSurvey(surveyDesc, startingseq, finishtext)
                End If
            Catch ex As Exception
                result = ex.Message.ToString
            End Try
        Else
            result = "Survey description is required!"
        End If
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Sub SaveTrafficTypes(BuyerOfferXrefID As Integer, TrafficTypes As String)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("BuyerOfferXrefID", BuyerOfferXrefID))
        params.Add(New SqlParameter("TrafficTypes", TrafficTypes))
        SqlHelper.ExecuteNonQuery("stp_SaveTrafficTypeXrefs", , params.ToArray)
    End Sub

    <WebMethod()> _
    Public Function SaveWebsite(websiteobject As websiteObject) As String
        Dim result As String = "Website"

        Try
            Dim wo As New websiteObject
            Dim ssql As String = "stp_websites_update"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("websiteid", websiteobject.WebsiteID))
            params.Add(New SqlParameter("Name", websiteobject.Name))
            params.Add(New SqlParameter("Description", websiteobject.Description))
            params.Add(New SqlParameter("URL", websiteobject.URL))
            params.Add(New SqlParameter("Type", websiteobject.WebSiteTypeID))
            params.Add(New SqlParameter("DefaultSurveyID", websiteobject.DefaultSurveyID))
            params.Add(New SqlParameter("Code", websiteobject.Code))
            params.Add(New SqlParameter("DisclosureText", websiteobject.DisclosureText))
            params.Add(New SqlParameter("UserID", HttpContext.Current.User.Identity.Name))
            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
            Select Case websiteobject.WebsiteID
                Case -1
                    result += " Created!!"
                Case Else
                    result += " Saved!!"
            End Select

        Catch ex As Exception
            Return ex.Message
        End Try
        Return result
    End Function

    <WebMethod()> _
    Public Function SendSchoolForm(ByVal posturl As String) As String
        Dim resultMsg As String = "ERROR:  No parameters given!!!"
        Dim statMsg As String = ""
        Dim rso As resultStatusObject = Nothing
        Dim resultObj As PostingResultObject = Nothing
        Dim reqUri As String() = posturl.Split(New Char() {"?"}, StringSplitOptions.RemoveEmptyEntries)
        If reqUri.Length > 1 Then

            Dim lstParams As List(Of String) = SchoolCampaignHelper.BuildFormParameters(posturl)
            resultObj = PostingResultObject.ParseResults(PostTestData(-1, Join(lstParams.ToArray, "&"), reqUri(0), False))

            If Not IsNothing(resultObj) Then
                'update submitted
                statMsg = ParseResultMessage(resultObj) & vbCrLf

                Select Case resultObj.State
                    Case "Delivered"
                        Select Case resultObj.Status
                            Case "OK"               'The post was accepted, processed and delivered to the Client.
                                resultMsg = "The post was accepted, processed and delivered to the Client" & vbCrLf

                            Case "Error"
                                resultMsg = "The post was accepted, processed and delivered to the Client. The Client rejected delivery. The lead will be redelivered if possible, or credited if not." & vbCrLf

                            Case "Credited"
                                resultMsg = "The post was rejected by the Client (see above). The post is considered invalid and will not count towards your commission." & vbCrLf

                        End Select
                    Case "Validated"
                        Select Case resultObj.Status
                            Case "Invalid"
                                resultMsg = "The post was processed and failed validation. The post is considered invalid and will not count towards your Commission." & vbCrLf

                        End Select
                    Case "Error"
                        Select Case resultObj.Status
                            Case "Invalid"
                                resultMsg = "The post was rejected. The format of the post was considered invalid. The post is considered invalid and will not count towards your Commission." & vbCrLf
                            Case "BillingExceeded"
                                resultMsg = "The post was processed and failed due to the Campaign budget being exceeded for the current billing cycle. The post is considered invalid and will not count towards your Commission." & vbCrLf
                            Case "Error"
                                resultMsg = "The post was processed and failed due to a fatal error. The post is considered invalid and will not count towards your Commission." & vbCrLf
                        End Select
                End Select
            End If
        End If
        rso = New resultStatusObject(resultObj.Status.ToString, String.Format("{0}:{1}", resultMsg, statMsg))
        Return jsonHelper.SerializeObjectIntoJson(rso) ' resultObj.Status.ToString

    End Function

    <System.Web.Services.WebMethod()> _
    Public Function getTestPostFields(boxid As Integer) As String
        Dim html As New StringBuilder
        Dim dmo As DeliveryMethodObject = DeliveryMethodObject.GetDeliveryMethod(boxid)

        html.Append("<table>")
        For Each obj As DataManagerHelper.PostFieldObject In dmo.PostFields
            Dim param() As String = Split(obj.Parameter, "=")
            Dim value As String = ""
            If param.Length > 1 Then
                value = param(1)
            End If
            html.Append("<tr>")
            html.AppendFormat("<td>{0}</td><td><input type='text' value='{1}' parameter='{0}' /></td>", param(0), value)
            html.Append("</tr>")
        Next
        html.Append("</table>")

        Return html.ToString
    End Function

    <System.Web.Services.WebMethod()> _
    Public Sub SendEmailMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String, smtpServerAddress As String, smtpUser As String, smtpPassword As String)
        Dim email As New Net.Mail.SmtpClient(smtpServerAddress)

        Dim message As New Net.Mail.MailMessage()
        message.From = New Net.Mail.MailAddress(from)
        message.To.Add([to])
        message.Subject = subject
        message.Body = body
        message.IsBodyHtml = True

        Try
            'make sure we have someone to send it to if all emails were invalid
            If message.To.Count > 0 Then
                'Dim nc As New Net.NetworkCredential(smtpUser, smtpPassword)
                'email.UseDefaultCredentials = False
                'email.Credentials = nc
                email.DeliveryMethod = Net.Mail.SmtpDeliveryMethod.Network
                'email.EnableSsl = True
                'Net.ServicePointManager.SecurityProtocol = Net.SecurityProtocolType.Tls 
                email.ServicePoint.MaxIdleTime = 1
                email.Send(message)
            End If
        Catch ex As Exception
            LeadHelper.LogError("SendMessage", ex.Message, ex.StackTrace)
            Throw
        End Try

    End Sub

    Public Shared Sub SendMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String)
        Dim email As New Net.Mail.SmtpClient(ConfigurationManager.AppSettings("emailSMTP").ToString)
        Dim message As New Net.Mail.MailMessage()
        message.From = New Net.Mail.MailAddress(from)
        For Each addr As String In [to].Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            message.To.Add(addr)
        Next
        message.Subject = subject
        message.Body = body

        message.IsBodyHtml = True

        Try
            email.ServicePoint.MaxIdleTime = 1
            email.Send(message)
        Catch ex As Exception
            LeadHelper.LogError("SendMessage", ex.Message, String.Concat(from, "|", [to], "|", subject, "|", body))
        Finally
            message.Dispose()
            message = Nothing
        End Try
    End Sub


    <System.Web.Services.WebMethod()> _
    Public Sub SendRealTimePost(LeadID As String, OfferID As String)

        'returns all the buyerofferxrefids for this offer
        Dim ContractsByOffer As DataTable
        ContractsByOffer = GetContractsByOfferId(OfferID, LeadID)

        Dim ExclusiveSold As Boolean = False    'has been sold to an exclusive buyer
        Dim LeadSold As Boolean = False         'has a lead been sold
        Dim Sellable As Boolean = True         'is the lead sellable to this contract
        Dim Description As String = ""          'why is the lead not sellable

        'get category from offer
        Dim CategoryID As String = GetCategoryFromOfferID(OfferID)

        'get lead information
        Dim LeadInfo As DataTable = GetLeadInfo(LeadID, CategoryID)

        'lock lead from other contracts
        If Not LeadInfo Is Nothing Then
            UpdateDataManagerLock(LeadID, 1)
        End If

        'for each contract
        For Each Contract As DataRow In ContractsByOffer.Rows

            Dim BuyerOfferXrefID As Integer = CInt(Contract("BuyerOfferXrefId").ToString)
            Dim dmo As DeliveryMethodObject = DeliveryMethodObject.GetDeliveryMethod(BuyerOfferXrefID)

            'if an exclusive contract has already purchased this lead skip condition
            'if this lead has been sold and the current contract is an exclusive contract skip condition.
            If Not (ExclusiveSold OrElse (LeadSold AndAlso dmo.Exclusive = 1) OrElse BuyerOfferXrefID = 481) Then

                'find if the contract schedule is active.
                If ExcludeBasedOnSchedule(dmo.DeliverySchedule) Then
                    Sellable = False
                    Description += "The current timestamp does not fall within the hours set for this contract."
                End If

                'find if we should exclude lead from contract based on contract's cap
                If Sellable AndAlso ExcludeBasedOnCap(dmo.DailyCap, dmo.BuyerOfferXrefID) Then
                    Sellable = False
                    Description += "The cap for this contract has been reached."
                End If

                'get sold already in offer
                Dim LastSoldDate As Date = GetLastDateSold(LeadID, OfferID, dmo.BuyerID)

                'find if we should exclude lead from contract based on lead's last sold date
                If Sellable AndAlso ExcludeBasedOnDate(LastSoldDate, 7) Then
                    Sellable = False
                    Description += "The last time this lead was sold falls within the duplicate range for this contract."
                End If

                'find if we should exclude lead from contract based on lead's website
                'If Sellable AndAlso ExcludeBasedOnWebsite(LeadInfo("website").ToString) Then
                '    Sellable = False
                '    Description += "This contract excludes this website in it's purchases."
                'End If

                'find if we should should exclude lead from contract based on state
                If Sellable AndAlso ExcludeBasedOnStateCode(dmo.BuyerOfferXrefID, LeadInfo(0)("StateCode")) Then
                    Sellable = False
                    Description += "This lead was excluded based on the lead's statecode."
                End If

                'find if we should should exclude lead from contract based on state
                If Sellable AndAlso ExcludeBasedOnExclusions(dmo.BuyerOfferXrefID, LeadInfo) Then
                    Sellable = False
                    Description += "This lead was excluded based on the custom exclusions."
                End If

                'Lead passed all filters
                If Sellable Then
                    'Sell Lead
                    Dim requestUri As String = ""
                    Dim requestUriData As String = ""
                    Dim postData As String = ""
                    Dim results As String = ""
                    Dim postError As Boolean
                    Dim valid As Boolean = False

                    requestUri = dmo.PostUrl
                    Dim postType As String = requestUri.Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)(0)
                    Select Case postType
                        Case "http", "https"
                            'Gather Delivery Information and Post
                            postData = BuildPostString(dmo, LeadInfo.Columns, LeadInfo(0), requestUriData)
                            If Not IsNothing(postData) Then
                                If Len(requestUriData) > 0 Then
                                    requestUri &= requestUriData
                                End If
                                If dmo.Method.Equals("GET") Then
                                    results = PostHelper._GET(LeadID, postData, requestUri, dmo.Throttle, postError)
                                Else
                                    results = PostHelper.POST(LeadID, postData, requestUri, dmo.Throttle, postError)
                                End If
                            End If

                            'Log Sale
                            Dim postResult As Boolean = False
                            Select Case dmo.ResultType.ToLower
                                Case "xml"
                                    postResult = ProcessXMLResult(dmo, LeadID, dmo.OfferId, CDate(LeadInfo(0)("Created").ToString), results, 1, postError)
                                    If postResult Then
                                        valid = True
                                        LeadSold = True
                                        If dmo.Exclusive = 1 Then
                                            ExclusiveSold = True
                                        End If
                                    Else
                                        valid = False
                                    End If

                                Case Else 'plain text
                                    postResult = ProcessTXTResult(dmo, LeadID, dmo.OfferId, CDate(LeadInfo(0)("Created").ToString), results, 1, postError)
                                    If postResult Then
                                        valid = True
                                        LeadSold = True
                                        If dmo.Exclusive = True Then
                                            ExclusiveSold = True
                                        End If
                                    Else
                                        valid = False
                                    End If
                            End Select

                            If Not valid Then
                                LogPost(dmo.BuyerOfferXrefID, "failure", String.Concat(requestUri, "?", postData), results, LeadID)
                            End If
                            InsertRealTimePost(LeadID, dmo, OfferID, String.Format("Posted Lead - Result: {0}", results))

                        Case "mailto"
                            'Gather Delivery Information and Email
                            postData = BuildEmailString(dmo, LeadInfo.Columns, LeadInfo(0), requestUriData)
                            Dim toRecipient As String = requestUri.Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)(1)
                            Try
                                SendEmailMessage("leads@Identifyle.com", toRecipient, "New Prospect From Identifyle", postData, "74.212.234.3", "administrator", "M1n10n11690")
                            Catch ex As Exception
                                LeadHelper.LogError("Sending Email From Real Time Engine", ex.Message, ex.StackTrace, LeadID)
                            End Try
                            'Log Sale
                            InsertSubmittedOffer(dmo.BuyerOfferXrefID, LeadID, OfferID, dmo.BuyerID, "success", "Email - No Result Text", "", 1, "", 1, 0, Now, 1)
                            InsertRealTimePost(LeadID, dmo, OfferID, "Posted Lead - Result: success")
                    End Select

                Else
                    'Write Description of Failure
                    InsertRealTimePost(LeadID, dmo, OfferID, Description)
                    Sellable = True
                End If

            End If
            Description = ""
        Next

        'unlock lead
        If Not LeadInfo Is Nothing Then
            UpdateDataManagerLock(LeadID, 0)
        End If
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Function sendTestPost2(boxid As Integer, queryString As String) As String
        Dim dm As DeliveryMethodObject = DeliveryMethodObject.getDeliveryMethod(boxid)
        Dim result As String
        result = String.Concat("Post URL", vbCrLf, vbCrLf, dm.PostUrl, "?", queryString, vbCrLf, vbCrLf, "Response", vbCrLf, vbCrLf)
        If dm.PostFields(0).Query Then
            result &= PostTestData(-1, "", dm.PostUrl & "?" & queryString, False)
        Else
            result &= PostTestData(-1, queryString, dm.PostUrl, False)
        End If
        Return result
    End Function

    '<System.Web.Services.WebMethod()> _
    'Public Function SendTestPost(ByVal boxid As String) As String
    '    Dim result As String
    '    Try
    '        Dim dm As DeliveryMethodObject = DeliveryMethodObject.getDeliveryMethod(boxid)
    '        If dm.PostUrl.Contains("http") Then
    '            Dim params As New List(Of SqlParameter)
    '            Dim tblLeads As DataTable
    '            Dim requestUriData As String = ""
    '            Dim postData As String

    '            If Not String.IsNullOrEmpty(dm.DataProcedureName) Then
    '                params.Add(New SqlParameter("buyerofferxrefid", boxid))
    '                Dim sParams As List(Of String) = GetStoredProcParams(dm.DataProcedureName)
    '                For i As Integer = 0 To sParams.Count - 1
    '                    If sParams(i).ToLower.Equals("@test") Then
    '                        'proc is setup with test flag which will only return 1 lead and skip the exclude check
    '                        params.Add(New SqlParameter("test", "1"))
    '                    End If
    '                Next
    '                tblLeads = SqlHelper.GetDataTable(dm.DataProcedureName, CommandType.StoredProcedure, params.ToArray)

    '                If tblLeads.Rows.Count > 0 Then
    '                    postData = BuildPostString(dm, tblLeads.Columns, tblLeads.Rows(0), requestUriData)
    '                    If Len(requestUriData) > 0 Then
    '                        dm.PostUrl &= requestUriData
    '                    End If
    '                    result = String.Format("<div style=""width:150px;font-size:10px;"">Test Post Result for:<br/> {0}<br/><br/>Post URL<br/><br/>{1}{2}{3}<br/><br/>Response<br/><br/>", tblLeads.Rows(0)("Email").ToString, dm.PostUrl, IIf(postData.Length > 0, "?", ""), postData)
    '                    result &= Server.HtmlEncode(PostTestData(-1, postData, dm.PostUrl, False))
    '                    result &= "</div>"
    '                Else
    '                    result = String.Format("<div style=""width:150px;"">There are currently no leads available for this contract to test</div>")
    '                End If
    '            Else
    '                result = String.Format("<div style=""width:150px;"">Please select Data Leads to pull from on the Home tab</div>")
    '            End If
    '        Else
    '            result = String.Format("<div style=""width:150px;"">Cannot send a test post to this Post URL</div>")
    '        End If
    '    Catch ex As Exception
    '        result = ex.Message
    '    End Try
    '    Return result
    'End Function

    <System.Web.Services.WebMethod()> _
    Public Sub UpdateCampaignPrice(CampaignID As Integer, Paid As Double, RevDate As String)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("Date", RevDate))
        params.Add(New SqlParameter("CampaignID", CampaignID))
        params.Add(New SqlParameter("Paid", Paid))
        SqlHelper.ExecuteNonQuery("stp_SaveCampaignPricing", CommandType.StoredProcedure, params.ToArray)
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Sub UpdateClicksConversions(ByVal CampaignID As Integer, ByVal SrcCampaignID As Integer, ByVal RevDate As String, ByVal NumClicks As Integer, NumConversions As Integer, Paid As String, SubID1 As String)
        SubID1 = Replace(SubID1, "[None]", "")
        Paid = Paid.Replace("$", "").Replace(",", "")

        If NumClicks > 0 Or NumConversions > 0 Then
            Dim addParams As New List(Of SqlParameter)
            addParams.Add(New SqlParameter("CampaignID", CampaignID))
            addParams.Add(New SqlParameter("SrcCampaignID", SrcCampaignID))
            addParams.Add(New SqlParameter("Date", RevDate))
            addParams.Add(New SqlParameter("NumClicks", NumClicks))
            addParams.Add(New SqlParameter("NumConversions", NumConversions))
            addParams.Add(New SqlParameter("Paid", Val(Paid)))
            addParams.Add(New SqlParameter("SubID1", SubID1))
            addParams.Add(New SqlParameter("UserID", HttpContext.Current.User.Identity.Name))
            SqlHelper.ExecuteNonQuery("stp_AddClicksConversions", , addParams.ToArray)
        End If

        If NumClicks < 0 Or NumConversions < 0 Then
            If NumClicks > 0 Then NumClicks = 0
            If NumConversions > 0 Then NumConversions = 0
            Dim remParams As New List(Of SqlParameter)
            remParams.Add(New SqlParameter("CampaignID", CampaignID))
            remParams.Add(New SqlParameter("SrcCampaignID", SrcCampaignID))
            remParams.Add(New SqlParameter("Date", RevDate))
            remParams.Add(New SqlParameter("NumClicks", Math.Abs(NumClicks)))
            remParams.Add(New SqlParameter("NumConversions", Math.Abs(NumConversions)))
            remParams.Add(New SqlParameter("SubID1", SubID1))
            SqlHelper.ExecuteNonQuery("stp_RemoveClicksConversions", , remParams.ToArray)
        End If
    End Sub

    Private Sub UpdateDataManagerLock(LeadId As Integer, Lock As Boolean)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadId", LeadId))
        params.Add(New SqlParameter("Lock", Lock))
        Try
            SqlHelper.ExecuteNonQuery("stp_UpdateDataManagerLock", CommandType.StoredProcedure, params.ToArray)
        Catch ex As Exception
            LeadHelper.LogError("cmService_UpdateDataManagerLock", ex.Message, ex.StackTrace, LeadId)
        End Try
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Function UpdateInsertDeliverySchedule(ByVal buyerid As String, ByVal boxid As String, ByVal action As String, ByVal rowData As String) As String
        Dim result As String = "Delivery Schedule"
        Dim ssql As String = ""
        Try
            Select Case action.ToLower
                Case "a"
                    result += " Added!"
                    For i As Integer = 1 To 7
                        Dim dayName As String = WeekdayName(i, False, Microsoft.VisualBasic.FirstDayOfWeek.Monday)
                        Dim dFrom As String = "12:00 AM"
                        Dim dTo As String = "11:59 PM"
                        result += vbCrLf & String.Format("{0} : {1} - {2}", dayName, dFrom, dTo)

                        ssql = "stp_datamgr_insertDeliverySchedule"
                        Dim params As New List(Of SqlParameter)
                        params.Add(New SqlParameter("BuyerID", buyerid))
                        params.Add(New SqlParameter("Weekday", dayName))
                        params.Add(New SqlParameter("FromHour", dFrom))
                        params.Add(New SqlParameter("ToHour", dTo))
                        params.Add(New SqlParameter("BuyerOfferXrefID", boxid))

                        SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
                    Next

                Case "d"
                    result += " Deleted!"
                    ssql = String.Format("delete from tblbuyerhours where buyerid = {0} and BuyerOfferXrefID = {1}", buyerid, boxid)
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
                Case "s"
                    result += " Saved!"
                    Dim r As String() = rowData.Replace("[", "").Replace("]", "").Split(New Char() {"{"}, StringSplitOptions.RemoveEmptyEntries)
                    For Each sched As String In r
                        Dim schedData As String() = sched.Replace("}", "").Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                        If schedData.Length > 2 Then
                            Dim wday As String = String.Empty
                            Dim fhour As String = String.Empty
                            Dim thour As String = String.Empty
                            For Each sd As String In schedData
                                Dim idx As Integer = sd.IndexOf(":")
                                Dim colName As String = sd.Substring(0, idx).Replace("""", "")
                                Dim colVal As String = sd.Substring(idx + 1).Replace("""", "")
                                Select Case colName.ToLower
                                    Case "weekday"
                                        wday = colVal
                                    Case "fromhour"
                                        fhour = colVal
                                    Case "tohour"
                                        thour = colVal
                                End Select
                            Next
                            ssql = String.Format("UPDATE tblBuyerHours set FromHour='{0}', ToHour='{1}' WHERE BuyerOfferXrefID={2} and [Weekday] = '{3}'", fhour, thour, boxid, wday)
                            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
                        End If

                    Next
            End Select

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function UpdateInsertFilter(ByVal boxid As String, ByVal action As String, ByVal filterType As String, ByVal filterVal As String) As String
        Dim result As String = "Filter"
        Try

            Select Case filterType.ToLower
                Case "Does Contain ZipCode".ToLower
                    Dim ssql As String = "delete from tblBuyerOfferXref_Zipcodes where BuyerOfferXrefID = @BuyerOfferXrefID"
                    Dim params As New List(Of SqlParameter)
                    params.Add(New SqlParameter("BuyerOfferXrefID", boxid))
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.Text, params.ToArray)
                    result += " Deleted!"
                Case Else
                    Dim ssql As String = String.Format("select ExcludedStates from tblBuyerOfferXref where BuyerOfferXrefID ={0}", boxid)
                    Dim exStates As New List(Of String)
                    Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                        For Each dr As DataRow In dt.Rows
                            Dim st As String() = dr("ExcludedStates").ToString.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                            exStates.AddRange(st.ToList)
                        Next
                    End Using
                    exStates.Sort()
                    Select Case action
                        Case "a"
                            result += " Saved!"
                            exStates.Add(filterVal)
                        Case Else
                            'delete
                            result += " Deleted!"
                            exStates.Remove(filterVal)
                    End Select
                    Dim newStates As String = Join(exStates.ToArray, ",")
                    ssql = String.Format("UPDATE tblBuyerOfferXref set ExcludedStates = '{0}' where BuyerOfferXrefID = {1}", newStates, boxid)
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
            End Select
        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()>
    Public Function UpdatePath(ByVal sortedList As String) As String
        Dim sortedArray As String() = sortedList.Split(New [Char]() {"&"c})
        Dim pathstructure As String = ""
        Dim PageId As String = ""
        Dim WebsitePathId As String = ""
        Dim WebsiteId As String = ""
        Dim dt As DataTable = Nothing

        For Each Str As String In sortedArray
            Dim splitElement As String() = Str.Split(New [Char]() {","c})
            Dim Active As Boolean = True
            If splitElement(1).ToString = "checked" Then
                pathstructure += splitElement(0) + ","
                PageId = splitElement(0)
            Else
                Active = False
            End If

            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("WebsitePageId", splitElement(0)))
            params.Add(New SqlParameter("Active", Active))

            Try
                SqlHelper.ExecuteScalar("stp_ActivatePage", CommandType.StoredProcedure, params.ToArray)
            Catch ex As Exception
                Return ex.Message
            End Try

        Next

        pathstructure = pathstructure.Substring(0, pathstructure.Length - 1)

        Dim params2 As New List(Of SqlParameter)
        params2.Add(New SqlParameter("WebsitePageId", PageId))
        Try
            dt = SqlHelper.GetDataTable("stp_GetWebPageInfo", CommandType.StoredProcedure, params2.ToArray)
        Catch ex As Exception
            Return ex.Message
        End Try

        For Each rw As DataRow In dt.Rows
            WebsitePathId = rw("WebsitePathId").ToString
            WebsiteId = rw("WebsiteId").ToString
        Next

        Dim params3 As New List(Of SqlParameter)
        params3.Add(New SqlParameter("PathStructure", pathstructure))
        params3.Add(New SqlParameter("WebsitePathId", WebsitePathId))
        params3.Add(New SqlParameter("WebsiteId", WebsiteId))
        params3.Add(New SqlParameter("LastModifiedBy", "-1"))
        Try
            SqlHelper.ExecuteScalar("stp_InsertPathStructure", CommandType.StoredProcedure, params3.ToArray)
        Catch ex As Exception
            Return ex.Message
        End Try

        Return "Web Structure Saved."
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function UploadDocuments(ByVal documentType As enumDocumentType) As String
        Dim result As String
        Try
            Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
            result = "<div id=""status"">success</div>"
            Dim files As HttpFileCollection = HttpContext.Current.Request.Files
            Dim fileKeys As String() = HttpContext.Current.Request.Files.AllKeys
            Dim docFolderPath As String = ""
            Dim hdnFieldName As String = ""
            Dim ssql As String = ""
            Dim procParamName As String = ""
            Select Case documentType
                Case enumDocumentType.BuyerDocument
                    hdnFieldName = "hdnBuyerID"
                    docFolderPath = ConfigurationManager.AppSettings("BuyerdocumentPath")
                    ssql = "stp_buyer_InsertDocument"
                    procParamName = "buyerid"
                Case enumDocumentType.AdvertiserDocument
                    hdnFieldName = "hdnAdvertiserID"
                    docFolderPath = ConfigurationManager.AppSettings("AdvertiserdocumentPath")
                    ssql = "stp_Advertiser_InsertDocument"
                    procParamName = "AdvertiserID"
                Case enumDocumentType.AffiliateDocument
                    hdnFieldName = "hdnAffiliateID"
                    docFolderPath = ConfigurationManager.AppSettings("AffiliatedocumentPath")
                    ssql = "stp_Affiliate_InsertDocument"
                    procParamName = "AffiliateID"
            End Select

            Dim uniqID As String = ""
            For Each obj As String In HttpContext.Current.Request.Form.Keys
                If obj.Contains(hdnFieldName) Then
                    'found unique id
                    uniqID = HttpContext.Current.Request.Form(obj)
                    Exit For
                End If
            Next

            If Not String.IsNullOrEmpty(uniqID) Then
                For Each fk As String In fileKeys
                    Dim pf As HttpPostedFile = HttpContext.Current.Request.Files(fk)
                    Dim DocName As String = pf.FileName

                    Dim docPath As String = docFolderPath & System.IO.Path.GetFileName(DocName)
                    pf.SaveAs(docPath)

                    Dim params As New List(Of SqlParameter)
                    params.Add(New SqlParameter(procParamName, uniqID))
                    params.Add(New SqlParameter("DocumentName", IO.Path.GetFileNameWithoutExtension(DocName)))
                    params.Add(New SqlParameter("DocumentPath", docPath))
                    params.Add(New SqlParameter("UserID", currentuserid))

                    SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

                Next
                result += "<div id=""message"">Your file success message</div>"
            Else
                result = "<div id=""status"">error</div>"
                result += "<div id=""message"">Could not find unique ID field!</div>"
            End If
        Catch ex As Exception
            result = "<div id=""status"">error</div>"
            result += String.Format("<div id=""message"">{0}</div>", ex.Message)
        End Try

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function ViewData(ByVal dataBatchID As String) As String
        Dim result As String = ""
        Try
            If Not String.IsNullOrEmpty(dataBatchID) Then

                Dim ssql As String = "stp_databatch_GetData"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("BatchID", dataBatchID))
                Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                    Dim gv As New GridView
                    gv.Width = New Unit(100, UnitType.Percentage)
                    gv.AutoGenerateColumns = False
                    gv.CssClass = "ui-widget-content"
                    Dim cols As String() = {"leadid", "fullname", "address", "city", "statecode", "zipcode", "phone", "workphone", "email", "dob", "besttimetocall"}
                    For Each c As String In cols
                        Dim bc As New BoundField
                        bc.HeaderStyle.CssClass = "ui-widget-header"
                        bc.HeaderText = StrConv(c, VbStrConv.ProperCase)
                        Select Case c.ToLower
                            Case "dob"
                                bc.DataFormatString = "{0:d}"
                            Case "statecode", "zipcode"
                                bc.HeaderText = StrConv(c.Replace("code", ""), VbStrConv.ProperCase)
                            Case "fullname", "address"
                                bc.ItemStyle.Wrap = False
                        End Select
                        bc.DataField = c
                        gv.Columns.Add(bc)
                    Next
                    gv.DataSource = dt
                    gv.DataBind()

                    result = ControlToHTML(gv)

                End Using
            End If

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function createFromTemplate(ByVal templateid As String, ByVal boxid As String) As String
        Dim result = "Created template sucessfully!"
        Try
            Dim purl As String = SqlHelper.ExecuteScalar(String.Format("SELECT posturl from tblDeliveryMethod where DeliveryMethodID = {0}", templateid), CommandType.Text)
            SavePostURL(boxid, purl)

        Catch ex As Exception
            result = ex.Message
        End Try
        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Function getBuyerLeadsBoughtChartData(ByVal buyerid As String) As String
        Dim result As String = String.Empty
        Try
            Dim chartData As New List(Of chartSeriesData)

            Dim ssql As String = String.Format("stp_buyer_getDataBought {0}", buyerid)

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                Dim contractData = From dr In dt.Rows _
                                   Group dr By key = dr("contractName") Into Group _
                                   Select ContractName = key, chartDataGroup = Group

                For Each c In contractData
                    Dim cdata As New chartSeriesData With {.SeriesName = c.ContractName}

                    Dim dayData As New List(Of String)
                    For Each g As DataRow In c.chartDataGroup
                        dayData.Add(String.Format("{0}={1}", Format(CDate(g("solddate").ToString), "MM/dd"), g("conversions").ToString))
                    Next
                    cdata.SeriesData = Join(dayData.ToArray, ",")
                    chartData.Add(cdata)
                Next
            End Using

            Dim oSerialize As New JavaScriptSerializer
            result = oSerialize.Serialize(chartData)
        Catch ex As Exception

        End Try
        Return result
    End Function

    Private Shared Function GetTextonly(ByVal editorcontent As String) As String
        Dim strtext As String = ""
        strtext = Regex.Replace(editorcontent, "<(.|\n)*?>", "")
        Return strtext
    End Function

    Private Shared Function ParseResultMessage(ByVal resultObj As PostingResultObject) As String
        Dim resultMsg As String = ""
        For Each ErrObj As String In resultObj.Errors
            resultMsg += ErrObj & "<br/>"
        Next

        'CampaignResults*************************************
        For Each ErrObj As String In resultObj.CampaignResults.Errors
            resultMsg += ErrObj & "<br/>"
        Next
        'MappingResult*************************************
        For Each notObj As String In resultObj.MappingResult.Errors
            resultMsg += notObj & "<br/>"
        Next
        'FormValidationResult*************************************
        For Each ErrObj As String In resultObj.CampaignResults.FormValidationResult.Errors
            resultMsg += ErrObj & "<br/>"
        Next
        For Each notObj As String In resultObj.CampaignResults.FormValidationResult.Notices
            resultMsg += notObj & "<br/>"
        Next

        'StandardizationResult*************************************
        For Each ErrObj As String In resultObj.CampaignResults.StandardizationResult.Errors
            resultMsg += ErrObj & vbCrLf
        Next
        For Each notObj As String In resultObj.CampaignResults.StandardizationResult.Notices
            resultMsg += notObj & vbCrLf
        Next

        'ValidationResult*************************************
        For Each ErrObj As String In resultObj.CampaignResults.ValidationResult.Errors
            resultMsg += ErrObj & "<br/>"
        Next
        For Each notObj As String In resultObj.CampaignResults.ValidationResult.Notices
            resultMsg += notObj & "<br/>"
        Next

        'PreProcessingResult*************************************
        For Each ErrObj As String In resultObj.CampaignResults.PreProcessingResult.Errors
            resultMsg += ErrObj & "<br/>"
        Next
        For Each notObj As String In resultObj.CampaignResults.PreProcessingResult.Notices
            resultMsg += notObj & "<br/>"
        Next

        'BillingResult*************************************
        For Each notObj As String In resultObj.BillingResult.Errors
            resultMsg += notObj & "<br/>"
        Next
        For Each notObj As String In resultObj.BillingResult.Notices
            resultMsg += notObj & "<br/>"
        Next

        'MCPSResult*************************************
        For Each notObj As String In resultObj.MCPSResult.Errors
            resultMsg += notObj & "<br/>"
        Next
        For Each notObj As String In resultObj.MCPSResult.Notices
            resultMsg += notObj & "<br/>"
        Next
        Return resultMsg
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Structure CategoryObject

#Region "Fields"

        Public CurriculumCategories As String
        Public CurriculumItems As String

#End Region 'Fields

    End Structure

#End Region 'Nested Types

End Class
