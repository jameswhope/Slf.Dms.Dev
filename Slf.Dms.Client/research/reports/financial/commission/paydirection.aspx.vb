Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_reports_financial_commission_paydirection
    Inherits PermissionPage


#Region "Variables"
    Private UserID As Integer
    Private qs As QueryStringCollection
   Private day As DateTime
   Public satty As Integer = 1
   Public scenid As Integer = 1
   Public FromWhere As String = "r" 'Allow two returns only r=Reports c=Company
#End Region

#Region "Util"
   Private Function GetQueryString(ByVal key As String, ByVal [default] As String) As String
      Dim result As String = DataHelper.Nz_string(Request.QueryString(key))
      If String.IsNullOrEmpty(result) Then
         result = [default]
      End If
      Return result
   End Function
   Protected Function LoadQueryString() As QueryStringCollection

      Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

      qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

      If Not qsv.Validate() Then
         Response.Redirect("error.aspx")
         Return Nothing
      End If

      Return qsv.QueryString

   End Function
   Private Function GetDay() As DateTime
      day = New DateTime(ddlYear.SelectedValue, ddlMonth.SelectedValue, ddlDay.SelectedValue)
      Return day
   End Function
   Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
      AddControl(pnlBody, c, "Research-Reports-Financial-Commission-Pay Direction")
   End Sub
   Private Function GetFirstYearAvailable() As Integer
      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
         Using cmd.Connection
            cmd.CommandText = "SELECT TOP 1 tblCommScen.StartDate FROM tblCommScen ORDER BY StartDate ASC"
            cmd.Connection.Open()
            Using rd As IDataReader = cmd.ExecuteReader
               If rd.Read() Then
                  If rd.IsDBNull(0) Then
                     Return Now.Year
                  Else
                     Return rd.GetDateTime(0).Year
                  End If
               Else
                  Return Now.Year
               End If
            End Using
         End Using
      End Using
   End Function
   Private Function GetLastYearAvailable() As Integer
      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
         Using cmd.Connection
            cmd.CommandText = "SELECT TOP 1 tblCommScen.EndDate FROM tblCommScen ORDER BY EndDate DESC"
            cmd.Connection.Open()
            Using rd As IDataReader = cmd.ExecuteReader
               If rd.Read() Then
                  If rd.IsDBNull(0) Then
                     Return Now.Year
                  Else
                     Dim d As DateTime = rd.GetDateTime(0)
                     If Now > d Then
                        Return Now.Year
                     Else
                        Return d.Year
                     End If
                  End If
               Else
                  Return Now.Year
               End If
            End Using
         End Using
      End Using
   End Function
   Private Sub FillCompanies()
      Using cmd As New SqlCommand("SELECT CompanyID, ShortCoName FROM tblCompany", ConnectionFactory.Create())
         Using cmd.Connection
            cmd.Connection.Open()

            Using reader As SqlDataReader = cmd.ExecuteReader()
               While reader.Read()
                  ddlCompany.Items.Add(New ListItem(StrConv(reader("ShortCoName"), VbStrConv.ProperCase), Integer.Parse(reader("CompanyID"))))
               End While
            End Using
         End Using
      End Using
   End Sub
#End Region

#Region "Dates"
   Private Sub SetAttributes(ByVal FromWhere As String)
      If FromWhere = "c" Then
         ddlYear.Visible = False
         ddlMonth.Visible = False
         ddlDay.Visible = False
      Else
         ddlYear.Attributes("onchange") = "Year_Change(this);"
         ddlMonth.Attributes("onchange") = "Month_Change(this);"
         lnkNewScenario.Visible = False
         lnkSettings.Visible = False
         Img6.Visible = False
      End If

   End Sub
   Private Sub FixDays()
      Dim daysInMonth As Integer = DateTime.DaysInMonth(day.Year, day.Month)
      While (ddlDay.Items.Count > daysInMonth)
         ddlDay.Items.Remove(ddlDay.Items.Count)
      End While
   End Sub
   Private Sub PopulateDates()
      ddlMonth.Items.Clear()
      ddlYear.Items.Clear()
      ddlDay.Items.Clear()

      ddlMonth.Items.Add(New ListItem("January", 1))
      ddlMonth.Items.Add(New ListItem("February", 2))
      ddlMonth.Items.Add(New ListItem("March", 3))
      ddlMonth.Items.Add(New ListItem("April", 4))
      ddlMonth.Items.Add(New ListItem("May", 5))
      ddlMonth.Items.Add(New ListItem("June", 6))
      ddlMonth.Items.Add(New ListItem("July", 7))
      ddlMonth.Items.Add(New ListItem("August", 8))
      ddlMonth.Items.Add(New ListItem("September", 9))
      ddlMonth.Items.Add(New ListItem("October", 10))
      ddlMonth.Items.Add(New ListItem("November", 11))
      ddlMonth.Items.Add(New ListItem("December", 12))

      For i As Integer = GetFirstYearAvailable() To GetLastYearAvailable()
         ddlYear.Items.Add(i)
      Next
      If ddlYear.Items.Count = 0 Then ddlYear.Items.Add(Now.Year)
      For i As Integer = 1 To 31
         ddlDay.Items.Add(i)
      Next

   End Sub
