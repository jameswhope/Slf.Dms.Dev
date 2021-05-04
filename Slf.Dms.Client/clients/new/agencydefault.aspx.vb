Imports System
Imports System.data
Imports System.Collections.Generic

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class clients_new_agencydefault
    Inherits PermissionPage

    Private UserID As Integer
    Private AgencyID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserId = DataHelper.Nz_int(Context.User.Identity.Name)
        Dim strAgencyID As String = DataHelper.FieldLookup("tblAgency", "AgencyID", "UserID=" & UserId)

        If Integer.TryParse(strAgencyID, AgencyID) Then
            LoadClientsGrid()
        End If
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlMenu, c, "Clients-Refer New Clients")
        AddControl(pnlBody, c, "Clients-Refer New Clients")
    End Sub

    Private Sub LoadClientsGrid()
        Dim agh As New AgencyGridHelper("clients_new_agencydefault_aspx")

        Dim dt As DataTable = agh.GetContents()

        'create grid and write in values
        Dim sb As New StringBuilder

        sb.Append("<table onclick=""Grid_TableClick(this)"" onselectstart=""return false;"" border=""0"" cellspacing=""0"" cellpadding=""0"">")
        sb.Append(" <colgroup>")

        For i As Integer = 0 To dt.Columns.Count - 1
            sb.Append("<col class=""c" & i.ToString() & """ />")
        Next

        sb.Append(" </colgroup>")
        sb.Append(" <thead>")
        sb.Append("     <tr>")
        sb.Append("         <th class=""first"" SelectAll=""1""><div class=""header""><div class=""header2"">&nbsp;</div></div></th>")

        For Each c As DataColumn In dt.Columns
            sb.Append("     <th " + IIf(c.ColumnName = "Comments", "style=""width: 300px""", "") + "><div class=""header""><div>" & c.ColumnName & "</div></div></th>")
        Next

        sb.Append("     </tr>")
        sb.Append(" </thead>")
        sb.Append(" <tbody>")

        'render contents
        For rowIndex As Integer = 0 To dt.Rows.Count - 1
            Dim r As DataRow = dt.Rows(rowIndex)

            sb.Append(" <tr>")
            sb.Append("     <th><div>" & (rowIndex + 1).ToString() & "</div></th>")
            For i As Integer = 0 To dt.Columns.Count - 1
                Dim value As String = "&nbsp;"
                If Not IsDBNull(r(i)) Then
                    value = r(i)
                End If
                sb.Append(" <td")
                Dim e As String = agh.Validate(value, i + 1)
                If Not e = "1" Then
                    sb.Append(" error=""" & e & """ style=""width:100px;border:red 1px solid""")
                End If
                sb.Append("><div nowrap=""true"">" & value & "</div></td>")
            Next
            sb.Append(" </tr>")
        Next

        ' add the new record row
        sb.Append("     <tr key=""*"">")
        sb.Append("         <th><div>*</div></th>")

        For i As Integer = 1 To dt.Columns.Count
            sb.Append("     <td")
            If agh.Definitions(i - 1).Required Then
                sb.Append(" error=""Field is required""")
            End If
            sb.Append("><div nowrap=""true"">&nbsp;</div></td>")
        Next

        sb.Append("     </tr>")

        'finish off the bottom footer
        sb.Append("     <tr>")
        sb.Append("         <td colspan=""" & dt.Columns.Count + 1 & """ style=""height:25;""></td>")
        sb.Append("     </tr>")
        sb.Append(" </tbody>")
        sb.Append("</table>")

        'add to grid div
        grdClients.InnerHtml = sb.ToString() + innerHtml.InnerHtml
        innerHtml.Visible = False

    End Sub
    Private Function GetDropDownLists() As String

        Dim cboPaymentType As New DropDownList

        cboPaymentType.Items.Add(New ListItem("", ""))
        cboPaymentType.Items(0).Selected = True
        cboPaymentType.Items.Add(New ListItem("ACH", "ACH"))
        cboPaymentType.Items.Add(New ListItem("Check", "Check"))
        cboPaymentType.Items.Add(New ListItem("Money Order", "Money Order"))

        cboPaymentType.Attributes("class") = "grdDDL uns"
        cboPaymentType.Attributes("onkeydown") = "Grid_DDL_OnKeyDown(this);"
        cboPaymentType.Attributes("onblur") = "Grid_DDL_OnBlur(this);"

        'render controls out to string
        Using Writer As New IO.StringWriter
            Using HtmlWriter As New HtmlTextWriter(Writer)

                cboPaymentType.RenderControl(HtmlWriter)

                Return Writer.ToString()

            End Using
        End Using

    End Function
    Private Function GetSelectedRows() As List(Of Integer)
        Dim result As New List(Of Integer)

        If txtSelected.Value.Length > 0 Then
            Dim parts() As String = txtSelected.Value.Split(",")
            For Each s As String In parts
                result.Add(Integer.Parse(s))
            Next
        End If

        Return result
    End Function
    Private Sub InsertClients()
        Dim Selected As List(Of Integer) = GetSelectedRows()

        Dim AgencyId As Integer = Integer.Parse(DataHelper.FieldLookup("tblAgency", "AgencyId", "UserId=" & UserID))

        Dim agh As New AgencyGridHelper("clients_new_agencydefault_aspx")
        Dim dt As DataTable = agh.GetContents(True)

        If dt.Rows.Count > 0 Then

            For ri As Integer = dt.Rows.Count - 1 To 0 Step -1 'must iterate in reverse direction because of row delete logic
                If Selected.Count = 0 Or Selected.Contains(ri + 1) Then 'if there is no selection, or this is a selected row
                    Dim r As DataRow = dt.Rows(ri)

                    Dim NewClientID As Integer = -1
                    Dim NewPersonID As Integer = -1
                    Dim NewEnrollmentID As Integer = -1

                    'prepare a fresh data command for person insert
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                        DatabaseHelper.AddParameter(cmd, "FirstName", r("First Name"))
                        DatabaseHelper.AddParameter(cmd, "LastName", r("Last Name"))
                        If Not IsDBNull(r("SSN")) Then DatabaseHelper.AddParameter(cmd, "SSN", r("SSN"))
                        DatabaseHelper.AddParameter(cmd, "LanguageId", DataHelper.FieldLookup("tblLanguage", "LanguageId", "[default]=1"))

                        DatabaseHelper.AddParameter(cmd, "Relationship", "Prime")
                        DatabaseHelper.AddParameter(cmd, "CanAuthorize", True)
                        DatabaseHelper.AddParameter(cmd, "ClientId", NewClientID)

                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                        DatabaseHelper.BuildInsertCommandText(cmd, "tblPerson", "PersonId", SqlDbType.Int)

                        Using cmd.Connection

                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()

                            NewPersonID = DataHelper.Nz_int(cmd.Parameters("@PersonID").Value)

                        End Using

                    End Using

                    'get default company
                    Dim CompanyID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblCompany", _
                        "CompanyID", "[Default] = 1"))

                    'prepare a fresh data command for client insert
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        If Not IsDBNull(r("Payment Type")) Then DatabaseHelper.AddParameter(cmd, "DepositMethod", r("Payment Type"))

                        If Not IsDBNull(r("Payment Amt")) Then DatabaseHelper.AddParameter(cmd, "DepositAmount", r("Payment Amt"))
                        DatabaseHelper.AddParameter(cmd, "EnrollmentId", NewEnrollmentID)
                        DatabaseHelper.AddParameter(cmd, "PrimaryPersonId", NewPersonID)
                        DatabaseHelper.AddParameter(cmd, "AgencyId", AgencyId)
                        DatabaseHelper.AddParameter(cmd, "CompanyID", CompanyID)

                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                        DatabaseHelper.BuildInsertCommandText(cmd, "tblClient", "ClientId", SqlDbType.Int)

                        Using cmd.Connection

                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()

                            NewClientID = DataHelper.Nz_int(cmd.Parameters("@ClientID").Value)

                        End Using
                    End Using

                    'prepare a fresh data command for enrollment insert
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                        DatabaseHelper.AddParameter(cmd, "ClientId", NewClientID)

                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

                        DatabaseHelper.BuildInsertCommandText(cmd, "tblEnrollment", "EnrollmentId", SqlDbType.Int)

                        Using cmd.Connection

                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()

                            NewEnrollmentID = DataHelper.Nz_int(cmd.Parameters("@EnrollmentId").Value)

                        End Using
                    End Using

                    'fix ref ID's to new ID's
                    DataHelper.FieldUpdate("tblClient", "EnrollmentID", NewEnrollmentID, "ClientId = " & NewClientID)
                    DataHelper.FieldUpdate("tblPerson", "ClientID", NewClientID, "PersonId = " & NewPersonID)

                    'load search
                    ClientHelper.LoadSearch(NewClientID)

                    'insert notes
                    Dim NewNoteId As Integer = -1

                    If Not IsDBNull(r("Comments")) Then
                        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                            DatabaseHelper.AddParameter(cmd, "Subject", "Agency Note")
                            DatabaseHelper.AddParameter(cmd, "Value", r("Comments"))
                            DatabaseHelper.AddParameter(cmd, "ClientID", NewClientID)

                            DatabaseHelper.AddParameter(cmd, "Created", Now)
                            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                            DatabaseHelper.BuildInsertCommandText(cmd, "tblNote", "NoteId", SqlDbType.Int)

                            Using cmd.Connection

                                cmd.Connection.Open()
                                cmd.ExecuteNonQuery()

                                NewNoteId = DataHelper.Nz_int(cmd.Parameters("@NoteId").Value)

                            End Using
                        End Using
                    End If

                    'prepare a fresh data command for extra fields insert
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                        DatabaseHelper.AddParameter(cmd, "ClientId", NewClientID)

                        If Not IsDBNull(r("Lead Number")) Then
                            DatabaseHelper.AddParameter(cmd, "LeadNumber", r("Lead Number"))
                        End If
                        If Not IsDBNull(r("Date Sent")) Then
                            DatabaseHelper.AddParameter(cmd, "DateSent", r("Date Sent"))
                        End If
                        If Not IsDBNull(r("Date Received")) Then
                            DatabaseHelper.AddParameter(cmd, "DateReceived", r("Date Received"))
                        End If
                        If Not IsDBNull("Seideman Pull Date") Then
                            DatabaseHelper.AddParameter(cmd, "SeidemanPullDate", r("Seideman Pull Date"))
                        End If
                        If Not IsDBNull(r("Missing Info")) Then
                            DatabaseHelper.AddParameter(cmd, "MissingInfo", r("Missing Info"))
                        End If
                        If Not IsDBNull(r("Debt Total")) Then
                            DatabaseHelper.AddParameter(cmd, "DebtTotal", r("Debt Total"))
                        End If

                        If Not NewNoteId = -1 Then
                            DatabaseHelper.AddParameter(cmd, "NoteId", NewNoteId)
                        End If

                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                        DatabaseHelper.BuildInsertCommandText(cmd, "tblAgencyExtraFields01")

                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using

                    'delete this row from the queue
                    Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ClientQueue_DeleteRow")
                        DatabaseHelper.AddParameter(cmd, "AgencyID", AgencyId)
                        DatabaseHelper.AddParameter(cmd, "Row", ri + 1)
                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using

                    'add roadmap status(s)
                    RoadmapHelper.InsertRoadmap(NewClientID, 21, Nothing, UserID) 'Received from Agency
                    RoadmapHelper.InsertRoadmap(NewClientID, 23, Nothing, UserID) 'Pending Review
                End If
            Next
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        InsertClients()

        Response.Redirect("~/research/queries/clients/agency.aspx")

    End Sub

End Class
