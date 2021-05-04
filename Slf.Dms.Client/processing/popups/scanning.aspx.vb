Option Explicit On
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports system.Threading

Partial Class processing_popups_scanning
    Inherits System.Web.UI.Page

#Region "Fields"

    Public UserID As Integer
    Public SettlementId As String
    Public TaskTypeId As Integer
    Public AccountID As String
    Public UserScanFolder As String

    Private ContextSensitive As String
    Private _UserScanFile As String

#End Region 'Fields

#Region "Properties"

    Public Property UserScanFile() As String
        Get
            Return ViewState("_UserScanFile").ToString
        End Get
        Set(ByVal value As String)
            ViewState("_UserScanFile") = value
        End Set
    End Property

#End Region 'Properties

#Region "Events"
    ''' <summary>
    ''' Loads The content of the page
    ''' </summary>
    ''' <remarks>sid is the SettlementId 
    '''         Creates the path to Save the Settlement Agreement Form(Scanned) D6004SCAN
    '''         temporarily in the path ..\CLientApproval\SettlementId\AccountNumber_D6004SCAN_DateString.pdf</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.QueryString("sid") Is Nothing Then
            SettlementId = Request.QueryString("sid")
            TaskTypeId = Request.QueryString("ttypeid")
            Dim att As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(SettlementId)
            AccountID = att.SettlementClientSDAAccountNumber
            Dim DocTypeId As String
            If Not IsPostBack Then
                If TaskTypeId = 84 Then
                    DocTypeId = "D9022SCAN"
                Else
                    DocTypeId = "D6004SCAN"
                End If
                UserScanFile = String.Format("{0}_{2}_{1}", AccountID, String.Format("{0:yyMMdd}", DateTime.Now), DocTypeId)
            End If
        End If
        txtDate.Text = String.Format("{0:MM/dd/yyyy}", Today)
        Dim folderRoot As String = System.Configuration.ConfigurationManager.AppSettings("ClientApproval").Replace("\", "\\")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserScanFolder = String.Format("{0}\\ClientApproval\\{1}\\", folderRoot, SettlementId)
        If Not Directory.Exists(UserScanFolder.Replace("\\", "\")) Then
            Directory.CreateDirectory(UserScanFolder.Replace("\\", "\"))
        End If
    End Sub
    ''' <summary>
    ''' Validates and Saves the temporary file to the Server 
    ''' </summary>
    Protected Sub lnkSave_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim folderRoot As String = System.Configuration.ConfigurationManager.AppSettings("ClientApproval")
        Dim tempFolder As String = String.Format("{0}\ClientApproval\{1}\", folderRoot, SettlementId)
        Dim tempFile As String = String.Format("{0}{1}.pdf", tempFolder, UserScanFile)
        'tempFile = "c:\test.pdf"
        If File.Exists(tempFile) Then
            Dim dt As Date

            If Not DateTime.TryParse(txtDate.Text, dt) Then
                lblNote.Text = "An error occurred processing the received date!"
                lblNote.Visible = True
                Return
            End If

            lblNote.Text = "Document saved!"
            lblNote.Visible = True

            TaskTypeId = Request.QueryString("ttypeid")
            If TaskTypeId = 84 Then
                SettlementMatterHelper.ResolveClientStipulation(SettlementId, UserID, tempFile)
                'close popup
                ScriptManager.RegisterStartupScript(Me, GetType(Page), "closestip", "CloseStipulation();", True)
            End If
        Else
            lblNote.Text = "No scan found!"
            lblNote.Visible = True
        End If
    End Sub

#End Region 'Methods

End Class