Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Windows.Forms

Imports Infragistics.Documents.Graphics
Imports Infragistics.Documents.Report
Imports Infragistics.Documents.Report.Text

Imports Microsoft.VisualBasic

Imports SharedFunctions.AsyncDB
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess

Public Class HarassmentHelper

#Region "Enumerations"

    Public Enum enumHarassmentStatus
        AbuseIntakeFormCreated = 0
        DeclineLetter = 1
        DropDisengage = 2
        SendDemand = 3
        LocateLC = 4
        Filed = 5
        ProcessSettlement = 6
    End Enum

#End Region 'Enumerations

#Region "Methods"
    Public Shared Sub ProcessHarassment(ByVal DataClientID As Integer, ByVal MatterId As Integer, ByVal TaskTypeID As Integer, ByVal currentUserID As Integer)

        Dim eSubject As String = ""
        Select Case TaskTypeID
            Case 14 'abuse intake form created
                eSubject = "abuse intake form created"
            Case 85 'decline letter
                eSubject = "decline letter"
            Case 60 'drop disengage
                eSubject = "drop disengage"
            Case 61 'send demand
                eSubject = "send demand"
            Case 54 'locate LC
                eSubject = "locate LC"
            Case 62 'files
                eSubject = "files"
            Case 44 'process settlement
                eSubject = "Process Settlement"
        End Select

        eSubject = StrConv(eSubject, VbStrConv.ProperCase)
        Dim CreditorAccountID As String = SqlHelper.ExecuteScalar(String.Format("SELECT accountid from tblaccount where CurrentCreditorInstanceID = (select  CreditorInstanceId from tblmatter where matterid = {0})", MatterId), CommandType.Text)

        'insert roadmap step
        'and create matter
        Dim ssql As String = "INSERT INTO [tblHarassmentRoadmap]([ClientSubmissionID],[HarassmentStatus],matterid,[Created],[CreatedBy]) "
        ssql += String.Format("SELECT ClientSubmissionID,{0}[HarassmentStatus],MatterID,getdate(),{1}CreatedBy ", TaskTypeID, currentUserID)
        ssql += String.Format("from tblHarassmentRoadmap where matterid = {0}", MatterId)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

        Dim clientEmail As String = SqlHelper.ExecuteScalar(String.Format("Select isnull(emailaddress,'')[Email] from tblperson where clientid = {0}", DataClientID), CommandType.Text)
        If Not String.IsNullOrEmpty(clientEmail) Then
            Dim et As EmailHelper.EmailTemplate = EmailHelper.GetEmailTemplateByUniqueCallingID("ABUSE", TaskTypeID)
            Dim CreditorName As String = AccountHelper.GetCreditorName(CreditorAccountID)
            Dim sBody As String = et.TemplateText
            sBody = sBody.Replace("(merge account)", CreditorName)
            EmailHelper.SendMessage("harassment@lexxiom.com", clientEmail, eSubject, sBody)
        End If


      


    End Sub

    

    Public Shared Function ProcessHarassmentForm(ByVal HarassmentForm As Harassment) As Infragistics.Documents.Report.Report
        Dim obj As New HarassmentHelper

        Try
            obj.SaveForm(HarassmentForm)
            'obj.BuildFormSubmissionInsert(HarassmentForm)
            Return obj.GenerateForm(HarassmentForm)

        Catch ex As Exception
            Throw ex
        Finally
            obj = Nothing
        End Try
    End Function

    Public Shared Function getReasonHeaderIDByText(ByVal reasonText As String) As Integer
        Dim sqlSearch As String = "select reasonheaderid from dbo.tblHarassmentReasonHeader where reasonheadervalue " & _
        "like '" & reasonText & "%'"
        Dim hdrID As Integer = executeScalar(sqlSearch, System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
        Return hdrID
    End Function

    Public Shared Function getReasonIDByText(ByVal reasonText As String) As Integer
        Dim sqlSearch As String = "select reasonid from dbo.tblHarassmentReasons where reason like '" & reasonText.Replace("'", "''") & "%'"
        Dim rID As Integer = executeScalar(sqlSearch, System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
        Return rID
    End Function

    Public Sub BuildFormSubmissionInsert(ByVal HarassmentFormData As Harassment)
        Dim submit As New List(Of harassmentSubmision)

        Dim sqlInsertForm As String = "INSERT INTO [FormSubmissions] ([FormID],[SubmissionDate])" & _
            "OUTPUT Inserted.SubmissionID VALUES(3,'" & Format(Now, "MM/dd/yyyy") & "')"
        Dim subID As String = executeScalar(sqlInsertForm, System.Configuration.ConfigurationManager.AppSettings("connectionstringtouchpoint").ToString)

        submit.Add(New harassmentSubmision(subID, 8, "", "8_string", HarassmentFormData.ClientAccountNumber, "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 9, "", "9_string", HarassmentFormData.CardHoldersName, "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 132, "", "132_string", HarassmentFormData.CardHolderState, "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 133, "", "133_string", Format(Now, "MM/dd/yyyy"), "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 137, "", "137_string", HarassmentFormData.DebtCollectorName, "string", 3, 1))
        If HarassmentFormData.OriginalNoticeOfRepresentationMailDate IsNot Nothing Then
            If HarassmentFormData.OriginalNoticeOfRepresentationMailDate.ToString <> "" Then
                Dim strContact As New StringBuilder
                strContact.AppendLine(HarassmentFormData.DescribeCreditorContact)
                strContact.AppendLine(".  Original Notice of Representation by Legal Counsel Mailed on " & FormatDateTime(HarassmentFormData.OriginalNoticeOfRepresentationMailDate, DateFormat.ShortDate).ToString)
                submit.Add(New harassmentSubmision(subID, 32, "", "32_string", strContact.ToString, "string", 3, 1))
            End If
        Else
            submit.Add(New harassmentSubmision(subID, 32, "", "32_string", HarassmentFormData.DescribeCreditorContact, "string", 3, 1))

        End If

        submit.Add(New harassmentSubmision(subID, 135, "", "135_string", HarassmentFormData.IndividualCallingName, "string", 3, 1))
        Dim strItem As String = ""
        For Each s As String In HarassmentFormData.IndividualCallingIdentity
            strItem += "<item>" & s & "</item>"
        Next
        submit.Add(New harassmentSubmision(subID, 16, "", "16_array", strItem, "array", 3, 1))

        submit.Add(New harassmentSubmision(subID, 136, "", "136_string", HarassmentFormData.IndividualCallingPhone, "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 19, "", "19_string", Format(HarassmentFormData.IndividualCallingDateOfCall, "MM/dd/yyyy"), "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 20, "", "20_string", HarassmentFormData.IndividualCallingNumTimesCalled, "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 21, "", "21_string", Format(HarassmentFormData.IndividualCallingTimeOfCall, "hh:mm"), "string", 3, 1))
        submit.Add(New harassmentSubmision(subID, 24, "", "24_string", Format(HarassmentFormData.IndividualCallingTimeOfCall, "tt"), "string", 3, 1))

        'insert harassment info
        If HarassmentFormData.ReasonData.Count > 0 Then

            For Each h As HarassmentReason In HarassmentFormData.ReasonData
                Dim fIDs As String() = h.FieldID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                If fIDs.Length = 2 Then
                    If h.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries).Length > 1 Then
                        For Each sv As String In h.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                            submit.Add(New harassmentSubmision(subID, fIDs(0), "", h.FieldID, sv, fIDs(1), 3, 1))
                        Next
                    Else
                        If h.ReasonValue <> "" Then
                            submit.Add(New harassmentSubmision(subID, fIDs(0), "", h.FieldID, h.ReasonValue, fIDs(1), 3, 1))
                        Else
                            'use text value is blank
                            submit.Add(New harassmentSubmision(subID, fIDs(0), "", h.FieldID, h.ReasonText, fIDs(1), 3, 1))
                        End If

                    End If
                End If
            Next
        End If

        If HarassmentFormData.AdditionalReasonData.Count > 0 Then
            For Each h As HarassmentReason In HarassmentFormData.AdditionalReasonData
                Dim fIDs As String() = h.FieldID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                If fIDs.Length = 2 Then
                    If h.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries).Length > 1 Then
                        Dim strItems As String = ""
                        For Each v As String In h.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                            strItems += "<item>" & v & "</item>"
                        Next
                        submit.Add(New harassmentSubmision(subID, fIDs(0), "", h.FieldID, strItems, fIDs(1), 3, 1))

                    Else
                        submit.Add(New harassmentSubmision(subID, fIDs(0), "", h.FieldID, h.ReasonValue, fIDs(1), 3, 1))
                    End If
                End If

            Next
        End If

        For Each hs As harassmentSubmision In submit
            If hs.FieldValue.ToString <> "" And hs.FieldValue.ToString <> "0" And hs.FieldValue.ToString <> "hh:mm" _
            And hs.FieldValue.ToString <> "tt" And hs.FieldValue.ToString <> "MM/dd/yyyy" Then
                Dim sqlFields As String = "INSERT INTO [FormSubmissionValues]([SubmissionID],[FieldID],[ColumnSuffix], " & _
                "[PivotID],[Value],[ValueType],[FormID],[FieldPivotSortOrder]) " & _
                "VALUES ([@SubmissionID],[@FieldID],'','[@PivotID]','[@Value]','[@ValueType]',3 ,1)"

                sqlFields = sqlFields.Replace("[@SubmissionID]", subID)
                sqlFields = sqlFields.Replace("[@FieldID]", hs.FieldID)
                sqlFields = sqlFields.Replace("[@PivotID]", hs.PivotID)

                Dim fieldValue As String = hs.FieldValue
                fieldValue = fieldValue.Replace("What Happened :", "").Replace("Other Parties Contacted :", "").Replace("|", "")

                'If fieldValue.Contains("hh:mm") = False Then
                '    Dim fVal As String() = fieldValue.Replace("'", "''").Split(":")
                '    If fVal.Length = 2 Then
                '        fieldValue = fVal(1)
                '    Else
                '        fieldValue = fVal(0)
                '    End If
                'End If

                sqlFields = sqlFields.Replace("[@Value]", fieldValue.Trim().Replace("'", "''"))

                sqlFields = sqlFields.Replace("[@ValueType]", hs.FieldValueType.Replace("'", "''"))

                executeScalar(sqlFields, System.Configuration.ConfigurationManager.AppSettings("connectionstringtouchpoint").ToString)
            End If
        Next
    End Sub

    Public Function GenerateForm(ByVal HarassmentFormData As Harassment) As Infragistics.Documents.Report.Report
        Dim obj As New HarassmentHelper

        Try

            Dim rpt As New Infragistics.Documents.Report.Report
            Dim HdrStyle As New Style(New Font("Verdana", 20), Brushes.Black)
            Dim lineStyle As New Style(New Font("Verdana", 12, FontStyle.Regular), Brushes.Black)

            Dim secClient As Infragistics.Documents.Report.Section.ISection = rpt.AddSection
            secClient.PagePaddings = New Infragistics.Documents.Report.Paddings(25)

            Dim band As Infragistics.Documents.Report.Band.IBand = secClient.AddBand
            band.Background = New Infragistics.Documents.Report.Background(Infragistics.Documents.Graphics.Colors.White)

            Dim bandHeader As Infragistics.Documents.Report.Band.IBandHeader = band.Header
            Dim aDate As String = ""

            bandHeader.Repeat = True
            bandHeader.Height = New Infragistics.Documents.Report.FixedHeight(60)
            bandHeader.Alignment = New Infragistics.Documents.Report.ContentAlignment(Infragistics.Documents.Report.Alignment.Left, Infragistics.Documents.Report.Alignment.Middle)
            bandHeader.Borders.Bottom = New Infragistics.Documents.Report.Border(Infragistics.Documents.Graphics.Pens.DarkBlue)
            bandHeader.Paddings.Horizontal = 5

            ' Add textual content to the header.
            Dim bandHeaderText As Infragistics.Documents.Report.Text.IText = bandHeader.AddText()
            bandHeaderText.AddContent("Client Debt Collection Abuse Intake Form", HdrStyle)
            Dim textPattern As New TextPattern()
            textPattern.Margins = New Margins(5, 10)
            textPattern.Paddings = New Paddings(5)
            textPattern.Interval = 5
            bandHeaderText.ApplyPattern(textPattern)

            ' Add content to the band.
            Dim bandText As Infragistics.Documents.Report.Text.IText

            '1.16.09.ug:  added client firm to report
            Dim sSQL As String = "select co.name from tblclient c left outer join tblcompany co on c.companyid=co.companyid where c.clientid = " & HarassmentFormData.DataClientID
            Dim clientCompany As String = executeScalar(sSQL, System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)

            bandText = obj.addBandText(band, "Client Firm : " & clientCompany, 25, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Client Acct Number : " & HarassmentFormData.ClientAccountNumber, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Card Holder's Name : " & HarassmentFormData.CardHoldersName, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "State : " & HarassmentFormData.CardHolderState, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Date: " & Now, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Original Creditor : " & HarassmentFormData.OriginalCreditorName, textStyle:=lineStyle)

            If HarassmentFormData.BeingSuedByCreditor = True Then
                bandText = obj.addBandText(band, "Have you been sued by this Creditor ? " & HarassmentFormData.BeingSuedByCreditor, textStyle:=lineStyle)
            End If

            'lineStyle = New Style(New Font("Verdana", 8, FontStyle.Italic), Brushes.Black)
            bandText = obj.addBandText(band, "Individual Calling: " & HarassmentFormData.IndividualCallingName)

            Dim listPattern1 As New Infragistics.Documents.Report.List.ListPattern()
            listPattern1.Bullets = New Infragistics.Documents.Report.List.Bullets(BulletType.WhiteCircle)
            listPattern1.Paddings.Left = 65

            ' Create a list and apply the first pattern to it.
            Dim sectionList1 As Infragistics.Documents.Report.List.IList = band.AddList()
            sectionList1.ApplyPattern(listPattern1)

            ' Create a list item.
            Dim sectionListItem1 As Infragistics.Documents.Report.List.IListItem

            ' For each name in the BulletType enum, add a new list item.
            lineStyle = New Style(New Font("Verdana", 8, FontStyle.Regular), Brushes.Black)
            For Each ind As String In HarassmentFormData.IndividualCallingIdentity
                sectionListItem1 = sectionList1.AddItem()
                Dim sText As IText = sectionListItem1.AddText()
                sText.AddContent(ind, lineStyle)
            Next

            lineStyle = New Style(New Font("Verdana", 12, FontStyle.Regular), Brushes.Black)
            bandText = obj.addBandText(band, "Phone # of Caller: " & HarassmentFormData.IndividualCallingPhone, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Phone # Creditor Dialed: " & HarassmentFormData.IndividualCallingNumberDialed, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Most Recent Date of Abuse: " & HarassmentFormData.IndividualCallingDateOfCall, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Date abuse began: " & HarassmentFormData.AbuseBeginDate, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Times called (On most recent date of abuse): " & HarassmentFormData.IndividualCallingNumTimesCalled, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Estimated number of daily calls during period of abuse : " & HarassmentFormData.EstNumberDailyCalls, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Time : " & HarassmentFormData.IndividualCallingTimeOfCall, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Debt Collector : " & HarassmentFormData.DebtCollectorName, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Reason : " & HarassmentFormData.ReasonHeaderText, textStyle:=lineStyle)

            Dim rGrid As Infragistics.Documents.Report.Table.ITable = obj.addBandTable(band, HarassmentFormData.ReasonData, HarassmentFormData.ReasonHeaderText)

            bandText = obj.addBandText(band, "Describe in FULL Detail Contact with Creditor: " & HarassmentFormData.DescribeCreditorContact, textStyle:=lineStyle)
            bandText = obj.addBandText(band, "Additional Info : ", textStyle:=lineStyle)

            Dim aGrid As Infragistics.Documents.Report.Grid.IGrid = obj.addBandGrid(band, HarassmentFormData.AdditionalReasonData)

            If Not HarassmentFormData.OriginalNoticeOfRepresentationMailDate Is Nothing Then
                aDate = HarassmentFormData.OriginalNoticeOfRepresentationMailDate
                If aDate <> "" Then
                    aDate = FormatDateTime(aDate, DateFormat.ShortDate)
                End If
                bandText = obj.addBandText(band, "Original Notice of Representation by Legal Counsel Mailed : " & aDate, textStyle:=lineStyle)
                bandText.Paddings.All = 5
                bandText.Style.Font.Size = 4
            End If
            aDate = "12:00:00"
            If Not HarassmentFormData.CeaseAndDesistNoticeMailDate Is Nothing Then
                aDate = HarassmentFormData.CeaseAndDesistNoticeMailDate
                If aDate <> "" Then
                    aDate = FormatDateTime(aDate, DateFormat.ShortDate)
                End If
                bandText = obj.addBandText(band, "Cease & Desist Notice Mailed : " & aDate, textStyle:=lineStyle)
                bandText.Paddings.All = 5
            End If
            aDate = "12:00:00"
            If HarassmentFormData.CreditorAddedUnAuthorizedCharges = True Then
                bandText = band.AddText()
                bandText = obj.addBandText(band, "Creditor added interest, fees or charges not authorized in the original agreement or by state law.", textStyle:=lineStyle)
            End If

            Return rpt
        Catch ex As Exception
            Throw ex
        Finally
            obj = Nothing
        End Try
    End Function
    Private Shared Function CreateMatterForHarassment(ByVal CreditorAccountID As Integer, _
                                                      ByVal dataClientID As Integer, _
                                                      ByVal CurrentUserID As Integer) As Integer

        Dim attID As String = SqlHelper.ExecuteScalar(String.Format("SELECT isnull(a.AttorneyId,-1)[AttorneyId] FROM tblClient c with(nolock) " & _
                                                                     "Inner Join tblPerson p with(nolock) ON c.PrimaryPersonId = p.PersonId " & _
                                                                     "Inner Join tblState s with(nolock) ON s.StateId = p.StateId " & _
                                                                     "left Join tblCompanyStatePrimary a with(nolock) ON a.CompanyId = c.CompanyId " & _
                                                                     "And s.Abbreviation = a.State Where c.ClientId = {0}", dataClientID), CommandType.Text)
        'insert matter
        Dim currentMatterID As Integer = -1
        Dim NewMatterID As Double = SqlHelper.ExecuteScalar("SELECT max(MatterId)+1 FROM tblMatter with(nolock)", CommandType.Text)
        Dim sqlMatter As String = "INSERT INTO tblMatter(ClientId, MatterStatusCodeId, MatterNumber,MatterDate, MatterMemo, CreatedDateTime, CreatedBy, " & _
        "CreditorInstanceId, AttorneyId, MatterTypeId, IsDeleted, MatterStatusId, MatterSubStatusId) VALUES ("
        sqlMatter += String.Format("{0},3,{1},", dataClientID, FormatNumber(NewMatterID, 0, TriState.False, TriState.False, TriState.False))
        sqlMatter += String.Format("'{0}','Generating a matter for the harassment','{0}',{1},", Now, CurrentUserID)
        sqlMatter += String.Format("{0},{1},1,0,3,14); select SCOPE_IDENTITY();", AccountHelper.GetCurrentCreditorInstanceID(CreditorAccountID), attID)
        currentMatterID = SqlHelper.ExecuteScalar(sqlMatter, CommandType.Text)
        SqlHelper.ExecuteNonQuery(String.Format("UPDATE tblmatter SET matternumber = matterid where matterid = {0}", currentMatterID), CommandType.Text)

        'insert note
        Dim username As String = UserHelper.GetName(CurrentUserID)
        Dim CreditorName As String = AccountHelper.GetCreditorName(CreditorAccountID)
        Dim sNote As String = String.Format("Generated a matter for the harassment with {0} by {1} on {2}", CreditorName, username, Now)
        Dim noteID As Integer = NoteHelper.InsertNote(sNote, CurrentUserID, dataClientID)
        NoteHelper.RelateNote(noteID, 1, dataClientID)
        NoteHelper.RelateNote(noteID, 2, CreditorAccountID)
        NoteHelper.RelateNote(noteID, 19, currentMatterID)

        InsertTasksForHarassmentMatter(dataClientID, "Abuse Intake Form Created", currentMatterID, CurrentUserID)

        Return currentMatterID
    End Function
    Private Shared Function InsertTasksForHarassmentMatter(ByVal dataClientid As Integer, ByVal TaskTypeText As String, ByVal currentMatterID As Integer, _
                                                        ByVal CurrentUserID As Integer) As Integer
        Dim TaskTypeId As Integer = DataHelper.FieldLookupIDs("tblTaskType", "TaskTypeId", String.Format("[Name] = '{0}'", TaskTypeText))(0)

        'insert task for matter
        Dim sqlTask As String = "INSERT INTO tblTask(TaskTypeId, [Description], Due, TaskResolutionId, Created,CreatedBy, LastModified, LastModifiedBy, AssignedTo,matterid) VALUES("
        sqlTask += String.Format("{0},'{1}','{2}',", TaskTypeId, TaskTypeText, Now.ToString)
        sqlTask += String.Format("NULL,getdate(),{0},getdate(),{0},0,{1}); select SCOPE_IDENTITY();", CurrentUserID, currentMatterID)
        Dim newTaskID As Integer = SqlHelper.ExecuteScalar(sqlTask, CommandType.Text)

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
    Public Sub SaveForm(ByVal HarassmentFormData As Harassment)
        Dim obj As New HarassmentHelper

        Try
            'insert client info
            Dim subID As Integer = obj.insertSubmission(HarassmentFormData.DataClientID, HarassmentFormData.ClientPersonID, HarassmentFormData.ClientAccountNumber, _
                                    HarassmentFormData.CardHolderState, HarassmentFormData.OriginalCreditorID, HarassmentFormData.BeingSuedByCreditor, _
                                    HarassmentFormData.DebtCollectorID, HarassmentFormData.CreatedBy, HarassmentFormData.IndividualCallingName, _
                                    HarassmentFormData.IndividualCallingIdentity, HarassmentFormData.IndividualCallingPhone, HarassmentFormData.IndividualCallingNumberDialed, HarassmentFormData.IndividualCallingDateOfCall, _
                                    HarassmentFormData.IndividualCallingNumTimesCalled, HarassmentFormData.IndividualCallingTimeOfCall, HarassmentFormData.OriginalNoticeOfRepresentationMailDate, _
                                    HarassmentFormData.CeaseAndDesistNoticeMailDate, HarassmentFormData.CreditorAddedUnAuthorizedCharges, _
                                    HarassmentFormData.CreditorAccountID, HarassmentFormData.AbuseBeginDate, HarassmentFormData.EstNumberDailyCalls, _
                                    HarassmentFormData.DocumentID)

            'insert harassment info
            obj.insertReason(subID, "32", 0, "32", HarassmentFormData.DescribeCreditorContact)

            'insert roadmap step
            'and create matter
            Dim mid As Integer = CreateMatterForHarassment(HarassmentFormData.CreditorAccountID, HarassmentFormData.DataClientID, HarassmentFormData.CreatedBy)
            Dim ssql As String = "INSERT INTO [tblHarassmentRoadmap]([ClientSubmissionID],[HarassmentStatus],matterid,[Created],[CreatedBy]) "
            ssql += String.Format("VALUES ({0},{1},{2},getdate(),{3})", subID, 86, mid, HarassmentFormData.CreatedBy)
            SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)

            Dim clientEmail As String = SqlHelper.ExecuteScalar(String.Format("Select isnull(emailaddress,'')[Email] from tblperson where clientid = {0}", HarassmentFormData.DataClientID), CommandType.Text)
            If Not String.IsNullOrEmpty(clientEmail) Then

                Dim et As EmailHelper.EmailTemplate = EmailHelper.GetEmailTemplateByUniqueCallingID("ABUSE", 86)
                Dim CreditorName As String = AccountHelper.GetCreditorName(HarassmentFormData.CreditorAccountID)
                Dim sBody As String = et.TemplateText
                sBody = sBody.Replace("(merge account)", CreditorName)
                EmailHelper.SendMessage("harassment@lexxiom.com", clientEmail, "Abuse Intake Form Created", sBody)
            End If

            If HarassmentFormData.ReasonData.Count > 0 Then
                For Each h As HarassmentReason In HarassmentFormData.ReasonData
                    If h.ReasonValue.ToString <> "" Then
                        obj.insertReason(subID, HarassmentFormData.ReasonHeaderID, 0, h.ReasonID, IIf(h.ReasonText.ToString = "", "", h.ReasonText & " - ") & h.ReasonValue)
                    Else
                        obj.insertReason(subID, HarassmentFormData.ReasonHeaderID, 0, HarassmentFormData.ReasonHeaderID, HarassmentFormData.ReasonHeaderText)
                    End If
                Next
            Else
                obj.insertReason(subID, HarassmentFormData.ReasonHeaderID, 0, HarassmentFormData.ReasonHeaderID, HarassmentFormData.ReasonHeaderText)
            End If

            If HarassmentFormData.AdditionalReasonData.Count > 0 Then
                For Each h As HarassmentReason In HarassmentFormData.AdditionalReasonData
                    Dim fIDs As String() = h.FieldID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                    If fIDs.Length = 2 Then
                        Dim strHeaderText As String = ""
                        If h.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries).Length > 1 Then
                            For Each sv2 As String In h.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                                If Not sv2.Contains("What Happened") Then
                                    strHeaderText += sv2 & vbCrLf
                                End If
                            Next
                            obj.insertReason(subID, h.ReasonID, 0, fIDs(0), strHeaderText)
                        Else
                            'no sub values
                            strHeaderText = h.ReasonValue.Replace("|", "")
                            obj.insertReason(subID, h.ReasonID, 0, fIDs(0), strHeaderText)
                        End If
                    End If
                Next

            End If

        Catch ex As Exception
            Throw ex
        Finally
            obj = Nothing
        End Try
    End Sub

    Public Function getReasonParentIDByText(ByVal reasonText As String, Optional ByVal reasonLevel As Integer = 0) As Integer
        Dim sqlSearch As String = "select reasonheaderid from dbo.tblHarassmentReasons where reason like '" & reasonText.Replace("'", "''") & "%'"
        If reasonLevel <> 0 Then
            sqlSearch += " AND ReasonLevel = " & reasonLevel
        End If

        Dim rID As Integer = executeScalar(sqlSearch, System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)

        Return rID
    End Function

    Public Sub insertReason(ByVal SubmissionID As Integer, ByVal headerID As String, ByVal reasonTypeID As Integer, ByVal reasonID As String, ByVal reasonData As String)
        Dim cmd As New SqlCommand
        Try
            cmd.Parameters.Clear()
            Dim cmdText As String = "INSERT INTO [tblHarassmentData]([ClientSubmissionID],[HeaderID],[ReasonTypeID],[ReasonID],[ReasonData])" & _
                "VALUES (@ClientSubmissionID,@HeaderID,@ReasonTypeID,@ReasonID,@ReasonData)"

            cmd.CommandText = cmdText
            cmd.Parameters.Add(New SqlParameter("ClientSubmissionID", SubmissionID))
            cmd.Parameters.Add(New SqlParameter("HeaderID", headerID))
            cmd.Parameters.Add(New SqlParameter("ReasonTypeID", reasonTypeID))
            cmd.Parameters.Add(New SqlParameter("ReasonID", reasonID))
            cmd.Parameters.Add(New SqlParameter("ReasonData", reasonData.Replace("'", "''").Replace(vbLf, "").Replace(vbCr, "").Replace(vbCrLf, "").Replace(vbTab, "").Replace(Environment.NewLine, "")))

            cmd.Connection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Sub

    Public Function insertSubmission(ByVal DataClientID As String, ByVal ClientPersonID As Integer, ByVal ClientAccountNumber As String, _
        ByVal CardHolderState As String, ByVal OriginalCreditorID As Integer, _
        ByVal BeingSuedByCreditor As String, ByVal DebtCollectorID As Integer, _
        ByVal CreatedBy As Integer, ByVal IndividualCallingName As String, _
        ByVal IndividualCallingIdentity As List(Of String), ByVal IndividualCallingPhone As String, ByVal IndividualCallingNumberDialed As String, _
        ByVal IndividualCallingDateOfCall As String, ByVal IndividualCallingNumTimesCalled As String, _
        ByVal IndividualCallingTimeOfCall As String, ByVal OriginalNoticeOfRepresentationMailDate As String, _
        ByVal CeaseAndDesistNoticeMailDate As String, ByVal CreditorAddedUnAuthorizedCharges As String, ByVal creditorAcctID As Integer, _
        ByVal DateAbuseBegan As String, ByVal EstimateNumberOfDailyCalls As Integer, ByVal documentID As String) As Integer
        Dim cmd As New SqlCommand
        Dim intID As Integer = 0
        Try
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_Harassment_InsertSubmission"
            cmd.Parameters.Add(New SqlParameter("ClientID", DataClientID))
            cmd.Parameters.Add(New SqlParameter("PersonID", ClientPersonID))
            cmd.Parameters.Add(New SqlParameter("ClientAccountNumber", ClientAccountNumber))
            cmd.Parameters.Add(New SqlParameter("ClientState", CardHolderState))
            cmd.Parameters.Add(New SqlParameter("OriginalCreditorID", OriginalCreditorID))
            cmd.Parameters.Add(New SqlParameter("SuedByCreditor", BeingSuedByCreditor))
            cmd.Parameters.Add(New SqlParameter("CurrentCreditorID", DebtCollectorID))
            cmd.Parameters.Add(New SqlParameter("CreatedBy", CreatedBy))
            'cmd.Parameters.Add(New SqlParameter("Method", DBNull.Value))
            cmd.Parameters.Add(New SqlParameter("IndividualCallingName", IndividualCallingName))

            If IndividualCallingIdentity.Count > 0 Then
                cmd.Parameters.Add(New SqlParameter("IndividualCallingIdentity", Join(IndividualCallingIdentity.ToArray(), "|")))
            Else
                cmd.Parameters.Add(New SqlParameter("IndividualCallingIdentity", DBNull.Value))
            End If

            cmd.Parameters.Add(New SqlParameter("IndividualCallingPhone", IndividualCallingPhone))
            cmd.Parameters.Add(New SqlParameter("IndividualCallingNumberDialed", IndividualCallingNumberDialed))
            cmd.Parameters.Add(New SqlParameter("IndividualCallingDateOfCall", IndividualCallingDateOfCall))
            cmd.Parameters.Add(New SqlParameter("IndividualCallingNumTimesCalled", IndividualCallingNumTimesCalled))
            cmd.Parameters.Add(New SqlParameter("IndividualCallingTimeOfCall", IndividualCallingTimeOfCall))
            cmd.Parameters.Add(New SqlParameter("AbuseBeginDate", IIf(DateAbuseBegan = "", DBNull.Value, DateAbuseBegan)))
            cmd.Parameters.Add(New SqlParameter("EstNumberDailyCalls", EstimateNumberOfDailyCalls))

            cmd.Parameters.Add(New SqlParameter("NoticeOfRepMailDate", IIf(OriginalNoticeOfRepresentationMailDate = "", DBNull.Value, OriginalNoticeOfRepresentationMailDate)))
            cmd.Parameters.Add(New SqlParameter("NoticeOfCeaseAndDesist", IIf(CeaseAndDesistNoticeMailDate = "", DBNull.Value, CeaseAndDesistNoticeMailDate)))
            cmd.Parameters.Add(New SqlParameter("CreditorUnAuthorizedCharges", CreditorAddedUnAuthorizedCharges))
            cmd.Parameters.Add(New SqlParameter("CreditorAcctID", creditorAcctID))
            cmd.Parameters.Add(New SqlParameter("documentID", documentID))

            cmd.Connection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            intID = cmd.ExecuteScalar()
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return intID
    End Function

    Private Function addBandGrid(ByVal bandToAdd As Infragistics.Documents.Report.Band.IBand, ByVal rdata As List(Of HarassmentReason)) As Infragistics.Documents.Report.Grid.IGrid
        Dim lineStyle As New Style(New Font("Verdana", 10, FontStyle.Regular), Brushes.Black)

        ' Create the grid and apply the GridPattern
        Dim bandgrid As Infragistics.Documents.Report.Grid.IGrid = bandToAdd.AddGrid()
        bandgrid.Paddings.Left = 55

        ' Declare a Row, and Cell object
        ' for object creation.
        Dim gridRow As Infragistics.Documents.Report.Grid.IGridRow
        Dim gridCell As Infragistics.Documents.Report.Grid.IGridCell

        bandgrid.AddColumn()

        Dim lstCheck As New List(Of String) 'holds existing headers
        Dim intIndentLevel As Integer = 10

        For Each r As HarassmentReason In rdata

            Dim tableCellText As IText
            'add header
            If lstCheck.Contains(r.ReasonText) = False Then
                If r.ReasonText <> "" Then
                    gridRow = bandgrid.AddRow()
                    gridCell = gridRow.AddCell()
                    tableCellText = gridCell.AddText()
                    tableCellText.Alignment = New TextAlignment(Alignment.Left, Alignment.Middle)
                    'hack for sublevel indent
                    If r.ReasonText.Split().Length > 2 Then
                        tableCellText.AddLeader(LeaderFormat.Dashes)
                        tableCellText.AddContent("* " & r.ReasonText)
                    Else
                        tableCellText.AddContent(r.ReasonText, lineStyle)
                        tableCellText.Indents = New Infragistics.Documents.Report.Text.Indents(intIndentLevel + 10)
                    End If

                    lstCheck.Add(r.ReasonText)
                Else
                    If r.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries).Length > 1 Then
                        For Each rv As String In r.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                            gridRow = bandgrid.AddRow()
                            gridCell = gridRow.AddCell()
                            tableCellText = gridCell.AddText()
                            tableCellText.Alignment = New TextAlignment(Alignment.Left, Alignment.Middle)
                            tableCellText.AddContent("- " & rv, lineStyle)
                            tableCellText.Indents = New Infragistics.Documents.Report.Text.Indents(intIndentLevel + 30)
                        Next
                    Else
                        gridRow = bandgrid.AddRow()
                        gridCell = gridRow.AddCell()
                        tableCellText = gridCell.AddText()
                        tableCellText.Alignment = New TextAlignment(Alignment.Left, Alignment.Middle)
                        tableCellText.AddContent("- " & r.ReasonValue.Replace("|", ""), lineStyle)
                        tableCellText.Indents = New Infragistics.Documents.Report.Text.Indents(intIndentLevel + 30)
                    End If

                End If
            End If
            'add values
            If r.ReasonValue.ToString <> "" And r.ReasonText.ToString <> "" And r.ReasonValue.ToString.ToLower <> "<item>yes</item>" Then
                Dim addCheck As New List(Of String)
                For Each v As String In r.ReasonValue.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                    gridRow = bandgrid.AddRow()
                    gridCell = gridRow.AddCell()
                    tableCellText = gridCell.AddText()
                    tableCellText.Alignment = New TextAlignment(Alignment.Left, Alignment.Middle)
                    tableCellText.Indents = New Infragistics.Documents.Report.Text.Indents(5)
                    If addCheck.Contains(v) = False And lstCheck.Contains(v) = False Then
                        tableCellText.AddContent("- " & v, lineStyle)
                        tableCellText.Indents = New Infragistics.Documents.Report.Text.Indents(intIndentLevel + 20)
                        addCheck.Add(v)
                    End If
                Next
            End If

        Next

        Return bandgrid
    End Function

    Private Function addBandTable(ByVal bandToAdd As Infragistics.Documents.Report.Band.IBand, ByVal rdata As List(Of HarassmentReason), Optional ByVal headerText As String = Nothing) As Infragistics.Documents.Report.Table.ITable
        Dim bandtable As Infragistics.Documents.Report.Table.ITable = bandToAdd.AddTable()
        bandtable.Width = New RelativeWidth(100)
        bandtable.Margins.Left = 15
        Dim bAdded As Boolean = False

        For Each r As HarassmentReason In rdata
            If r.ReasonText <> headerText And bAdded = False Then
                Dim tableRow As Infragistics.Documents.Report.Table.ITableRow
                Dim tableCell As Infragistics.Documents.Report.Table.ITableCell

                tableRow = bandtable.AddRow()

                tableCell = tableRow.AddCell()
                tableCell.Width = New RelativeWidth(100)

                Dim tableCellText As IText = tableCell.AddText()
                tableCellText.Alignment = New TextAlignment(Alignment.Right, Alignment.Middle)
                tableCellText.AddContent(r.ReasonText)
                bAdded = True
            End If
            If r.ReasonValue.ToString <> headerText And r.ReasonValue.ToString.ToLower <> "<item>yes</item>" Then
                Dim tableRow As Infragistics.Documents.Report.Table.ITableRow
                Dim tableCell As Infragistics.Documents.Report.Table.ITableCell

                tableRow = bandtable.AddRow()

                tableCell = tableRow.AddCell()
                tableCell.Width = New RelativeWidth(15)
                Dim tableCellText As IText = tableCell.AddText()
                tableCellText.Alignment = New TextAlignment(Alignment.Right, Alignment.Middle)
                tableCellText.AddContent("")

                tableCell = tableRow.AddCell()
                tableCell.Width = New RelativeWidth(85)
                tableCellText = tableCell.AddText()
                tableCellText.Alignment = New TextAlignment(Alignment.Left, Alignment.Middle)

                tableCellText.AddContent(r.ReasonValue)
                tableCellText.Indents = New Infragistics.Documents.Report.Text.Indents(20)

            End If
        Next
        Return bandtable
    End Function

    Private Function addBandText(ByVal AddToBand As Infragistics.Documents.Report.Band.IBand, _
        ByVal bandText As String, Optional ByVal bandTop As Integer = 5, _
        Optional ByVal bandLeft As Integer = 0, Optional ByVal textStyle As Infragistics.Documents.Report.Text.Style = Nothing) As Infragistics.Documents.Report.Text.IText
        Dim bandTxt As Infragistics.Documents.Report.Text.IText

        bandTxt = AddToBand.AddText()
        If textStyle Is Nothing Then
            bandTxt.AddContent(bandText)
        Else
            bandTxt.AddContent(bandText, textStyle)
        End If

        bandTxt.Indents = New Infragistics.Documents.Report.Text.Indents(20)
        bandTxt.Paddings.Top = bandTop
        bandTxt.Paddings.Bottom = 5
        If bandLeft <> 0 Then
            bandTxt.Margins.Left = bandLeft
        End If

        Return bandTxt
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Class Harassment
        Implements IDisposable

