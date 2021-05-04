Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Controls
Imports Slf.Dms.Records

Imports System
Imports System.Threading
Imports System.Collections.Generic
Imports System.Collections.ObjectModel
Imports System.Data
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Net
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Net.Mail
Imports Microsoft.VisualBasic
'Imports Microsoft.SqlServer.Management.Smo
'Imports Microsoft.Office.Interop
Imports System.Configuration

Partial Class clientimport_default
   Inherits PermissionPage

   Public Structure FileAttachment
      Public Name As String
      Public Description As String
      Public Content As String

      Public Sub Email(ByVal FileName As String, ByVal FileDescription As String, ByVal FileContent As String)
         Name = FileName
         Description = FileDescription
         Content = FileContent
      End Sub
   End Structure

#Region "Variables"

   Private m_xl As Excel.Application
   Private wb As Excel.Workbook

   Private UserID As Integer

   Private connStrDMS As String
   Private connStrImport As String

   Private dirTemp As String
   Private dirArchive As String

   Private CompanyID As Integer
   Private AgencyID As Integer
   Private BankProcess As String

   Private ScenarioCounter As Integer = 0
   Private ScenarioIDs(0) As Integer

   Public Duplicates As String
   Public EqualRows(0) As Boolean

   Public ClientImportBook As Excel.Worksheet

   Shared waitTime As New TimeSpan(0, 0, 0, 30) 'Set for 30 seconds

   Public Name As String
   Public Description As String
   Public Content As String

   Public validTbls As Dictionary(Of String, DataTable)
   Public filePath As String

   Public result As String = ""
   Public ImportLog As String

   Public DepositDays As List(Of Integer)

#End Region

   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

      UserID = DataHelper.Nz_int(Page.User.Identity.Name)
      SetupLog()
      connStrDMS = ConfigurationSettings.AppSettings.Item("connectionstring").ToString()
      connStrImport = ConfigurationSettings.AppSettings.Item("connectionstringimport").ToString()

      dirTemp = ConfigurationSettings.AppSettings.Item("importDirTemp").ToString()
      dirArchive = ConfigurationSettings.AppSettings.Item("importDirArchive").ToString()

      If Directory.Exists(dirTemp) = False Then
         Directory.CreateDirectory(dirTemp)
      End If

      If Directory.Exists(dirArchive) = False Then
         Directory.CreateDirectory(dirArchive)
      End If

      Me.lnkImportClient.Enabled = False

      If Not IsPostBack Then
         GetAllCompanies()
         GetAllAgencies()

         ClearTemps()

         lblFile.Visible = False
      End If

      validTbls = Session("clientimport_default_tables")
      filePath = Session("clientimport_default_filepath")
      hdnFileName.Value = filePath

      ImportLog += "<tr style=""font-weight:normal"">" & Now & ": Collecting Attorney & Agency data for this spreadsheet: Completed.</tr>"
   End Sub

#Region "GetAll_Info"

   Public Sub GetAllCompanies()
      ddlCompany.Items.Clear()

      Using cmd As SqlCommand = ConnectionFactory.Create().CreateCommand()
         Using cmd.Connection
            Dim companyID As Integer
            Dim companyName As String

            cmd.Connection.Open()
            cmd.CommandText = "SELECT DISTINCT CompanyId, ShortCoName FROM tblCompany"
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            While reader.Read()
               companyID = reader.GetInt32(0)
               companyName = reader.GetString(1)
               ddlCompany.Items.Add(New ListItem(companyName, companyID, True))
            End While
         End Using
      End Using

      ddlCompany.Items.Add(New ListItem("-- SELECT --", -9, True))
   End Sub

   Public Sub GetAllAgencies()
      ddlAgency.Items.Clear()

      Using cmd As SqlCommand = ConnectionFactory.Create().CreateCommand()
         Using cmd.Connection
            Dim agencyID As Integer
            Dim agencyName As String

            cmd.Connection.Open()
            cmd.CommandText = "SELECT AgencyID, ImportAbbr FROM tblAgency ORDER BY ImportAbbr ASC"
            Dim tempAgencies As SqlDataReader = cmd.ExecuteReader()
            While tempAgencies.Read()
               agencyID = tempAgencies.GetInt32(0)
               agencyName = tempAgencies.GetString(1)
               ddlAgency.Items.Add(New ListItem(agencyName, agencyID, True))
            End While
         End Using
      End Using

      ddlAgency.Items.Add(New ListItem("-- SELECT --", -9, True))
   End Sub

#End Region

   Protected Sub lnkImportClient_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkImportClient.Click
      ImportClients()
   End Sub

   Protected Sub ddlSheet_OnSelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSheet.SelectedIndexChanged
      DisplaySheet()
   End Sub

   Private Sub ClearTemps()
      Dim fInfo As FileInfo

      For Each foundfile As String In My.Computer.FileSystem.GetFiles(dirTemp, FileIO.SearchOption.SearchTopLevelOnly, "*.*")
         fInfo = New FileInfo(foundfile)

         If Not DateDiff(DateInterval.Day, fInfo.CreationTime, DateTime.Now) = 0 Then
            File.Delete(foundfile)
         End If
      Next
   End Sub

   Protected Sub lnkValidate_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkValidate.Click
      If txtPath.PostedFile.FileName = "" Then
         Throw New Exception("File name was not captured please try again.")
      End If

      ImportLog += "<tr>" & Now & ": Validating the spreadsheet format and data.</tr>"

      Me.lblNote.Text = "Validating Excel spread sheet. Please wait....................."
      Me.lblNote.Visible = True

      If (txtPath.HasFile AndAlso (txtPath.PostedFile.FileName.Contains(".xls") Or txtPath.PostedFile.FileName.Contains(".xlsx"))) Or (Not filePath Is Nothing AndAlso (filePath.Contains(".xls") Or filePath.Contains(".xlsx"))) Then
         If txtPath.HasFile Then
            HandleMessage("Validating Excel spread sheet. Please wait.........................")
            ValidateFormatting(txtPath.PostedFile.FileName)
         End If
         filePath = txtPath.PostedFile.FileName
         ValidateIt()
         filePath = UploadFile()
         Session("clientimport_default_filepath") = filePath
         lblFile.Text = Path.GetFileName(filePath)
         lblFile.Visible = True
         hdnFileName.Value = filePath
         ImportLog += "<tr>" & Now & ": Validating the spreadsheet format and data: Completed.</tr>"
      Else
         HandleMessage("File must be a valid Excel workbook!")
         ImportLog += "<tr style=""color:red"">" & Now & ": Validating the spreadsheet format and data: Failed.</tr>"
      End If
   End Sub

   Public Sub ImportClients()
      Dim notes As String = ""
      Dim newFile As String = Session("clientimport_default_filepath")

      filePath = newFile

      Try
         If txtDate.Text.Length < 6 AndAlso Not IsValidDate(CStr(txtDate.Text.Substring(0, 2) + "/" + txtDate.Text.Substring(2, 2) + "/" + txtDate.Text.Substring(4, 2)), False) Then
            notes += "Please select the batch date!<BR>"
         End If

         If ddlAgency.SelectedItem.Value = -9 Then
            notes += "Please select the batch agency!<BR>"
         End If

         If ddlCompany.SelectedItem.Value = -9 Then
            notes += "Please select the batch company!<BR>"
         End If

         If notes = "" Or notes.Length = 0 Then
            notes += ImportSheet(validTbls.Item(ddlSheet.SelectedItem.Text))

            newFile = ArchiveFile(filePath)

            DisplaySheet()
         End If
      Catch ex As Exception
         HandleMessage(ex.Message)
         Return
      End Try

      Session("clientimport_default_filepath") = newFile
      hdnFileName.Value = newFile

      HandleMessage(notes)
   End Sub

   Public Function UploadFile() As String
      Dim newThread As New Thread(AddressOf LSheet)
      Dim newPath As String = GetUniqueFileName(dirTemp + Path.GetFileName(txtPath.PostedFile.FileName))


      'LSheet()
      If FileIsOpen(newPath) Then 'Suggested by Mr Data
         Throw New Exception("File in use! Please close the file and try again.")
         ImportLog += "<tr>" & Now & ": Uploading the spreadsheet: Failed.</tr>"
      End If

      txtPath.PostedFile.SaveAs(newPath)
      ImportLog += "<tr>" & Now & "Uploading spread sheet: " & vbTab & txtPath.PostedFile.FileName & "</tr>"
      Return newPath
   End Function

   Public Sub ValidateIt()
      Try
         dtgExcel.Dispose()
         ImportLog += Now & "Validating spread sheet data and formating columns: "
         validTbls = ValidateSheets(filePath)

         ddlSheet.Visible = True
         ddlCompany.Visible = True
         ddlAgency.Visible = True
         txtDate.Visible = True

         lblDate.Visible = True
         lblSheet.Visible = True

         ddlSheet.Enabled = False
         ddlCompany.Enabled = False
         ddlAgency.Enabled = False
         txtDate.Enabled = False
         Me.tdImport.Visible = True

         If validTbls.Count = 1 Then
            ImportLog += "<tr>" & Now & "Validating spread sheet data and formating columns: Completed</tr>"
            HandleMessage("Client Sheet is valid! Please review, then select Import Client.")
         ElseIf validTbls.Count = 2 Then
            Dim keyList As New List(Of String)

            For Each val As String In validTbls.Keys
               keyList.Add(val)
            Next

            Dim comp As String = ""
            Dim results As String = CompareSheets(validTbls.Item(keyList.Item(0)), validTbls.Item(keyList.Item(1)), comp)

            If results.Length > 0 Then
               HandleMessage("There are multiple valid sheets with different values, please review and verify for accuracy (the green highlights indicate which option is <I>most likely</I> correct; however, this is <I>not</I> a guarantee).<BR><BR>" + results + "<BR><BR><I>(click the ""Edit File"" button on the right hand side of the toolbar to fix the above errors)</I>")
               ddlSheet.Enabled = True
            Else
               HandleMessage("Client Sheet is valid! Please review, then select Import Client.")
            End If

            ddlSheet.SelectedValue = comp.Trim().ToLower()
         ElseIf validTbls.Count > 2 Then
            HandleMessage("There are multiple valid sheets, please review and choose the correct one.")
            ddlSheet.Enabled = True
            End If

            DisplaySheet()
         GetFileInfo()
         btnClientImport.Visible = True
      Catch ex As Exception
         HandleMessage(ex.Message + "<BR><BR><I>(click the ""Edit File"" button on the right hand side of the toolbar to fix the above errors)</I>")
         CleanupInterface()
         Return
      End Try
   End Sub

   Private Sub CleanupInterface()
      ddlSheet.Visible = False
      ddlCompany.Visible = False
      ddlAgency.Visible = False
      txtDate.Visible = False
      lblDate.Visible = False
      lblSheet.Visible = False
      btnClientImport.Visible = False

      dtgExcel.DataSource = Nothing
      dtgExcel.DataBind()
   End Sub

   Private Sub DisplaySheet()
      dtgExcel.DataSource = validTbls.Item(ddlSheet.SelectedItem.Text)
      dtgExcel.DataBind()
      Session("clientimport_default_tables") = validTbls
   End Sub

#Region "GetFileInfo"
   Private Sub GetFileInfo()
      If Not GetCompany() Then
         ddlCompany.Enabled = True
         ddlCompany.SelectedValue = -9
      End If

      If Not GetAgency() Then
         ddlAgency.Enabled = True
         ddlAgency.SelectedValue = -9
      End If

      If Not GetDate() Then
         txtDate.Enabled = True
      End If
   End Sub

   Private Function GetCompany() As Boolean
      For idx As Integer = 0 To ddlCompany.Items.Count - 1
         If filePath.ToLower().Contains(ddlCompany.Items(idx).Text.ToLower()) Then
            ddlCompany.SelectedIndex = idx
            CompanyID = ddlCompany.SelectedValue
            Return True
         End If
      Next

      Return False
   End Function

   Private Function GetAgency() As Boolean
      For idx As Integer = 0 To ddlAgency.Items.Count - 1
         If filePath.ToLower().Contains(ddlAgency.Items(idx).Text.ToLower()) Then
            ddlAgency.SelectedIndex = idx
            AgencyID = ddlAgency.SelectedValue
            Return True
         End If
      Next

      Return False
   End Function

   Private Function GetDate() As Boolean
      Dim idxDate As Integer = filePath.IndexOf("-", 2)

      While Not IsValidNumber(filePath.Substring(idxDate - 2, 2), False)
         If idxDate = filePath.LastIndexOf("-") Then
            Return False
         End If

         idxDate = filePath.IndexOf("-", idxDate + 1)
      End While

      If Not idxDate < 0 And filePath.Length > (idxDate + 6) Then
         Dim batchDate As String = filePath.Substring(idxDate - 2, 2) + filePath.Substring(idxDate + 1, 2)
         Dim yearPart As String = filePath.Substring(idxDate + 4, 2)

         If Integer.TryParse(yearPart, Nothing) Then
            If filePath.Length > idxDate + 8 AndAlso Integer.TryParse(filePath.Substring(idxDate + 6, 2), Nothing) Then
               batchDate += filePath.Substring(idxDate + 6, 2)
            Else
               batchDate += yearPart
            End If

            txtDate.Text = batchDate
            Return True
         End If
      End If

      Return False
   End Function

   Private Function GetAllScenarios(Optional ByVal CompanyID As Integer = 0, Optional ByVal AgencyID As Integer = 0) As Integer

      If CompanyID = 0 Then
         CompanyID = ddlCompany.SelectedValue
      End If

      If AgencyID = 0 Then
         AgencyID = ddlAgency.SelectedValue
      End If

      Using cmd As SqlCommand = ConnectionFactory.Create().CreateCommand()
         Using cmd.Connection
            cmd.Connection.Open()
            cmd.CommandText = "SELECT DISTINCT(cs.CommScenID), cs.StartDate FROM tblCommScen cs " _
            & "INNER JOIN tblCommStruct ct ON ct.CommScenID = cs.CommScenID " _
            & "WHERE(cs.AgencyID = " & AgencyID & ") " _
            & "AND (ct.companyid = " & CompanyID & ") " _
            & "AND (cs.StartDate <= " & Format(Now, "MM/dd/yyyy") & ") " _
            & "AND ct.CommScenID IN (select distinct(commscenid) from tblcommstruct where tblcommstruct.companyid = " & CompanyID & ") " _
            & "ORDER BY cs.CommScenID"

            Dim reader As SqlDataReader = cmd.ExecuteReader()
            While reader.Read()
               ScenarioIDs(ScenarioCounter) = reader.Item("CommScenID")
               ScenarioCounter += 1
               ReDim Preserve ScenarioIDs(ScenarioCounter)
            End While
            ReDim Preserve ScenarioIDs(ScenarioIDs.Length - 1)
         End Using
      End Using
      Return ScenarioCounter
   End Function

