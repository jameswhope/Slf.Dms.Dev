Option Explicit On
Imports LexxiomLetterTemplates
Imports AssistedSolutions.WebControls.InputMask

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Partial Class clients_client_reports_Default
    Inherits PermissionPage

#Region "Variables"
    Public UserID As Integer
	Public DataClientID As Integer
    Public oldWelcomePkg As String
    Public UName As String

    Private strSQLConnection As String = ""
    Private LexxiomReports As LexxiomLetterTemplates.LetterTemplates
    Private dicReportSentDates As Dictionary(Of String, String)

    Private strCreateDiv As String = "DIV runat=""server"" style=""width:103.5%;height:300px;overflow:auto"""

#End Region
#Region "Events"
    Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        '*******************************************************************
        'BUG ID: 560
        'Fixed By: Bereket S. Data
        'Validate Id before proceeding with subsequent operation.
        '*******************************************************************
        If ((Request.QueryString("id") Is Nothing) Or (IsNumeric(Request.QueryString("id")) = False)) Then
			DataClientID = -1
		Else
			DataClientID = Request.QueryString("id")
        End If

        If Not IsPostBack Then
            BuildReportInterface()
        End If
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UName = LetterTemplates.GetUserName(UserID)

        If Not IsPostBack Then

            '*******************************************************************
            'BUG ID: 560
            'Fixed By: Bereket S. Data
            'Validate Id before proceeding with subsequent operation.
            '*******************************************************************
            If ((Request.QueryString("id") Is Nothing) Or (IsNumeric(Request.QueryString("id")) = False)) Then
				DataClientID = -1
			Else
				DataClientID = Request.QueryString("id")
            End If

            SetRollups()
        End If

    End Sub