#Region "Fields"

        Private _AbuseBeginDate As String
        Private _BeingSuedByCreditor As Boolean
        Private _CardHoldersName As String
        Private _CeaseAndDesist As String
        Private _ClientAcctNumber As String
        Private _ClientID As Integer
        Private _DebtCollectorID As String
        Private _DebtCollectorName As String
        Private _DescribeCreditorContact As String
        Private _DocumentID As String
        Private _EstNumberDailyCalls As String
        Private _NoticeOfRep As String
        Private _OriginalCreditorID As String
        Private _OriginalCreditorName As String
        Private _PersonID As Integer
        Private _State As String
        Private _accountID As Integer
        Private _additionalReasonData As List(Of HarassmentReason)
        Private _createdBy As Integer
        Private _creditorUnAuthCharges As Boolean
        Private _individualCallingDateOfCall As String
        Private _individualCallingIdentity As List(Of String)
        Private _individualCallingName As String
        Private _individualCallingNumTimesCalled As Integer
        Private _individualCallingNumberDialed As String
        Private _individualCallingPhone As String
        Private _individualCallingTimeOfCall As String
        Private _reasonData As List(Of HarassmentReason)
        Private _reasonID As String
        Private _reasonText As String
        Private disposedValue As Boolean = False 'To detect redundant calls