#End Region

#Region "Validation of sheets"

   Private Function FileIsOpen(ByVal path As String) As Boolean
      Dim fsFile As FileStream

      Try
         fsFile = New FileStream(path, FileMode.Open)
      Catch ex As System.IO.IOException
         Return False
      End Try

      fsFile.Close()
      fsFile.Dispose()

      Return True
   End Function

   Private Function ValidateSheets(ByVal path As String) As Dictionary(Of String, DataTable)
      Dim excelData As DataSet
      Dim sheets As List(Of String) = GetSheets(path)
      Dim validTables As New Dictionary(Of String, DataTable)
      Dim valResults As String
      Dim finalException As String = ""
      Dim exampleSheet As String = "<table style=""font-size:12px;""><tr><td><b>Lead Number</b></td><td><b>Date Sent</b></td><td><b>Date Received</b></td><td><b>First Name</b></td><td><b>Last Name</b></td><td><b>Social Security No.</b></td><td><b>Payment Type</b></td><td><b>Pull Date</b></td><td><b>Payment Amount</b></td><td><b>Debt Total</b></td><td><b>Missing Info.</b></td><td><b>Comments</b></td></tr><tr><td>83742</td><td>10/03/98</td><td>10/09/98</td><td>John</td><td>Smith</td><td>123-45-6789</td><td>ACH</td><td>11/20/98</td><td>$800.32</td><td>$51980.09</td><td>&nbsp;</td><td>Received Payment 10/28/98</td></tr></table>"

      If Not sheets.Count > 0 Then
         Throw New Exception("Could not acquire sheets!")
      End If

      Try
         Using objDataConn As New OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties=""Excel 12.0;HDR=YES""")
            objDataConn.Open()

            For Each sheet As String In sheets
               Using objDataAdapter As New OleDbDataAdapter("SELECT * FROM [" + sheet + "]", objDataConn)
                  excelData = New DataSet()
                  objDataAdapter.Fill(excelData)

                  excelData.Tables(0).TableName = sheet
                  valResults = ValidateSheet(excelData.Tables(0))

                  If valResults = "" Then
                     validTables.Add(sheet, excelData.Tables(0))
                  Else
                     finalException += "<FONT font-size=""14px"">" + sheet + "</FONT><BR>" + valResults + "<BR><BR>"
                  End If

               End Using
            Next
         End Using
      Catch ex As OleDbException
         Throw New Exception("Please copy from the main sheet into a new sheet to get rid of blank rows or columns, then try again.")
      End Try

      finalException += "<BR>" + exampleSheet

      ddlSheet.Items.Clear()

      For Each tempSheet As String In validTables.Keys
         ddlSheet.Items.Add(New ListItem(tempSheet, tempSheet.Trim().ToLower(), True))
      Next

      If validTables.Count < 1 Then
         Throw New Exception(finalException)
         ImportLog += "<tr " & finalException & "</tr>"
      End If

      Return validTables
   End Function

   Private Function ValidateSheet(ByVal sheet As DataTable) As String
      Dim results As String = ""
      Dim idxRow As Integer = 1
      Dim curCol As String
      Dim order As Dictionary(Of Integer, Integer)
      Dim Weighted As Boolean
      Dim PayMethod As String
      Dim y As Integer = 0
      Dim RoutingNo(0) As String
      Dim AccountNo(0) As String

      'Modified code to handle multi deposits 04/01/2009 and then again 04/30/2009 for a layout and field name change Jhope
      'Modified again new layout changes 5/7/2009 jhope

      GetCompany()
      GetAgency()

      DepositDays = New List(Of Integer)

      'ScenarioCounter = GetAllScenarios(CompanyID, AgencyID) 'I'm doing this twice and it's probably not necessary. The other is in import sheet

      If sheet.Rows.Count < 1 Or sheet.Columns.Count = 1 Then
         results += "<I>Sheet is empty.</I><BR>"
         ImportLog += "<td>" & Now & ": " & results & "</td>"
      ElseIf sheet.Columns.Count < 12 Then
         results += "<I>There are too few columns.</I><BR>"
         ImportLog += "<td>" & Now & ": " & results & "</td>"
      Else
         'If there are more columns than required then this routine removes them
         If sheet.Columns.Count - 1 > 46 Then
            For y = 46 To sheet.Columns.Count - 1
               sheet.Columns.RemoveAt(y)
            Next
         End If

         order = ValidateHeaders(sheet)

         'Get all the Social Security numbers
         y = 0
         Dim SocialSN(0) As String
         For Each number As DataRow In sheet.Rows
            If Trim(number(5).ToString) <> "" Then
               SocialSN(y) = number(order(5)).ToString
               y += 1
               ReDim Preserve SocialSN(y)
            End If
         Next
         If SocialSN(y) Is Nothing Then
            ReDim Preserve SocialSN(y - 1)
            y = 0
         End If

         Dim DupSocialSecurityNo As Boolean = CheckForDuplicateSSNo(SocialSN)
         If DupSocialSecurityNo Then
            results += "<b>Social Security Duplicates: There are Social Security numbers in this spread sheet that are duplicated in the database!</B>"
            GoTo StopImport
         End If

         If Duplicates = "ALL" Then
            results += "<b>Duplication Errors: This entire sheet has been imported before!</B>"
            GoTo StopImport
         End If

         If InStr(Duplicates, "There is/are") > 0 Then
            results += "<b>Some of the clients on this spread sheet have already been imported. Please review and correct this sheet and try again!</b>"
            GoTo StopImport
         End If

         'Validate Bank accounts are not duplicated
         'Load the BankAccount and RoutingNumbers for comparison
         y = 0
         For Each bankaccount As DataRow In sheet.Rows
            '1st acct
            If Trim(bankaccount(24).ToString) <> "" Then
               RoutingNo(y) = bankaccount(order(23)).ToString
               AccountNo(y) = bankaccount(order(24)).ToString
               y += 1
               ReDim Preserve RoutingNo(y)
               ReDim Preserve AccountNo(y)
            End If
            'Draft acct
            If Trim(bankaccount(15).ToString) <> "" Then
               RoutingNo(y) = bankaccount(order(14)).ToString
               AccountNo(y) = bankaccount(order(15)).ToString
               y += 1
               ReDim Preserve RoutingNo(y)
               ReDim Preserve AccountNo(y)
            End If
            '2nd acct
            If Trim(bankaccount(29).ToString) <> "" Then
               RoutingNo(y) = bankaccount(order(28)).ToString
               AccountNo(y) = bankaccount(order(29)).ToString
               y += 1
               ReDim Preserve RoutingNo(y)
               ReDim Preserve AccountNo(y)
            End If
            '3rd acct
            If Trim(bankaccount(36).ToString) <> "" Then
               RoutingNo(y) = bankaccount(order(35)).ToString
               AccountNo(y) = bankaccount(order(36)).ToString
               y += 1
               ReDim Preserve RoutingNo(y)
               ReDim Preserve AccountNo(y)
            End If
            '4th acct
            If Trim(bankaccount(43).ToString) <> "" Then
               RoutingNo(y) = bankaccount(order(42)).ToString
               AccountNo(y) = bankaccount(order(43)).ToString
               y += 1
               ReDim Preserve RoutingNo(y)
               ReDim Preserve AccountNo(y)
            End If
         Next
         If AccountNo(y) Is Nothing Then
            ReDim Preserve RoutingNo(y - 1)
            ReDim Preserve AccountNo(y - 1)
         End If
         Dim DupBankAccounts As Boolean = CheckForDuplicateBankAcct(RoutingNo, AccountNo, sheet)

         'Validate the fields on the sheet
         ImportLog += "<td>" & Now & ": Validating spread sheet data and formating: Started</td>"

         Try

            For Each row As DataRow In sheet.Rows
               Weighted = False
               idxRow += 1
               'check for blank rows
               If row(order(3)).ToString Is DBNull.Value And row(order(4)).ToString Is DBNull.Value Then
                  'We are done here this is a completely blank row, try the next one.
                  sheet.Rows.Remove(row)
                  GoTo TryAnotherRow
               Else
                  If row(order(3)).ToString = "" And row(order(4)).ToString = "" Then
                     sheet.Rows.Remove(row)
                     GoTo TryAnotherRow
                  End If
               End If

               '-----------------------------------------------------------
               'Sets up the rest of the sheet for weighted validation ***********************
               If Not row(order(23)) Is DBNull.Value Then
                  If Not row(order(22)) Is Nothing And row(order(23)) = 10 Then
                     Weighted = True
                  End If
               Else
                  If Not row(order(22)) Is Nothing Then
                     Weighted = True
                  Else
                     Weighted = False
                  End If
               End If
               '***************************************************************

               'Begin the basic processing
               curCol = row(order(0)).ToString().Trim()
               If Not IsValidNumber(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  A:</B> """ + curCol + """ is not a valid Lead Number!<BR>"
               End If

               curCol = row(order(1)).ToString().Trim()
               If Not IsValidDate(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  B:</B> """ + curCol + """ is not a valid Sent Date!<BR>"
               End If

               curCol = row(order(2)).ToString().Trim()
               If Not IsValidDate(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  C:</B> """ + curCol + """ is not a valid Received Date!<BR>"
               End If

               curCol = row(order(3)).ToString().Trim()
               If Not IsValidString(curCol, False) Or curCol = "" Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  D:</B> """ + curCol + """ is not a valid First Name!<BR>"
               End If

               curCol = row(order(4)).ToString().Trim()
               If Not IsValidString(curCol, False) Or curCol = "" Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  E:</B> """ + curCol + """ is not a valid Last Name!<BR>"
               End If

               curCol = row(order(5)).ToString().Trim()
               If Not IsValidSSN(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  F:</B> """ + curCol + """ is not valid a Social Security Number!<BR>"
               End If

               results += IsDuplicatedSS(row(order(5)).ToString, sheet, order, idxRow)

               'First deposit 

               curCol = row(order(6)).ToString().Trim()
               If Not IsValidPmtMethod(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  L:</B> """ + curCol + """ is not a valid Deposit Method! Must be ACH or CHECK.<BR>"
               End If

               curCol = row(order(7)).ToString().Trim()
               DepositDays.Add(DatePart(DateInterval.Day, CDate(curCol.ToString)))
               If Not IsValidDate(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  G:</B> """ + curCol + """ is not a valid 1st Deposit Date!<BR>"
               End If

               curCol = row(order(8)).ToString().Trim()
               If Not IsValidCurrency(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  H:</B> """ + curCol + """ is not a valid 1st Deposit Amount!<BR>"
               End If

               PayMethod = row(order(6)).ToString.Trim
               curCol = row(order(9)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidRoutingNumber(curCol, False, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  I:</B> """ + curCol + """ is not a valid 1st Bank Routing Number!<BR>"
                  End If
               Else
                  If Not IsValidRoutingNumber(curCol, True, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  I:</B> """ + curCol + """ is not a valid 1st Bank Routing Number!<BR>"
                  End If
               End If

               curCol = row(order(10)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidAccountNumber(curCol, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  J:</B> """ + curCol + """ is not a valid 1st Bank Account Number!<BR>"
                  End If
               Else
                  If Not IsValidAccountNumber(curCol, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  J:</B> """ + curCol + """ is not a valid 1st Bank Account Number!<BR>"
                  End If
               End If

               curCol = row(order(11)).ToString().Trim()
               If Not IsValidString(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  K:</B> """ + curCol + """ is not a valid 1st Bank Name!<BR>"
               End If

               curCol = row(order(12)).ToString().Trim()
               If Not IsValidCheckSaving(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  M:</B> """ + curCol + """ is not a valid Deposit Account Type! Must be (S)avings or (C)hecking.<BR>"
               End If

               curCol = row(order(13)).ToString().Trim()
               If Not IsValidCurrency(curCol, False) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AI:</B> """ + curCol + """ is not a valid Debt Total!<BR>"
               End If

               curCol = row(order(14)).ToString().Trim()
               If Not IsValidString(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AJ:</B> """ + curCol + """ is not valid Missing Information!<BR>"
               End If

               curCol = row(order(15)).ToString().Trim()
               If Not IsValidString(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AK:</B> """ + curCol + """ are not valid Comments!<BR>"
               End If

               '1st Draft 

               'Draft date
               PayMethod = row(order(22)).ToString.Trim
               curCol = row(order(16)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If Not IsValidDraftDate(curCol, True) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AL:</B> """ + curCol + """ is not a valid 1st Draft Date!<BR>"
                  End If
               Else
                  'Draft date
                  If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                     If Not IsValidDraftDate(curCol, True) And Weighted = True Then
                        results += "<B>Error At Row " + idxRow.ToString() + ", Column - AL:</B> """ + curCol + """ is not a valid 1st Draft Date!<BR>"
                     End If
                  Else
                     If Not IsValidDraftDate(curCol, False) Then
                        results += "<B>Error At Row " + idxRow.ToString() + ", Column - AL:</B> """ + curCol + """ is not a valid 1st Draft Date!<BR>"
                     End If
                  End If
               End If
               'Draft Amount
               curCol = row(order(17)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If (Not IsValidDraftCurrency(curCol, True) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AM:</B> """ + curCol + """ is not a valid 1st Draft Amount!<BR>"
                  End If
               Else
                  If (Not IsValidDraftCurrency(curCol, False) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AM:</B> """ + curCol + """ is not a valid Draft Amount!<BR>"
                  End If
               End If
               'Routing number
               curCol = row(order(18)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If (Not IsValidRoutingNumber(curCol, True, False) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AN:</B> """ + curCol + """ is not a valid Bank Routing No!<BR>"
                  End If
               Else
                  If (Not IsValidRoutingNumber(curCol, False, True) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AN:</B> """ + curCol + """ is not a valid Bank Routing No!<BR>"
                  End If
               End If
               'Account Number
               curCol = row(order(19)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If (Not IsValidAccountNumber(curCol, True) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AO:</B> """ + curCol + """ is not a valid Bank Account No!<BR>"
                  End If
               Else
                  If (Not IsValidAccountNumber(curCol, False) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AO:</B> """ + curCol + """ is not a valid Bank Account No!<BR>"
                  End If
               End If
               'Bank Name
               curCol = row(order(20)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If (Not IsValidBankString(curCol, True) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AP:</B> """ + curCol + """ is not a valid Bank Name!<BR>"
                  End If
               Else
                  If (Not IsValidBankString(curCol, False) Or curCol Is Nothing Or curCol = "") And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AP:</B> """ + curCol + """ is not a valid Bank Name!<BR>"
                  End If
               End If

               curCol = row(order(21)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If (Not IsValidCheckSaving(curCol, True) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AR:</B> """ + curCol + """ is not a valid 1st Draft Account Type! Must be (S)avings or (C)hecking.<BR>"
                  End If
               Else
                  If (Not IsValidCheckSaving(curCol, False) Or curCol Is Nothing Or curCol = "") And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AR:</B> """ + curCol + """ is not a valid 1st Draft Account Type! Must be (S)avings or (C)hecking.<BR>"
                  End If
               End If

               curCol = row(order(22)).ToString().Trim()
               If Not Weighted Or PayMethod.ToUpper = "CHECK" Or PayMethod = "" Then
                  If (Not IsValidPmtMethod(curCol, True) Or curCol Is Nothing) And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AQ:</B> """ + curCol + """ is not a valid 1st Draft Deposit Method! Must be ACH or Check.<BR>"
                  End If
               Else
                  If (Not IsValidPmtMethod(curCol, False) Or curCol Is Nothing Or curCol = "") And Weighted = True Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column - AQ:</B> """ + curCol + """ is not a valid 1st Draft Deposit Method! Must be ACH or Check.<BR>"
                  End If
               End If

               'Agency percent
               curCol = row(order(23)).ToString().Trim()
               If Not IsValidRetainerNumber(curCol, True) Then 'Needed to use a string value because at one time we absolutely needed this pct.
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column - AT:</B> """ + curCol + """ is not a valid Retainer Fee Percent!<BR>"
               End If

               curCol = row(order(24)).ToString().Trim
               If Not IsValidBankingType(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column - AU:</B> """ + curCol + """ is not a valid Bank processing code!<BR>"
               End If
               'Is this a valid banking type for this attorney
               Dim ColOk As Boolean
               Select Case CompanyID
                  Case 1, 2
                     If row(order(24)).ToString.ToUpper = "COL" Then
                        ColOk = True
                     ElseIf row(order(24)) Is DBNull.Value Then
                        ColOk = True
                     ElseIf row(order(24)).ToString = "" Then
                        ColOk = True
                     ElseIf row(order(24)).ToString.ToUpper = "CKS" Then
                        ColOk = False
                     End If
                  Case Else
                     ColOk = True
               End Select
               If Not ColOk Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column - AU:</B> """ + curCol + """ is not a valid Bank processing code for this attorney!<BR>"
               End If

               'Agent Name
               curCol = row(order(25)).ToString().Trim()
               If Not IsValidString(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column - AS:</B> """ + curCol + """ is not a valid Agent Name!<BR>"
               End If

               'Second deposit + banking info
               curCol = row(order(26)).ToString().Trim()
               If Not IsValidDepositDay(CInt(Val(curCol.ToString)), True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  N:</B> """ + curCol + """ is not a valid 2nd Deposit Day!<BR>"
               End If

               curCol = row(order(27)).ToString().Trim()
               If Not IsValidCurrency(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  O:</B> """ + curCol + """ is not a valid 2nd Deposit Amount!<BR>"
               End If

               curCol = row(order(28)).ToString().Trim()
               PayMethod = row(order(31)).ToString.Trim
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidRoutingNumber(curCol, False, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  P:</B> """ + curCol + """ is not a valid 2nd Bank Routing Number!<BR>"
                  End If
               Else
                  If Not IsValidRoutingNumber(curCol, True, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  P:</B> """ + curCol + """ is not a valid 2nd Bank Routing Number!<BR>"
                  End If
               End If

               curCol = row(order(29)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidAccountNumber(curCol, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  Q:</B> """ + curCol + """ is not a valid 2nd Bank Account Number!<BR>"
                  End If
               Else
                  If Not IsValidAccountNumber(curCol, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  Q:</B> """ + curCol + """ is not a valid 2nd Bank Account Number!<BR>"
                  End If
               End If

               curCol = row(order(30)).ToString().Trim()
               If Not IsValidString(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  R:</B> """ + curCol + """ is not a valid 2nd Bank Name!<BR>"
               End If

               curCol = row(order(31)).ToString().Trim()
               If Not IsValidPmtMethod(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  S:</B> """ + curCol + """ is not a valid Deposit Method! Must be ACH or CHECK.<BR>"
               End If

               curCol = row(order(32)).ToString().Trim()
               If Not IsValidCheckSaving(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  T:</B> """ + curCol + """ is not a valid 2nd Deposit Account Type! Must be (S)avings or (C)hecking.<BR>"
               End If

               'Third deposit + banking info
               curCol = row(order(33)).ToString().Trim()
               If Not IsValidDepositDay(CInt(Val(curCol.ToString)), True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  U:</B> """ + curCol + """ is not a valid 3rd Deposit Day!<BR>"
               End If

               curCol = row(order(34)).ToString().Trim()
               If Not IsValidCurrency(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  V:</B> """ + curCol + """ is not a valid 3rd Deposit Amount!<BR>"
               End If

               PayMethod = row(order(38)).ToString.Trim
               curCol = row(order(35)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidRoutingNumber(curCol, False, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  W:</B> """ + curCol + """ is not a valid 3rd Bank Routing Number!<BR>"
                  End If
               Else
                  If Not IsValidRoutingNumber(curCol, True, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  W:</B> """ + curCol + """ is not a valid 3rd Bank Routing Number!<BR>"
                  End If
               End If

               curCol = row(order(36)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidAccountNumber(curCol, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  X:</B> """ + curCol + """ is not a valid 3rd Bank Account Number!<BR>"
                  End If
               Else
                  If Not IsValidAccountNumber(curCol, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  X:</B> """ + curCol + """ is not a valid 3rd Bank Account Number!<BR>"
                  End If
               End If

               curCol = row(order(37)).ToString().Trim()
               If Not IsValidString(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  Y:</B> """ + curCol + """ is not a valid 3rd Bank Name!<BR>"
               End If

               curCol = row(order(38)).ToString().Trim()
               If Not IsValidPmtMethod(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  Z:</B> """ + curCol + """ is not a valid Deposit Method! Must be ACH or CHECK.<BR>"
               End If

               curCol = row(order(39)).ToString().Trim()
               If Not IsValidCheckSaving(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AA:</B> """ + curCol + """ is not a valid 3rd Deposit Account Type! Must be (S)avings or (C)hecking.<BR>"
               End If

               'Fourth deposit + banking info
               curCol = row(order(40)).ToString().Trim()
               If Not IsValidDepositDay(CInt(Val(curCol.ToString)), True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AB:</B> """ + curCol + """ is not a valid 4th Deposit Day!<BR>"
               End If

               curCol = row(order(41)).ToString().Trim()
               If Not IsValidCurrency(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AC:</B> """ + curCol + """ is not a valid 4th Deposit Amount!<BR>"
               End If

               PayMethod = row(order(45)).ToString.Trim
               curCol = row(order(42)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidRoutingNumber(curCol, False, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AD:</B> """ + curCol + """ is not a valid 4th Bank Routing Number!<BR>"
                  End If
               Else
                  If Not IsValidRoutingNumber(curCol, True, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AD:</B> """ + curCol + """ is not a valid 4th Bank Routing Number!<BR>"
                  End If
               End If

               PayMethod = row(order(45)).ToString.Trim
               curCol = row(order(43)).ToString().Trim()
               If PayMethod.ToUpper = "ACH" Then
                  If Not IsValidAccountNumber(curCol, False) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AE:</B> """ + curCol + """ is not a valid 4th Bank Account Number!<BR>"
                  End If
               Else
                  If Not IsValidAccountNumber(curCol, True) Then
                     results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AE:</B> """ + curCol + """ is not a valid 4th Bank Account Number!<BR>"
                  End If
               End If

               curCol = row(order(44)).ToString().Trim()
               If Not IsValidString(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AF:</B> """ + curCol + """ is not a valid 4th Bank Name!<BR>"
               End If

               curCol = row(order(45)).ToString().Trim()
               If Not IsValidPmtMethod(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AG:</B> """ + curCol + """ is not a valid Deposit Method! Must be ACH or CHECK.<BR>"
               End If

               curCol = row(order(46)).ToString().Trim()
               If Not IsValidCheckSaving(curCol, True) Then
                  results += "<B>Error At Row " + idxRow.ToString() + ", Column -  AH:</B> """ + curCol + """ is not a valid 4th Deposit Account Type! Must be (S)avings or (C)hecking.<BR>"
               End If

               'If sheet.Columns.Count > 18 Then
               '   'BankProcessing or how to handle processing the banking for this client. Which account to process through
               '   If order.Count - 1 > 45 Then

               '   End If

               '   'This is for handling the CommScen for Client
               '   'If order.Count >= 20 Then 'Ok lets add the next set of data fix for everything including the scenario number
               '   'curCol = row(order(20)).ToString().Trim()
               '   'Dim x As Integer = 0
               '   'Dim ScenOK As Boolean = False
               '   'If Not IsValidNumber(curCol, True) Or curCol Is Nothing Then
               '   'For x = 0 To ScenarioIDs.Length - 1
               '   'If (ScenarioIDs(x) = Val(curCol) Or curCol Is Nothing) And ScenarioCounter >= 1 Then
               '   'ScenOK = True
               '   'End If
               '   'Next
               '   'If Not ScenOK Then
               '   'results += "<B>Error At Row " + idxRow.ToString() + ", Column - S:</B> """ + curCol + """ is not a valid Fee Structure!<BR>"
               '   'End If
               '   'End If
               '   'End If
               'End If
TryAnotherRow:
               DepositDays.Clear()
            Next
         Catch ex As Exception
            ImportLog += "<td>" & Now & (": There was an error on Row " & idxRow.ToString & " of the spread sheet.</td>")
         End Try
      End If
StopImport:
      If results <> "" Then
         ImportLog += "<td>" & Now & ": " & results & "</td>"
         Duplicates = ""
      Else
         ImportLog += "<td>" & Now & ": Spread sheet validated successfully.</td>"
      End If
      Return results
   End Function

   Private Function ValidateHeaders(ByVal sheet As DataTable) As Dictionary(Of Integer, Integer)
      Dim order As New Dictionary(Of Integer, Integer)
      Dim toRemove As New List(Of Integer)
      Dim curHeader As String
      Dim err As String = ""

      'Modified code to handle multi deposits 04/01/2009 and then again 04/30/2009 for a layout and field name change Jhope
      'Had to modify code again because of another layout and field name change 05/07/2009 JHope

      ImportLog += "<td>" & Now & "Validating spread sheet headers: </td>"

      For idx As Integer = 0 To sheet.Columns.Count - 1
         curHeader = sheet.Columns(idx).ColumnName.ToString().ToLower()

         If curHeader.Contains("lead") And curHeader.Contains("number") Then
            sheet.Columns(idx).ColumnName = "Lead Number"
            order.Add(0, idx)
         ElseIf curHeader.Contains("date") And curHeader.Contains("sent") Then
            sheet.Columns(idx).ColumnName = "Date Sent"
            order.Add(1, idx)
         ElseIf curHeader.Contains("date") And curHeader.Contains("received") Then
            sheet.Columns(idx).ColumnName = "Date Received"
            order.Add(2, idx)
         ElseIf curHeader.Contains("first") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "First Name"
            order.Add(3, idx)
         ElseIf curHeader.Contains("last") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "Last Name"
            order.Add(4, idx)
         ElseIf (curHeader.Contains("social") And curHeader.Contains("security")) Or curHeader.Contains("ssn") Then
            sheet.Columns(idx).ColumnName = "Social Security No#"
            order.Add(5, idx)
            'Ok the new changes for multi deposit start on the next line, and below.
         ElseIf curHeader.Contains("1st deposit") And curHeader.Contains("method") Then
            sheet.Columns(idx).ColumnName = "1st Deposit Method"
            order.Add(6, idx)
         ElseIf curHeader.Contains("1st deposit") And curHeader.Contains("date") Then
            sheet.Columns(idx).ColumnName = "1st Deposit Date"
            order.Add(7, idx)
         ElseIf curHeader.Contains("1st deposit") And curHeader.Contains("amount") Then
            sheet.Columns(idx).ColumnName = "1st Deposit Amount"
            order.Add(8, idx)
         ElseIf curHeader.Contains("1st bank") And curHeader.Contains("routing") Then
            sheet.Columns(idx).ColumnName = "1st Bank Routing"
            order.Add(9, idx)
         ElseIf curHeader.Contains("1st bank") And curHeader.Contains("account") Then
            sheet.Columns(idx).ColumnName = "1st Bank Account"
            order.Add(10, idx)
         ElseIf curHeader.Contains("1st bank") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "1st Bank Name"
            order.Add(11, idx)
         ElseIf curHeader.Contains("1st checking") And curHeader.Contains("savings") Then
            sheet.Columns(idx).ColumnName = "1st Checking Savings"
            order.Add(12, idx)
         ElseIf curHeader.Contains("debt") And curHeader.Contains("total") Then
            sheet.Columns(idx).ColumnName = "Debt Total"
            order.Add(13, idx)
         ElseIf curHeader.Contains("missing") And curHeader.Contains("info") Then
            sheet.Columns(idx).ColumnName = "Missing Info"
            order.Add(14, idx)
         ElseIf curHeader.Contains("comments") Then
            sheet.Columns(idx).ColumnName = "Comments"
            order.Add(15, idx)
         ElseIf curHeader.Contains("1st draft") And curHeader.Contains("date") Then
            sheet.Columns(idx).ColumnName = "1st Draft Date"
            order.Add(16, idx)
         ElseIf curHeader.Contains("1st draft") And curHeader.Contains("amount") Then
            sheet.Columns(idx).ColumnName = "1st Draft Amount"
            order.Add(17, idx)
         ElseIf curHeader.Contains("1st draft") And curHeader.Contains("routing") Then
            sheet.Columns(idx).ColumnName = "1st Draft Routing No"
            order.Add(18, idx)
         ElseIf curHeader.Contains("1st draft") And curHeader.Contains("account") Then
            sheet.Columns(idx).ColumnName = "1st Draft Account No"
            order.Add(19, idx)
         ElseIf curHeader.Contains("1st draft") And curHeader.Contains("bank name") Then
            sheet.Columns(idx).ColumnName = "1st Draft Bank Name"
            order.Add(20, idx)
         ElseIf curHeader.Contains("draft") And curHeader.Contains("savings") Then
            sheet.Columns(idx).ColumnName = "Draft Checking Savings"
            order.Add(21, idx)
         ElseIf curHeader.Contains("draft") And curHeader.Contains("method") Then
            sheet.Columns(idx).ColumnName = "Draft Deposit Method"
            order.Add(22, idx)
         ElseIf curHeader.Contains("retainer") Then
            sheet.Columns(idx).ColumnName = "Retainer"
            order.Add(23, idx)
         ElseIf curHeader.Contains("banking") And curHeader.Contains("type") Then
            sheet.Columns(idx).ColumnName = "Banking Type"
            order.Add(24, idx)
         ElseIf curHeader.Contains("agent") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "Agent Name"
            order.Add(25, idx)
         ElseIf curHeader.Contains("2nd deposit") And curHeader.Contains("day") Then
            sheet.Columns(idx).ColumnName = "2nd Deposit Day"
            order.Add(26, idx)
         ElseIf curHeader.Contains("2nd deposit") And curHeader.Contains("amount") Then
            sheet.Columns(idx).ColumnName = "2nd Deposit Amount"
            order.Add(27, idx)
         ElseIf curHeader.Contains("2nd bank") And curHeader.Contains("routing") Then
            sheet.Columns(idx).ColumnName = "2nd Bank Routing"
            order.Add(28, idx)
         ElseIf curHeader.Contains("2nd bank") And curHeader.Contains("account") Then
            sheet.Columns(idx).ColumnName = "2nd Bank Account"
            order.Add(29, idx)
         ElseIf curHeader.Contains("2nd bank") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "2nd Bank Name"
            order.Add(30, idx)
         ElseIf curHeader.Contains("2nd deposit") And curHeader.Contains("method") Then
            sheet.Columns(idx).ColumnName = "2nd Deposit Method"
            order.Add(31, idx)
         ElseIf curHeader.Contains("2nd checking") And curHeader.Contains("savings") Then
            sheet.Columns(idx).ColumnName = "2nd Checking Savings"
            order.Add(32, idx)
         ElseIf curHeader.Contains("3rd deposit") And curHeader.Contains("day") Then
            sheet.Columns(idx).ColumnName = "3rd Deposit Day"
            order.Add(33, idx)
         ElseIf curHeader.Contains("3rd deposit") And curHeader.Contains("amount") Then
            sheet.Columns(idx).ColumnName = "3rd Deposit Amount"
            order.Add(34, idx)
         ElseIf curHeader.Contains("3rd bank") And curHeader.Contains("routing") Then
            sheet.Columns(idx).ColumnName = "3rd Bank Routing"
            order.Add(35, idx)
         ElseIf curHeader.Contains("3rd bank") And curHeader.Contains("account") Then
            sheet.Columns(idx).ColumnName = "3rd Bank Account"
            order.Add(36, idx)
         ElseIf curHeader.Contains("3rd bank") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "3rd Bank Name"
            order.Add(37, idx)
         ElseIf curHeader.Contains("3rd deposit") And curHeader.Contains("method") Then
            sheet.Columns(idx).ColumnName = "3rd Deposit Method"
            order.Add(38, idx)
         ElseIf curHeader.Contains("3rd checking") And curHeader.Contains("savings") Then
            sheet.Columns(idx).ColumnName = "3rd Checking Savings"
            order.Add(39, idx)
         ElseIf curHeader.Contains("4th deposit") And curHeader.Contains("day") Then
            sheet.Columns(idx).ColumnName = "4th deposit day"
            order.Add(40, idx)
         ElseIf curHeader.Contains("4th deposit") And curHeader.Contains("amount") Then
            sheet.Columns(idx).ColumnName = "4th Deposit Amount"
            order.Add(41, idx)
         ElseIf curHeader.Contains("4th bank") And curHeader.Contains("routing") Then
            sheet.Columns(idx).ColumnName = "4th Bank Routing"
            order.Add(42, idx)
         ElseIf curHeader.Contains("4th bank") And curHeader.Contains("account") Then
            sheet.Columns(idx).ColumnName = "4th Bank Account"
            order.Add(43, idx)
         ElseIf curHeader.Contains("4th bank") And curHeader.Contains("name") Then
            sheet.Columns(idx).ColumnName = "4th Bank Name"
            order.Add(44, idx)
         ElseIf curHeader.Contains("4th deposit") And curHeader.Contains("method") Then
            sheet.Columns(idx).ColumnName = "4th Deposit Method"
            order.Add(45, idx)
         ElseIf curHeader.Contains("4th checking") And curHeader.Contains("savings") Then
            sheet.Columns(idx).ColumnName = "4th Checking Savings"
            order.Add(46, idx)
            'ElseIf curHeader.Contains("fee") And curHeader.Contains("structure") Then
            'sheet.Columns(idx).ColumnName = "Fee Structure"
            'order.Add(48, idx)
         Else
            err += """" + curHeader.Trim() + """ is not a valid header!<BR>"
            ImportLog += "<td>" & Now & ": Validating spread sheet data and formating: Failed</td>"
            toRemove.Add(idx)
         End If
      Next

      If toRemove.Count > 0 Then
         For idx As Integer = 0 To toRemove.Count - 1
            sheet.Columns.RemoveAt(toRemove.Item(idx))
         Next
      End If

      'If sheet.Columns.Count < 20 Then
      'We are short the scenario column
      'err = "The header - Fee Structure - is missing on the spread sheet!<BR>"
      'End If

      'If err.Length > 0 And (Not sheet.Columns.Count = 12 Or Not sheet.Columns.Count = 18) Then
      If err.Length > 0 And Not sheet.Columns.Count >= 42 Then
         Throw New Exception(err)
      End If

      Return order
   End Function

   Private Function CompareSheets(ByVal sheet1 As DataTable, ByVal sheet2 As DataTable, ByRef which As String) As String
      Dim curCol1 As String
      Dim curCol2 As String
      Dim rowNum1 As Integer = 0
      Dim row2 As DataRow
      Dim numNulls As Integer
      Dim tempRes As String
      Dim results As String = ""

      If sheet1.Rows.Count < sheet2.Rows.Count Or sheet1.Columns.Count < sheet2.Columns.Count Then
         Dim tempTable As DataTable = sheet2

         sheet2 = sheet1
         sheet1 = tempTable
      End If

      which = sheet2.TableName.ToString()

      For Each row As DataRow In sheet1.Rows
         rowNum1 += 1
         numNulls = 0

         tempRes = ""

         For col1 As Integer = 0 To sheet1.Columns.Count - 1
            curCol1 = row(col1).ToString().Trim()

            If curCol1.Length > 0 Then
               numNulls += 1
            End If

            If rowNum1 < sheet2.Rows.Count + 1 And col1 < sheet2.Columns.Count Then
               row2 = sheet2.Rows(rowNum1 - 1)
               curCol2 = row2(col1).ToString().Trim()

               If Not curCol1 = curCol2 Then
                  If curCol1.Length > curCol2.Length Or Not curCol1.ToLower() = "ach" Then
                     tempRes += "<FONT color=""green"">" + sheet1.TableName.ToString() + "</FONT> and " + sheet2.TableName.ToString() + " row " + rowNum1.ToString() + ", column " + CStr(Chr(65 + col1)) + ": ""<FONT color=""green"">" + curCol1 + "</FONT>"" and """ + curCol2 + """<BR>"
                  Else
                     tempRes += sheet1.TableName.ToString() + " and <FONT color=""green"">" + sheet2.TableName.ToString() + "</FONT> row " + rowNum1.ToString() + ", column " + CStr(Chr(65 + col1)) + ": """ + curCol1 + """ and ""<FONT color=""green"">" + curCol2 + "</FONT>""<BR>"
                  End If
               End If
            End If
         Next

         If tempRes.Length > 0 And numNulls < sheet1.Columns.Count Then
            results += tempRes
         End If
      Next

      Return results
   End Function

#End Region

#Region "IsValid_"
   Private Function IsValidNumber(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (Regex.IsMatch(str, "^\d+$") Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return Regex.IsMatch(str, "^\d+$")
   End Function

   Private Function IsValidRoutingNumber(ByVal str As String, ByVal canBeNull As Boolean, ByVal mustFill As Boolean)

      Dim objClient As New WCFClient.Store

      If canBeNull And (str = "" Or str.ToLower() = "null") And str.Length = 0 And mustFill = False Then
         Return True
      ElseIf canBeNull And (str = "" Or str.ToLower = "null" Or str.Length <> 9) And mustFill = False Then
         Return False
      ElseIf Not canBeNull And (str <> "" Or str.ToLower() <> "null") And str.Length = 9 And mustFill = True Then
         Return True
      ElseIf Not canBeNull And (str = "" Or str.ToLower() = "null" Or str.Length <> 9) And mustFill = True Then
         Return False
      Else
         Return objClient.RoutingIsValid(str, Nothing)
      End If
      Return objClient.RoutingIsValid(str, Nothing)
   End Function

   Private Function IsValidDate(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (DateTime.TryParse(str, Nothing) Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return DateTime.TryParse(str, Nothing) 'Does not raise an error
   End Function

   Private Function IsValidPmtMethod(ByVal str As String, ByVal canBeNull As Boolean) As Boolean
      If canBeNull And (str = "" Or str.ToLower() = "null" Or str.Length = 0) Then
         Return True
      Else
         If str.ToUpper() = "ACH" Or str.ToUpper = "CHECK" Then
            Return True
         Else
            Return False
         End If
      End If

   End Function

   Private Function IsValidString(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (Not (IsValidNumber(str, False) Or IsValidDate(str, False)) Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return Not (IsValidNumber(str, False) Or IsValidDate(str, False))
   End Function

   Private Function IsValidSSN(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return ((str.Length = 11 AndAlso (IsValidNumber(str.Substring(0, 3), False) And IsValidNumber(str.Substring(4, 2), False) And IsValidNumber(str.Substring(7, 4), False))) Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return (str.Length = 11 AndAlso (IsValidNumber(str.Substring(0, 3), False) And IsValidNumber(str.Substring(4, 2), False) And IsValidNumber(str.Substring(7, 4), False)))
   End Function

   Private Function IsValidCurrency(ByVal str As String, ByVal canBeNull As Boolean)
      Return (Regex.IsMatch(str, "^-?\d+(\.\d{2})?$") Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
   End Function

   Private Function IsValidDraftCurrency(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (Regex.IsMatch(str, "^-?\d+(\.\d{2})?$") Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      'Return (Regex.IsMatch(str, "^-?\d+(\.\d{2})?$"))
      If Left(str, 1) = "$" Then
         str = Int(str)
      End If
      Return Regex.IsMatch(str, "^(-)?\d+(\.\d\d)?$")
   End Function

   Private Function IsValidDraftDate(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (DateTime.TryParse(str, Nothing) Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return DateTime.TryParse(str, Nothing)
   End Function

   Private Function IsValidAccountNumber(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (Regex.IsMatch(str, "^\d+$") Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return Regex.IsMatch(str, "^\d+$")
   End Function

   Private Function IsValidBankString(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (Not (IsValidNumber(str, False) Or IsValidDate(str, False)) Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return Not (IsValidNumber(str, False) Or IsValidDate(str, False))
   End Function

   Private Function IsValidRetainerNumber(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Return (Regex.IsMatch(str, "^\d+$") Or str = "" Or str.ToLower() = "null" Or Not str.Length > 0)
      End If
      Return Regex.IsMatch(str, "^\d+$")
   End Function

   Private Function IsValidDepositDay(ByVal Day As Integer, ByVal canBeNull As Boolean) As Boolean
      Dim x As Int16 = 0
      Dim y As Int16 = 0
      Dim i As Int16 = 0

      If canBeNull Then
         If Day <= 0 Then
            Return True
         Else
            DepositDays.Add(Day)
            DepositDays.Sort()
            If DepositDays.Count > 1 Then
               For x = 1 To DepositDays.Count - 1
                  If DepositDays(x) - DepositDays(x - 1) < 7 Then
                     Return False
                  End If
               Next
            End If
         End If
      End If
      Return True

   End Function

   Private Function IsValidBankingType(ByVal str As String, ByVal canBeNull As Boolean)
      If canBeNull Then
         Select Case str.ToUpper
            Case "", "CKS"
               str = str.ToUpper()
               Return (IsValidString(str, canBeNull))
            Case Else
               str = str.ToUpper
               Return Not (IsValidNumber(str, False) Or IsValidDate(str, False))
         End Select
      End If
      str = str.ToUpper
      Return Not (IsValidNumber(str, False) Or IsValidDate(str, False))
   End Function

   Private Function IsDuplicatedSS(ByVal str As String, ByVal sheet As DataTable, ByVal order As Dictionary(Of Integer, Integer), ByVal idxRow As Integer) As String
      Dim curCol As String
      Dim results As String = ""
      Dim x As Integer = 0
      Dim Dup(0) As Integer
      Dim StartingRow As Integer = idxRow + 1 'Since we go through a full iteration get a starting row
      idxRow = 1 'Back to the full iteration

      If str.Length > 0 Then
         For Each row As DataRow In sheet.Rows
            idxRow += 1
            If idxRow > sheet.Rows.Count - 1 Then
               Return results
            End If

            If row(order(3)).ToString = "" And row(order(4)).ToString = "" Then
               'We are done here this is a completely blank row, try the next one.
               sheet.Rows.Remove(row)
               GoTo TryAnotherRow
            End If

            If StartingRow = idxRow Then 'Find the starting point
               curCol = row(order(5)).ToString().Trim()
               If curCol = str.Trim Then 'Are they equal, there will be one that is
                  Dup(x) += idxRow
                  results += "<B>Error At Row " + CStr(StartingRow - 1) + ", Column -  F:</B> """ + curCol + """ There are duplicate Social Security Numbers on this sheet!<BR>"
                  results += "<B>Error At Row " + Dup(x).ToString() + ", Column -  F:</B> """ + curCol + """ There are duplicate Social Security Numbers on this sheet!<BR>"
                  x += 1
               End If
            End If

TryAnotherRow:
            ReDim Preserve Dup(x) 'Ratchet up
         Next

         'ReDim Preserve Dup(x - 1) 'You're one over so fix it.
         If Dup.Length < 1 Then
            results = ""
            ReDim Dup(0)
         End If
      Else
         results += "<B>Error At Row " + CStr(idxRow + 1) & ", Column - F:</B> " & " Does not contain a Social Security Number!<BR>"
         ReDim Preserve Dup(x)
      End If
      Return results
   End Function

   Private Function IsValidCheckSaving(ByVal str As String, ByVal canBeNull As Boolean) As Boolean
      If canBeNull Then
         Select Case str.ToUpper
            Case "", "C", "S"
               str = str.ToUpper()
               Return (IsValidString(str, canBeNull))
            Case Else
               Return Not (IsValidNumber(str, False) Or IsValidDate(str, False))
         End Select
      End If
      Return Not (IsValidNumber(str, False) Or IsValidDate(str, False))
   End Function

   Private Function ValidateFormatting(ByVal filepath As String) As Boolean
      Dim m_xl As Microsoft.Office.Interop.Excel.Application = Nothing
      Dim wb As Microsoft.Office.Interop.Excel.Workbook = Nothing
      Dim xlHeader As String
      Dim y As Integer = 65
      Dim z As Integer
      Dim Alpha As String

      Try
         m_xl = New Microsoft.Office.Interop.Excel.Application
         wb = m_xl.Workbooks.Open(filepath)
         m_xl.Visible = False
         wb.Activate()
      Catch ex As Exception
         HandleMessage("Error opening sheet: " & ex.Message)
      End Try

      Try
         Dim xlSheet As Excel.Worksheet = wb.Sheets.Item(1)
         Dim xlCols As Integer = xlSheet.UsedRange.Columns.Count
         '********workaround*******
         If xlCols > 47 Then xlCols = 47
         '***********************
         Dim xlRows As Integer = xlSheet.UsedRange.Rows.Count
         Dim x As Integer
         With xlSheet
            For x = 0 To xlCols - 1
               y += x
               If y > 90 Then
                  z = y - 26
                  Alpha = Chr(65).ToString + Chr(z).ToString
               Else
                  Alpha = Chr(y)
               End If
               .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
               xlHeader = .Range(Alpha.ToString & "1").Value.ToString
               If xlHeader.Contains("Date") Then
                  .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
                  .Range(Alpha.ToString & ":" & Alpha.ToString).NumberFormat = "m/d/yyyy"
                  .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
               ElseIf xlHeader.Contains("Amount") Or xlHeader.Contains("Total") Then
                  .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
                  .Range(Alpha.ToString & ":" & Alpha.ToString).NumberFormat = "$#,##0.00"
                  .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
               ElseIf xlHeader.Contains("Routing") Or xlHeader.Contains("Account") Then
                  .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
                  .Range(Alpha.ToString & ":" & Alpha.ToString).NumberFormat = "@"
                  .Range(Alpha.ToString & ":" & Alpha.ToString).Select()
               Else
                  .Range(Alpha.ToString & "2" & ":" & Alpha & xlRows.ToString).Select()
                  .Range(Alpha.ToString & "2" & ":" & Alpha.ToString & xlRows.ToString).NumberFormat = "General"
                  .Range(Alpha.ToString & "1" & ":" & Alpha.ToString & "1").Select()
               End If
               y = 65
            Next
            wb.Save()
            xlSheet = Nothing
         End With
      Catch ex As Exception
         HandleMessage("Error parsing sheet: " & ex.Message)
      End Try

      Try
         If Not wb Is Nothing Then
            wb.Close()
         End If

         If Not m_xl.Application Is Nothing Then
            m_xl.Application.Quit()
         End If

         If Not m_xl Is Nothing Then
            m_xl.Quit()
         End If
      Catch ex As Exception

      Finally
         m_xl = Nothing
         wb = Nothing
      End Try

   End Function

#End Region

   Private Function GetSheets(ByVal path As String) As List(Of String)
      Dim sheets As New List(Of String)
      Dim ExcelSheets As DataTable

      Try
         Using objDataConn As New OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + path + ";Extended Properties=""Excel 12.0;HDR=YES""")
            Try
               objDataConn.Open()

               ExcelSheets = objDataConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, New Object() {Nothing, Nothing, Nothing, "TABLE"})
            Catch ex As OleDbException
               Throw New Exception("Microsoft.ACE failed to initialize. " & ex.Message & ". Please contact your system administrator.")
            End Try

            Try
               For i As Integer = 0 To 0 'ExcelSheets.Rows.Count - 1 'This was when we were expecting multiple sheets no more.......
                  'Make sure the filename and sheet names match
                  If path.Contains(Mid(ExcelSheets.Rows(i).Item("TABLE_NAME").ToString(), 2, Len(ExcelSheets.Rows(i).Item("TABLE_NAME").ToString()) - 3)) Then
                     sheets.Add(ExcelSheets.Rows(i).Item("TABLE_NAME").ToString())
                  Else
                     'They did not match. Throw an error
                     Throw New Exception("")
                  End If
               Next
            Catch ex As Exception
               Throw New Exception("Could not add this sheet. Spread sheet tab and file name do not match. Please change the tab at the bottom of the spread sheet to match the attorney in the spreadsheet's file name or contact your manager.")
            End Try
         End Using
      Catch ex As OleDbException
         Throw New Exception("Please copy from the main sheet into a new sheet to get rid of blank rows, then delete the original sheet and try again.")
      End Try

      Return sheets
   End Function

   Private Function ImportSheet(ByVal table As DataTable) As String
      Dim batchDate As String = txtDate.Text
      Dim company As String = ddlCompany.SelectedItem.Text
      Dim companyID As Integer = Integer.Parse(ddlCompany.SelectedItem.Value)
      Dim agencyCode As String = ddlAgency.SelectedItem.Text
      Dim agencyID As Integer = Integer.Parse(ddlAgency.SelectedItem.Value)
      Dim colNames As String = ""
      Dim nameEx As String = ""
      Dim y As Integer = -1
      Dim dFailed As Dictionary(Of Integer, String)
      Dim CopyIn As Boolean = False

      'Modified code to handle multi deposits 04/01/2009 and then again 04/30/2009 for a layout, field name and table change Jhope

      ImportLog += "<tr style=""font-weight:normal"">" & Now & ": Importing spread sheet client data:</td>"

      Try

         For idx As Integer = 0 To table.Columns.Count - 1
            colNames += "[" + table.Columns(idx).ColumnName.ToString() + "], "
         Next

         colNames = colNames.Substring(0, colNames.Length - 2)

         If company = "" Then
            nameEx = "Incorrect file name! Must contain <FONT color=""red"">company name</FONT>, "
         Else
            nameEx = "Incorrect file name! Must contain company name, "
         End If

         If agencyID = -1 Then
            nameEx += "<FONT color=""red"">agency name</FONT>, and "
         Else
            nameEx += "agency name, and "
         End If

         If batchDate = "" Then
            nameEx += "<FONT color=""red"">process date (mm-dd-yyy)</FONT>."
         Else
            nameEx += "process date (mm-dd-yyy)."
         End If

         If nameEx.Length > 90 Then
            Throw New Exception(nameEx.Length.ToString())
         End If

         Using cmd As New SqlCommand("SELECT TOP 1 [Code] FROM tblAgency WHERE AgencyID = " + agencyID.ToString(), New SqlConnection(connStrDMS))
            Using cmd.Connection
               cmd.Connection.Open()
               agencyCode = cmd.ExecuteScalar().ToString().ToLower()
            End Using
         End Using

         If Not agencyCode.Length > 0 Then
            Throw New Exception("Invalid agency specified!")
         End If

         'GoTo ReportingStarts

         Dim newTable As String = ""
         Dim numNulls As Integer

         newTable = "_import_agbatch_" + agencyCode.ToLower() & company.ToLower() & "_" & batchDate

         ReDim EqualRows(0) 'Clear the array, just in case, it's private to this pages code
         EqualRows(0) = False 'Make sure this is set before the routine is called

         If CheckForDuplicate(table, newTable) Then
            If Duplicates = "ALL" Then
               Throw New Exception("The spreadsheet " + newTable & " has already had all it's clients imported! These clients can not be re-imported.")
            Else
               HandleMessage(Duplicates)
            End If
         End If

         Using cmd As New SqlCommand("SELECT count(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '" & newTable & "_1" & "'", New SqlConnection(connStrImport))
            Using cmd.Connection
               cmd.Connection.Open()
               y = cmd.ExecuteScalar() 'Does the 1st table exist?

               'Create another incremented table name if others exist
               Dim x As Integer = 2
               Do While y > 0
                  cmd.CommandText = "SELECT count(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '" & newTable & "_" & CStr(x) & "'"
                  y = cmd.ExecuteScalar()
                  x += 1
               Loop

               'How many scenarios has this client got? Is it only a default
               'ScenarioCounter = GetAllScenarios(companyID, agencyID)

               'Modified 4/7 jhope to handle multiple deposits
               'Modified 4/30 jhope layout changes
               'Modified 5/7 jhope more layout changes
               Try 
                        cmd.CommandText = "CREATE TABLE [dbo].[" & newTable & "_" & CStr(x - 1) & "] ([Lead Number] [nvarchar](255) NULL, [Date Sent] [datetime] NULL, [Date Received] [nvarchar](255) NULL, [First Name] [nvarchar](255) NULL, [Last Name] [nvarchar](255) NULL, [Social Security No#] [nvarchar](255) NULL, [1st Deposit Method] [nvarchar](255) NULL, [1st Deposit Date] [datetime] NULL, [1st Deposit Amount] [money] NULL, [1st Bank Routing] [nvarchar](255) NULL, [1st Bank Account] [nvarchar](255) NULL, [1st Bank Name] [nvarchar](255) NULL, [1st Checking Savings] [nvarchar](255) NULL, [Debt Total] [money], [Missing Info] [nvarchar](255) NULL, [Comments] [nvarchar](255) NULL, [1st Draft Date] [datetime] NULL, [1st Draft Amount] [money] NULL, [1st Draft Routing No] [nvarchar](255) NULL, [1st Draft Account No] [nvarchar](255) NULL, [1st Draft Bank Name] [nvarchar](255) NULL, [Draft checking Savings] [nvarchar](255) NULL, [Draft Deposit Method] [nvarchar](255) NULL, [Retainer] [nvarchar](255) NULL, [Banking Type] [nvarchar](255) NULL, [Agent Name] [nvarchar](255) NULL, [2nd Deposit Day] [int] NULL, [2nd Deposit Amount] [money] NULL, [2nd Bank Routing] [nvarchar](255) NULL, [2nd Bank Account] [nvarchar](255) NULL, [2nd Bank Name] [nvarchar](255) NULL, [2nd Deposit Method] [nvarchar](255) NULL, [2nd Checking Savings] [nvarchar](255) NULL, [3rd Deposit Day] [int] NULL, [3rd Deposit Amount] [money] NULL, [3rd Bank Routing] [nvarchar](255) NULL, [3rd Bank Account] [nvarchar](255) NULL, [3rd Bank Name] [nvarchar](255) NULL, [3rd Deposit Method] [nvarchar](255) NULL, [3rd Checking Savings] [nvarchar](255) NULL, [4th Deposit Day] [int] NULL, [4th Deposit Amount] [money] NULL, [4th Bank Routing] [nvarchar](255) NULL, [4th Bank Account] [nvarchar](255) NULL, [4th Bank Name] [nvarchar](255) NULL, [4th Deposit Method] [nvarchar](255) NULL, [4th Checking Savings] [nvarchar](255) NULL) ON [PRIMARY]"
                  cmd.ExecuteNonQuery()
               Catch ex As SqlException
                  Alert.Show("Error creating table in the database. " & ex.Message)
               End Try

                  Dim commStr As String
                  Dim column As String
                  y = x - 1
                  x = 1

                  Dim bankName As String = "NA"

                  For Each row As DataRow In table.Rows
                     'check for blank row as the end of the spread sheet.
                     If row.Item("First Name").ToString Is DBNull.Value And row.Item("Last Name").ToString Is DBNull.Value Then
                        row.Delete()
                        GoTo DoNextRow
                     Else
                        If row.Item("First Name").ToString = "" And row.Item("Last Name").ToString = "" Then
                           row.Delete()
                           GoTo DoNextRow
                        End If
                     End If

                     If EqualRows(x - 1) = False Then
                        numNulls = 0

                        commStr = "INSERT INTO [" & newTable & "_" & CStr(y) & "] (" + colNames + ") VALUES ("
                        For Each col As DataColumn In table.Columns

                           'Assign default Scenario Counter
                           'If col.ColumnName = "Fee Structure" And ScenarioCounter = 1 Then
                           'row(col) = 1
                           'End If

                           If Not (row(col) Is DBNull.Value Or row(col).ToString().Trim().Length = 0) Then
                              column = CStr(row(col)).Replace("'", "''").Trim()

                              If col.ColumnName.ToLower.Contains("bank") And col.ColumnName.ToLower.Contains("routing") And (col.ColumnName.ToLower.Contains("no") Or col.ColumnName.ToLower.Contains("number")) Or (col.ColumnName.ToLower.Contains("bank") And col.ColumnName.ToLower.Contains("account")) Then
                                 column = "'" + column + "'"
                              ElseIf col.ColumnName.ToLower.Contains("bank") And col.ColumnName.ToLower.Contains("name") And column = "" Then
                                 column = bankName
                              End If

                              If IsValidNumber(column, False) And Not column.StartsWith("0") And Not column.Contains("'") Then
                                 commStr += column
                              ElseIf column.Contains("'") Then
                                 commStr += column
                              Else
                                 commStr += "'" + column + "'"
                              End If
                           Else
                              commStr += "NULL"
                              numNulls += 1
                           End If
                           commStr += ", "
                        Next

                        If numNulls = table.Columns.Count Then
                           Exit For
                        End If

                        cmd.CommandText = commStr.Substring(0, commStr.Length - 2) + ")"
                        cmd.ExecuteNonQuery()
                     End If