#End Region

#Region "Events"
   Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      UserID = DataHelper.Nz_int(Page.User.Identity.Name)
      qs = LoadQueryString()

      If Not IsNumeric(Request.QueryString("From")) Then
         If Request.QueryString("From") = "c" Then
            FromWhere = Request.QueryString("From")
         End If
      End If

      If Not IsPostBack Then
            Dim cmpName As String
            Dim userPerm As Integer = UserID

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT isnull(UserGroupID, 3) FROM tblUser WHERE UserID = " + UserID.ToString()
                    cmd.Connection.Open()
                    Dim permission As Integer = cmd.ExecuteScalar()
                    If permission = 6 Or permission = 11 Then
                        userPerm = -2
                    Else
                        userPerm = UserID
                    End If

                    ddlCompany.Items.Clear()

                    cmd.CommandText = "SELECT isnull(CompanyIDs, 0) FROM tblUserCompany WHERE UserID = " + userPerm.ToString()
                    Dim companies() As String = cmd.ExecuteScalar().ToString().Split(",")
                    For Each cmp As Integer In companies
                        cmd.CommandText = "SELECT lower(ShortCoName)+':'+cast(companyID as varchar) FROM tblCompany WHERE CompanyID = " + cmp.ToString()
                        Dim strTemp As String = cmd.ExecuteScalar()
                        Dim coInfo As String() = strtemp.split(":")
                        ddlCompany.Items.Add(New ListItem(StrConv(coInfo(0), VbStrConv.ProperCase), coInfo(1), True))
                        If ddlCompany.Items.Count Then
                            ddlCompany.Visible = True
                        End If
                    Next
                End Using
            End Using



         PopulateDates()
            'FillCompanies()

         If Not String.IsNullOrEmpty(qs("y")) Then
            ddlDay.SelectedIndex = Integer.Parse(qs("d")) - 1
            ddlMonth.SelectedIndex = Integer.Parse(qs("m")) - 1
            ListHelper.SetSelected(ddlYear, Integer.Parse(qs("y")))
            ddlCompany.SelectedValue = Integer.Parse(qs("c"))
         Else
            ddlDay.SelectedIndex = Now.Day - 1
            ddlMonth.SelectedIndex = Now.Month - 1
            ListHelper.SetSelected(ddlYear, Now.Year)
            ddlCompany.SelectedValue = 1
         End If
         SetAttributes(FromWhere)
      End If

      GetDay()
      FixDays()
      Requery()

   End Sub

   Protected Sub lnkNewScenario_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNewScenario.Click
      Dim page As String = "Slf.Dms.Client/../../../../../admin/commission/scenario.aspx"
      Response.Redirect(page & "?CoID=" & satty & "&ScenID=" & scenid)
   End Sub

   Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
      GetDay()

      Dim qsb As New QueryStringBuilder(Context.Request.Url.Query)

      qsb("d") = day.Day
      qsb("m") = day.Month
      qsb("y") = day.Year
      qsb("c") = ddlCompany.SelectedValue

      Dim page As String = Context.Request.Url.AbsolutePath.Substring(Context.Request.Url.AbsolutePath.LastIndexOf("/"c) + 1)
      Response.Redirect(page & "?" & qsb.QueryString)

   End Sub

   Protected Sub lnkSettings_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSettings.Click
      Dim page As String = "Slf.Dms.Client/../../../../../admin/settings/default.aspx"
      Response.Redirect(page)
   End Sub
#End Region