#End Region 'Fields

#Region "Constructors"

        Sub New(ByVal DataClientID As Integer, ByVal ClientAcctNumber As String, ByVal PersonID As Integer, _
            ByVal ClientState As String, ByVal OriginalCreditorID As String, _
            ByVal BeingSuedByCreditor As Boolean, ByVal DebtCollectorID As String, ByVal CreatedBy As Integer, _
            Optional ByVal ReasonId As String = "NONE", Optional ByVal ReasonData As List(Of HarassmentReason) = Nothing, Optional ByVal DocID As String = Nothing)
            _ClientID = DataClientID
            _ClientAcctNumber = ClientAcctNumber
            _PersonID = PersonID
            _State = ClientState
            _OriginalCreditorID = OriginalCreditorID
            _BeingSuedByCreditor = BeingSuedByCreditor
            _DebtCollectorID = DebtCollectorID
            _createdBy = CreatedBy
            _reasonID = ReasonId
            _reasonData = ReasonData
            _DocumentID = DocID
        End Sub

        Sub New()
        End Sub

#End Region 'Constructors

#Region "Properties"

        Public Property AbuseBeginDate() As String
            Get
                Return _AbuseBeginDate
            End Get
            Set(ByVal value As String)
                _AbuseBeginDate = value
            End Set
        End Property

        Public Property AdditionalReasonData() As List(Of HarassmentReason)
            Get
                Return Me._additionalReasonData
            End Get
            Set(ByVal value As List(Of HarassmentReason))
                Me._additionalReasonData = value
            End Set
        End Property

        Public Property BeingSuedByCreditor() As Boolean
            Get
                Return Me._BeingSuedByCreditor
            End Get
            Set(ByVal value As Boolean)
                Me._BeingSuedByCreditor = value
            End Set
        End Property

        Public Property CardHolderState() As String
            Get
                Return Me._State
            End Get
            Set(ByVal value As String)
                Me._State = value
            End Set
        End Property

        Public Property CardHoldersName() As String
            Get
                Return Me._CardHoldersName
            End Get
            Set(ByVal value As String)
                Me._CardHoldersName = value
            End Set
        End Property

        Public Property CeaseAndDesistNoticeMailDate() As String
            Get
                Return Me._CeaseAndDesist
            End Get
            Set(ByVal value As String)
                Me._CeaseAndDesist = value
            End Set
        End Property

        Public Property ClientAccountNumber() As String
            Get
                Return Me._ClientAcctNumber
            End Get
            Set(ByVal value As String)
                Me._ClientAcctNumber = value
            End Set
        End Property

        Public Property ClientPersonID() As Integer
            Get
                Return Me._PersonID
            End Get
            Set(ByVal value As Integer)
                Me._PersonID = value
            End Set
        End Property

        Public Property CreatedBy() As Integer
            Get
                Return Me._createdBy
            End Get
            Set(ByVal value As Integer)
                Me._createdBy = value
            End Set
        End Property

        Public Property CreditorAccountID() As Integer
            Get
                Return _accountID
            End Get
            Set(ByVal value As Integer)
                _accountID = value
            End Set
        End Property

        Public Property CreditorAddedUnAuthorizedCharges() As Boolean
            Get
                Return Me._creditorUnAuthCharges
            End Get
            Set(ByVal value As Boolean)
                Me._creditorUnAuthCharges = value
            End Set
        End Property

        Public Property DataClientID() As Integer
            Get
                Return Me._ClientID
            End Get
            Set(ByVal value As Integer)
                Me._ClientID = value
            End Set
        End Property

        Public Property DebtCollectorID() As String
            Get
                Return Me._DebtCollectorID
            End Get
            Set(ByVal value As String)
                Me._DebtCollectorID = value
            End Set
        End Property

        Public Property DebtCollectorName() As String
            Get
                Return Me._DebtCollectorName
            End Get
            Set(ByVal value As String)
                Me._DebtCollectorName = value
            End Set
        End Property

        Public Property DescribeCreditorContact() As String
            Get
                Return _DescribeCreditorContact
            End Get
            Set(ByVal value As String)
                _DescribeCreditorContact = value
            End Set
        End Property

        Public Property DocumentID() As String
            Get
                Return Me._DocumentID
            End Get
            Set(ByVal value As String)
                Me._DocumentID = value
            End Set
        End Property

        Public Property EstNumberDailyCalls() As String
            Get
                Return _EstNumberDailyCalls
            End Get
            Set(ByVal value As String)
                _EstNumberDailyCalls = value
            End Set
        End Property

        Public Property IndividualCallingDateOfCall() As String
            Get
                Return _individualCallingDateOfCall
            End Get
            Set(ByVal value As String)
                _individualCallingDateOfCall = value

            End Set
        End Property

        Public Property IndividualCallingIdentity() As List(Of String)
            Get
                Return _individualCallingIdentity
            End Get
            Set(ByVal value As List(Of String))
                _individualCallingIdentity = value
            End Set
        End Property

        Public Property IndividualCallingName() As String
            Get
                Return _individualCallingName
            End Get
            Set(ByVal value As String)
                _individualCallingName = value
            End Set
        End Property

        Public Property IndividualCallingNumTimesCalled() As Integer
            Get
                Return _individualCallingNumTimesCalled
            End Get
            Set(ByVal value As Integer)
                _individualCallingNumTimesCalled = value
            End Set
        End Property

        Public Property IndividualCallingNumberDialed() As String
            Get
                Return _individualCallingNumberDialed
            End Get
            Set(ByVal value As String)
                _individualCallingNumberDialed = value
            End Set
        End Property

        Public Property IndividualCallingPhone() As String
            Get
                Return _individualCallingPhone
            End Get
            Set(ByVal value As String)
                _individualCallingPhone = value
            End Set
        End Property

        Public Property IndividualCallingTimeOfCall() As String
            Get
                Return _individualCallingTimeOfCall
            End Get
            Set(ByVal value As String)
                _individualCallingTimeOfCall = value
            End Set
        End Property

        Public Property OriginalCreditorID() As String
            Get
                Return Me._OriginalCreditorID
            End Get
            Set(ByVal value As String)
                Me._OriginalCreditorID = value
            End Set
        End Property

        Public Property OriginalCreditorName() As String
            Get
                Return Me._OriginalCreditorName
            End Get
            Set(ByVal value As String)
                Me._OriginalCreditorName = value
            End Set
        End Property

        Public Property OriginalNoticeOfRepresentationMailDate() As String
            Get
                Return Me._NoticeOfRep
            End Get
            Set(ByVal value As String)
                Me._NoticeOfRep = value
            End Set
        End Property

        Public Property ReasonData() As List(Of HarassmentReason)
            Get
                Return Me._reasonData
            End Get
            Set(ByVal value As List(Of HarassmentReason))
                Me._reasonData = value
            End Set
        End Property

        Public Property ReasonHeaderID() As String
            Get
                Return _reasonID
            End Get
            Set(ByVal value As String)
                _reasonID = value
            End Set
        End Property

        Public Property ReasonHeaderText() As String
            Get
                Return _reasonText
            End Get
            Set(ByVal value As String)
                _reasonText = value
            End Set
        End Property