DoNextRow:
                     x += 1
                  Next
            End Using
         End Using

         Dim dr As SqlDataReader
         Dim importId As Integer
         Dim numClients As Integer
            Dim numOpenedAccounts As Integer '*************************CkSite

            newTable = newTable & "_" & CStr(y - 1)

            Using cmd As New SqlCommand("exec stp_ClientImport " + companyID.ToString() + ", " + agencyID.ToString() + ", '" & newTable & "'", New SqlConnection(connStrDMS))
                Using cmd.Connection
                    cmd.Connection.Open()

                    cmd.CommandTimeout = 300

                    dr = cmd.ExecuteReader
                    If dr.Read Then
                        result += CStr(dr(0))
                        numClients = CInt(dr(1))
                        importId = CInt(dr(2))
                    End If
                    dr.Close()
                End Using
            End Using

         If Duplicates = "ALL" Then
            result = "All of these clients have been imported before and will not be duplicated. No clients were imported from this spread sheet."
            ImportLog += "<tr style=""font-weight:normal color:red"">" & Now & ": Importing spread sheet clients: Aborted</td>"
         ElseIf InStr(Duplicates, "did not get imported") > 0 Then
            result = result & " Some, of the clients on this spread sheet have already been imported. Any duplicated clients in the system were not imported."
            ImportLog += "<tr style=""font-weight:normal; color:red"">" & Now & ": Importing spread sheet client data: There were some duplicate clients that were not imported.</td>"
         Else
            result += "<td style=""font-weight:normal color:green"">" & Now & ": " & "Importing spread sheet client data: Successful!</td>"
            ImportLog += "<br><tr style=""font-weight:normal color:green"">" & Now & ": Importing spread sheet clients: Successful!</td>"
         End If

         'Setup client virtual accounts with CheckSite************************
         If companyID > 2 And Duplicates <> "ALL" Then 'All new companies (settlement attorneys) use checksite by default, do not create duplicate stores
            Dim store As New WCFClient.Store
            numOpenedAccounts = store.OpenAccounts(importId, UserID)
            If numOpenedAccounts > 0 Then
               result &= " " & CStr(numOpenedAccounts) & " Shadow Store Accounts opened."
            End If
            dFailed = store.OpenAccountFailture   'stored failed calls
            store = Nothing
            'show failed open account info
            If dFailed.Count > 0 Then
               CopyIn = True
               result &= vbCrLf & vbTab & CStr(dFailed.Count) & " Shadow Store Accounts failed and did not open. The clients have been imported regardless.<br>"
               For Each kvp As KeyValuePair(Of Integer, String) In dFailed
                  result &= vbCrLf & vbTab & vbTab & "Client ID: " & kvp.Key & "  Error: " & kvp.Value & vbCrLf
                  ImportLog += "<br><tr style=""font-weight:normal color:red"">" & Now & ": Shadow Store Accounts failed and did not open: Failed</td>"
               Next
            End If
         End If

         If Not result.ToLower().Contains("client data: successful!") Then
            Throw New Exception("Error: <FONT color=""red"">" + result + "</FONT>")
         End If

      Catch ex As Exception
         result = result & ex.Message
         ImportLog += "<tr style=""font-weight:normal; color:red"">" & Now & ": Importing spread sheet client data: Aborted</td><tr style=""font-weight:normal; color:red"">" & result & "</tr>"
      Finally
         If result.ToString = "" Then
            result = "Unknown"
            Me.tdImport.Visible = False
         End If

         Dim report As String = CreateReport(table, result)
         SendEmail("Client upload report for: " & Now, report, CopyIn, dFailed)
      End Try
      Me.tdImport.Visible = False
      Return "Note: " + result
   End Function

   Private Function CheckForDuplicateSSNo(ByVal SSN() As String) As Boolean
      Dim dr As SqlDataReader
      Dim commStr As String
      EqualRows(0) = True
      Dim v As Integer
      Dim x As Integer
      Dim y As Integer
      Dim z As Integer
      Dim NecessaryData(13) As String
      Dim SocialSecurity(0, 1) As String
      Dim SocialSecTest As String

        Try
            ReDim SocialSecurity(SSN.Length - 1, 1)
            For x = 0 To SSN.Length - 1
                SocialSecurity(x, 0) = Format(CDbl(Val(SSN(x).Replace("-", ""))), "###-##-####")
                If SocialSecurity(x, 0).Length < 11 Then SocialSecurity(x, 0) = "0" & SocialSecurity(x, 0)
                SocialSecurity(x, 1) = Format(CDbl(Val(SSN(x).Replace("-", ""))), "#########")
                If SocialSecurity(x, 1).Length < 9 Then SocialSecurity(x, 1) = "0" & SocialSecurity(x, 1)
            Next
            x = 0

            'For SSN searching only
            For v = 0 To SSN.Length - 1
                SocialSecTest = Trim(SocialSecurity(v, 0).ToString)
                If SSN(v) Is Nothing Then
                    GoTo DoNextSSN
                End If

                Using cmd As New SqlCommand("", New SqlConnection(connStrDMS))
                    Using cmd.Connection
                        cmd.Connection.Open()
                        commStr = "SELECT p.SSN FROM tblPerson p "
                        commStr += "INNER JOIN tblClient c ON c.ClientID = p.ClientID "
                        commStr += "WHERE "
                        'Social with or without dashes
                        commStr += "SSN = '" & Trim(SocialSecurity(v, 0)) & "' "
                        commStr += "OR SSN = '" & Trim(SocialSecurity(v, 1)) & "'"
                        cmd.CommandText = commStr
                        dr = cmd.ExecuteReader
                        If dr.HasRows Then
                            'Got a match on the second pass
                            EqualRows(x) = True 'Client exists
                            z += 1
                        Else
                            EqualRows(x) = False 'Client Does Not Exist for sure
                            y += 1
                        End If
                        dr.Close()
                        x += 1
                        ReDim Preserve EqualRows(x)
                        EqualRows(x) = False
                    End Using
                End Using