#Region "Query"

   Private Sub Requery()
      Dim Agencies As New Dictionary(Of Integer, GridAgency)
      Dim FeeTypes As New Dictionary(Of Integer, List(Of FeeType))
      Dim FeeTypeHeaders As New Dictionary(Of Integer, String)

      Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetCommissionPayDirection")
         Using cmd.Connection
            DatabaseHelper.AddParameter(cmd, "Date", GetDay())
            DatabaseHelper.AddParameter(cmd, "CompanyID", ddlCompany.SelectedValue)
            'Session("rptcmd_report_servicefee_agency_payments") = cmd

            cmd.Connection.Open()
            Using rd As IDataReader = cmd.ExecuteReader()
               While rd.Read()
                  Dim AgencyName As String = DatabaseHelper.Peel_string(rd, "Agency")
                  Dim CommRecName As String = DatabaseHelper.Peel_string(rd, "CommRec")
                  Dim AgencyId As Integer = DatabaseHelper.Peel_int(rd, "AgencyId")
                  Dim CommRecId As Integer = DatabaseHelper.Peel_int(rd, "CommRecId")
                  Dim CommStructID As Integer = DatabaseHelper.Peel_int(rd, "CommStructID")
                  Dim ParentCommRecId As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "ParentCommRecId")

                  Dim EntryTypeID As Integer = DatabaseHelper.Peel_nint(rd, "EntryTypeID")
                  Dim FeeName As String = DatabaseHelper.Peel_string(rd, "Name")
                  Dim Percent As Double = DatabaseHelper.Peel_double(rd, "Percent")
                  Dim CommScenID As Integer = DatabaseHelper.Peel_int(rd, "CommScenID")
                  Dim IsTrust As Boolean = DatabaseHelper.Peel_bool(rd, "IsTrust")

                  Dim Agency As GridAgency = Nothing
                  If Not Agencies.TryGetValue(CommScenID, Agency) Then
                     Agency = New GridAgency
                     Agency.AgencyId = AgencyId
                     Agency.Name = AgencyName
                     Agency.CommScenID = CommScenID
                     Agency.IsTrust = IsTrust
                     Agencies.Add(Agency.CommScenID, Agency)
                  End If

                  Dim Recipient As GridRecipient = Nothing
                  If Not Agency.Recipients.TryGetValue(CommRecId, Recipient) Then
                     Recipient = New GridRecipient
                     Recipient.CommRecId = CommRecId
                     Recipient.CommRecName = CommRecName
                     Recipient.ParentCommRecId = ParentCommRecId
                     Recipient.CommStructID = CommStructID
                     Recipient.CommScenID = CommScenID
                     Recipient.IsTrust = IsTrust
                     Agency.Recipients.Add(Recipient.CommRecId, Recipient)
                  End If

                  If Not FeeTypeHeaders.ContainsKey(EntryTypeID) Then
                     FeeTypeHeaders.Add(EntryTypeID, FeeName)
                  End If

                  If Not FeeTypes.ContainsKey(CommStructID) Then
                     FeeTypes.Add(CommStructID, New List(Of FeeType))
                  End If

                  FeeTypes(CommStructID).Add(New FeeType(EntryTypeID, Percent))
               End While
            End Using
         End Using
         'Session("xls_servicefeemy_list") = Agencies
      End Using

      For Each a As GridAgency In Agencies.Values
         Dim ToRemove As New List(Of Integer)

         'link up transfers to their parents
         For Each i As Integer In a.Recipients.Keys
            Dim b As GridRecipient = a.Recipients(i)

            If b.ParentCommRecId.HasValue Then
               Dim ParentCommRecId As Integer = b.ParentCommRecId.Value

               If a.Recipients.ContainsKey(ParentCommRecId) Then
                  Dim Parent As GridRecipient = a.Recipients(ParentCommRecId)

                  Parent.Children.Add(b)
                  b.Parent = Parent
                  ToRemove.Add(i)
               End If
            End If
         Next

         For Each i As Integer In ToRemove
            a.Recipients.Remove(i)
         Next

         Dim Ordered As New Dictionary(Of Integer, GridRecipient)
         For Each b As GridRecipient In a.Recipients.Values
            AddRecursive(b, Ordered, 0)
         Next
         a.Recipients = Ordered
      Next

      Dim sb As New StringBuilder
      RenderGrid(sb, Agencies, FeeTypes, FeeTypeHeaders)
      ltrGrid.Text = sb.ToString()
   End Sub

   Private Sub AddRecursive(ByVal b As GridRecipient, ByVal lst As Dictionary(Of Integer, GridRecipient), ByVal Level As Integer)
      lst.Add(b.CommRecId, b)
      b.Level = Level

      If b.Children.Count > 0 Then
         For Each child As GridRecipient In b.Children
            AddRecursive(child, lst, Level + 1)
         Next
         b.Children(b.Children.Count - 1).IsLast = True
      End If
   End Sub

   Protected Function GetArrowImg(ByVal b As GridRecipient) As String
      Dim result As String = ""

      Dim parent As GridRecipient = b.Parent
      While Not parent Is Nothing
         If parent.Parent IsNot Nothing Then
            If Not parent.IsLast Then
               result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/arrow_vertical.png") & """ border=""0""/>" & result
            Else
               result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/blank.png") & """ border=""0""/>" & result
            End If
         Else
            result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/blank.png") & """ border=""0""/>" & result
         End If
         parent = parent.Parent
      End While

      If b.ParentCommRecId.HasValue Then
         result += "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/arrow_" & IIf(b.IsLast, "end", "connector")) & ".png"" border=""0""/>"
      End If

      Return result
   End Function

   Private Sub RenderGrid(ByVal sb As StringBuilder, ByVal Agencies As Dictionary(Of Integer, GridAgency), ByVal FeeTypes As Dictionary(Of Integer, List(Of FeeType)), ByVal FeeTypeHeaders As Dictionary(Of Integer, String))
      For Each Agency As GridAgency In Agencies.Values
         If FromWhere = "r" Then
            sb.Append("<tr><td><b>Client From: <u>" & Agency.Name & "</u></b></td></tr>")
         Else
            satty = ddlCompany.SelectedValue
            scenid = Agency.CommScenID
            sb.Append("<td style=""padding-left:20;""><a runat=""server"" class=""lnk"" href=""Slf.Dms.Client/../../../../../admin/commission/scenario.aspx?c=" & satty & "&s=" & scenid & """>" & Agency.Name & "</a></td>")
         End If
         sb.Append("<tr><td>")

         sb.Append("<table class=""fixedlist"" onselectstart=""return false;"" style=""font-size:11px;font-family:tahoma"" cellspacing=""0"" cellpadding=""0"" width=""350"" border=""0"">")
         sb.Append("<thead>")
         sb.Append("<th align=""left"" style=""width:80px;height:22px;padding-left:4px""><b>Recipient</b></th>")
         sb.Append("<th align=""left"" style=""width:80px;height:22px;padding-left:4px"">&nbsp;</th>")
         sb.Append("<th align=""left"" style=""width:80px;height:22px;padding-left:4px"">&nbsp;</th>")

         For Each EntryTypeID As Integer In FeeTypeHeaders.Keys
            sb.Append("<th align=""left"" style=""width:80px;height:22px;padding-left:4px""><b>")

            sb.Append(FeeTypeHeaders(EntryTypeID))

            sb.Append("</b></th>")
         Next

         sb.Append("</tr>")
         sb.Append("</thead>")
         sb.Append("<tbody>")

         For Each Recip As GridRecipient In Agency.Recipients.Values
            sb.Append("<tr>")
            sb.Append("<td style=""height:22px;padding-left:4px"" nowrap=""nowrap"">")
            'sb.Append("<table  style=""font-size:11px;font-family:tahoma"" cellpadding=""0"" cellspacing=""0""><tr style=""border: rgb(180,180,180) 1px solid; height:17;padding-left:4px;padding-right:4px"">")
            sb.Append(GetArrowImg(Recip))
            sb.Append("</td>")
            sb.Append("<td style=""height:22px;padding-left:4px"" nowrap=""nowrap"">")
            sb.Append(Recip.CommRecName)
            sb.Append("</td>")
            sb.Append("<td style=""height:22px;padding-left:4px;width:10px"" nowrap=""nowrap"">&nbsp;")
            sb.Append("</td>")

            For Each EntryTypeID As Integer In FeeTypeHeaders.Keys
               sb.Append("<td style=""height:22px;padding-left:4px"" nowrap=""nowrap"">")

               sb.Append(GetPercentByType(FeeTypes(Recip.CommStructID), EntryTypeID).ToString("P"))

               sb.Append("</td>")
            Next

            'sb.Append("</tr></table>")
            'sb.Append("</td>")
            sb.Append("</tr>")
         Next

         sb.Append("</tbody>")
         sb.Append("</table></td></tr>")
      Next

   End Sub

   Private Function GetPercentByType(ByVal FeeTypeList As List(Of FeeType), ByVal EntryTypeID As Integer) As Double
      For Each Fee As FeeType In FeeTypeList
         If Fee.EntryTypeID = EntryTypeID Then
            Return Fee.Percent
         End If
      Next

      Return 0
   End Function

   Public Class GridRecipient
      Private _CommRecName As String
      Private _ParentCommRecName As String
      Private _CommRecId As Integer
      Private _ParentCommRecId As Nullable(Of Integer)
      Private _IsLast As Boolean
      Private _Children As List(Of GridRecipient)
      Private _Parent As GridRecipient
      Private _Level As Integer
      Private _CommStructID As Integer
      Private _CommScenID As Integer
      Private _IsTrust As Boolean

      Public Property Level() As Integer
         Get
            Return _Level
         End Get
         Set(ByVal value As Integer)
            _Level = value
         End Set
      End Property
      Public Property Parent() As GridRecipient
         Get
            Return _Parent
         End Get
         Set(ByVal value As GridRecipient)
            _Parent = value
         End Set
      End Property
      Public ReadOnly Property Children() As List(Of GridRecipient)
         Get
            If _Children Is Nothing Then
               _Children = New List(Of GridRecipient)
            End If
            Return _Children
         End Get
      End Property
      Public Property IsLast() As Boolean
         Get
            Return _IsLast
         End Get
         Set(ByVal value As Boolean)
            _IsLast = value
         End Set
      End Property
      Public Property CommRecId() As Integer
         Get
            Return _CommRecId
         End Get
         Set(ByVal value As Integer)
            _CommRecId = value
         End Set
      End Property
      Public Property ParentCommRecId() As Nullable(Of Integer)
         Get
            Return _ParentCommRecId
         End Get
         Set(ByVal value As Nullable(Of Integer))
            _ParentCommRecId = value
         End Set
      End Property
      Public Property CommRecName() As String
         Get
            Return _CommRecName
         End Get
         Set(ByVal value As String)
            _CommRecName = value
         End Set
      End Property
      Public Property CommStructID() As String
         Get
            Return _CommStructID
         End Get
         Set(ByVal value As String)
            _CommStructID = value
         End Set
      End Property
      Public Property CommScenID() As String
         Get
            Return _CommScenID
         End Get
         Set(ByVal value As String)
            _CommScenID = value
         End Set
      End Property
      Public Property IsTrust() As Boolean
         Get
            Return _IsTrust
         End Get
         Set(ByVal value As Boolean)
            _IsTrust = value
         End Set
      End Property
   End Class

   Protected Class GridAgency
      Private _Recipients As New Dictionary(Of Integer, GridRecipient)
      Private _Name As String
      Private _AgencyId As Integer
      Private _CommScenID As Integer
      Private _IsTrust As Boolean

      Public Property AgencyId() As Integer
         Get
            Return (_AgencyId)
         End Get
         Set(ByVal value As Integer)
            _AgencyId = value
         End Set
      End Property
      Public Property Name() As String
         Get
            Return _Name
         End Get
         Set(ByVal value As String)
            _Name = value
         End Set
      End Property
      Public Property CommScenID() As Integer
         Get
            Return (_CommScenID)
         End Get
         Set(ByVal value As Integer)
            _CommScenID = value
         End Set
      End Property
      Public Property IsTrust() As Boolean
         Get
            Return _IsTrust
         End Get
         Set(ByVal value As Boolean)
            _IsTrust = value
         End Set
      End Property

      Public Property Recipients() As Dictionary(Of Integer, GridRecipient)
         Get
            Return _Recipients
         End Get
         Set(ByVal value As Dictionary(Of Integer, GridRecipient))
            _Recipients = value
         End Set
      End Property
      Public Sub New()

      End Sub
   End Class

   Public Structure FeeType
      Public EntryTypeID As Integer
      Public Percent As Double

      Public Sub New(ByVal _EntryTypeID As Integer, ByVal _Percent As Double)
         Me.EntryTypeID = _EntryTypeID
         Me.Percent = _Percent
      End Sub
   End Structure
#End Region

End Class