#End Region 'Properties

#Region "Methods"

        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: free other state (managed objects).
                End If

                ' TODO: free your own state (unmanaged objects).
                ' TODO: set large fields to null.
            End If
            Me.disposedValue = True
        End Sub

#End Region 'Methods

    End Class

    Public Class HarassmentReason

#Region "Fields"

        Private _ReasonID As Integer
        Private _ReasonText As String
        Private _ReasonValue As String
        Private _reasonFieldID As String

#End Region 'Fields

#Region "Constructors"

        Sub New(ByVal ReasonID As String, ByVal ReasonText As String, ByVal ReasonValue As String, ByVal FieldID As String)
            Me._ReasonID = ReasonID
            Me._ReasonText = ReasonText
            Me._ReasonValue = ReasonValue
            Me._reasonFieldID = FieldID
        End Sub

#End Region 'Constructors

#Region "Properties"

        Public Property FieldID() As String
            Get
                Return _reasonFieldID
            End Get
            Set(ByVal value As String)
                _reasonFieldID = value
            End Set
        End Property

        Public Property ReasonID() As Integer
            Get
                Return Me._ReasonID
            End Get
            Set(ByVal value As Integer)
                Me._ReasonID = value
            End Set
        End Property

        Public Property ReasonText() As String
            Get
                Return Me._ReasonText
            End Get
            Set(ByVal value As String)
                Me._ReasonText = value
            End Set
        End Property

        Public Property ReasonValue() As String
            Get
                Return Me._ReasonValue
            End Get
            Set(ByVal value As String)
                Me._ReasonValue = value
            End Set
        End Property