DoNextSSN:
            Next v

            ReDim Preserve EqualRows(x - 1)
            If y > 0 And y < SSN.Length Then
                'Some new clients
                Duplicates = "There is/are " & SSN.Length - z & " client(s) that did not get imported." & vbCrLf & "The " & y & " clients will be imported with this spread sheet import."
                Return True
            ElseIf y = SSN.Length Then 'And z = 0 Then
                'None, all new clients
                Duplicates = "NONE"
                Return False
            ElseIf y = 0 Then 'z = table.Rows.Count Then
                'All duplicates
                Duplicates = "ALL"
                Return True
            End If

        Catch ex As Exception
            HandleMessage(ex.Message)
            Return True
        End Try
      Return False

   End Function

   Private Function CheckForDuplicate(ByVal table As DataTable, ByVal name As String) As Boolean

      Dim dr As SqlDataReader
      Dim commStr As String
      EqualRows(0) = True
      Dim r As Integer = table.Rows.Count
      Dim x As Integer
      Dim y As Integer
      Dim z As Integer
      Dim NecessaryData(13) As String
      Dim FirstName As String
      Dim LastName As String

      Try
         Using cmd As New SqlCommand("", New SqlConnection(connStrDMS))
            Using cmd.Connection
               cmd.Connection.Open()
               For Each row As DataRow In table.Rows
                  If row.Item("First Name").ToString = "" And row.Item("Last Name").ToString = "" Then
                     r = r - 1 'Blank row not used don't count it.
                     GoTo DoNextRow
                  End If

                  FirstName = Trim(row.Item("First Name").ToString)
                  FirstName = FirstName.Replace("'", "''")
                  LastName = Trim(row.Item("Last Name").ToString)
                  LastName = LastName.Replace("'", "''")

                  commStr = "SELECT p.ClientID, c.AccountNumber FROM tblPerson p "
                  commStr += "INNER JOIN tblClient c ON c.ClientID = p.ClientID "
                  commStr += "WHERE "
                  commStr += "FirstName = '" & FirstName & "' AND "
                  commStr += "LastName = '" & LastName & "' AND "

                  'Social as entered on spread sheet
                  commStr += "SSN = '" & Trim(row.Item(5).ToString) & "'"
                  cmd.CommandText = commStr

                  'If cmd.ExecuteScalar > 0 Then
                  dr = cmd.ExecuteReader
                  If dr.HasRows Then
                     EqualRows(x) = True 'Client exists
                     z += 1
                     'Validate that the Import did not stop in the middle and load the data elements necessary
                     dr.Read()
                     If dr.Item("AccountNumber") Is DBNull.Value Then
                        NecessaryData(0) = dr.Item("ClientID").ToString 'ClientID
                        NecessaryData(1) = "" 'Primary PersonID
                        NecessaryData(2) = "" 'Current Client StatusID
                        NecessaryData(3) = Now.ToString 'Created and Modified date
                        NecessaryData(4) = "24" 'ImportID
                        NecessaryData(5) = "" 'Primary Road MapID
                        NecessaryData(6) = row.Item(12).ToString 'Deposit day
                        NecessaryData(7) = row.Item(13).ToString 'Deposit Amount
                        NecessaryData(8) = row.Item(14).ToString 'Routing Number
                        NecessaryData(9) = row.Item(15).ToString 'Account Number
                        NecessaryData(10) = row.Item(16).ToString 'Bank Name
                        NecessaryData(11) = row.Item(18).ToString 'Retainer
                        NecessaryData(12) = "" 'Will be the account number
                        NecessaryData(13) = row.Item(19).ToString 'Banking Type
                        UpdateThisClient(NecessaryData)
                     End If
                  Else
                     y += 1
                     EqualRows(x) = False
                  End If
                  dr.Close()
