Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports ReportsHelper

Partial Class CustomTools_UserControls_AutoNoteWizardControl
    Inherits System.Web.UI.UserControl

    #Region "Fields"

    Private dtTemplates As Data.DataTable
    Private intNumOfActions As Integer
    Private ltrTemplate As LexxiomLetterTemplates.LetterTemplates
    Private noteTemplateList As New List(Of NoteTemplate)
    Private sSQL As String

    #End Region 'Fields

    #Region "Properties"

    Public Property DataClientID() As String
        Get
            Return ViewState("_dataClientID")
        End Get
        Set(ByVal value As String)
            ViewState("_dataClientID") = value
        End Set
    End Property

    Public Property UserID() As String
        Get
            Return ViewState("_UserID")
        End Get
        Set(ByVal value As String)
            ViewState("_UserID") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        BuildWizard()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        TurnOffCaching()
    End Sub

    Protected Sub wzNotes_ActiveStepChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles wzNotes.ActiveStepChanged
        'check if we are on the finish step
        If wzNotes.WizardSteps(wzNotes.ActiveStepIndex).StepType = WizardStepType.Finish Then
            'create textbox to hold samples of templates
            Dim lblNotes As New TextBox() With {.Enabled = False, .ID = "lblNotes", .TextMode = TextBoxMode.MultiLine, .Height = 350, .Width = 365}
            'loop thru templates
            For Each nt As NoteTemplate In noteTemplateList
                'loop thru variables for template
                If Not IsNothing(nt.NoteVariables) Then
                    For Each var As AutoNoteTextVariable In nt.NoteVariables
                        'find variable textbox to get value
                        Dim strVarValue As String = ""
                        Dim strControlName As String = ""
                        strControlName = nt.NoteTypeName & nt.WizardStep & "_" & var.VariableName.Replace(" ", "")
                        Select Case var.VariableType
                            Case "T"
                                Dim cValue As TextBox = CType(wzNotes.FindControl("txt" & strControlName), TextBox)
                                strVarValue = cValue.Text
                            Case "S"
                                Dim cValue As DropDownList = CType(wzNotes.FindControl("ddl" & strControlName), DropDownList)
                                strVarValue = cValue.SelectedItem.ToString
                            Case "D"
                                Dim cValue As AssistedSolutions.WebControls.InputMask = CType(wzNotes.FindControl("cal" & strControlName), AssistedSolutions.WebControls.InputMask)
                                strVarValue = cValue.Text.ToString
                        End Select
                        'replace variable in note text with variable text value
                        Dim fieldTxt As String = String.Format("\[{0}-{1}]", var.VariableID, var.VariableName)
                        nt.NoteText = Regex.Replace(nt.NoteText, fieldTxt, strVarValue.ToString.ToUpper, RegexOptions.IgnoreCase)
                    Next
                End If

                'add to txtbox
                lblNotes.Text += "---------------" & vbNewLine
                lblNotes.Text += nt.NoteTitle & " - Note Template" & vbNewLine
                lblNotes.Text += "---------------" & vbNewLine & vbNewLine
                lblNotes.Text += nt.NoteText.ToString & vbNewLine & vbNewLine
                lblNotes.Text += "*********************************"
            Next

            'add textbox to div container
            Dim tDiv As New HtmlGenericControl("DIV")
            tDiv.Style("text-align") = "center"
            tDiv.Style("width") = "100%"
            tDiv.Controls.Add(lblNotes)
            'add div to wizard step
            wzNotes.WizardSteps(wzNotes.WizardSteps.Count - 1).Controls.Add(tDiv)
        End If
    End Sub

    Protected Sub wzNotes_CancelButtonClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles wzNotes.CancelButtonClick
        Me.Parent.Page.ClientScript.RegisterStartupScript(Me.GetType(), "winclose", "<script>window.returnValue='false';window.close();</script>")
    End Sub

    Protected Sub wzNotes_FinishButtonClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.WizardNavigationEventArgs) Handles wzNotes.FinishButtonClick
        If IsNothing(Session("ReportNotesInfoObj")) Then
            Exit Sub
        End If
        Try
            Dim transerHash As New Hashtable
            Dim nInfo As Object = Session("ReportNotesInfoObj")

            For Each nt As NoteTemplate In noteTemplateList

                If Not IsNothing(nt.NoteVariables) Then
                    'loop thru variables for template
                    For Each var As AutoNoteTextVariable In nt.NoteVariables
                        'find variable textbox to get value
                        Dim strVarValue As String = ""
                        Dim strControlName As String = ""
                        strControlName = nt.NoteTypeName & nt.WizardStep & "_" & var.VariableName.Replace(" ", "")
                        Select Case var.VariableType
                            Case "T"
                                Dim cValue As TextBox = CType(wzNotes.FindControl("txt" & strControlName), TextBox)
                                strVarValue = cValue.Text
                            Case "S"
                                Dim cValue As DropDownList = CType(wzNotes.FindControl("ddl" & strControlName), DropDownList)
                                strVarValue = cValue.SelectedItem.ToString
                            Case "D"
                                Dim cValue As AssistedSolutions.WebControls.InputMask = CType(wzNotes.FindControl("cal" & strControlName), AssistedSolutions.WebControls.InputMask)
                                strVarValue = cValue.Text.ToString
                        End Select
                        'replace variable in note text with variable text value
                        Dim fieldTxt As String = String.Format("\[{0}-{1}]", var.VariableID, var.VariableName)
                        nt.NoteText = Regex.Replace(nt.NoteText, fieldTxt, strVarValue.ToString.ToUpper, RegexOptions.IgnoreCase)
                    Next
                End If

                Dim charSeparators() As Char = {";"c}
                'insert note
                Dim intNoteID As Integer = NoteHelper.InsertNote(nt.NoteText, UserID, DataClientID)

                'attach documents to note
                For Each rInfo As Object In nInfo

                    If nt.NoteTypeName = rInfo.ReportTypeName Then
                        Select Case rInfo.ReportType.ToString.ToLower
                            Case "client"
                                'relate note to client
                                NoteHelper.RelateNote(intNoteID, 1, DataClientID)
                                'attach client copy of letter
                                SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(rInfo.ReportFilePath), UserID)
                            Case "creditor"
                                'transer package
                                If rInfo.ReportTypeName.ToString.ToLower = "TransferLetterOfRepresentation".ToLower Then
                                    If Not transerHash.ContainsKey(rInfo.ReportFilePath) Then
                                        Try
                                            Dim credName As String = AccountHelper.GetCreditorName(rInfo.ReportCreditor)
                                            Dim ssql As String = String.Format("select right(accountnumber,4) from tblcreditorinstance where creditorinstanceid = {0}", AccountHelper.GetCurrentCreditorInstanceID(rInfo.ReportCreditor))
                                            Dim acctNum As String = SharedFunctions.AsyncDB.executeScalar(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)
                                            Dim credInfo As String = String.Format("{0} #{1}", credName, acctNum)

                                            NoteHelper.Delete(intNoteID, UserID)
                                            intNoteID = NoteHelper.InsertNote(String.Format("{0} : {1}", credInfo, nt.NoteText), UserID, DataClientID)

                                        Catch ex As Exception
                                            Continue For
                                        End Try

                                        'relate creditor to note
                                        NoteHelper.RelateNote(intNoteID, 2, rInfo.ReportCreditor)
                                        'attach creditor copy of letter
                                        SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(rInfo.ReportFilePath), UserID, rInfo.ReportFolderPath & "\")

                                        transerHash.Add(rInfo.ReportFilePath, Nothing)
                                        Exit For
                                    End If
                                Else
                                    'relate creditor to note
                                    NoteHelper.RelateNote(intNoteID, 2, rInfo.ReportCreditor)
                                    'attach creditor copy of letter
                                    SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(rInfo.ReportFilePath), UserID, rInfo.ReportFolderPath & "\")
                                End If

                            Case "package"
                                Select Case rInfo.ReportTypeName
                                    Case "ClientLetter"
                                    Case Else
                                        'relate note to client
                                        NoteHelper.RelateNote(intNoteID, 1, DataClientID)
                                        'attach client copy of letter
                                        SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(rInfo.ReportFilePath), UserID)
                                End Select

                        End Select
                    End If
                Next
            Next
        Catch ex As Exception
        Finally

            Me.Parent.Page.ClientScript.RegisterStartupScript(Me.GetType(), "winclose", "<script>window.returnValue='true';window.close();</script>")
        End Try
    End Sub

    Private Shared Sub RemoveBadReports(ByRef strQuery As String)
        strQuery = strQuery.Replace("chkClient|", "")
        strQuery = strQuery.Replace("chkCreditor|", "")
        strQuery = strQuery.Replace("chkPackage|", "")
        strQuery = strQuery.Replace("ClientInfoSheet|", "")
        strQuery = strQuery.Replace("ClientInfoSheetESP|", "")
        strQuery = strQuery.Replace("LetterOfRepresentationCopies|", "")
        strQuery = strQuery.Replace("LetterOfRepresentationOriginal|", "")
        strQuery = strQuery.Replace("LetterOfRepresentationCopiesESP|", "")
        strQuery = strQuery.Replace("LetterOfRepresentationOriginalESP|", "")
    End Sub

    Private Sub ActionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim objDDL As DropDownList = CType(sender, DropDownList)
    End Sub

    Private Sub BuildWizard()
        Dim strQuery As String = Request.QueryString("reports")
        Dim aReports() As String = Nothing
        Dim noteRow As TableRow
        Dim noteCell As TableCell

        'welcome package only has notes for 2 docs in package
        RemoveBadReports(strQuery)

        'get report typename and doctypeid
        aReports = strQuery.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)

        ltrTemplate = New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
        LoadData()

        Dim intStepCount As Integer = 0

        For Each s As String In aReports
            'split report string to get name, typeid, and arguments
            Dim reportData() As String = Nothing
            reportData = s.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)

            Dim reportType As String = reportData(0)
            Dim reportInfo As LexxiomLetterTemplates.LetterTemplates.ReportInfo = ltrTemplate.GetReportInfoByTypeName(reportType)
            Dim reportDocTypeID As String = ltrTemplate.GetDocTypeID(reportType)
            'create asp table
            Dim templateTable As New Table() With {.Width = 375, .CssClass = "wzTable"}
            Dim templateVariables As List(Of AutoNoteTextVariable) = GetVariables(reportInfo.ReportDocTypeID)

            'create header row
            templateTable.Rows.Add(CreateHdrRow)

            If templateVariables.Count > 0 Then
                For Each strVar As AutoNoteTextVariable In templateVariables
                    Dim variableName As String = StrConv(strVar.VariableName, VbStrConv.ProperCase)
                    Dim variableValue As String = strVar.VariableValue
                    Dim variableType As String = strVar.VariableType
                    Dim variableControlName As String = reportInfo.ReportTypeName & intStepCount & "_" & variableName.Replace(" ", "")

                    'add variable name to tablecell
                    noteRow = New TableRow
                    noteCell = New TableCell
                    noteCell.HorizontalAlign = HorizontalAlign.Left
                    noteCell.Text = variableName
                    noteRow.Cells.Add(noteCell)

                    noteCell = New TableCell
                    noteCell.HorizontalAlign = HorizontalAlign.Left
                    Select Case variableType
                        Case "T"
                            variableControlName = "txt" & variableControlName
                            Dim cText As New TextBox() With {.ID = variableControlName, .Width = 200}
                            noteCell.Controls.Add(cText)
                        Case "S"
                            variableControlName = "ddl" & variableControlName
                            Dim sValues() As String = variableValue.Split(",")
                            Dim ddlValues As New DropDownList() With {.ID = variableControlName, .Width = 200}
                            For Each sTemp As String In sValues
                                ddlValues.Items.Add(sTemp.ToUpper)
                            Next
                            noteCell.Controls.Add(ddlValues)
                        Case "D"
                            variableControlName = "cal" & variableControlName
                            Dim calValues As New AssistedSolutions.WebControls.InputMask() With {.Mask = "nn/nn/nnnn", .ID = variableControlName}
                            noteCell.Controls.Add(calValues)
                    End Select

                    Dim rFld As New RequiredFieldValidator() With {.ControlToValidate = variableControlName, .ID = "rfv_" & variableControlName, .Text = "*Required", .InitialValue = ""}
                    noteCell.Controls.Add(rFld)

                    noteRow.Cells.Add(noteCell)
                    templateTable.Rows.Add(noteRow)

                Next
                noteTemplateList.Add(New NoteTemplate(reportInfo.ReportDisplayName, reportInfo.ReportTypeName, templateVariables, GetTemplateText(reportInfo.ReportDocTypeID, "None"), intStepCount))
            Else
                If Not GetTemplateText(reportInfo.ReportDocTypeID, "None") = "" Then
                    noteTemplateList.Add(New NoteTemplate(reportInfo.ReportDisplayName, reportInfo.ReportTypeName, Nothing, GetTemplateText(reportInfo.ReportDocTypeID, "None"), intStepCount))
                End If
                templateTable.Controls.Add(CreateTableMsgRow("There are no variables for this note."))
            End If

            Dim wzStep As New WizardStep() With {.ID = "ws" & reportInfo.ReportTypeName & intStepCount, .Title = reportInfo.ReportDisplayName, .StepType = WizardStepType.Step}
            Dim tDiv As New HtmlGenericControl("DIV style=""text-align:center;width:100%;""")
            tDiv.Controls.Add(templateTable)
            wzStep.Controls.Add(tDiv)
            wzNotes.StepStyle.VerticalAlign = VerticalAlign.Top
            wzNotes.WizardSteps.AddAt(wzNotes.WizardSteps.Count - 1, wzStep)
            intStepCount += 1
        Next

        ltrTemplate.Dispose()
        ltrTemplate = Nothing
    End Sub

    Private Function CreateHdrRow() As TableRow
        'create header row
        Dim headerRow As New TableRow() With {.BackColor = System.Drawing.Color.AliceBlue, .Height = 35}

        Dim headerCell As TableCell = New TableCell() With {.Text = "Name", .HorizontalAlign = HorizontalAlign.Left}
        headerRow.Cells.Add(headerCell)

        Dim headerCellVal As New TableCell() With {.HorizontalAlign = HorizontalAlign.Left, .Text = "Value"}
        headerRow.Cells.Add(headerCellVal)

        Return headerRow
    End Function

    Private Function CreateTableMsgRow(ByVal strMsg As String) As TableRow
        Dim lblNone As New Label() With {.Text = strMsg}
        lblNone.Font.Size = 14

        Dim msgCell As TableCell = New TableCell() With {.HorizontalAlign = HorizontalAlign.Center, .ColumnSpan = 2}
        msgCell.Controls.Add(lblNone)

        Dim msgRow As New TableRow
        msgRow.Controls.Add(msgCell)

        Return msgRow
    End Function

    Private Function GetDocTitle(ByVal strTypeID As String) As String
        'get the displayname of the letter this note belongs to
        Try
            Dim fRows As Data.DataRow() = dtTemplates.Select("DocTypeID = '" & strTypeID & "'")
            Return fRows(0).Item(3).ToString

        Catch ex As Exception
            Return ""
        End Try
    End Function

    Private Function GetTemplateText(ByVal strTypeID As String, ByVal strActionText As String) As String
        'get template text based on doc type id and action
        Try
            Dim fRows As Data.DataRow() = dtTemplates.Select("DocTypeID = '" & strTypeID & "'")
            Dim strTemp As String = CType(fRows.GetValue(0), DataRow).Item("autonotetext").ToString

            strTemp = strTemp.Replace("<", "[")
            strTemp = strTemp.Replace(">", "]")
            Return strTemp

        Catch ex As Exception
            Return ""
        End Try
    End Function

    Private Function GetVariables(ByVal strTypeID As String) As List(Of AutoNoteTextVariable)
        DataClientID = Request.QueryString("id")
        Dim compID As Integer = SharedFunctions.AsyncDB.executeScalar(String.Format("select companyid from tblclient where clientid = '{0}'", DataClientID), ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim bodyText As String = SharedFunctions.AsyncDB.executeScalar(String.Format("select isnull(AutoNoteText,'')[AutoNoteText] from tblLetters where doctypeid = '{0}' and lettercompanyid = {1}", strTypeID, compID), ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim dVars As New List(Of AutoNoteTextVariable)
        For Each m As Match In extractVariablesFromText(bodyText)
            Dim var() As String = m.Value.Replace("[", "").Replace("]", "").Split(New Char() {"-"}, StringSplitOptions.RemoveEmptyEntries)
            Dim v As AutoNoteTextVariable = getVariableInfo(var(0))
            If Not dVars.Contains(v) Then
                dVars.Add(v)
            End If
        Next
        Return dVars
    End Function

    Private Sub LoadData()
        'load all note templates so we can cycle thru to get info based on docid
        sSQL = "select distinct l.doctypeid, dt.DisplayName, lettertype, autonotetext "
        sSQL += "from tblLetters l left outer join tblDocumentType AS dt ON l.DocTypeID = dt.TypeID where not autonotetext is null "
        sSQL += "order by LetterType"

        dtTemplates = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
    End Sub

    Private Sub TurnOffCaching()
        'stop the popup from caching
        Response.Cache.SetNoServerCaching()
        Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache)
        Response.Cache.SetNoStore()
        Response.Cache.SetExpires(New DateTime(1900, 1, 1, 0, 0, 0, 0))
        Response.AppendHeader("Pragma", "no-cache")
    End Sub

    Private Function extractVariablesFromText(ByVal bodyText As String) As MatchCollection
        Dim rx As New Regex("\[[^<]+?\]")
        Dim rm As MatchCollection
        If IsNothing(bodyText) Then
            rm = rx.Matches("")
        Else
            rm = rx.Matches(bodyText)
        End If

        Return rm
    End Function

    Private Function getVariableInfo(ByVal variableID As Integer) As AutoNoteTextVariable
        Dim sSQL As String = String.Format("select * from tblletters_variables where lettervariableid = {0}", variableID)
        Dim v As AutoNoteTextVariable = Nothing

        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each var As DataRow In dt.Rows
                v = New AutoNoteTextVariable(var("lettervariableid").ToString, var("variablename").ToString, var("variabletype").ToString, var("variablevalue").ToString)
                Exit For
            Next
        End Using

        Return v
    End Function

    #End Region 'Methods

  
   

End Class