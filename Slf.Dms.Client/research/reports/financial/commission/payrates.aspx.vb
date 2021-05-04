Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_reports_financial_commission_payrates
    Inherits PermissionPage


#Region "Variables"
    Private UserID As Integer
    Private qs As QueryStringCollection
    Private day As DateTime
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
        AddControl(pnlBody, c, "Research-Reports-Financial-Commission-Pay Rates")
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
#End Region
#Region "Dates"
    Private Sub SetAttributes()
        ddlYear.Attributes("onchange") = "Year_Change(this);"
        ddlMonth.Attributes("onchange") = "Month_Change(this);"
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

        If Not IsPostBack Then
            PopulateDates()

            If Not String.IsNullOrEmpty(qs("y")) Then
                ddlDay.SelectedIndex = Integer.Parse(qs("d")) - 1
                ddlMonth.SelectedIndex = Integer.Parse(qs("m")) - 1
                ListHelper.SetSelected(ddlYear, Integer.Parse(qs("y")))
            Else
                ddlDay.SelectedIndex = Now.Day - 1
                ddlMonth.SelectedIndex = Now.Month - 1
                ListHelper.SetSelected(ddlYear, Now.Year)
            End If

            SetAttributes()
        End If
        GetDay()
        FixDays()
        Requery()

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        GetDay()

        Dim qsb As New QueryStringBuilder(Context.Request.Url.Query)

        qsb("d") = day.Day
        qsb("m") = day.Month
        qsb("y") = day.Year

        Dim page As String = Context.Request.Url.AbsolutePath.Substring(Context.Request.Url.AbsolutePath.LastIndexOf("/"c) + 1)
        Response.Redirect(page & "?" & qsb.QueryString)

    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/research/reports/financial/commission/payratesxls.ashx"))
    End Sub