DoNextRow:
                  x += 1
                  ReDim Preserve EqualRows(x)
                  EqualRows(x) = False
               Next 'the for each loop of the variable table

               ReDim Preserve EqualRows(x - 1)

               If y > 0 And y < r Then
                  'Some new clients
                  Duplicates = "There is/are " & table.Rows.Count - z & " client(s) that did not get imported." & vbCrLf & "The " & y & " clients will be imported with this spread sheet import."
                  Return True
               ElseIf y = r Then
                  'None, all new clients
                  Duplicates = "NONE"
                  Return False
               ElseIf y = 0 And z = r Then 'z = table.Rows.Count Then
                  'All duplicates
                  Duplicates = "ALL"
                  Return True
               End If
            End Using
         End Using

      Catch ex As Exception
         HandleMessage(ex.Message)
         Return True
      End Try
      Return False

   End Function

   Private Function CheckForDuplicateBankAcct(ByVal RoutingNo() As String, ByVal AccountNo() As String, ByVal Sheet As DataTable) As Boolean
      Dim commStr As String = ""
      Dim y As Integer = 0
      Dim dr As SqlDataReader = Nothing
      Dim a As Long = 0
      Dim b As Long = 0
      Dim c As Long = 0
      Dim SheetMatchingAccts(0) As String
      Dim DBMatchingAccts(0) As String

      'Read the sheet data for duplicates first
      For a = LBound(AccountNo) To UBound(AccountNo)
         'Start the second loop 
         For b = a + 1 To UBound(AccountNo)
            'Check if the values are the same
            'if they're equal, then we found a duplicate AccountNo
            If AccountNo(a) = AccountNo(b) And AccountNo(a).ToString <> "" Then
               ' Now check against a duplicate routing number with this account number
               If RoutingNo(a) = RoutingNo(b) And RoutingNo(a).ToString <> "" Then
                  'got a duplicate bank account
                  SheetMatchingAccts(c) = "Routing Number: " & RoutingNo(a) & " Account Number: " & AccountNo(a) & "<br>"
                  c += 1
                  ReDim Preserve SheetMatchingAccts(c)
               End If
            End If
         Next b
      Next a
      'Clean up the array
      If SheetMatchingAccts(c) Is Nothing Then
         ReDim Preserve SheetMatchingAccts(c - 1)
      End If

      'Now check for duplicates against the database itself, got'a do it one at a time
      b = 0
      Try
         For a = 0 To AccountNo.Length - 1
            Using cmd As New SqlCommand("", New SqlConnection(connStrDMS))
               Using cmd.Connection
                  cmd.Connection.Open()

                  commStr = "SELECT BankRoutingNumber, BankAccountNumber "
                  commStr += "FROM tblClient "
                  commStr += "WHERE "
                  commStr += "BankRoutingNumber = '" & RoutingNo(a) & "' AND "
                  commStr += "BankAccountNumber = '" & AccountNo(a) & "' AND "
                  commStr += "CurrentClientStatusID NOT IN (15, 17, 18)"

                  cmd.CommandType = CommandType.Text
                  cmd.CommandText = commStr

                  dr = cmd.ExecuteReader

                  If dr.HasRows Then
                     DBMatchingAccts(b) = "Routing Number: " & RoutingNo(a) & " Account Number: " & AccountNo(a) & "<br>" 'This Bank account already exists in the database"
                     b += 1
                     ReDim Preserve DBMatchingAccts(b)
                  End If
                  dr.Close()
               End Using
            End Using
         Next
         'Clean up the array
         If DBMatchingAccts(b) Is Nothing Then
            ReDim Preserve DBMatchingAccts(b - 1)
         End If

         If SheetMatchingAccts.Length > 0 Or DBMatchingAccts.Length > 0 Then
            SendAccountEmail(SheetMatchingAccts, DBMatchingAccts)
            Return True
         End If

      Catch ex As Exception
         HandleMessage(ex.Message)
         Return True
      End Try

      Return False

   End Function

