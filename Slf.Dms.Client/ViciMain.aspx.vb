Public Class ViciRedirectNormalException
    Inherits Exception

End Class


Partial Class ViciMain
    Inherits System.Web.UI.Page
    Dim _UserId As Integer

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        Session("CallControlsType") = "vicidial"

        _UserId = CInt(Page.User.Identity.Name)

        If Not Me.IsPostBack Then

            Dim sourceid As String = ""
            Dim did As String = ""
            Dim phonenumber As String = ""
            Dim campaign As String = ""

            If Not Me.Request.QueryString("source_id") Is Nothing AndAlso Me.Request.QueryString("source_id").Trim.Length > 0 AndAlso Me.Request.QueryString("source_id").Trim.ToLower <> "vdcl" Then
                sourceid = Me.Request.QueryString("source_id").Trim()
            End If

            If Not Me.Request.QueryString("did_extension") Is Nothing AndAlso Me.Request.QueryString("did_extension").Trim.Length > 0 Then
                did = Me.Request.QueryString("did_extension").Trim
            End If

            If Not Me.Request.QueryString("campaign") Is Nothing AndAlso Me.Request.QueryString("campaign").Trim.Length > 0 Then
                campaign = Me.Request.QueryString("campaign").Trim
            End If

            If sourceid.Trim.Length = 0 Then
                'Get the source from did
                sourceid = VicidialHelper.GetSourceByDID(did)
            End If

            Dim clientId As Integer = 0

            Try
                Select Case sourceid.ToLower
                    Case VicidialGlobals.ViciLeadSource.ToLower
                        If Not Me.Request.QueryString("lead_id") Is Nothing AndAlso Me.Request.QueryString("lead_id").Trim.Length > 0 Then
                            VicidialHelper.PostponeDialerForLead(Me.Request.QueryString("lead_id"))
                            Me.Redirect("~/clients/Enrollment/NewEnrollment2.aspx?id=" & Me.Request.QueryString("lead_id"))
                        ElseIf Not Me.Request.QueryString("vicilead_id") Is Nothing AndAlso Me.Request.QueryString("vicilead_id").Trim.Length > 0 Then
                            If Not Me.Request.QueryString("phone") Is Nothing AndAlso Me.Request.QueryString("phone").Trim.Length > 0 Then
                                phonenumber = SmartDebtorHelper.CleanPhoneNumber(Me.Request.QueryString("phone"))
                                Dim leadid As Integer = VicidialHelper.GetLeadByPhone(phonenumber)
                                If leadid > 0 Then
                                    VicidialHelper.PostponeDialerForLead(leadid)
                                    'Connect with Lead Card
                                    VicidialHelper.ConnectCallWithLead(Me.Request.QueryString("vicilead_id"), leadid, sourceid)
                                    'Open Lead Card
                                    Me.Redirect("~/clients/Enrollment/NewEnrollment2.aspx?id=" & leadid)
                                ElseIf did.Trim.Length > 0 Then
                                    AutoInsertLeadApplicant(phonenumber, did)
                                End If
                            End If
                        End If
                        Me.Redirect("~/clients/Enrollment/default.aspx")
                    Case VicidialGlobals.ViciClientSource.ToLower
                        If Not Me.Request.QueryString("lead_id") Is Nothing AndAlso Me.Request.QueryString("lead_id").Trim.Length > 0 Then
                            'If Not Me.Request.QueryString("vicilead_id") Is Nothing AndAlso Me.Request.QueryString("vicilead_id").Trim.Length > 0 Then
                            '    Dim callStatus As String = VicidialHelper.GetCallDirection(Me.Request.QueryString("vicilead_id"))
                            '    VicidialHelper.CancelPendingLeadCalls(Me.Request.QueryString("vicilead_id"), Me.Request.QueryString("lead_id"), sourceid)
                            'End If
                            ClientId = Me.Request.QueryString("lead_id")
                            Me.Redirect("~/clients/client/?id=" & Me.Request.QueryString("lead_id"))
                        ElseIf Not Me.Request.QueryString("vicilead_id") Is Nothing AndAlso Me.Request.QueryString("vicilead_id").Trim.Length > 0 Then
                            If Not Me.Request.QueryString("phone") Is Nothing AndAlso Me.Request.QueryString("phone").Trim.Length > 0 Then
                                phonenumber = SmartDebtorHelper.CleanPhoneNumber(Me.Request.QueryString("phone"))
                                ClientId = VicidialHelper.GetClientByPhone(phonenumber)
                                If clientID > 0 Then
                                    'Connect with Client Card
                                    VicidialHelper.ConnectCallWithLead(Me.Request.QueryString("vicilead_id"), clientID, sourceid)
                                    'Open Client Card
                                    Me.Redirect("~/clients/client/?id=" & ClientId)
                                End If
                            End If
                        End If
                        Me.Redirect("~/search.aspx")
                    Case VicidialGlobals.ViciMatterSource.ToLower
                        If Not Me.Request.QueryString("lead_id") Is Nothing AndAlso Me.Request.QueryString("lead_id").Trim.Length > 0 Then
                            'Get Matter Type, ClientId
                            'For Nondeposit redirect to matter page
                            'For Settlement Get Task id redirect to Settlement Approval Page
                            Dim matterid = Me.Request.QueryString("lead_id")
                            Dim dtmatter As System.Data.DataTable = VicidialHelper.GetMatterData(matterid)
                            If dtmatter.Rows.Count > 0 Then
                                clientId = dtmatter.Rows(0)("clientid")
                                Select Case dtmatter.Rows(0)("mattertypeid")
                                    Case 3
                                        Dim taskid As Integer = VicidialHelper.GetMatterTaskId(matterid)
                                        If taskid > 0 Then
                                            Me.Redirect("~/processing/TaskSummary/default.aspx?id=" & taskid)
                                        Else
                                            Me.Redirect("~/clients/client/?id=" & clientId)
                                        End If
                                    Case 5
                                        Me.Redirect(String.Format("{0}?id={1}&aid=0&mid={2}&ciid=0", ResolveUrl("~/clients/client/creditors/matters/nondepositmatterinstance.aspx"), clientId, matterid))
                                End Select
                            End If
                        End If
                    Case Else
                        Me.Redirect(GetDefaultPage(did, campaign))
                End Select

                'If not found Go to the the default page 
                Me.Redirect(GetDefaultPage(did, campaign))
            Catch ex As ViciRedirectNormalException
                'If clientId <> 0 Then
                '    Dim commlastpage As String = "side_commsholder"
                '    ClientScript.RegisterStartupScript(GetType(Page), "opensidecommwnd", String.Format("LoadSideCommPage('{0}{1}.aspx?auto=phonecall&ClientID={2}&RelationTypeID=-1&RelationID=-1&EntityName=');", ResolveUrl("~/clients/client/communication/"), commlastpage, clientId), True)
                'End If
                ClientScript.RegisterStartupScript(GetType(Page), "resizeframeforparent", "window.top.parent.resizeInnerAppFrame();", True)
            End Try
        End If

    End Sub

    Private Function GetDefaultPage(ByVal did As String, ByVal campaign As String) As String
        'Get default page by DID
        Dim defaultpage As String = ""

        If did.Trim.Length > 0 Then VicidialHelper.GetDefaultPageByDID(did)

        If defaultpage.Trim.Length = 0 AndAlso campaign.Trim.Length > 0 Then defaultpage = VicidialHelper.GetDefaultPageByCampaign(campaign)

        If defaultpage.Trim.Length > 0 Then
            Return defaultpage
        Else
            Return "~/search.aspx"
        End If

    End Function

    Private Sub AutoInsertLeadApplicant(ByVal PhoneNumber As String, ByVal DID As String)
        If VicidialHelper.IsAutoInsertDID(DID.Trim) Then
            If Not AsteriskHelper.IsGeneratedNumber(PhoneNumber) Then
                'Create Lead and redirect it
                Dim leadid As Integer = VicidialHelper.AutoInsertLeadByDID(PhoneNumber, DID, _UserId)
                If leadid > 0 Then
                    Me.Redirect("~/clients/Enrollment/NewEnrollment2.aspx?id=" & leadid)
                End If
            End If
        End If
    End Sub

    Private Sub Redirect(ByVal url As String)
        Me.iMainPanel.Attributes("src") = ResolveUrl(url)
        Throw New ViciRedirectNormalException()
    End Sub

End Class