#End Region
#Region "Subs/Funcs"
    Private Function Unescape(ByVal Enc As String) As String
        For i As Long = 1 To Len(Enc)
            If Mid(Enc, i, 1) = "%" Then
                Enc = Replace(Enc, Mid(Enc, i, 3), Chr(Asc(Chr("&H" & Mid(Enc, i + 1, 2)))), 1, 1)
            End If
        Next

        Return Enc
    End Function
    Private Sub SetRollups()
        If Master.UserEdit Then
            Master.CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""PrintSelected();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>View Reports</a>")
        End If
    End Sub
    Private Sub GetOldPaths()
		Dim oldPath As String = CreateDirForClient(DataClientID) + "\ClientDocs\"
		Dim accountNo As String

		oldWelcomePkg = ""

		Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber FROM tblClient WHERE ClientID = " + DataClientID.ToString(), ConnectionFactory.Create())
			Using cmd.Connection
				cmd.Connection.Open()
				Using reader As SqlDataReader = cmd.ExecuteReader()
					reader.Read()
					accountNo = DatabaseHelper.Peel_string(reader, "AccountNumber")
				End Using
			End Using
		End Using

		For Each found As String In My.Computer.FileSystem.GetFiles(oldPath, Microsoft.VisualBasic.FileIO.SearchOption.SearchTopLevelOnly, accountNo + "_D4000K_*.pdf")
			If Not found = oldPath Then
				oldWelcomePkg = found
			End If
		Next

		oldWelcomePkg = oldWelcomePkg.Replace("\", "\\")
	End Sub
	Private Function CreateDirForClient(ByVal id As Integer) As String
		Dim rootDir As String
		Dim tempDir As String

		Using cmd As New SqlCommand("SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + id.ToString(), ConnectionFactory.Create())
			Using cmd.Connection
				cmd.Connection.Open()
				Using reader As SqlDataReader = cmd.ExecuteReader()
					reader.Read()
					rootDir = "\\" + DatabaseHelper.Peel_string(reader, "StorageServer") + "\" + DatabaseHelper.Peel_string(reader, "StorageRoot") + "\" + DatabaseHelper.Peel_string(reader, "AccountNumber") + "\"
				End Using

				If Not Directory.Exists(rootDir) Then
					Directory.CreateDirectory(rootDir)
				End If

				cmd.CommandText = "SELECT DISTINCT [Name] FROM tblDocFolder "

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						tempDir = rootDir + DatabaseHelper.Peel_string(reader, "Name")

						If Not Directory.Exists(tempDir) Then
							Directory.CreateDirectory(tempDir)
						End If
					End While
				End Using

				Dim strSQL As String = "SELECT CurrentCreditorInstanceID, AccountID, [Name], Original "
				strSQL += "FROM (SELECT a.CurrentCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original "
				strSQL += "FROM  tblAccount a INNER JOIN "
				strSQL += "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN "
				strSQL += "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN "
				strSQL += "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN "
				strSQL += "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID "
				strSQL += "WHERE (a.ClientID = " + id.ToString() + " And a.removed Is null) "
				strSQL += "UNION "
				strSQL += "SELECT a.OriginalCreditorInstanceID, a.AccountID, cr1.[Name], cr2.[Name] as Original "
				strSQL += "FROM  tblAccount a INNER JOIN "
				strSQL += "tblCreditorInstance c1 on a.OriginalCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN "
				strSQL += "tblCreditorInstance c2 on a.OriginalCreditorInstanceID = c2.CreditorInstanceID INNER JOIN "
				strSQL += "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN "
				strSQL += "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID "
				strSQL += "WHERE (a.ClientID = " + id.ToString() + " And a.removed Is null) "
				strSQL += ") as AllCreditors ORDER BY [Name] ASC "

				cmd.CommandText = strSQL

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						tempDir = reader.Item("AccountID").ToString() + "_" + reader.Item("Name").ToString() 'Regex.Replace("", "^[a-zA-Z0-9]+$", "", RegexOptions.IgnoreCase)
						tempDir = rootDir + "CreditorDocs\" + tempDir.Replace("*", "").Replace(".", "").Replace("""", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")

						If Not System.IO.Directory.Exists(tempDir) Then
							Directory.CreateDirectory(tempDir)
						End If
					End While
				End Using
			End Using
		End Using

		Return rootDir
	End Function
#End Region
#Region "String Format"
	Private Function FormatSelect(ByVal name As String, ByVal desc As String) As String
		If name.Length > 37 Then
			name = name.Substring(0, 37) + "..."
		End If

		desc = desc.Trim()

		Return name + RepeatString(" ", 49 - (name.Length + desc.Length)) + desc
	End Function
	Private Function RepeatString(ByVal str As String, ByVal count As Integer) As String
		Dim result As String = ""

		For i As Integer = 0 To count - 1
			result += str
		Next

		Return result
	End Function
	Private Function ConvertDateToString(ByVal dt As DateTime) As String
		Dim ext As String = "AM"
		Dim hour As String = dt.Hour.ToString().PadLeft(2, "0")

		If dt.Year.ToString() = "1900" Then
			Return ""
		End If

		If dt.Hour > 12 Then
			hour = CStr(dt.Hour - 12).PadLeft(2, "0")
			ext = "PM"
		End If

		Return dt.Month.ToString().PadLeft(2, "0") + dt.Day.ToString().PadLeft(2, "0") + dt.Year.ToString() + hour + dt.Minute.ToString().PadLeft(2, "0") + ext
	End Function
#End Region
#Region "Report Template Subs/Funcs"
	Private Sub BuildReportInterface()
		strSQLConnection = System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString

		LexxiomReports = New LexxiomLetterTemplates.LetterTemplates(strSQLConnection)

		Dim Reports As List(Of LetterTemplates.ReportInfo) = LexxiomReports.GetReports
		Dim arrReportArgs As String = "ReportArgsArray"
		Dim arrValues As String = ""
		tblMain.Style("Font-family") = "tahoma"
		For Each r As LetterTemplates.ReportInfo In Reports
			arrValues = r.ReportTypeName & "|"
			For Each arg As KeyValuePair(Of String, String) In r.ReportArguments
				arrValues += arg.Key & ","
			Next
			arrValues = arrValues.Substring(0, arrValues.Length - 1) & "|"

			If Not IsNothing(r.RequiredFieldsList) Then
				For Each s As String In r.RequiredFieldsList
					arrValues += s.ToString & ","
				Next
			End If

			arrValues = arrValues.Substring(0, arrValues.Length - 1)
			arrValues = arrValues.Replace(")", "")


			ClientScript.RegisterArrayDeclaration(arrReportArgs, Chr(34) & arrValues & Chr(34))
		Next
		dicReportSentDates = Me.GetSentDates

		cellReports.Controls.Add(Me.BuildClientReportsTable(Reports))
		cellReports.Controls.Add(Me.BuildCreditorReportsTable(Reports))
		cellReports.Controls.Add(Me.BuildPackageReportsTable(Reports))

		Dim tDiv As New HtmlGenericControl("DIV id=""divMsg"" style=""display:none""")
		cellArguments.Controls.Add(tDiv)
		cellArguments.Controls.Add(Me.BuildArgumentTables(Reports))


	End Sub
	Private Function BuildClientReportsTable(ByVal ListOfReports As List(Of LetterTemplates.ReportInfo)) As Table

		Dim tDiv As New HtmlGenericControl(Me.strCreateDiv & " id=""divClientRpt""")

		'create main cell table
		Dim tblReports As New Table
		tblReports.ID = "tblClient"
		tblReports.Style("width") = "100%"
		tblReports.CellPadding = 0
		tblReports.CellSpacing = 0

		Dim rowClient As TableRow
		Dim cellClient As TableCell

		'header checkbox
		rowClient = New TableRow
		rowClient.ID = "rowClientHdr"

		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.ForeColor = System.Drawing.Color.White
		Dim chkClient As New CheckBox
		chkClient.ID = "chkClient"
		chkClient.Attributes.Add("onclick", "CheckAll(this);")
		chkClient.Text = "Client Reports"
		chkClient.Font.Name = "tahoma"
		cellClient.Controls.Add(chkClient)
		rowClient.Controls.Add(cellClient)

		'last hdr cell
		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.HorizontalAlign = HorizontalAlign.Right
		cellClient.Style("PADDING-RIGHT") = "5px"

		'img cell for expanding/collapsing
		Dim imgControl As New HtmlImage
		imgControl.ID = "imgClient"
		imgControl.Attributes.Add("onclick", "ShowTable('rowClient',this)")

		imgControl.Attributes.Add("onmouseover", "this.style.cursor='hand';")
		imgControl.Src = "~/images/collapse.png"
		cellClient.Controls.Add(imgControl)
		rowClient.Controls.Add(cellClient)

		'add row to table
		tblReports.Controls.Add(rowClient)

		'create table with report checkboxes
		Dim tblTemp As New Table
		tblTemp.ID = "tblClientChecks"
		tblTemp.Style("width") = "100%"
		Dim tblRow As TableRow

		Dim tblCell As TableCell
		For Each r As LetterTemplates.ReportInfo In ListOfReports
			Select Case r.ReportDocFolder
				Case "ClientDocs"
					If IsNothing(r.ReportPackages) Then
						Dim chkTemp As New CheckBox
						Dim txtTemp As New AssistedSolutions.WebControls.InputMask
						txtTemp.Mask = "nn/nn/nnnn nn:nn aa"
						txtTemp.Font.Name = "tahoma"
						txtTemp.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
						If Me.dicReportSentDates.ContainsKey(r.ReportDocTypeID) Then
							txtTemp.Text = Me.dicReportSentDates(r.ReportDocTypeID)
						End If

						tblRow = New TableRow
						tblRow.ID = "row_client_" & r.ReportTypeName
						tblRow.Style("font-size") = "x-small"
						tblRow.Attributes.Add("onmouseover", "this.style.cursor='hand';")

						'checkbox for report
						tblCell = New TableCell
						tblCell.Style("width") = "85%"
						chkTemp.ID = "chk_Client_" & r.ReportTypeName
						chkTemp.Attributes.Add("onclick", "SetSentDate(this);GetParameters(this);")
						chkTemp.Attributes.Add("onmouseover", "this.style.textDecorationUnderline=true;")
						chkTemp.Attributes.Add("onmouseout", "this.style.textDecorationUnderline=false;")

						chkTemp.Text = r.ReportDisplayName
						chkTemp.Font.Name = "tahoma"
						chkTemp.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

						'**********************************
						'6.11.09.ug
						'only show for palmer
						Dim compID As Integer = DataHelper.FieldLookup("tblClient", "Companyid", "Clientid = " & DataClientID)
						If r.ReportTypeName.ToLower = "NonResponseTerminationLetter".ToLower Then
							Select Case compID
								Case 2
									chkTemp.Enabled = True
								Case Else
									chkTemp.Enabled = False
							End Select
						End If
						'**********************************

						tblCell.Controls.Add(chkTemp)
						tblRow.Controls.Add(tblCell)

						'textbox for sent date
						tblCell = New TableCell
						tblCell.Style("width") = "15%"
						tblCell.HorizontalAlign = HorizontalAlign.Right
						txtTemp.ID = "txt_Client_Sent" & r.ReportTypeName
						tblCell.Controls.Add(txtTemp)
						tblRow.Controls.Add(tblCell)

						tblTemp.Controls.Add(tblRow)
					End If

			End Select

		Next
		rowClient = New TableRow
		rowClient.ID = "rowClient"

		cellClient = New TableCell
		cellClient.Style("PADDING-LEFT") = "25px"

		tDiv.Controls.Add(tblTemp)
		cellClient.Controls.Add(tDiv)
		'cellClient.Controls.Add(tblTemp)
		rowClient.Controls.Add(cellClient)
		tblReports.Controls.Add(rowClient)



		Return tblReports

	End Function
	Private Function BuildCreditorReportsTable(ByVal ListOfReports As List(Of LetterTemplates.ReportInfo)) As Table

		Dim tDiv As New HtmlGenericControl(Me.strCreateDiv & " id=""divCreditorRpt""")



		Dim tblReports As New Table
		tblReports.ID = "tblCreditor"
		tblReports.Style("width") = "100%"
		tblReports.CellPadding = 0
		tblReports.CellSpacing = 0


		Dim rowClient As TableRow
		Dim cellClient As TableCell

		rowClient = New TableRow
		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.ForeColor = System.Drawing.Color.White

		Dim chkClient As New CheckBox
		chkClient.Attributes.Add("onclick", "CheckAll(this);")
		chkClient.ID = "chkCreditor"

		chkClient.Text = "Creditor Reports"
		chkClient.Font.Name = "tahoma"
		cellClient.Controls.Add(chkClient)
		rowClient.Controls.Add(cellClient)

		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.HorizontalAlign = HorizontalAlign.Right
		cellClient.Style("PADDING-RIGHT") = "5px"
		Dim imgControl As New HtmlImage
		imgControl.ID = "imgCreditor"
		imgControl.Attributes.Add("onclick", "ShowTable('rowCreditor',this)")
		imgControl.Attributes.Add("onmouseover", "this.style.cursor='hand';")

		imgControl.Src = "~/images/collapse.png"
		cellClient.Controls.Add(imgControl)
		rowClient.Controls.Add(cellClient)

		tblReports.Controls.Add(rowClient)

		Dim tblTemp As New Table

		tblTemp.Style("width") = "100%"
		tblTemp.ID = "tblCreditorChecks"
		Dim tblRow As TableRow
		Dim tblCell As TableCell
		For Each r As LetterTemplates.ReportInfo In ListOfReports
			Select Case r.ReportDocFolder
				Case "CreditorDocs"
					Dim chkTemp As New CheckBox
					Dim txtTemp As New AssistedSolutions.WebControls.InputMask
					txtTemp.Mask = "nn/nn/nnnn nn:nn aa"
					txtTemp.Font.Name = "tahoma"
					txtTemp.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
					If Me.dicReportSentDates.ContainsKey(r.ReportDocTypeID) Then
						txtTemp.Text = Me.dicReportSentDates(r.ReportDocTypeID)
					End If

					tblRow = New TableRow
					tblRow.ID = "row_creditor_" & r.ReportTypeName
					tblRow.Style("font-size") = "x-small"
					tblRow.Attributes.Add("onmouseover", "this.style.cursor='hand';")

					tblCell = New TableCell
					tblCell.Style("width") = "85%"
					chkTemp.ID = "chk_Creditor_" & r.ReportTypeName
					chkTemp.Font.Name = "tahoma"
					chkTemp.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
					chkTemp.Attributes.Add("onclick", "SetSentDate(this);GetParameters(this);")
					chkTemp.Attributes.Add("onmouseover", "this.style.textDecorationUnderline=true;")
					chkTemp.Attributes.Add("onmouseout", "this.style.textDecorationUnderline=false;")


					chkTemp.Text = r.ReportDisplayName
					tblCell.Controls.Add(chkTemp)
					tblRow.Controls.Add(tblCell)

					tblCell = New TableCell
					tblCell.Style("width") = "15%"
					tblCell.HorizontalAlign = HorizontalAlign.Right
					txtTemp.ID = "txt_Creditor_Sent" & r.ReportTypeName
					tblCell.Controls.Add(txtTemp)
					tblRow.Controls.Add(tblCell)

					tblTemp.Controls.Add(tblRow)
			End Select

		Next
		rowClient = New TableRow
		rowClient.ID = "rowCreditor"
		cellClient = New TableCell
		cellClient.Style("PADDING-LEFT") = "25px"
		tDiv.Controls.Add(tblTemp)
		cellClient.Controls.Add(tDiv)
		rowClient.Controls.Add(cellClient)
		tblReports.Controls.Add(rowClient)

		Return tblReports

	End Function
	Private Function BuildPackageReportsTable(ByVal ListOfReports As List(Of LetterTemplates.ReportInfo)) As Table

		Dim tDiv As New HtmlGenericControl(Me.strCreateDiv & " id=""divPackageRpt""")

		Dim tblReports As New Table
		tblReports.ID = "tblPackage"
		tblReports.Style("width") = "100%"
		tblReports.CellPadding = 0
		tblReports.CellSpacing = 0

		Dim rowClient As TableRow
		Dim cellClient As TableCell

		rowClient = New TableRow
		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.ForeColor = System.Drawing.Color.White

		Dim chkClient As New CheckBox
		chkClient.Attributes.Add("onclick", "CheckAll(this);")
		chkClient.ID = "chkPackage"

		chkClient.Text = "Welcome Package"
		chkClient.Font.Name = "tahoma"
		cellClient.Controls.Add(chkClient)
		rowClient.Controls.Add(cellClient)

		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.HorizontalAlign = HorizontalAlign.Right
		cellClient.Style("PADDING-RIGHT") = "5px"
		Dim imgControl As New HtmlImage
		imgControl.ID = "imgPackage"
		imgControl.Attributes.Add("onclick", "ShowTable('rowPackage', this)")
		imgControl.Attributes.Add("onmouseover", "this.style.cursor='hand';")

		imgControl.Src = "~/images/collapse.png"
		cellClient.Controls.Add(imgControl)
		rowClient.Controls.Add(cellClient)

		tblReports.Controls.Add(rowClient)

		Dim tblTemp As New Table
		tblTemp.ID = "tblPackageChecks"
		tblTemp.Style("width") = "100%"
		Dim tblRow As TableRow
		Dim tblCell As TableCell
		For Each r As LetterTemplates.ReportInfo In ListOfReports
			If Not IsNothing(r.ReportPackages) Then
				For Each p As String In r.ReportPackages
					Dim chkTemp As New CheckBox
					Dim txtTemp As New AssistedSolutions.WebControls.InputMask
					txtTemp.Mask = "nn/nn/nnnn nn:nn aa"
					txtTemp.Font.Name = "tahoma"
					txtTemp.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

					If Me.dicReportSentDates.ContainsKey("D4000K") Then
						txtTemp.Text = Me.dicReportSentDates("D4000K")
					ElseIf Me.dicReportSentDates.ContainsKey(r.ReportDocTypeID) Then
						txtTemp.Text = Me.dicReportSentDates(r.ReportDocTypeID)
					End If

					tblRow = New TableRow
					tblRow.ID = "row_package_" & r.ReportTypeName
					tblRow.Style("font-size") = "x-small"
					tblRow.Attributes.Add("onmouseover", "this.style.cursor='hand';")

					tblCell = New TableCell
					tblCell.Style("width") = "85%"
					chkTemp.ID = "chk_Package_" & r.ReportTypeName
					chkTemp.Attributes.Add("onclick", "SetSentDate(this);GetParameters(this);")
					chkTemp.Attributes.Add("onmouseover", "this.style.textDecorationUnderline=true;")
					chkTemp.Attributes.Add("onmouseout", "this.style.textDecorationUnderline=false;")


					chkTemp.Text = r.ReportDisplayName
					chkTemp.Font.Name = "tahoma"
					chkTemp.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

					tblCell.Controls.Add(chkTemp)
					tblRow.Controls.Add(tblCell)

					tblCell = New TableCell
					tblCell.Style("width") = "15%"
					tblCell.HorizontalAlign = HorizontalAlign.Right
					txtTemp.ID = "txt_Package_Sent" & r.ReportTypeName
					tblCell.Controls.Add(txtTemp)
					tblRow.Controls.Add(tblCell)

					tblTemp.Controls.Add(tblRow)
				Next
			End If
		Next

		rowClient = New TableRow
		rowClient.ID = "rowPackage"
		cellClient = New TableCell
		cellClient.Style("PADDING-LEFT") = "25px"
		tDiv.Controls.Add(tblTemp)

		cellClient.Controls.Add(tDiv)
		'cellClient.Controls.Add(tblTemp)
		rowClient.Controls.Add(cellClient)
		tblReports.Controls.Add(rowClient)

		Return tblReports
	End Function
	Private Function BuildArgumentTables(ByVal ListOfReports As List(Of LetterTemplates.ReportInfo)) As Table

		UName = LetterTemplates.GetUserName(UserID)

		Dim cellHolder As New TableCell

		'instantiate html table
		Dim tblReports As New Table
		tblReports.ID = "tblArguments"
		tblReports.Style("width") = "100%"
		tblReports.CellPadding = 0
		tblReports.CellSpacing = 0

		'row and cell vars
		Dim rowClient As TableRow
		Dim cellClient As TableCell

		'create header row
		rowClient = New TableRow

		'create header cell
		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.ForeColor = System.Drawing.Color.White
		Dim lblClient As New Label
		lblClient.ID = "lblArguments"
		lblClient.Text = "Report Arguments"
		cellClient.HorizontalAlign = HorizontalAlign.Center
		cellClient.Controls.Add(lblClient)
		rowClient.Controls.Add(cellClient)

		'create header image cell
		cellClient = New TableCell
		cellClient.BackColor = System.Drawing.Color.SteelBlue
		cellClient.HorizontalAlign = HorizontalAlign.Right
		cellClient.Style("PADDING-RIGHT") = "5px"
		Dim imgControl As New HtmlImage
		imgControl.ID = "imgArgs"
		imgControl.Attributes.Add("onclick", "ShowTable('rowArgument', this)")
		imgControl.Attributes.Add("onmouseover", "this.style.cursor='hand';")
		imgControl.Src = "~/images/collapse.png"
		cellClient.Controls.Add(imgControl)
		rowClient.Controls.Add(cellClient)

		'add header row to table
		tblReports.Controls.Add(rowClient)

		'used to only show variable once
		Dim ListOfArguments As New List(Of String)


		For Each r As LetterTemplates.ReportInfo In ListOfReports
			Dim tblArg As Table = Nothing
			If Not IsNothing(r.ReportArguments) Then
				rowClient = New TableRow
				rowClient.ID = "rowArguments"
				cellClient = New TableCell

				Dim rowArg As TableRow = Nothing
				Dim cellArg As TableCell = Nothing

				For Each dArg As KeyValuePair(Of String, String) In r.ReportArguments
					If Not ListOfArguments.Contains(dArg.Key) Then
						tblArg = New Table
						tblArg.BackColor = Color.AliceBlue
						tblArg.Style("width") = "100%"
						tblArg.Style("display") = "none"

						ListOfArguments.Add(dArg.Key)
						tblArg.ID = "tbl_arg_" & dArg.Key

						Select Case dArg.Key.Trim
							'don't show these
							Case "ClientID", "bIsThisACopy", "DebtReasonOther"
								Exit For
							Case "CreditorInstanceIDsCommaSeparated"
								tblArg.Rows.Add(createHeaderRowCell("SelectCreditor", r.ReportTypeName & "_arg_" & dArg.Key))
							Case "SettlmentID"
								tblArg.Rows.Add(createHeaderRowCell("SelectSettlement", r.ReportTypeName & "_arg_" & dArg.Key))
							Case Else
								tblArg.Rows.Add(createHeaderRowCell(dArg.Key, r.ReportTypeName & "_arg_" & dArg.Key))

						End Select

						rowArg = New TableRow
						cellArg = New TableCell
						cellArg.ID = r.ReportTypeName & "_arg_value_" & dArg.Key

						Dim strControlName As String = ""
						Select Case dArg.Key
							Case "ClientID", "bIsThisACopy"
							Case "DepositMonth"
								cellArg.Controls.Add(BuildMonthsTable())
							Case "DebtRejectionReason" ', "DebtReasonOther"
								Using cnSQL As New SqlConnection(strSQLConnection)
									cellArg.Controls.Add(BuildDebtReasonsTable(cnSQL))
								End Using
							Case "MissingInfoReasonCode"
								Using cnSQL As New SqlConnection(strSQLConnection)
									cellArg.Controls.Add(Me.BuildVerificationReasonsList(cnSQL))
								End Using
							Case "CreditorInstanceIDsCommaSeparated"
								Using cnSQL As New SqlConnection(strSQLConnection)
									cellArg.Controls.Add(BuildCreditorList(cnSQL))
								End Using
							Case "SettlmentID"
								Using cnSQL As New SqlConnection(strSQLConnection)
									cellArg.Controls.Add(BuildSettlementList(cnSQL))
								End Using
							Case "BankAccountStatus"
								cellArg.Controls.Add(BuildBankAccountStatusTable())
							Case "ReturnedReason"
								cellArg.Controls.Add(BuildReturnedReasonsList())
							Case Else
								If dArg.Key.Contains("Date") Then				'check if this is a date param
									strControlName = "arg_value_txt_" & dArg.Key

									Dim tempDate As New AssistedSolutions.WebControls.InputMask
									tempDate.ID = strControlName
									tempDate.Text = Format(Now, "MM/dd/yyyy")
									tempDate.Font.Name = "tahoma"
									tempDate.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
									tempDate.Mask = "nn/nn/nnnn"
									tempDate.Attributes.Add("onblur", "onBlurCheck();")
									cellArg.Controls.Add(tempDate)
								ElseIf dArg.Key.Contains("Has") Then			'check if this is a true/false param
									strControlName = "arg_value_rbl_" & dArg.Key
									Dim tempCtl As New RadioButtonList

									tempCtl.Items.Add(New ListItem("True", "True"))
									tempCtl.Items.Add(New ListItem("False", "False"))
									tempCtl.SelectedValue = "False"

									tempCtl.ID = strControlName

									tempCtl.Font.Name = "tahoma"
									tempCtl.Style("width") = "100%"
									tempCtl.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
									tempCtl.Attributes.Add("onblur", "onBlurCheck();")
									cellArg.Controls.Add(tempCtl)
								Else											'use textbox for what's left
									strControlName = "arg_value_txt_" & dArg.Key
									Dim tempDate As New TextBox
									tempDate.ID = strControlName
									If dArg.Key = "ClientServiceRep" Then
										tempDate.Text = UName
									End If
									tempDate.Font.Name = "tahoma"
									tempDate.Style("width") = "100%"
									tempDate.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
									tempDate.Attributes.Add("onblur", "onBlurCheck();")
									cellArg.Controls.Add(tempDate)
								End If
						End Select

						rowArg.Cells.Add(cellArg)
						tblArg.Rows.Add(rowArg)
						If tblArg.Rows.Count > 0 Then
							cellHolder.Controls.Add(tblArg)
						End If
					End If
				Next
			End If
		Next

		cellHolder.Style("PADDING-LEFT") = "25px"
		cellHolder.ID = "ArgumentsCell"
		rowClient.Controls.Add(cellHolder)
		tblReports.Controls.Add(rowClient)

		Return tblReports

	End Function
	Private Function createHeaderRowCell(ByVal headerText As String, ByVal strCellID As String) As TableRow
		Dim rowArg As New TableRow
		Dim cellArg As New TableCell

		cellArg.ID = strCellID
		cellArg.Text = InsertSpaceAfterCap(headerText.Replace(")", ""))
		cellArg.Font.Name = "tahoma"
		cellArg.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
		cellArg.BackColor = ColorTranslator.FromHtml("#C6DEF2")
		cellArg.Style("padding") = "5px"
		rowArg.Cells.Add(cellArg)

		Return rowArg
	End Function
	Private Function BuildMonthsTable() As RadioButtonList
		'build dynamic table with radiobuttons to select the debt rejection reason
		Dim lstDebtReasons As New RadioButtonList
		lstDebtReasons.Style("height") = "150px"
		lstDebtReasons.Style("width") = "100%"
		lstDebtReasons.ID = "arg_value_lst_DepositMonth"
		lstDebtReasons.Style("overflow") = "auto"

		lstDebtReasons.Font.Name = "tahoma"
		lstDebtReasons.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		For i As Integer = 1 To 12
			Dim sMonthName As String = MonthName(i, False)
			lstDebtReasons.Items.Add(sMonthName)
		Next

		Return lstDebtReasons
	End Function
	Private Function BuildDebtReasonsTable(ByVal sqlConnection As SqlConnection) As RadioButtonList
		'build dynamic table with radiobuttons to select the debt rejection reason
		Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'DebtRejectionLetter')"
		Dim lstDebtReasons As New RadioButtonList
		lstDebtReasons.Style("height") = "150px"
		lstDebtReasons.Style("width") = "100%"
		lstDebtReasons.ID = "arg_value_lst_DebtRejectionReason"
		lstDebtReasons.Style("overflow") = "auto"

		lstDebtReasons.Font.Name = "tahoma"
		lstDebtReasons.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		Using cmd As New SqlCommand(strSQL, sqlConnection)
			Using cmd.Connection
				cmd.Connection.Open()

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						lstDebtReasons.Items.Add(New ListItem(reader("ReasonDesc"), CInt(reader("ReasonID"))))
					End While
				End Using
			End Using
		End Using

		Return lstDebtReasons
	End Function
	Private Function BuildVerificationReasonsList(ByVal sqlConnection As SqlConnection) As CheckBoxList

		Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'VerificationResponseLetter605')"

		Dim lstCreditors As New CheckBoxList
		lstCreditors.Style("height") = "150px"
		lstCreditors.Style("width") = "100%"
		lstCreditors.ID = "arg_value_lst_MissingInfoReasonCode"

		lstCreditors.Font.Name = "tahoma"
		lstCreditors.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		Using cmd As New SqlCommand(strSQL, sqlConnection)
			Using cmd.Connection
				cmd.Connection.Open()

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						Dim reasonDesc As String = reader("ReasonDesc")
						lstCreditors.Items.Add(New ListItem(reasonDesc, CInt(reader("ReasonID"))))
					End While
				End Using
			End Using
		End Using

		Return lstCreditors

	End Function
	Private Function BuildSettlementList(ByVal sqlConnection As SqlConnection) As ListBox

		Dim sSQL As String = "select c.name + ' #' + right(ci.accountnumber,4) + ' ($' + cast(s.settlementamount as varchar) +')'[SettInfo],s.settlementid  "
		sSQL += "from tblsettlements s "
		sSQL += "inner join tblaccount a on a.accountid = s.creditoraccountid "
		sSQL += "inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid "
		sSQL += "inner join tblcreditor c on c.creditorid = ci.creditorid "
		sSQL += "where [status] = 'a' and s.clientid = " & DataClientID

		Dim lst As New ListBox
		lst.Style("height") = "150px"
		lst.Style("width") = "100%"
		lst.ID = "arg_value_lst_SettlmentID"
		lst.SelectionMode = ListSelectionMode.Single

		lst.Attributes.Add("onblur", "onBlurCheck();")

		lst.Font.Name = "tahoma"
		lst.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		Using cmd As New SqlCommand(sSQL, sqlConnection)
			Using cmd.Connection
				cmd.Connection.Open()

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						lst.Items.Add(New ListItem(FormatSelect(CStr(reader("SettInfo")), reader("settlementid")), reader("settlementid")))
					End While
				End Using
			End Using
		End Using

		Return lst

	End Function
	Private Function BuildCreditorList(ByVal sqlConnection As SqlConnection) As ListBox

		Dim strSQL As String = String.Format("stp_LetterTemplates_GetClientCreditors {0}", DataClientID)

		Dim lstCreditors As New ListBox
		lstCreditors.Style("height") = "150px"
		lstCreditors.Style("width") = "100%"
		lstCreditors.SelectionMode = ListSelectionMode.Multiple
		lstCreditors.ID = "arg_value_lst_CreditorInstanceIDsCommaSeparated"

		lstCreditors.Attributes.Add("onblur", "onBlurCheck();")

		lstCreditors.Font.Name = "Courier New"
		lstCreditors.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		Using cmd As New SqlCommand(strSQL, sqlConnection)
			Using cmd.Connection
				cmd.Connection.Open()

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						lstCreditors.Items.Add(New ListItem(reader("Name").ToString.PadRight(35, Chr(160)) & reader("AcctLast4").ToString, reader("CurrentCreditorInstanceID"), True))
						'lstCreditors.Items.Add(New ListItem(FormatSelect(CStr(reader("Name")), CStr(reader("AccountID"))), CInt(reader("CreditorInstanceID")), True))
					End While
				End Using
			End Using
		End Using

		Return lstCreditors

	End Function
	Private Function BuildBankAccountStatusTable() As RadioButtonList
		'build dynamic table with radiobuttons to select the debt rejection reason
		'build dynamic table with radiobuttons to select the debt rejection reason
		Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'NSFLetter')"
		Dim lstBankStatus As New RadioButtonList
		'lstDebtReasons.Style("height") = "150px"
		lstBankStatus.Style("width") = "100%"
		lstBankStatus.ID = "arg_value_lst_BankAccountStatus"
		lstBankStatus.Style("overflow") = "auto"

		lstBankStatus.Font.Name = "tahoma"
		lstBankStatus.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		Using cmd As New SqlCommand(strSQL, New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
			Using cmd.Connection
				cmd.Connection.Open()
				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						lstBankStatus.Items.Add(New ListItem(reader("ReasonDesc"), CInt(reader("ReasonID"))))
					End While
				End Using
			End Using
		End Using

		lstBankStatus.SelectedIndex = 0

		Return lstBankStatus
	End Function
	Private Function BuildReturnedReasonsList() As CheckBoxList

		Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'DepositReturnedLetter')"

		Dim lstCreditors As New CheckBoxList
		lstCreditors.Style("height") = "150px"
		lstCreditors.Style("width") = "100%"
		lstCreditors.ID = "arg_value_lst_ReturnedReason"

		lstCreditors.Font.Name = "tahoma"
		lstCreditors.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

		Using cmd As New SqlCommand(strSQL, New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
			Using cmd.Connection
				cmd.Connection.Open()

				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						Dim reasonDesc As String = reader("ReasonDesc")
						If reasonDesc.Contains("[!ClientName]") Then
							Dim cName As String = PersonHelper.GetName(ClientHelper.GetDefaultPerson(DataClientID))
							reasonDesc = reasonDesc.Replace("[!ClientName]", cName)
						End If
						lstCreditors.Items.Add(New ListItem(reasonDesc, reasonDesc))
					End While
				End Using
			End Using
		End Using

		Return lstCreditors

	End Function
	Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String

		If strToChange.Contains("CityStateZip") Then
			strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
		End If

		Dim sChars() As Char = strToChange.ToCharArray()
		Dim strNew As String = ""

		For Each c As Char In sChars
			Select Case Asc(c)
				Case 65 To 95, 49 To 57	  'upper caps or numbers
					strNew += Space(1) & c.ToString
				Case 97 To 122	'lower caps
					strNew += c.ToString
				Case Else
					strNew += Space(1) & c.ToString
			End Select
		Next

		strNew = strNew.Replace("I D", "ID")
		Return strNew.Trim
	End Function
	Private Function GetDirtyParameters() As Dictionary(Of String, String)
		'dictionary to hold arguments
		Dim dicArguments As New Dictionary(Of String, String)

		'get cell with argument controls
		Dim ArgumentsRow As TableCell = Me.Page.FindControl("ArgumentsCell")
		For Each arg As Control In ArgumentsRow.Controls
			Dim tempTable As Table = CType(arg, Table)
			For Each tr As TableRow In tempTable.Rows
				For Each c As Control In tr.Controls
					If c.ID.IndexOf("value") > 0 Then
						For Each aControl As Control In c.Controls
							Dim t As Type = aControl.GetType
							Select Case t.Name
								Case "ListBox"
									Dim intLast As Integer = aControl.ID.LastIndexOf("_")
									Dim strControl As String = aControl.ID.Substring(intLast + 1)
									Dim cList As ListBox = CType(aControl, ListBox)
									If Not String.IsNullOrEmpty(cList.SelectedValue) Then
										dicArguments.Add(strControl, cList.SelectedValue.ToString)
									End If
								Case "TextBox"
									Dim intLast As Integer = aControl.ID.LastIndexOf("_")
									Dim strControl As String = aControl.ID.Substring(intLast + 1)
									Dim cText As TextBox = CType(aControl, TextBox)
									If Not String.IsNullOrEmpty(cText.Text) Then
										dicArguments.Add(strControl, cText.Text)
									End If

								Case "InputMask"
									Dim cText As AssistedSolutions.WebControls.InputMask = CType(aControl, AssistedSolutions.WebControls.InputMask)
									Dim intLast As Integer = aControl.ID.LastIndexOf("_")
									Dim strControl As String = aControl.ID.Substring(intLast + 1)
									If Not String.IsNullOrEmpty(cText.Text) Then
										dicArguments.Add(strControl, cText.Text)
									End If
								Case "Table"
									Dim cTable As Table = CType(aControl, Table)
									For Each tRow As TableRow In cTable.Rows
										Select Case tRow.Cells(0).Controls.Count
											Case Is > 0
												Dim oTemp As RadioButton = tRow.Cells(0).Controls(0)
												If oTemp.Checked Then
													Dim tCell As TableCell = tRow.Cells(1)
													dicArguments.Add("DebtRejectionReason", tCell.Text)
												End If
										End Select
									Next
							End Select
						Next
					End If
				Next
			Next
		Next

		Return dicArguments
	End Function
	Private Function GetSentDates() As Dictionary(Of String, String)
		Dim strSQL As String = "SELECT DocTypeID, MAX(SentDate) AS LastSent FROM vwSentLetters WHERE ClientID = " & DataClientID & " GROUP BY TypeName, DocTypeID"
		Dim dSent As New Dictionary(Of String, String)

		Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create)
			Using cmd.Connection
				cmd.Connection.Open()
				Using reader As SqlDataReader = cmd.ExecuteReader()
					While reader.Read()
						dSent.Add(reader("DocTypeID").ToString, Format(CDate(reader("LastSent").ToString), "MM/dd/yyyy hh:mm tt"))
					End While
				End Using
			End Using
		End Using

		Return dSent
	End Function
#End Region
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

End Class