#Region "ManipulateFile"
   Private Function ArchiveFile(ByVal path As String) As String
      Dim fInfo As New FileInfo(path)
      Dim newPath As String = GetUniqueFileName(dirArchive + fInfo.Name)

      File.Move(path, newPath)

      If Not File.Exists(newPath) Then
         Throw New Exception("Could not move file!")
      End If

      File.SetAttributes(newPath, FileAttributes.Archive Or FileAttributes.ReadOnly)

      Return newPath
   End Function

   Private Function GetUniqueFileName(ByVal path As String)
      Dim incFile As Integer = 1
      Dim idxExt As Integer = 0
      Dim newPath As String = path

      While File.Exists(newPath)
         incFile += 1
         idxExt = path.LastIndexOf(".")
         newPath = path.Substring(0, idxExt) + "_" + incFile.ToString() + path.Substring(idxExt)
      End While

      Return newPath
   End Function
#End Region

   Private Sub HandleMessage(ByVal msg As String)
      lblNote.Text = msg
      lblNote.Visible = True
   End Sub

   Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
      AddControl(pnlBody, c, "Clients-Client Import")
   End Sub

   Shared Sub LSheet()
      Thread.Sleep(waitTime)
   End Sub

   Private Function UpdateThisClient(ByVal NecessaryData() As String) As Boolean

      'This function uploads any unfinished client into the database.

      Dim strSQL As String = ""

      'Enter the missing primary person value
      Using cmd As New SqlCommand("", New SqlConnection(connStrDMS))
         Using cmd.Connection
            strSQL = "SELECT PersonID FROM tblPerson WHERE ClientID = " & CInt(NecessaryData(0)) & " AND Relationship = 'Prime'"
            cmd.CommandText = strSQL
            cmd.Connection.Open()
            NecessaryData(1) = cmd.ExecuteScalar()
            If NecessaryData(1) = "" Then
               strSQL = "INSERT INTO tblClient SET PrimaryPersonID = " & CInt(NecessaryData(1)) & " WHERE ClientID = " & CInt(NecessaryData(0))
               cmd.CommandText = strSQL
               cmd.ExecuteNonQuery()
            End If

            strSQL = "SELECT CurrentClientStatusID FROM tblClient WHERE ClientID = " & CInt(NecessaryData(0))
            cmd.CommandText = strSQL
            NecessaryData(2) = cmd.ExecuteScalar()

            If NecessaryData(2) = "" Then
               'Enter the missing road map data if it's missing
               strSQL = "SELECT TOP 1 RoadMapID FROM tblRoadMap WHERE ClientID = " & CInt(NecessaryData(0)) & " ORDER BY Created"
               cmd.CommandText = strSQL
               NecessaryData(5) = cmd.ExecuteScalar()
               If NecessaryData(5) = "" Then
                  NecessaryData(2) = "2"
                  strSQL = "INSERT INTO tblRoadMap " _
                  & "ClientID, ClientStatusID, Created, CreatedBy, LastModified, LastModifiedBy " _
                  & "VALUES (" & CInt(NecessaryData(0)) & "," & CInt(NecessaryData(2)) & ", '" & NecessaryData(3) & "', " _
                  & CInt(NecessaryData(4)) & ", " & NecessaryData(3) & "', " & CInt(NecessaryData(4)) & ")"
                  cmd.ExecuteNonQuery()
               End If
               strSQL = "SELECT RoadMapID FROM tblRoadMap WHERE ClientID = " & CInt(NecessaryData(0)) & " AND ClientStatusID = 2"
               cmd.CommandText = strSQL
               NecessaryData(5) = cmd.ExecuteScalar()
               If NecessaryData(5) = "" Then
                  NecessaryData(2) = "5"
                  strSQL = "INSERT INTO tblRoadMap " _
                  & "ParentRoadMapID, ClientID, ClientStatusID, Created, CreatedBy, LastModified, LastModifiedBy " _
                  & "VALUES (" & CInt(NecessaryData(5)) & ", " & CInt(NecessaryData(0)) & "," & CInt(NecessaryData(2)) & ", '" & NecessaryData(3) & "', " _
                  & CInt(NecessaryData(4)) & ", '" & NecessaryData(3) & "', " & CInt(NecessaryData(4)) & ")"
                  cmd.ExecuteNonQuery()
               End If
               strSQL = "SELECT RoadMapID FROM tblRoadMap WHERE ClientID = " & CInt(NecessaryData(0)) & " AND ClientStatusID = 5"
               cmd.CommandText = strSQL
               NecessaryData(5) = cmd.ExecuteScalar()
               If NecessaryData(5) = "" Then
                  NecessaryData(2) = "6"
                  strSQL = "INSERT INTO tblRoadMap " _
                  & "ParentRoadMapID, ClientID, ClientStatusID, Created, CreatedBy, LastModified, LastModifiedBy " _
                  & "VALUES (" & CInt(NecessaryData(5)) & ", " & CInt(NecessaryData(0)) & "," & CInt(NecessaryData(2)) & ", '" & NecessaryData(3) & "', " _
                  & CInt(NecessaryData(4)) & ", '" & NecessaryData(3) & "', " & CInt(NecessaryData(4)) & ")"
                  cmd.ExecuteNonQuery()
               End If

               'Enter the client current status id in tblClient
               strSQL = "UPDATE tblClient SET CurrentClientStatusID = " & CInt(NecessaryData(2)) & " WHERE ClientID = " & CInt(NecessaryData(0))
               cmd.CommandText = strSQL
               cmd.ExecuteNonQuery()
            End If

            'If necessary create an AdHocACH for this client.
            If NecessaryData(6) <> "" And NecessaryData(7) <> "" And NecessaryData(8) <> "" And NecessaryData(9) <> "" And NecessaryData(10) <> "" Then
               strSQL = "SELECT ClientID FROM tblAdHocACH WHERE ClientID = " & CInt(NecessaryData(0))
               cmd.CommandText = strSQL
               If cmd.ExecuteScalar() = 0 Then 'We need an ACH created but don't have one yet
                  If NecessaryData(6) <> "" And NecessaryData(11) = "10" Then
                     NecessaryData(11) = "1"
                     strSQL = "INSERT INTO tblAdHocACH ClientID, DepositDate, DepositAmount, BankRoutingNumber, BankAccountNumber Created, CreatedBy, Modified, ModifiedBy, InitialDraft " _
                     & "VALUES (" & CInt(NecessaryData(0)) & ", '" & NecessaryData(6) & "', " & CDbl(NecessaryData(7)) & ", " & NecessaryData(8).ToString & ", " _
                     & NecessaryData(9).ToString & ", " & NecessaryData(10).ToString & ", " & CInt(NecessaryData(11))
                     cmd.CommandText = strSQL
                     cmd.ExecuteNonQuery()
                  Else
                     NecessaryData(11) = "0"
                  End If
               End If
            End If

            'Setup the account number we know we don't have one
            strSQL = "SELECT AccountNumber FROM tblClient WHERE ClientID = " & CInt(NecessaryData(0))
            cmd.CommandText = strSQL
            Dim accountnumber As Int32
            Dim acctTable As DataTable = New DataTable("tblAccountNumber")
            Dim dr As SqlDataReader
            strSQL = "SELECT value FROM tblProperty WHERE PropertyID = 29"
            cmd.CommandText = strSQL
            dr = cmd.ExecuteReader
            If dr.HasRows Then
               dr.Read()
               accountnumber = dr.Item(0) + 1
            End If
            dr.Close()
            strSQL = "UPDATE tblProperty SET value = " & accountnumber
            cmd.CommandText = strSQL
            cmd.ExecuteNonQuery()
            If NecessaryData(12).ToString = "" Then
               NecessaryData(12) = accountnumber
               strSQL = "UPDATE tblClient SET AccountNumber = " & NecessaryData(12) & " WHERE ClientID = " & NecessaryData(0)
               cmd.CommandText = strSQL
               cmd.ExecuteNonQuery()
            End If

            'Test to see if this client is going to be part of the new banking stuff
            If NecessaryData(13) = "CKS" Then
               'Setup the client's virtual account with CheckSite
               Dim store As New WCFClient.Store
               store.OpenAccount(CInt(NecessaryData(0)), UserID)
            End If

            'Setup the client search criteria
            strSQL = "SELECT ClientID from tblClientSearch WHERE ClientID = " & CInt(NecessaryData(0))
            cmd.CommandText = strSQL
            If cmd.ExecuteScalar() <= 0 Then
               strSQL = "exec stp_LoadClientSearch"
               cmd.CommandText = strSQL
               cmd.ExecuteNonQuery()
            End If
            cmd.Connection.Close()
         End Using
      End Using

   End Function