#End Region
#Region "Query"



    Private Sub Requery()
        Dim Agencies As New Dictionary(Of Integer, GridAgency)
        Dim CompanyIDs As String = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ReportGetPayRates")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "Date", GetDay())

                If Len(CompanyIDs) > 0 And InStr(CompanyIDs, ",") = 0 Then
                    DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyIDs)
                End If

                Session("rptcmd_report_servicefee_agency_payments") = cmd

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim AgencyName As String = DatabaseHelper.Peel_string(rd, "Agency")
                        Dim CommRecName As String = DatabaseHelper.Peel_string(rd, "CommRec")
                        Dim FeeTypeName As String = DatabaseHelper.Peel_string(rd, "FeeType")
                        Dim EntryTypeId As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeId")
                        Dim AgencyId As Integer = DatabaseHelper.Peel_int(rd, "AgencyId")
                        Dim CommRecId As Integer = DatabaseHelper.Peel_int(rd, "CommRecId")
                        Dim Percent As Single = DatabaseHelper.Peel_float(rd, "Percent")

                        Dim Agency As GridAgency = Nothing
                        If Not Agencies.TryGetValue(AgencyId, Agency) Then
                            Agency = New GridAgency
                            Agency.AgencyId = AgencyId
                            Agency.Name = AgencyName
                            Agencies.Add(Agency.AgencyId, Agency)
                        End If

                        Dim Recipient As GridRecipient = Nothing
                        If Not Agency.Recipients.TryGetValue(CommRecId, Recipient) Then
                            Recipient = New GridRecipient
                            Recipient.CommRecId = CommRecId
                            Recipient.Name = CommRecName
                            Agency.Recipients.Add(Recipient.CommRecId, Recipient)
                        End If

                        If Not Agency.FeeTypes.ContainsKey(EntryTypeId) Then
                            Dim FeeType As New GridFeeType
                            FeeType.EntryTypeId = EntryTypeId
                            FeeType.Name = FeeTypeName
                            Agency.FeeTypes.Add(FeeType.EntryTypeId, FeeType)
                        End If
                        Dim FeeTypeRate As New GridFeeTypeRate
                        FeeTypeRate.EntryTypeId = EntryTypeId
                        FeeTypeRate.Percent = Percent
                        If Not Recipient.FeeTypeRates.ContainsKey(EntryTypeId) Then
                            Recipient.FeeTypeRates.Add(EntryTypeId, FeeTypeRate)
                        End If
                    End While
                End Using
            End Using
            Session("xls_servicefeemy_list") = Agencies
        End Using
        Dim sb As New StringBuilder
        RenderGrid(sb, Agencies)
        ltrGrid.Text = sb.ToString

    End Sub
    Private Sub RenderGrid(ByVal sb As StringBuilder, ByVal Agencies As Dictionary(Of Integer, GridAgency))
        Dim first As Boolean = True
        For Each Agency As GridAgency In Agencies.Values
            If Not first Then
                sb.Append("<tr><td>&nbsp;</td></tr>")
            Else
                first = False
            End If
            sb.Append("<tr><td><b>Client From: <u>" & Agency.Name & "</u></b></td></tr>")
            sb.Append("<tr><td>")

            sb.Append("<table class=""fixedlist"" onselectstart=""return false;"" style=""font-size:11px;font-family:tahoma"" cellspacing=""0"" cellpadding=""3"" width=""100%"" border=""0"">")
            sb.Append("<thead>")
            sb.Append("<tr><th style=""width:150px"">&nbsp;</th>")
            For Each Recipient As GridRecipient In Agency.Recipients.Values
                sb.Append("<th align=""left"" style=""width:80px""><b>" & Recipient.Name & "</b></th>")
            Next
            sb.Append("<th align=""right""><b>Total</b></th>")
            sb.Append("</tr>")
            sb.Append("</thead>")
            sb.Append("<tbody>")
            Dim even As Boolean
            For Each FeeType As GridFeeType In Agency.FeeTypes.Values
                even = Not even
                sb.Append("<tr " & IIf(even, "style=""background-color:#f1f1f1;""", "") & "><td>" & FeeType.Name & "</td>")
                Dim Total As Single = 0
                For Each Recipient As GridRecipient In Agency.Recipients.Values
                    Dim FeeTypeRate As GridFeeTypeRate = Nothing
                    If Recipient.FeeTypeRates.TryGetValue(FeeType.EntryTypeId, FeeTypeRate) Then
                        Total += FeeTypeRate.Percent
                        sb.Append("<td>" & (FeeTypeRate.Percent * 100).ToString("F2") & "%</td>")
                    Else
                        sb.Append("<td>0.00%</td>")
                    End If
                Next
                sb.Append("<td align=""right""" & IIf(Not Total = 1, " style=""color:red""", "") & "><b>" & (Total * 100).ToString("F2") & "%</b></td>")
                sb.Append("</tr>")
            Next
            sb.Append("</tbody>")
            sb.Append("</table></td></tr>")
        Next

    End Sub
    Protected Class GridFeeTypeRate
        Private _EntryTypeId As Integer
        Private _Percent As Single

        Public Property Percent() As Single
            Get
                Return _Percent
            End Get
            Set(ByVal value As Single)
                _Percent = value
            End Set
        End Property
        Public Property EntryTypeId() As Integer
            Get
                Return _EntryTypeId
            End Get
            Set(ByVal value As Integer)
                _EntryTypeId = value
            End Set
        End Property
        Public Sub New()

        End Sub
    End Class
    Protected Class GridFeeType
        Private _EntryTypeId As Integer
        Private _Name As String

        Public Property EntryTypeId() As Integer
            Get
                Return _EntryTypeId
            End Get
            Set(ByVal value As Integer)
                _EntryTypeId = value
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
        Public Sub New()

        End Sub
    End Class
    Protected Class GridRecipient
        Private _Name As String
        Private _FeesTypes As New Dictionary(Of Integer, GridFeeTypeRate)
        Private _CommRecId As Integer
        Public Property CommRecId() As Integer
            Get
                Return _CommRecId
            End Get
            Set(ByVal value As Integer)
                _CommRecId = value
            End Set
        End Property
        Public Property FeeTypeRates() As Dictionary(Of Integer, GridFeeTypeRate)
            Get
                Return _FeesTypes
            End Get
            Set(ByVal value As Dictionary(Of Integer, GridFeeTypeRate))
                _FeesTypes = value
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
        Public Sub New()

        End Sub
    End Class
    Protected Class GridAgency
        Private _Recipients As New Dictionary(Of Integer, GridRecipient)
        Private _FeeTypes As New Dictionary(Of Integer, GridFeeType)
        Private _Name As String
        Private _AgencyId As Integer

        Public Property AgencyId() As Integer
            Get
                Return (_AgencyId)
            End Get
            Set(ByVal value As Integer)
                _AgencyId = value
            End Set
        End Property
        Public Property FeeTypes() As Dictionary(Of Integer, GridFeeType)
            Get
                Return _FeeTypes
            End Get
            Set(ByVal value As Dictionary(Of Integer, GridFeeType))
                _FeeTypes = value
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
#End Region
End Class
