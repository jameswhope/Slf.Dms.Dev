<%@ WebHandler Language="VB" Class="FileUploaderHandler" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.Data
Imports SchoolFormControl.SchoolCampaignHelper
Imports SchoolFormControl

Public Class FileUploaderHandler : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "text/plain"
        'context.Response.Write("Hello World")
        Dim result As String = ""
        Try
            Dim currentuserid = CInt(HttpContext.Current.User.Identity.Name)
            result = "<div id=""status"">success</div>"
            Dim files As HttpFileCollection = HttpContext.Current.Request.Files
            Dim fileKeys As String() = HttpContext.Current.Request.Files.AllKeys
            Dim docFolderPath As String = ""
            Dim ssql As String = ""
            Dim procParamName As String = ""
            
            Dim documentType As String = String.Empty
            documentType = context.Request.QueryString("type")
            
            Dim uniqID As String = ""
            
            Select Case documentType.ToLower
                Case "zipaccept".ToLower
                    docFolderPath = ConfigurationManager.AppSettings("PublisherDocumentPath")
                    uniqid = context.Request.Params("uid")
                Case "schoolcampaign".ToLower
                    docFolderPath = ConfigurationManager.AppSettings("PublisherDocumentPath")
                    uniqid = context.Request.Params("uid")
                Case "Buyer".ToLower
                    docFolderPath = ConfigurationManager.AppSettings("BuyerdocumentPath")
                    ssql = "stp_buyer_InsertDocument"
                    procParamName = "buyerid"
                    uniqid = context.Request.Params("buyerid")
                Case "Advertiser".ToLower
                    docFolderPath = ConfigurationManager.AppSettings("PublisherDocumentPath")
                    ssql = "stp_Advertisers_InsertDocument"
                    procParamName = "AdvertiserID"
                    uniqid = context.Request.Params("AdvertiserID")
                Case "Affiliate".ToLower
                    docFolderPath = ConfigurationManager.AppSettings("PublisherDocumentPath")
                    ssql = "stp_Affiliate_InsertDocument"
                    procParamName = "AffiliateID"
                    uniqID = context.Request.Params("AffiliateID")
                Case "zipfilter".ToLower
                    docFolderPath = ConfigurationManager.AppSettings("BuyerdocumentPath")
                    ssql = "stp_contracts_InsertZipcodes"
                    procParamName = "BuyerOfferXrefID"
                    uniqID = context.Request.Params("BuyerOfferXrefID")
                    
            End Select

            If Not String.IsNullOrEmpty(uniqID) Then
                For Each fk As String In fileKeys
                    Dim pf As HttpPostedFile = HttpContext.Current.Request.Files(fk)
                    Dim DocName As String = pf.FileName

                    Dim docPath As String = docFolderPath & System.IO.Path.GetFileName(DocName)
                    pf.SaveAs(docPath)

                    Select Case documentType.ToLower
                        Case "zipfilter".ToLower
                            BuyerHelper.InsertContractZipFilters(uniqID, docPath)
                            
                        Case "zipaccept".ToLower
                            SchoolFormControl.SOAPLocationCurriculumObject.AddAcceptedZipcodesForLocation(uniqID, docPath)
                        
                        Case "schoolcampaign".ToLower
                            SchoolCampaignsFormDefinitionObject.SaveFormDefinition("Default", uniqID, docPath, currentuserid, Nothing, Nothing, 0)
                        
                        Case Else
                            Dim params As New List(Of SqlParameter)
                            params.Add(New SqlParameter(procParamName, uniqID))
                            params.Add(New SqlParameter("DocumentName", IO.Path.GetFileNameWithoutExtension(DocName)))
                            params.Add(New SqlParameter("DocumentPath", docPath))
                            params.Add(New SqlParameter("UserID", currentuserid))
                            SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)
                    End Select
                Next
                context.Response.Write("<div id=""message"">Upload was successful!</div>")
            Else
                context.Response.Write("<div id=""status"">error</div>")
                context.Response.Write("<div id=""message"">Could not find unique ID field!</div>")
            End If

          
        Catch ex As Exception
            context.Response.Write("<div id=""status"">error</div>")
            context.Response.Write(String.Format("<div id=""message"">{0}</div>", ex.Message))
        End Try
        
        
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class