#Region "Report"

   Private Function CreateReport(ByVal table As DataTable, ByVal result As String) As String
      'Create a report

      table.TableName = "Client"
      table.DataSet.DataSetName = "Client"
      Dim strBldr As New System.Text.StringBuilder

      Try
         Dim ds As DataSet = table.DataSet
         ds.Tables.Add(CreateSummaryTable(table, result))
         ds.Tables(1).DataSet.DataSetName = "Summary"

         For Each row As DataRow In ds.Tables(0).Rows
            If row.Item("First Name").ToString <> "" Or Not row.Item("First Name") Is DBNull.Value Then
               row.Item("Last Name") = Trim(row.Item("Last Name").ToString & ", ")
               If row.ItemArray.Length - 1 > 18 Then
                  If row.Item("Banking Type").ToString() = "CKS" Then
                     row.Item("Banking Type") = "CheckSite"
                  ElseIf row.Item("Banking Type").ToString = "" Or row.Item("Banking Type") Is DBNull.Value Then
                     row.Item("Banking Type") = "Colonial Bank"
                  End If
               End If
            Else
               row.Delete()
            End If
         Next
         ds.Tables(0).GetChanges()
         ds.Tables(0).AcceptChanges()

         Dim xmlDocument As XmlDataDocument = New XmlDataDocument(ds)
         Dim xslCompTran As XslCompiledTransform = New XslCompiledTransform

         xslCompTran.Load(System.Configuration.ConfigurationManager.AppSettings("ImportXsltPath").ToString() & "XSLTClientImport.xslt")

         Dim ms As New System.IO.MemoryStream
         Dim sr As System.IO.StreamReader

         xslCompTran.Transform(xmlDocument, Nothing, ms)
         sr = New System.IO.StreamReader(ms, System.Text.Encoding.UTF8)
         ms.Position = 0
         strBldr.Append(sr.ReadToEnd())

         If Not sr Is Nothing Then sr.Close()
         If Not ms Is Nothing Then ms.Close()
      Catch ex As Exception
         result += "</td><td>" & Now & ": " & "Importing the spread sheet client data was successful, but there was an error creating the log report. Please notify IT......."
      End Try

      Return strBldr.ToString()

   End Function

   Function CreateSummaryTable(ByVal table As DataTable, ByVal result As String) As DataTable
      Dim tbl As New DataTable
      Dim dc As New DataColumn("ReportDate", GetType(System.String))
      tbl.Columns.Add(dc)
      dc = New DataColumn("CkSiteCount", GetType(System.String))
      tbl.Columns.Add(dc)
      dc = New DataColumn("TotalCount", GetType(System.String))
      tbl.Columns.Add(dc)
      dc = New DataColumn("Results", GetType(System.String))
      tbl.Columns.Add(dc)

      Try
         Dim cksite As Integer = 0
         For Each r As DataRow In table.Rows
            If r.ItemArray.Length - 1 >= 19 Then
               If r.Item("Banking Type").ToString() = "CKS" Then
                  cksite += 1
               End If
            End If
         Next

         Dim row As DataRow = tbl.NewRow
         row("ReportDate") = Now.ToString()
         row("TotalCount") = table.Rows.Count.ToString
         row("CkSiteCount") = cksite.ToString
         row("Results") = result.ToString
         tbl.Rows.Add(row)
         tbl.TableName = "Summary"
      Catch ex As Exception

      End Try

      Return tbl
   End Function

   Private Function SetupLog() As String
      ImportLog = "<table width=""100%"" cols=""1"" style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
         & "<tr style=""font-size:14; font-weight:normal; font-family:Tahoma"">" _
         & Now & ": Beginning Processing" _
         & "</tr>" _
         & "<tr style=""font-size:14; font-weight:normal; font-family:Tahoma"">" _
         & "User ID:" & vbTab & UserID _
         & "</tr>" _
         & "<br/>"
      Return ImportLog
   End Function