#End Region 'Properties

    End Class

    Public Class harassmentSubmision

#Region "Fields"

        Private _ColumnSuffix As String
        Private _FieldID As Integer
        Private _SubmissionID As Integer
        Private _fieldPivotSortOrder As String
        Private _formID As Integer
        Private _pivotID As String
        Private _value As String
        Private _valueType As String

#End Region 'Fields

#Region "Constructors"

        Sub New(ByVal SubmissionID As Integer, ByVal FieldID As Integer, ByVal ColumnSuffix As String, ByVal pivotID As String, ByVal Fieldvalue As String, ByVal FieldValueType As String, ByVal FormID As Integer, ByVal FieldPivotSortOrder As String)
            _SubmissionID = SubmissionID
            _FieldID = FieldID
            _ColumnSuffix = ColumnSuffix
            _pivotID = pivotID
            _value = Fieldvalue
            _valueType = FieldValueType
            _formID = FormID
            _fieldPivotSortOrder = FieldPivotSortOrder
        End Sub

#End Region 'Constructors

#Region "Properties"

        Public Property ColumnSuffix() As String
            Get
                Return _ColumnSuffix
            End Get
            Set(ByVal value As String)
                _ColumnSuffix = value
            End Set
        End Property

        Public Property FieldID() As Integer
            Get
                Return _FieldID
            End Get
            Set(ByVal value As Integer)
                _FieldID = value
            End Set
        End Property

        Public Property FieldPivotSortOrder() As Integer
            Get
                Return _fieldPivotSortOrder
            End Get
            Set(ByVal value As Integer)
                _fieldPivotSortOrder = value
            End Set
        End Property

        Public Property FieldValue() As String
            Get
                Return _value
            End Get
            Set(ByVal value As String)
                _value = value
            End Set
        End Property

        Public Property FieldValueType() As String
            Get
                Return _valueType
            End Get
            Set(ByVal value As String)
                _valueType = value
            End Set
        End Property

        Public Property FormID() As Integer
            Get
                Return _formID
            End Get
            Set(ByVal value As Integer)
                _formID = value
            End Set
        End Property

        Public Property PivotID() As String
            Get
                Return _pivotID
            End Get
            Set(ByVal value As String)
                _pivotID = value
            End Set
        End Property

        Public Property SubmissionID() As Integer
            Get
                Return _SubmissionID
            End Get
            Set(ByVal value As Integer)
                _SubmissionID = value
            End Set
        End Property

#End Region 'Properties

    End Class

#End Region 'Nested Types

End Class