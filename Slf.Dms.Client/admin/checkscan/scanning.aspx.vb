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

Partial Class check_scanning
    Inherits System.Web.UI.Page

    #Region "Fields"

    Public UserID As Integer
    Public UserScanFolder As String

    Private ContextSensitive As String
    Private  Dim _UserScanFile As String

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

    #Region "Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim folderRoot As String = ConfigurationManager.AppSettings("icl_DocumentPath").ToString.Replace("\", "\\")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserScanFolder = String.Format("{0}ScanTemp\\{1}\\", folderRoot, Format(Now, "yyyyMMdd"))
        If Not Directory.Exists(UserScanFolder.Replace("\\", "\")) Then
            Directory.CreateDirectory(UserScanFolder.Replace("\\", "\"))
        End If

        UserScanFolder = String.Format("{0}{1}\\", UserScanFolder, UserID)
        If Not Directory.Exists(UserScanFolder.Replace("\\", "\")) Then
            Directory.CreateDirectory(UserScanFolder.Replace("\\", "\"))
        End If

        ' SetRollups()
        If Not IsPostBack Then
            txtDate.Text = Format(Now, "MM/dd/yyyy")
            UserScanFile = String.Format("PreFormat_ClientCheck_{0}", Now.Ticks.ToString)
        End If
    End Sub

    Protected Sub lnkSave_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim tempFolder As String = String.Format("\\Lex-dev-30\ClientStorage\scanTemp\{0}\{1}\", Format(Now, "yyyyMMdd"), UserID)
        Dim tempFile As String = String.Format("{0}{1}.tif", UserScanFolder, UserScanFile)

        If File.Exists(tempFile) Then
            Dim dt As Date

            If Not DateTime.TryParse(txtDate.Text, dt) Then
                lblNote.Text = "An error occurred processing the received date!"
                lblNote.Visible = True
                Return
            End If

            Dim theFileInfo As FileInfo = New FileInfo(tempFile)
            Dim attrArc As System.IO.FileAttributes = theFileInfo.Attributes Or Not FileAttributes.Archive
            System.IO.File.SetAttributes(tempFile, attrArc)

            lblNote.Text = "Document saved!"
            lblNote.Visible = True
        Else
            lblNote.Text = "No scan found!"
            lblNote.Visible = True
        End If
    End Sub

#End Region 'Methods

End Class