#End Region

#Region "Email"

   Private Sub SendAccountEmail(ByVal SheetMatchingAccts() As String, ByVal DBMatchingAccts() As String)

      Dim x As Integer = 0
      Dim subject1 As String
      Dim Accounts As String = ""

      If SheetMatchingAccts.Length > 0 Or DBMatchingAccts.Length > 0 Then
         subject1 = "There are duplicated bank account numbers in this spreadsheet!"

         If SheetMatchingAccts.Length > 0 Then
            Accounts += "<td style=""font-size:12; font-weight:normal; font-family:Tahoma; font-color:red;""><u>The following spreadsheet Bank Accounts are the same: </u></td><br><br>"
            For x = 0 To SheetMatchingAccts.Length - 1
               Accounts += "<td style=""font-size:12; font-weight:normal; font-family:Tahoma; font-color:black;"">" & SheetMatchingAccts(x) & "<br>"
            Next
            Accounts += "</td>"
         End If

         If DBMatchingAccts.Length > 0 Then
            Accounts += "<td style=""font-size:12; font-weight:normal; font-family:Tahoma;""><u>The following bank accounts in our records match these account numbers in the spreadsheet: </u></td><br><br>"
            For x = 0 To DBMatchingAccts.Length - 1
               Accounts += "<td td style=""font-size:12; font-weight:normal; font-family:Tahoma; font-color:black;"">" & DBMatchingAccts(x) & "<br>"
            Next
            Accounts += "</td>"
         End If

         From = "ClientImport@lexxiom.com"
         [To] = System.Configuration.ConfigurationManager.AppSettings("AccountDupMailTo")
         Cc = System.Configuration.ConfigurationManager.AppSettings("AccountDupMailCopyTo")
         Subject = subject1
         Body = "<tr style=""font-size:14; font-weight:bold; font-family:Tahoma;"">"
         Body += "<td style=""font-color:red; font-family:Tahoma;"">Duplicated Bank Accounts in the spread sheet below. Please verify......."
         Body += "</td><br><br>"
         Body += Accounts
         Body += "<td>The spread sheet can be found here: </td><br>" & "" & filePath & ""
         Body += "<br><br>"
         Body += "<td style=""font-size:14; font-weight:bold; font-family:Tahoma"">"
         Body += "End of report.</td>"
         Body += "</tr>"
         SmtpServer = System.Configuration.ConfigurationManager.AppSettings("EmailSMTP")
         Send()
      End If

   End Sub

   Private Sub SendEmail(ByVal subject1 As String, ByVal Attachment As String, ByVal Copies As Boolean, ByVal Failures As Dictionary(Of Integer, String))
      Try

         Dim Copy(1) As String
         Dim x As Integer

         If Failures.Count > 0 Then
            ImportLog += vbCrLf & vbCrLf
            For x = 0 To Failures.Count - 1
               ImportLog += Failures.Item(0) & " - " & Failures.Item(1) & vbCrLf
            Next
         End If

         If Copies Then
            Copy(0) = System.Configuration.ConfigurationManager.AppSettings("ImportMailTo")
            Copy(1) = "ITGroup@Lexxiom.com"
         Else
            ReDim Preserve Copy(0)
            Copy(0) = System.Configuration.ConfigurationManager.AppSettings("ImportMailTo")
         End If

         For x = 0 To Copy.Length - 1
            From = "ClientImport@lexxiom.com"
            [To] = Copy(x)
            Subject = subject1
            Body = "<table width=""100%"" cols=""1"" style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            & "<tr style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            & "<b>Client Import Summary.</b>" _
            & "</tr>" _
            & "<br/>" _
            & "<br/>" _
            & "<tr style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            & "<b>Results:</b>" _
            & "</tr>" _
            & "<br/>" _
            & "<tr style=""font-size:14; font-weight:normal; font-family:Tahoma; color:red"">" _
            & ImportLog _
            & "</tr>" _
            & "<br/>" _
            & "<br/>" _
            & "<tr style=""font-size:14; font-weight:bold; font-family:Tahoma"">" _
            & "<b>End of summary.</b>" _
            & "</tr>"
            If Attachment.Trim.Length > 0 Then
               Body += "<br/>" _
               & "<br/>" _
               & "<tr style=""font-size:14; font-weight:normal; font-family:Tahoma"">" _
               & "For additional details please open the attached page." _
               & "</tr>" _
               & "</table>"
            Else
               Body += "</table>"
            End If
            SmtpServer = System.Configuration.ConfigurationManager.AppSettings("EmailSMTP")
            Send(Attachment, "Client Import Report.html")
         Next x
      Catch ex As Exception
         'Error sending email
      End Try
   End Sub

   Private _fromAddress As String
   Private _toAddresses As String
   Private _subject As String
   Private _server As String
   Private _body As String = String.Empty
   Private _CopyTo As String

   Public Property From() As String
      Get
         Return _fromAddress
      End Get
      Set(ByVal value As String)
         _fromAddress = value
      End Set
   End Property

   Public Property [To]() As String
      Get
         Return _toAddresses
      End Get
      Set(ByVal value As String)
         _toAddresses = value
      End Set
   End Property

   Public Property Cc() As String
      Get
         Return _CopyTo
      End Get
      Set(ByVal value As String)
         _CopyTo = value
      End Set
   End Property

   Public Property Subject() As String
      Get
         Return _subject
      End Get
      Set(ByVal value As String)
         _subject = value
      End Set
   End Property

   Public Property SmtpServer() As String
      Get
         Return _server
      End Get
      Set(ByVal value As String)
         _server = value
      End Set
   End Property

   Public Property Body() As String
      Get
         Return _body
      End Get
      Set(ByVal value As String)
         _body = value
      End Set
   End Property

   Public Sub Send()
      Dim email As New SmtpClient(_server)
      Dim message As New MailMessage
      message.From = New MailAddress(_fromAddress)
      message.To.Add(_toAddresses)
      If Not _CopyTo Is DBNull.Value Then
         If _CopyTo.ToString <> "" Then
            message.CC.Add(_CopyTo)
         End If
      End If
      message.IsBodyHtml = True
      message.Subject = _subject
      message.Body = _body
      email.Send(message)
   End Sub

   Public Sub Send(ByVal fileContent As String, ByVal fileName As String)
      Dim memoryStream As New System.IO.MemoryStream
      Dim memoryWriter As New System.IO.StreamWriter(memoryStream)
      Try
         Dim email As New SmtpClient(_server)
         Dim message As New MailMessage
         message.From = New MailAddress(_fromAddress)
         message.To.Add(_toAddresses)
         memoryWriter.Write(fileContent)
         memoryWriter.Flush()
         memoryStream.Seek(0, System.IO.SeekOrigin.Begin)
         message.Attachments.Add(New Attachment(memoryStream, fileName, System.Net.Mime.MediaTypeNames.Text.Html))
         message.IsBodyHtml = True
         message.Subject = _subject
         message.Body = _body
         email.Send(message)
      Finally
         memoryWriter.Close()
         memoryStream.Close()
      End Try
   End Sub

   Public Sub Send(ByVal fileAttachements As FileAttachment())
      Dim streams As New List(Of System.IO.MemoryStream)
      Dim writers As New List(Of System.IO.StreamWriter)
      Dim objStream As System.IO.MemoryStream
      Dim objWriter As System.IO.StreamWriter
      Try
         Dim email As New SmtpClient(_server)
         Dim message As New MailMessage
         message.From = New MailAddress(_fromAddress)
         message.To.Add(_toAddresses)
         'Initialize 
         For i As Integer = 0 To fileAttachements.Length - 1
            Try
               objStream = New System.IO.MemoryStream
               streams.Add(objStream)
               objWriter = New System.IO.StreamWriter(objStream)
               writers.Add(objWriter)
               objWriter.Write(fileAttachements(i).Content)
               objWriter.Flush()
               objStream.Seek(0, System.IO.SeekOrigin.Begin)
               message.Attachments.Add(New Attachment(objStream, fileAttachements(i).Name, System.Net.Mime.MediaTypeNames.Text.Html))
               _body = _body & String.Format("<br/>{0} is attached.", fileAttachements(i).Description)
            Catch ex As Exception
               _body = _body & String.Format("<br/>{0} was not attached because {1}.", fileAttachements(i).Name, ex.Message)
            End Try
         Next
         message.IsBodyHtml = True
         message.Subject = _subject
         message.Body = _body
         email.Send(message)
      Finally
         For Each objWriter In writers
            objWriter.Close()
         Next
         For Each objStream In streams
            objStream.Close()
         Next
      End Try
   End Sub

#End Region

End Class
