Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports Microsoft.VisualBasic

Partial Class clients_client_matters_matterroadmap

    Inherits System.Web.UI.Page

#Region "Variables"

    Public QueryString As String
    Private Shadows ClientID As Integer
    Private MatterID As Integer
    Private AccountId As Integer
    Private Action As String
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"

    Private grdRoadmap As New Slf.Dms.Controls.RoadmapGrid
    Private strMatterDesc As String = String.Empty
    Private strDate As String = String.Empty
    Private strCreatedBy As String = String.Empty
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()
        PrepQuerystring()

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            MatterID = DataHelper.Nz_int(qs("mid"), 0)
            AccountId = DataHelper.Nz_int(qs("aid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then
                LoadClientStatuses()
                'LoadRoadmaps()
                If MatterID > 0 Then
                    LoadMatterAuditsByMatterID()
                Else
                    LoadMatterAudits()
                    LoadCreditorDetails()
                End If
                LoadPrimaryPerson()
                'LoadMatterDetail()

                ddlNewClientStatusId.SelectedIndex = CInt(Request.QueryString("status"))

                imDate.Text = DateTime.Now.ToString("MMddyyyyhhmmtt")
            End If
        End If
    End Sub

    Private Sub LoadCreditorDetails()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "select oc.name as OriginalCreditorName, RIGHT(oci.accountnumber,4) as OriginalAccountNumber from tblaccount a inner join tblcreditorinstance oci ON a.originalcreditorinstanceid = oci.creditorinstanceid inner join tblcreditor oc ON oci.creditorid = oc.creditorid where clientid=@ClientID and a.accountid=@AccountID"
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "AccountId", AccountId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        lblMatterNumber.Text = rd("OriginalCreditorName")
                        lblClientInfo.Text = "***" & rd("OriginalAccountNumber")
                    End While

                End Using
            End Using
        End Using
    End Sub

    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub

    Private Sub LoadClientStatuses()
        ddlNewClientStatusId.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.CommandText = "SELECT * FROM tblClientStatus"
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read()
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        Dim Id As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusId")
                        ddlNewClientStatusId.Items.Add(New ListItem(Name, Id))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterAudits()
        Dim rdMatter As IDataReader = Nothing
        Dim cmdMatter As IDbCommand = ConnectionFactory.Create().CreateCommand
        Dim strHTML As String = String.Empty

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
        Try
            cmd.Connection.Open()
            'loading matters information
            cmdMatter.Connection.Open()
            cmdMatter.CommandText = "stp_GetMattersbyClientAccount"
            cmdMatter.CommandType = CommandType.StoredProcedure
            DatabaseHelper.AddParameter(cmdMatter, "ClientId", ClientID)
            DatabaseHelper.AddParameter(cmdMatter, "AccountId", AccountId)
            rdMatter = cmdMatter.ExecuteReader()

            'for header creation
            strHTML = "<table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">  <tr>      <td class=""rmgHeaderStatus""></td>      <td class=""rmgHeaderStatus"">Action</td>      <td class=""rmgHeaderCreated"">When</td>      <td class=""rmgHeaderFacilitator"">Facilitated By</td>  </tr></table>"
            'end of header creation

            While rdMatter.Read()

                'lblMatterNumber.Text = rdMatter("MatterNumber")
                'lblClientInfo.Text = rdMatter(7)

                strMatterDesc = rdMatter("MatterMemo")
                strDate = DatabaseHelper.Peel_datestring(rdMatter, "CreatedDateTime", "MMM dd, yyyy hh:mm tt ")
                strCreatedBy = rdMatter("CreatedBy")
                Dim strFname As String = DataHelper.FieldLookup("tblUser", "FirstName", "UserId=" & strCreatedBy)
                Dim strLname As String = DataHelper.FieldLookup("tblUser", "LastName", "UserId=" & strCreatedBy)
                strCreatedBy = strFname & " " & strLname

                MatterID = rdMatter("MatterID")
                'loading matter audits
                cmd.CommandText = "stp_GetMatterAudit"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Clear()
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterID)
                rd = cmd.ExecuteReader()

                strHTML &= "<table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0""> " & _
                "<tr class=""rmgRow"">      <td class=""rmgCellFirst"">" & _
                "<table class=""rmgCellTable"" cellpadding=""0"" cellspacing=""0"" border=""0""> <tr><td class=""rmgCellStatus"" style=""width:35px""><a class=""lnk"" href=""#""><img border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/matter.jpg") & """/></a></td><td class=""rmgCellStatus"">" & strMatterDesc & "</td><td class=""rmgCellCreated"">" & strDate & "</td>     <td class=""rmgCellFacilitator"">" & strCreatedBy & "&nbsp;</td> </tr></table></td>  </tr></table>"

                strHTML &= "<table>"

                While rd.Read()
                    ' strHTML &= "<table>"
                    If DatabaseHelper.Peel_int(rd, "seq") = 1 Then
                        Dim strFieldName As String = String.Empty
                        Dim strUpdatedDate As String = String.Empty
                        Dim strValue As String = String.Empty
                        Dim strUpdatedBy As String = String.Empty
                        If Not IsDBNull(rd("change")) Then
                            strValue = rd("change")
                        End If
                        If Not IsDBNull(rd("description")) Then
                            strFieldName = rd("description") 'fieldname
                        End If
                        If Not IsDBNull(rd("created")) Then
                            strUpdatedDate = DatabaseHelper.Peel_datestring(rd, "created", "MMM dd, yyyy hh:mm tt ") 'updatedate
                        End If

                        If Not IsDBNull(rd("createdbyname")) Then
                            strUpdatedBy = rd("createdbyname") 'username
                        End If
                        'strFieldName = strFieldName.Replace("Id", "")
                        strFieldName = strFieldName.Replace("MatterStatusCodeId", "Matter Status").Replace("AttorneyID", "Attorney").Replace("CreditorInstanceId", "Creditor Instance")
                        strHTML &= " <tr>      <td class=""rmgHolderFirst""><table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">  <tr class=""rmgRow"">      <td class=""rmgCell""><table class=""rmgCellTable"" cellpadding=""0"" cellspacing=""0"" border=""0""> <tr><td class=""rmgCellStatus"" style=""width:35px""><a class=""lnk"" href=""#""><img border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/matter.jpg") & """/></a></td><td nowrap=""true"" class=""rmgCellStatus""><img align=""absmiddle"" class=""rmgImage"" runat=""server"" src=""" & ResolveUrl("~/images/rootend.png") & """ border=""0""> Changed  " & strFieldName & "   " & strValue & "</td><td class=""rmgCellCreated"">" & strUpdatedDate & "</td>     <td class=""rmgCellFacilitator"">" & strUpdatedBy & "&nbsp;</td> </tr></table></td>  </tr> " '</table></td>  </tr>

                    ElseIf DatabaseHelper.Peel_int(rd, "seq") = 2 Then
                        'Continue While
                        Dim task As New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                       0, _
                       0, _
                       "", _
                       0, _
                       "", _
                       0, _
                       "", _
                       DatabaseHelper.Peel_string(rd, "Description"), _
                       0, _
                       "", _
                       DatabaseHelper.Peel_date(rd, "Due"), _
                       DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                     0, _
                       "", _
                       0, _
                       "", _
                       DatabaseHelper.Peel_date(rd, "Created"), _
                       0, _
                       DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                       Nothing, _
                       0, _
                       "")
                        'colspan=""4"" 
                        strHTML &= "<tr>    <td class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_calendar.png") & """ border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"">" & task.Description & "</td>  <td class=""rmgCellTaskResolved""><a style=""color:rgb(0,129,0);""  href=""" & ResolveUrl("~/tasks/task/resolve.aspx?id=" & task.TaskID & "") & """ class=""lnk"">" & task.StatusFormatted & "</a><br><font class=""rmgCellTaskResolvedDate"">" & task.Resolved & "</font></td>  <td class=""rmgCellTaskCreated"">" & task.Created & "</td>  <td class=""rmgCellTaskFacilitator"">" & task.CreatedByName & "&nbsp;</td></tr>        </table>    </td></tr> "

                    ElseIf DatabaseHelper.Peel_int(rd, "seq") = 3 Then
                        'Continue While

                        Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                        Dim UserType As String = DatabaseHelper.Peel_string(rd, "change") 'UserType
                        Dim NoteDate As String = DatabaseHelper.Peel_date(rd, "created") 'Date
                        Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                        'colspan=""4""
                        strHTML &= "<tr>    <td  class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage""><img  runat=""server"" src=""" & ResolveUrl("~/images/16x16_note.png") & """ border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"">" & Value & "</td>    <td class=""rmgCellTaskCreated"">" & NoteDate & "</td>  <td class=""rmgCellTaskFacilitator"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "
                    ElseIf DatabaseHelper.Peel_int(rd, "seq") = 4 Then

                        Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                        Dim starttime As Date = DatabaseHelper.Peel_date(rd, "created") 'Value
                        Dim endtime As Date = DatabaseHelper.Peel_date(rd, "Resolved") 'Value
                        Value = Value & "->" & LocalHelper.FormatTimeSpan(endtime.Subtract(starttime)) & "&nbsp;(" & starttime.ToString("hh:mm tt") & "->" & endtime.ToString("hh:mm tt") & "&nbsp;)"
                        Dim strDirection As String = DatabaseHelper.Peel_string(rd, "change")
                        Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                        strHTML &= "<tr>    <td  class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_call" & strDirection & ".png") & """  border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"">" & Value & "</td>    <td class=""rmgCellTaskCreated"">" & starttime & "</td>  <td class=""rmgCellTaskFacilitator"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "
                    ElseIf DatabaseHelper.Peel_int(rd, "seq") = 5 Then
                        Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                        Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                        Dim starttime As Date = DatabaseHelper.Peel_date(rd, "created") 'Value
                        Dim receivedDate As Date = DatabaseHelper.Peel_date(rd, "due") 'Value
                        Value = Value & "&nbsp;Received Date->" & receivedDate.ToString("mm/dd/yyyy")
                        strHTML &= "<tr>    <td  class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_no_file.png") & """ border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"">" & Value & "</td>    <td class=""rmgCellTaskCreated"">" & starttime & "</td>  <td class=""rmgCellTaskFacilitator"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "

                    ElseIf DatabaseHelper.Peel_int(rd, "seq") = 6 Then
                        'Continue While

                        Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                        Dim UserType As String = DatabaseHelper.Peel_string(rd, "change") 'UserType
                        Dim EMailDate As String = DatabaseHelper.Peel_date(rd, "created") 'Date
                        Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                        'colspan=""4""
                        strHTML &= "<tr>    <td  class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_email_read.png") & """  border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"">" & Value & "</td>    <td class=""rmgCellTaskCreated"">" & EMailDate & "</td>  <td class=""rmgCellTaskFacilitator"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "
                    End If
                    'strHTML &= "</table>"

                End While
                rd.Close()
                strHTML &= "</table>"
            End While
            rdMatter.Close()
            lblMatterAudits.Text = strHTML

        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            DatabaseHelper.EnsureReaderClosed(rdMatter)
            DatabaseHelper.EnsureConnectionClosed(cmdMatter.Connection)
        End Try

    End Sub

    Private Sub LoadMatterAuditsByMatterID()
        LoadMatterDetail()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
        Try
            cmd.Connection.Open()
            cmd.CommandText = "stp_GetMatterAudit"
            cmd.CommandType = CommandType.StoredProcedure
            DatabaseHelper.AddParameter(cmd, "MatterId", MatterID)
            rd = cmd.ExecuteReader()
            Dim strHTML As String = String.Empty
            'for header creation
            strHTML = "<table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"" width=""100%"">  <tr>      <td class=""rmgHeaderStatus"" width=""5%"" align=""center""></td>      <td class=""rmgHeaderStatus"" width=""50%"" align=""left"">Action</td>      <td class=""rmgHeaderCreated"" width=""25%"" align=""center"">When</td>      <td class=""rmgHeaderFacilitator"" width=""20%"" align=""center"">Facilitated By</td>  </tr></table>"
            'end of header creation

            strHTML &= "<table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"" width=""100%""> " & _
            "<tr class=""rmgRow"">      <td class=""rmgCellFirst"" width=""100%"">" & _
            "<table class=""rmgCellTable"" cellpadding=""0"" cellspacing=""0"" border=""0""> <tr><td class=""rmgCellStatus"" style=""width:5%""  align=""center""><a class=""lnk"" href=""#""><img border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/matter.jpg") & """/></a></td><td class=""rmgCellStatus"" width=""50%"" align=""left"">" & strMatterDesc & "</td><td class=""rmgCellCreated"" width=""25%"" align=""center"">" & strDate & "</td>     <td class=""rmgCellFacilitator"" width=""20%"" align=""center"">" & strCreatedBy & "&nbsp;</td> </tr></table></td>  </tr></table>"

            strHTML &= "<table>"

            While rd.Read()
                ' strHTML &= "<table>"
                If DatabaseHelper.Peel_int(rd, "seq") = 1 Then
                    Dim strFieldName As String = String.Empty
                    Dim strUpdatedDate As String = String.Empty
                    Dim strValue As String = String.Empty
                    Dim strUpdatedBy As String = String.Empty

                    strValue = DatabaseHelper.Peel_string(rd, "change")
                    strFieldName = DatabaseHelper.Peel_string(rd, "Description") 'fieldname
                    'strFieldName = strFieldName.Replace("Id", "")
                    strFieldName = strFieldName.Replace("MatterStatusCodeId", "Matter Status").Replace("AttorneyID", "Attorney").Replace("CreditorInstanceId", "Creditor Instance")
                    strUpdatedDate = DatabaseHelper.Peel_datestring(rd, "created", "MMM dd, yyyy hh:mm tt ") 'updatedate
                    strUpdatedBy = DatabaseHelper.Peel_string(rd, "CreatedByName") 'username
                    strHTML &= " <tr>      <td class=""rmgHolderFirst"" width=""100%""><table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">  <tr class=""rmgRow"">      <td class=""rmgCell""><table class=""rmgCellTable"" cellpadding=""0"" cellspacing=""0"" border=""0""> <tr><td class=""rmgCellStatus"" style=""width:5%"" align=""center""><a class=""lnk"" href=""#""><img border=""0""runat=""server"" src=""" & ResolveUrl("~/images/matter.jpg") & """ /></a></td><td nowrap=""true"" class=""rmgCellStatus"" width=""50%"" align=""left""><img align=""absmiddle"" class=""rmgImage""runat=""server"" src=""" & ResolveUrl("~/images/rootend.png") & """  border=""0""> Changed  " & strFieldName & "   " & strValue & "</td><td class=""rmgCellCreated"" width=""25%"" align=""center"">" & strUpdatedDate & "</td>     <td class=""rmgCellFacilitator"" width=""20%"" align=""center"">" & strUpdatedBy & "&nbsp;</td> </tr></table></td>  </tr> " '</table></td>  </tr>

                ElseIf DatabaseHelper.Peel_int(rd, "seq") = 2 Then
                    'Continue While
                    Dim task As New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                   0, _
                   0, _
                   "", _
                   0, _
                   "", _
                   0, _
                   "", _
                   DatabaseHelper.Peel_string(rd, "Description"), _
                   0, _
                   "", _
                   DatabaseHelper.Peel_date(rd, "Due"), _
                   DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                 0, _
                   "", _
                   0, _
                   "", _
                   DatabaseHelper.Peel_date(rd, "Created"), _
                   0, _
                   DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                   Nothing, _
                   0, _
                   "")
                    'colspan=""4"" 
                    strHTML &= "<tr>    <td class=""rmgCellTask"" width=""100%"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0"" width=""100%""><tr>  <td class=""rmgCellTaskImage"" style=""width:5%"" align=""center""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_calendar.png") & """  border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"" width=""50%"" align=""left"">" & task.Description & "</td>  <td class=""rmgCellTaskResolved""><a style=""color:rgb(0,129,0);"" href=""" & ResolveUrl("~/tasks/task/resolve.aspx?id=" & task.TaskID & "") & """ class=""lnk"">" & task.StatusFormatted & "</a><br><font class=""rmgCellTaskResolvedDate"">" & task.Resolved & "</font></td>  <td class=""rmgCellTaskCreated"">" & task.Created & "</td>  <td class=""rmgCellTaskFacilitator"">" & task.CreatedByName & "&nbsp;</td></tr>        </table>    </td></tr> "


                    'for fetching child records
                    Dim rdChilds As IDataReader = Nothing
                    Dim cmdChilds As IDbCommand = ConnectionFactory.Create().CreateCommand
                    Try
                        Dim iTaskId As Integer = DatabaseHelper.Peel_int(rd, "TaskID")
                        cmdChilds.Connection.Open()
                        cmdChilds.CommandText = "select  tbltask.taskid, tbltask.Resolved,   tbltask.Description, tbltask.Due , " & _
                            " tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname ,tbltask.created, '' as change " & _
                            " from tbltask left outer join tbluser as tblcreatedby on tbltask.createdby = tblcreatedby.userid  " & _
                            " WHERE tbltask.parenttaskid=@parenttaskid"
                        cmdChilds.CommandType = CommandType.Text
                        DatabaseHelper.AddParameter(cmdChilds, "parenttaskid", iTaskId)
                        rdChilds = cmdChilds.ExecuteReader()

                        While rdChilds.Read()
                            Dim taskChild As New Task(DatabaseHelper.Peel_int(rdChilds, "TaskID"), _
                                  0, _
                                  0, _
                                  "", _
                                  0, _
                                  "", _
                                  0, _
                                  "", _
                                  DatabaseHelper.Peel_string(rdChilds, "Description"), _
                                  0, _
                                  "", _
                                  DatabaseHelper.Peel_date(rdChilds, "Due"), _
                                  DatabaseHelper.Peel_ndate(rdChilds, "Resolved"), _
                                0, _
                                  "", _
                                  0, _
                                  "", _
                                  DatabaseHelper.Peel_date(rdChilds, "Created"), _
                                  0, _
                                  DatabaseHelper.Peel_string(rdChilds, "CreatedByName"), _
                                  Nothing, _
                                  0, _
                                  "")
                            strHTML &= "<tr>    <td class=""rmgCellTask"" width=""100%"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0"" width=""100%""><tr>  <td class=""rmgCellTaskImage"" style=""width:5%"" align=""center""></td>  <td class=""rmgCellTaskStatus"" width=""50%"" align=""left""><img align=""absmiddle"" class=""rmgImage"" runat=""server"" src=""" & ResolveUrl("~/images/rootend.png") & """ border=""0""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_calendar.png") & """  border=""0"" align=""absmiddle""/>&nbsp;&nbsp;" & taskChild.Description & "</td>  <td class=""rmgCellTaskResolved""><a style=""color:rgb(0,129,0);"" href=""" & ResolveUrl("~/tasks/task/resolve.aspx?id=" & taskChild.TaskID & "") & """ class=""lnk"">" & taskChild.StatusFormatted & "</a><br><font class=""rmgCellTaskResolvedDate"">" & taskChild.Resolved & "</font></td>  <td class=""rmgCellTaskCreated"" width=""25%"" align=""center"">" & taskChild.Created & "</td>  <td class=""rmgCellTaskFacilitator"" width=""20%"" align=""left"">" & taskChild.CreatedByName & "&nbsp;</td></tr>        </table>    </td></tr> "

                        End While

                    Catch
                    Finally
                        DatabaseHelper.EnsureReaderClosed(rdChilds)
                        DatabaseHelper.EnsureConnectionClosed(cmdChilds.Connection)
                    End Try

                ElseIf DatabaseHelper.Peel_int(rd, "seq") = 3 Then
                    'Continue While

                    Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                    Dim UserType As String = DatabaseHelper.Peel_string(rd, "change") 'UserType
                    Dim NoteDate As String = DatabaseHelper.Peel_date(rd, "created") 'Date
                    Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                    'colspan=""4""
                    strHTML &= "<tr>    <td  class=""rmgCellTask"" width=""100%"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0"" width=""100%""><tr>  <td class=""rmgCellTaskImage"" style=""width:5%"" align=""center""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_note.png") & """  border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"" width=""50%"" align=""left"">" & Value & "</td>    <td class=""rmgCellTaskCreated"" width=""25%"" align=""center"">" & NoteDate & "</td>  <td class=""rmgCellTaskFacilitator"" width=""20%"" align=""left"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "

                ElseIf DatabaseHelper.Peel_int(rd, "seq") = 4 Then

                    Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                    Dim starttime As Date = DatabaseHelper.Peel_date(rd, "created") 'Value
                    Dim endtime As Date = DatabaseHelper.Peel_date(rd, "Resolved") 'Value
                    Value = Value & "->" & LocalHelper.FormatTimeSpan(endtime.Subtract(starttime)) & "&nbsp;(" & starttime.ToString("hh:mm tt") & "->" & endtime.ToString("hh:mm tt") & "&nbsp;)"
                    Dim strDirection As String = DatabaseHelper.Peel_string(rd, "change")
                    Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                    strHTML &= "<tr>    <td  class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage"" style=""width:5%"" align=""center""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_call" & strDirection & ".png") & """ border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"" width=""50%"" align=""left"">" & Value & "</td>    <td class=""rmgCellTaskCreated"" width=""25%"" align=""center"">" & starttime & "</td>  <td class=""rmgCellTaskFacilitator"" width=""20%"" align=""left"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "

                ElseIf DatabaseHelper.Peel_int(rd, "seq") = 5 Then
                    Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                    Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                    Dim starttime As Date = DatabaseHelper.Peel_date(rd, "created") 'Value
                    Dim receivedDate As Date = DatabaseHelper.Peel_date(rd, "due") 'Value
                    Value = Value & "&nbsp;Received Date->" & receivedDate.ToString("mm/dd/yyyy")
                    strHTML &= "<tr>    <td  class=""rmgCellTask"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage"" style=""width:5%"" align=""center""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_no_file.png") & """ border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"" width=""50%"" align=""left"">" & Value & "</td>    <td class=""rmgCellTaskCreated"" width=""25%"" align=""center"">" & starttime & "</td>  <td class=""rmgCellTaskFacilitator"" width=""20%"" align=""left"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "

                ElseIf DatabaseHelper.Peel_int(rd, "seq") = 6 Then
                    'Continue While

                    Dim Author As String = DatabaseHelper.Peel_string(rd, "createdbyname") 'By
                    Dim UserType As String = DatabaseHelper.Peel_string(rd, "change") 'UserType
                    Dim EMailDate As String = DatabaseHelper.Peel_date(rd, "created") 'Date
                    Dim Value As String = DatabaseHelper.Peel_string(rd, "description") 'Value
                    'colspan=""4""
                    strHTML &= "<tr>    <td  class=""rmgCellTask"" width=""100%"">        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0""><tr>  <td class=""rmgCellTaskImage"" style=""width:5%"" align=""center""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_email_read.png") & """ border=""0"" align=""absmiddle""/></td>  <td class=""rmgCellTaskStatus"" width=""50%"" align=""left"">" & Value & "</td>    <td class=""rmgCellTaskCreated"" width=""25%"" align=""center"">" & EMailDate & "</td>  <td class=""rmgCellTaskFacilitator"" width=""20%"" align=""left"">" & Author & "&nbsp;</td></tr>        </table>    </td></tr> "
                End If
                'strHTML &= "</table>"

            End While
            rd.Close()
            strHTML &= "</table>"
            lblMatterAudits.Text = strHTML
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)

        End Try

    End Sub

    Private Sub LoadMatterDetail()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetMatterInstance"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterID)
                DatabaseHelper.AddParameter(cmd, "AccountId", AccountId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        lblMatterMemo.Text = rd("Note")
                        lblMatterNumber.Text = rd("MatterNumber")
                        strMatterDesc = rd("Note")
                        strDate = DatabaseHelper.Peel_datestring(rd, "CreatedDateTime", "MMM dd, yyyy hh:mm tt ")
                        strCreatedBy = rd("CreatedBy")
                        Dim strFname As String = DataHelper.FieldLookup("tblUser", "FirstName", "UserId=" & strCreatedBy)
                        Dim strLname As String = DataHelper.FieldLookup("tblUser", "LastName", "UserId=" & strCreatedBy)
                        strCreatedBy = strFname & " " & strLname
                        lblClientInfo.Text = rd("AccountNumber") & "<br>" & rd("localcounsel")
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadRoadmaps()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRoadmapsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Roadmap As New Roadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), _
                    DatabaseHelper.Peel_int(rd, "ParentRoadmapID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_int(rd, "ClientStatusID"), _
                    DatabaseHelper.Peel_int(rd, "ParentClientStatusID"), _
                    DatabaseHelper.Peel_string(rd, "ClientStatusName"), _
                    DatabaseHelper.Peel_string(rd, "Reason"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"))

                LoadNotesForRoadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), Roadmap)
                LoadTasksForRoadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), Roadmap)

                grdRoadmap.AddRoadmap(Roadmap)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        pnlRoadmap.Controls.Add(grdRoadmap)

    End Sub
    Private Sub LoadNotesForRoadmap(ByVal RoadmapID As Integer, ByVal Roadmap As Roadmap)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForRoadmap")

        DatabaseHelper.AddParameter(cmd, "RoadmapID", RoadmapID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Roadmap.Notes.Add(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    New Note(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    DatabaseHelper.Peel_string(rd, "Value"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadTasksForRoadmap(ByVal RoadmapID As Integer, ByVal Roadmap As Roadmap)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasksForRoadmap")

        DatabaseHelper.AddParameter(cmd, "RoadmapID", RoadmapID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Task As New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_string(rd, "ClientName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                    DatabaseHelper.Peel_string(rd, "Description"), _
                    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                    DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                    DatabaseHelper.Peel_date(rd, "Due"), _
                    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"))

                LoadNotesForTask(Task.TaskID, Task)

                Roadmap.Tasks.Add(Task.TaskID, Task)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadNotesForTask(ByVal TaskID As Integer, ByVal Task As Task)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Task.Notes.Add(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    New Note(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    DatabaseHelper.Peel_string(rd, "Value"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPrimaryPerson()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(ClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)

                lblName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(DatabaseHelper.Peel_string(rd, "SSN"), "___-__-____")

            Else
                lblName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(ClientID, Now)

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim NumApplicants As Integer = DataHelper.FieldCount("tblPerson", "PersonID", "ClientID = " & ClientID)

        If NumApplicants > 1 Then
            lnkNumApplicants.InnerText = "(" & NumApplicants & ")"
            lnkNumApplicants.HRef = "~/clients/client/applicants/" & QueryString
        End If

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Protected Sub lnkChangeStatus_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeStatus.Click
        If ddlNewClientStatusId.SelectedValue = 17 Then
            Response.Redirect("reasonsTree.aspx?id=" + ClientID.ToString() + "&date=" + imDate.Text)
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "ClientStatusId", ddlNewClientStatusId.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", Integer.Parse(Page.User.Identity.Name))
                DatabaseHelper.AddParameter(cmd, "Reason", "Manually created")
                Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, Now, "RoadmapID"))
                If Not chkAsRoot.Checked And Not CurrentRoadmapID = 0 Then
                    DatabaseHelper.AddParameter(cmd, "ParentRoadmapId", CurrentRoadmapID)
                End If
                If Not String.IsNullOrEmpty(imDate.Text) Then
                    DatabaseHelper.AddParameter(cmd, "Created", DateTime.Parse(imDate.Text))
                    DatabaseHelper.AddParameter(cmd, "LastModified", DateTime.Parse(imDate.Text))
                    ' imDate.Text = Date.Now.ToString("MMddyyyy")
                Else
                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)

                End If
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", Integer.Parse(Page.User.Identity.Name))

                DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmap")
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Response.Redirect("roadmap.aspx?id=" + ClientID.ToString() + "&status=" + ddlNewClientStatusId.SelectedIndex.ToString())
    End Sub

    Private Sub AddRoadmapIdsRecursive(ByVal l As List(Of Integer), ByVal RoadmapId As Integer)
        l.Add(RoadmapId)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT RoadmapId FROM tblRoadmap WHERE ParentRoadmapId=@RoadmapId"
                DatabaseHelper.AddParameter(cmd, "RoadmapId", RoadmapId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        AddRoadmapIdsRecursive(l, DatabaseHelper.Peel_int(rd, "RoadmapID"))
                    End While
                End Using
            End Using
        End Using
    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Dim RoadmapIds As New List(Of Integer)
        AddRoadmapIdsRecursive(RoadmapIds, Integer.Parse(txtRoadmapId.Value))

        For Each RoadmapId As Integer In RoadmapIds
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "DELETE FROM tblRoadmap WHERE RoadmapId=@RoadmapId"
                    DatabaseHelper.AddParameter(cmd, "RoadmapId", RoadmapId)
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Next
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub


End Class