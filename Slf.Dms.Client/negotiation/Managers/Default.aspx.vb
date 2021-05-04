﻿Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Linq

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates

Partial Class negotiation_Managers_Default
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private UserID As String
    Private _DataClientID As String
    Private _accountID As String

    #End Region 'Fields

    #Region "Methods"

    Public Shared Function CreateNewDocumentPathAndName(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ssql As String = String.Format("SELECT AccountNumber FROM tblClient WHERE ClientID = {0}", ClientID.ToString)
        Dim acctNum As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        Dim ret As String
        ret = rootDir + subFolder + acctNum + "_" + strDocTypeID + "_" + ReportsHelper.GetNewDocID() + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        Return ret
    End Function

    Public Sub ApproveQueue()
        'Enumerate the GridViewRows
        For index As Integer = 0 To gvManager.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvManager.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

            'If it's checked, delete it...
            If cb.Checked Then
                Dim actionid As Integer = gvManager.DataKeys(index).Item(0).ToString
                Dim acctid As Integer = gvManager.DataKeys(index).Item(1).ToString
                Dim cid As Integer = gvManager.DataKeys(index).Item(2).ToString
                Dim sType As String = gvManager.DataKeys(index).Item(3).ToString

                Select Case sType.ToLower
                    Case "SettlementPercent".ToLower
                        Try
                            Dim sqlUpdate As String = String.Format("UPDATE tblSettlements_Overs SET Approved = GETDATE(), ApprovedBy = {0} WHERE (OverID = {1})", UserID, actionid)
                            SqlHelper.ExecuteNonQuery(sqlUpdate, Data.CommandType.Text)
                            Dim sid As String = SqlHelper.ExecuteScalar(String.Format("select settlementid from tblSettlements_Overs where overid = {0}", actionid), CommandType.Text)
                            Dim cuID As Integer = 0
                            'Dim currTaskId As Integer = 0
                            Dim bRestrictEndorse As Boolean = False
                            Dim bIsPaymentArrangement As Boolean = False
                            Dim ssql As String = String.Format("select s.createdby,s.IsRestrictiveEndorsement, s.IsPaymentArrangement from tblsettlements s where s.settlementid = {0}", sid)
                            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                                For Each dr As DataRow In dt.Rows
                                    cuID = dr("createdby").ToString
                                    'currTaskId = dr("currenttaskid").ToString
                                    bRestrictEndorse = dr("IsRestrictiveEndorsement").ToString
                                    If Not dr("IsPaymentArrangement") Is DBNull.Value Then
                                        bIsPaymentArrangement = dr("IsPaymentArrangement")
                                    End If
                                    Exit For
                                Next
                            End Using

                            Dim nid As Integer = NoteHelper.InsertNote("Overage settlement approved by manager.", UserID, cid)
                            NoteHelper.RelateNote(nid, 1, cid)

                            'resolve task
                            Using settInfo As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(sid)
                                If settInfo.IsClientStipulation Then
                                    NegotiationRoadmapHelper.InsertRoadmap(sid, 5, "Waiting on SIF", cuID)
                                    InsertMatterAndTask(settInfo.SettlementClientID, settInfo.SettlementID, settInfo.SettlementCreditorAccountID, 87, "Attach SIF/CS")
                                ElseIf bRestrictEndorse Then
                                    InsertMatterAndTask(settInfo.SettlementClientID, settInfo.SettlementID, settInfo.SettlementCreditorAccountID, 51, "Client Approval")
                                Else
                                    NegotiationRoadmapHelper.InsertRoadmap(sid, 5, "Waiting on SIF", cuID)
                                    InsertMatterAndTask(settInfo.SettlementClientID, settInfo.SettlementID, settInfo.SettlementCreditorAccountID, 92, "Attach SIF")
                                End If
                            End Using
                        Catch ex As Exception
                            Continue For
                        End Try
                End Select
            End If
        Next
    End Sub

    Public Sub RejectQueue()
        'Enumerate the GridViewRows
        For index As Integer = 0 To gvManager.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvManager.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

            'If it's checked, delete it...
            If cb.Checked Then
                Dim actionid As Integer = gvManager.DataKeys(index).Item(0).ToString
                Dim acctid As Integer = gvManager.DataKeys(index).Item(1).ToString
                Dim cid As Integer = gvManager.DataKeys(index).Item(2).ToString
                Dim sType As String = gvManager.DataKeys(index).Item(3).ToString
                Dim sid As String = SqlHelper.ExecuteScalar(String.Format("select settlementid from tblSettlements_Overs where overid = {0}", actionid), CommandType.Text)
                Select Case sType.ToLower
                    Case "SettlementPercent".ToLower
                        Dim myParams As New List(Of SqlParameter)
                        myParams.Add(New SqlParameter("userid", UserID))
                        myParams.Add(New SqlParameter("overid", actionid))
                        SqlHelper.ExecuteNonQuery("stp_settlements_rejectOver", Data.CommandType.StoredProcedure, myParams.ToArray)

                        Dim nid As Integer = NoteHelper.InsertNote("Overage settlement rejected by manager.", UserID, cid)
                        NoteHelper.RelateNote(nid, 1, cid)

                End Select

            End If
        Next
    End Sub

    Protected Sub btnApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApprove.Click
        ApproveQueue()
        dsManager.DataBind()
        gvManager.DataBind()
    End Sub

    Protected Sub btnReject_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReject.Click
        RejectQueue()
        dsManager.DataBind()
        gvManager.DataBind()
    End Sub

    Protected Sub gvManager_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvManager.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
        End Select
    End Sub

    Protected Sub gvManager_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvManager.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim lbl As Label = TryCast(e.Row.FindControl("lblExpected"), Label)
                lbl.CssClass = "listItem"
                Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_ExpectedDeposits_GetSummary {0},'{1}'", rowView("clientid").ToString, rowView("settlementduedate").ToString), CommandType.Text)
                    For Each row As DataRow In dt.Rows
                        lbl.Text = FormatCurrency(row(0).ToString, 2)
                        Exit For
                    Next
                End Using

                Select Case Math.Sign(Double.Parse(rowView("SDABalance").ToString))
                    Case -1
                        e.Row.Cells(9).ForeColor = System.Drawing.Color.Red
                    Case Else

                End Select

        End Select
    End Sub

    Protected Sub negotiation_Managers_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not SettlementProcessingHelper.IsManager(UserID) Then

            'show for non managers
            gvManager.Visible = False
            btnApprove.Visible = False
            btnReject.Visible = False

            Dim div As New HtmlGenericControl("div class=""warning"" ")
            div.InnerHtml = "You are not authorized to view this page!"
            phMsg.Controls.Add(div)


        End If
    End Sub

    Private Shared Function CreateSAFFilePath(ByVal clientId As Integer, ByVal creditorAcctId As Integer) As String
        Dim filePath As String = ""
        Dim tempName As String
        Dim strDocTypeName As String = "SettlementAcceptanceForm"
        Dim strDocID As String = "D6004"
        Dim rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(clientId)
        Dim strCredName As String = AccountHelper.GetCreditorName(creditorAcctId)

        tempName = strCredName
        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
        filePath = CreateNewDocumentPathAndName(rootDir, clientId, strDocID, String.Format("CreditorDocs\{0}_{1}\", creditorAcctId, tempName))

        If Directory.Exists(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName)) = False Then
            Directory.CreateDirectory(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName))
        End If
        Return filePath
    End Function

    Function EmailAddressCheck(ByVal emailAddress As String) As Boolean
        Dim pattern As String = "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
        Dim emailAddressMatch As Match = Regex.Match(emailAddress, pattern)
        If emailAddressMatch.Success Then
            EmailAddressCheck = True
        Else
            EmailAddressCheck = False
        End If
    End Function

    Private Function InsertMatterAndTask(ByVal clientId As Integer, ByVal settlementId As Integer, ByVal creditorAcctId As Integer, ByVal MatterSubStatusId As Integer, ByVal TaskTypeText As String) As Integer
        'Adjust settlement Fee
        Dim settDesc As String = "Settlement - "
        Dim settFeeDesc As String = "Settlement Fee - "
        Dim adjustedDesc As String = "Fee Adjustment - "
        Dim DelDesc As String = "Delivery Fee - "
        Dim Desc As String
        Dim ssqlDesc As String = String.Format("Select SettlementAmount,SettlementFee,DeliveryAmount,DeliveryMethod,AdjustedSettlementFee,SettlementDueDate,isclientstipulation from tblsettlements where settlementid = {0}", settlementId)
        Dim settAMount As Double = 0
        Dim settFee As Double = 0
        Dim delAmount As Double = 0
        Dim delMethod As String = ""
        Dim adjustedFee As Double = 0
        Using dt As DataTable = SqlHelper.GetDataTable(ssqlDesc, CommandType.Text)
            For Each Row As DataRow In dt.Rows
                settAMount = CDbl(Row("SettlementAmount").ToString)
                settFee = CDbl(Row("SettlementFee").ToString)
                delAmount = CDbl(Row("DeliveryAmount").ToString)
                delMethod = Row("DeliveryMethod").ToString
                adjustedFee = CDbl(Row("AdjustedSettlementFee").ToString)
                Exit For
            Next
        End Using

        Desc = SettlementMatterHelper.GetSettRegisterEntryDesc(creditorAcctId)
        settDesc += Desc
        settFeeDesc += Desc
        adjustedDesc += Desc
        DelDesc += Desc

        SettlementFeeHelper.AdjustSettlementFee(settlementId, clientId, UserID, creditorAcctId)

        SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 18, settDesc, (Math.Abs(settAMount) * -1), UserID, True, -1, False, Nothing)
        SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 4, settFeeDesc, (Math.Abs(settFee) * -1), UserID, True, -1, False, Nothing)

        If delAmount <> 0 Then
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, IIf(delMethod.Equals("chk"), 6, 28), DelDesc, (Math.Abs(delAmount) * -1), UserID, True, -1, False, Nothing)
        End If

        If adjustedFee <> 0 Then
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, -2, adjustedDesc, (adjustedFee * -1), UserID, True, -1, False, Nothing)
        End If

        'Add Matter
        Dim ret As Integer
        Dim TaskTypeId As Integer = 0
        Using settinfo As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(settlementId)
            Dim currentMatterID As Integer
            Dim userName As String = UserHelper.GetName(UserID)

            'close existing matters
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("clientid", settinfo.SettlementClientID))
            params.Add(New SqlParameter("accountid", settinfo.SettlementCreditorAccountID))
            SqlHelper.ExecuteNonQuery("stp_settlements_CloseExistingMattersForAccount", CommandType.StoredProcedure, params.ToArray)

            'update calc
            ret = matter_UpdateSettlementCalculations(delAmount, delMethod, adjustedFee, settinfo.SettlementID)
            'create matter
            currentMatterID = matter_CreateMatterForSettlement(settinfo.SettlementID, settinfo.SettlementCreditorAccountID, MatterSubStatusId, settinfo.SettlementClientID, userName)
            'create task
            Dim newTaskID As Integer = matter_InsertTasksForMatter(settinfo.SettlementClientID, settinfo.SettlementDueDate, TaskTypeText, currentMatterID)
            matter_InsertAlertsForMatter(settinfo.SettlementID, settinfo.SettlementCreditorAccountID, settinfo.SettlementClientID, TaskTypeText, currentMatterID, userName)
        End Using

        Return ret 'returnParam.Value

    End Function

    Private Function matter_CreateMatterForSettlement(ByVal settlementID As Integer, ByVal SettlementCreditorAccountID As Integer, _
        ByVal MatterSubStatusId As Integer, ByVal dataClientID As Integer, ByRef userName As String) As Integer
        Dim attID As String = SqlHelper.ExecuteScalar(String.Format("SELECT isnull(a.AttorneyId,-1)[AttorneyId] FROM tblClient c with(nolock) " & _
                                                                     "Inner Join tblPerson p with(nolock) ON c.PrimaryPersonId = p.PersonId " & _
                                                                     "Inner Join tblState s with(nolock) ON s.StateId = p.StateId " & _
                                                                     "left Join tblCompanyStatePrimary a with(nolock) ON a.CompanyId = c.CompanyId " & _
                                                                     "And s.Abbreviation = a.State Where c.ClientId = {0}", dataClientID), CommandType.Text)
        'insert matter
        Dim currentMatterID As Integer = -1
        Dim negID As Integer = SqlHelper.ExecuteScalar(String.Format("select createdby from tblsettlements where settlementid = {0}", settlementID), CommandType.Text)
        Dim NewMatterID As Double = SqlHelper.ExecuteScalar("SELECT max(MatterId)+1 FROM tblMatter with(nolock)", CommandType.Text)
        Dim sqlMatter As String = "INSERT INTO tblMatter(ClientId, MatterStatusCodeId, MatterNumber,MatterDate, MatterMemo, CreatedDateTime, CreatedBy, " & _
        "CreditorInstanceId, AttorneyId, MatterTypeId, IsDeleted, MatterStatusId, MatterSubStatusId) VALUES ("
        sqlMatter += String.Format("{0},23,", dataClientID)
        sqlMatter += String.Format("{0},", FormatNumber(NewMatterID, 0, TriState.False, TriState.False, TriState.False))
        sqlMatter += String.Format("'{0}','Generating a matter for the settlement',", Now)
        sqlMatter += String.Format("'{0}',{1},", Now, negID)
        sqlMatter += String.Format("{0},{1},3,0,3,{2}); select SCOPE_IDENTITY();", AccountHelper.GetCurrentCreditorInstanceID(SettlementCreditorAccountID), attID, MatterSubStatusId)
        currentMatterID = SqlHelper.ExecuteScalar(sqlMatter, CommandType.Text)
        SqlHelper.ExecuteNonQuery(String.Format("UPDATE tblmatter SET matternumber = matterid where matterid = {0}", currentMatterID), CommandType.Text)

        'associate matter w/ sett
        Dim sqlUpdate As String = String.Format("UPDATE tblSettlements SET MatterId = {0},LocalCounselId = {1},LastModified = getdate(),LastModifiedBy = {2} WHERE SettlementId = {3}", currentMatterID, attID, UserID, settlementID)
        SqlHelper.ExecuteNonQuery(sqlUpdate, CommandType.Text)

        Using si As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(settlementID)
            Dim CredName As String = SqlHelper.ExecuteScalar(String.Format("select name from tblcreditor where creditorid = {0}", si.SettlementCreditorID), CommandType.Text)
            'insert note
            Dim negName As String = UserHelper.GetName(negID)
            Dim sNote As String = String.Format("Generated a Matter for the settlement with {0} by {1} on {2}", CredName, negName, Now)
            Dim noteID As Integer = NoteHelper.InsertNote(sNote, negID, dataClientID)
            NoteHelper.RelateNote(noteID, 1, dataClientID)
            NoteHelper.RelateNote(noteID, 2, SettlementCreditorAccountID)
            NoteHelper.RelateNote(noteID, 19, currentMatterID)

            'insert roadmap
            Dim sqlRoad As String = "INSERT INTO tblSettlementRoadmap(SettlementId, MatterStatusCodeId, NoteId, CreatedBy, Created) VALUES("
            sqlRoad += String.Format("{0}, {1}, {2}, {3}, getdate())", settlementID, "23", noteID, UserID)
            SqlHelper.ExecuteNonQuery(sqlRoad, CommandType.Text)

            sNote = String.Format("{0} approved Settlement % for settlement with {1} on {2}", userName, CredName, Now)
            noteID = NoteHelper.InsertNote(sNote, negID, dataClientID)
            NoteHelper.RelateNote(noteID, 1, dataClientID)
            NoteHelper.RelateNote(noteID, 2, SettlementCreditorAccountID)
            NoteHelper.RelateNote(noteID, 19, currentMatterID)
        End Using

        Return currentMatterID
    End Function

    Private Sub matter_InsertAlertsForMatter(ByVal SettlementID As Integer, ByVal SettlementCreditorAccountID As Integer, ByVal dataClientID As Integer, ByVal TaskTypeText As String, ByVal currentMatterID As Integer, ByVal userName As String)
        Dim aNote As String = String.Format("{0} created a task of type {1} on {2}", userName, TaskTypeText, Now)
        Dim aNoteID As Integer = NoteHelper.InsertNote(aNote, UserID, dataClientID)
        NoteHelper.RelateNote(aNoteID, 1, dataClientID)
        NoteHelper.RelateNote(aNoteID, 2, SettlementCreditorAccountID)
        NoteHelper.RelateNote(aNoteID, 19, currentMatterID)
    End Sub

    Private Function matter_InsertTasksForMatter(ByVal dataClientid As Integer, ByVal SettlementDueDate As String, ByVal TaskTypeText As String, ByVal currentMatterID As Integer) As Integer
        Dim TaskTypeId As Integer = DataHelper.FieldLookupIDs("tblTaskType", "TaskTypeId", String.Format("[Name] = '{0}'", TaskTypeText))(0)
        'insert task for matter

        Dim sqlTask As String = "INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,CreatedBy, LastModified, " & _
                                "LastModifiedBy, AssignedTo,matterid) VALUES("
        sqlTask += String.Format("{0},", TaskTypeId)
        sqlTask += String.Format("'{0}',", TaskTypeText)
        sqlTask += String.Format("'{0}',", SettlementDueDate)
        sqlTask += String.Format("NULL,getdate(),{0},getdate(),{0},0,{1}); select SCOPE_IDENTITY();", UserID, currentMatterID)
        Dim newTaskID As Integer = SqlHelper.ExecuteScalar(sqlTask, CommandType.Text)

        'insert client task
        Dim sqlCT As String = String.Format("INSERT INTO tblClientTask(ClientId,TaskId,Created,CreatedBy,LastModified,LastModifiedBy) " & _
                                            "VALUES({0}, {1}, getdate(), {2}, getdate(), {2})", dataClientid, newTaskID, UserID)
        SqlHelper.ExecuteNonQuery(sqlCT, CommandType.Text)

        'associate with matter still
        Dim sqlMT As String = String.Format("Select * from tblmattertask where matterid = {0}", currentMatterID)
        Dim dtMT As DataTable = SqlHelper.GetDataTable(sqlMT, CommandType.Text)
        If dtMT.Rows.Count > 0 Then
            Dim sqlAssoc As String = String.Format("update tblMatterTask set taskid = {0} where matterid = {1}", newTaskID, currentMatterID)
            SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
        Else
            Dim sqlAssoc As String = String.Format("INSERT INTO tblMatterTask(MatterId, TaskId) VALUES({0}, {1})", currentMatterID, newTaskID)
            SqlHelper.ExecuteNonQuery(sqlAssoc, CommandType.Text)
        End If
        SettlementMatterHelper.UpdateMatterCurrentTaskID(currentMatterID, newTaskID)
        Return newTaskID
    End Function

    Private Function matter_UpdateSettlementCalculations(ByVal delAmount As Double, ByVal delMethod As String, ByVal adjustedFee As Double, ByVal SettlementID As Integer) As Integer
        Dim ret As Integer
        Dim sqlCalc As String = "stp_UpdateSettlementCalculations"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("settlementid", SettlementID))
        params.Add(New SqlParameter("CreatedBy", UserID))
        params.Add(New SqlParameter("DeliveryMethod", delMethod))
        params.Add(New SqlParameter("DeliveryAmount", delAmount))
        params.Add(New SqlParameter("AdjustedFee", adjustedFee))
        ret = SqlHelper.ExecuteScalar(sqlCalc, CommandType.StoredProcedure, params.ToArray)
        Return ret
    End Function

#End Region 'Methods

End Class