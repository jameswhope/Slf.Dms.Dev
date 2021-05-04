Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Partial Class processing_popups_SendStipulationLetter
    Inherits System.Web.UI.Page

#Region "Declaration"
    Public SettlementID As Integer = 0
    Public UserID As Integer = 0
    Private Information As SettlementMatterHelper.SettlementInformation
#End Region

#Region "Events"
    ''' <summary>
    ''' Loads the content of the page
    ''' </summary>    
    ''' <remarks>sid is the settlementId</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Request.QueryString("sid") Is Nothing Then
            SettlementID = Integer.Parse(Request.QueryString("sid"))
            Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)
            If Not Me.IsPostBack Then
                LoadDoc(Information.MatterId)
                LoadEmailAddresses(Information.ClientID)
                LoadPrinters()
            End If
        End If

    End Sub

    Private Sub LoadDoc(ByVal MatterId As Integer)
        Me.lblDocument.Text = "<span style=""color: red;"">There is no document</span>"
        Dim filename As String = SettlementMatterHelper.GetStipulationDocPath(MatterId)
        hdnDoc.Value = filename.Trim
        If filename.Trim.Length > 0 AndAlso File.Exists(filename) Then
            filename = LocalHelper.GetVirtualDocFullPath(filename)
            Me.lblDocument.Text = String.Format("<div class=""lnkstipdoc""><a id=""lnkstipdoc"" href=""{0}"" target=""_blank""></a></div>", filename)
        End If
    End Sub

    Private Sub LoadEmailAddresses(ByVal ClientId As Integer)
        Dim emailaddresses As String() = NonDepositHelper.GetValidClientEmailAdresses(ClientId).Split(",")
        ddlEmailAddresses.DataSource = emailaddresses
        ddlEmailAddresses.DataBind()
    End Sub

    Private Sub LoadPrinters()
        'This should be read from the DB instead
        ddlPrinters.Items.Clear()
        ddlPrinters.Items.Add(New ListItem("Mail Room", "\\DMF-APP-0001\dmf-prn-0001"))
        ddlPrinters.Items.Add(New ListItem("Data Entry", "\\DMF-APP-0001\dmf-prn-0002"))
        ddlPrinters.Items.Add(New ListItem("IT", "\\DMF-APP-0001\dmf-prn-0016"))
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Try
            Dim doc As String = hdnDoc.Value.Trim
            Dim methodused As String = String.Empty
            Dim sentto As String = String.Empty
            Dim note As String = String.Empty
            If rdEmail.Checked Then
                methodused = "email"
                hdnEmail.Value = "opereira@lexxiom.com"
                sentto = hdnEmail.Value
                SettlementMatterHelper.EmailStipulationLetter(Information.ClientID, hdnEmail.Value.Trim, New List(Of String)(New String() {doc}))
            ElseIf rdPrinter.Checked Then
                methodused = "printer"
                Dim printer As String = Me.ddlPrinters.Items.FindByText(hdnPrinter.Value.Trim).Value
                sentto = printer
                If Not RawPrinterHelper.SendFileToPrinter(printer, doc) Then
                    Throw New Exception("Error Printing Stipulation Document")
                End If
                ReportsHelper.InsertPrintInfo("D9012", Information.ClientID, doc.Substring(doc.LastIndexOf("\")), UserID, 1)
            End If
            SettlementMatterHelper.InsertStipulationLog(SettlementID, doc, methodused, sentto, UserID)
            note = String.Format("A client stipulation letter for matter {0} was sent to client. ", Information.MatterId)
            If txtNote.Text.Trim.Length > 0 Then
                note = note & txtNote.Text.Trim.Replace("'", "")
            End If
            SettlementMatterHelper.AddSettlementNote(SettlementID, note, UserID)
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "closethiswindow", "CloseSend();", True)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "reporterror", String.Format("ShowMessage('{0}');", ex.Message.Replace("'", "")), True)
        End Try
    End Sub

#End Region



End Class
