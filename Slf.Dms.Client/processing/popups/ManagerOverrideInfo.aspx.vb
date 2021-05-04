Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Linq
Imports System.Xml.Linq

Partial Class processing_popups_ManagerOverrideInfo
    Inherits System.Web.UI.Page
#Region "Declaration"
    Public SettlementID As Integer = 0
    Public UserID As Integer = 0
    Private _AccountNumber As String
#End Region

#Region "Structures"
    ''' <summary>
    ''' Structure to Hold the Document information pertaining to a Settlement
    ''' </summary>
    ''' <remarks>DocumentName is the Display name of the doc, FolderName (CreditorDocs/ClientDocs/LegalDocs), 
    ''' Filepath is the SubFolder and Filename(AcctNumber_DocTypeId_DocId_DateString.pdf/tif) of the document</remarks>
    Public Structure DocScan
        Public DocumentName As String
        Public FolderName As String
        Public FilePath As String

        Public Sub New(ByVal _DocumentName As String, ByVal _FolderName As String, ByVal _FilePath As String)
            Me.DocumentName = _DocumentName
            Me.FilePath = _FilePath
            Me.FolderName = _FolderName
        End Sub
    End Structure
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
        End If
        If Not IsPostBack Then
            LoadSettlementInfo(SettlementID)
        End If
    End Sub
    ''' <summary>
    ''' Sub routine called on click of the Save link button
    ''' </summary>
    ''' <remarks>stp_ResolveManagerOverride - Inserts Note and adds the note relations to Matter, Client and Creditor
    '''                                       Updates Task as Completed
    '''                                       Marks Settlement as Active/InActive depending on IsApproved
    '''          stp_InsertTaskForSettlement - Creates a Task for Process Settlement Amount</remarks>
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        dvError.Style.Add("display", "none")
        tdError.InnerHtml = ""

        Dim isApproved As Boolean = True
        If radReject.Checked Then
            isApproved = False
        End If

        Dim returnParam As IDataParameter
        Dim returnValue As Integer
        Dim TaskTypeId As Integer
        Dim matterTransaction As IDbTransaction = Nothing
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()
            matterTransaction = CType(connection, IDbConnection).BeginTransaction(IsolationLevel.RepeatableRead)

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_ResolveManagerOverride"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementID)
                DatabaseHelper.AddParameter(cmd, "IsApproved", isApproved)
                DatabaseHelper.AddParameter(cmd, "Note", IIf(String.IsNullOrEmpty(txtNote.Text), Nothing, txtNote.Text))
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
                returnParam.Direction = ParameterDirection.ReturnValue
                cmd.Transaction = matterTransaction
                cmd.ExecuteNonQuery()
            End Using

            If returnParam.Value = 0 And returnValue = 0 Then
                matterTransaction.Commit()
                ClientScript.RegisterClientScriptBlock(GetType(Page), "ManagerPopup", "<script> window.onload = function() { CloseManagerOverride(); } </script>")
            Else
                matterTransaction.Rollback()
                dvError.Style.Add("display", "inline")
                tdError.InnerHtml = "An error occurred while resolving the task. Try Again"
            End If
        End Using
    End Sub
#End Region

#Region "User Control Subs/Funcs"
    ''' <summary>
    ''' Populates the Data on the Popup
    ''' </summary>
    ''' <param name="_SettlementId">Integer to uniquely identify a Settlement</param>
    Public Sub LoadSettlementInfo(ByVal _SettlementId As Integer)
        Me.SettCalcs.LoadSettlementInfo(_SettlementId)

        Dim DataClientid As Integer = (DataHelper.FieldLookupIDs("tblSettlements", "ClientId", "SettlementId = " & _SettlementId)(0))
        Dim CreditorAccountID As Integer = (DataHelper.FieldLookupIDs("tblSettlements", "CreditorAccountId", "SettlementId = " & _SettlementId)(0))

        If Not DataClientid = 0 Then
            LoadClientInfo(DataClientid)
        End If

        If Not String.IsNullOrEmpty(_AccountNumber) Then
            BuildDocuments(_SettlementId, DataClientid, _AccountNumber)
        End If
    End Sub

    ''' <summary>
    ''' Fetches the Data pertaining to the client
    ''' </summary>
    ''' <param name="_ClientId">Integer to uniquely identify a client</param>
    Private Sub LoadClientInfo(ByVal _ClientId As Integer)
        Dim dtClient As New Data.DataTable
        Using saTemp = New Data.SqlClient.SqlDataAdapter("stp_GetSettlementClientInfo " & _ClientId, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            saTemp.Fill(dtClient)
        End Using

        For Each dRow As DataRow In dtClient.Rows
            If CInt(dRow("isprime").ToString()) = 1 Then
                Me.lblClientName.Text = dRow("FirstName").ToString & " " & dRow("LastName").ToString
                _AccountNumber = dRow("Accountnumber").ToString
                Me.lblClientAccount.Text = dRow("Accountnumber").ToString
                Me.lblClientAddress.Text = PersonHelper.GetAddress(dRow("Street").ToString(), _
                      dRow("Street2").ToString(), _
                       dRow("City").ToString(), dRow("statename").ToString(), _
                         dRow("ZipCode").ToString()).Replace(vbCrLf, "<br>")
            End If
        Next
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="_SettlementId"></param>
    ''' <param name="_ClientId"></param>
    ''' <param name="acctNumber"></param>
    ''' <remarks></remarks>
    Private Sub BuildDocuments(ByVal _SettlementId As Integer, ByVal _ClientId As Integer, ByVal acctNumber As String)
        'TODO>>*****This code is duplicate of code from Client Documents Web part. See if the code can be centralized******'
        Dim root As String = "\\" & DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " & _ClientId) + "\" & _
            DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " & _ClientId) & "\" & _
            acctNumber & "\"

        Dim DocList As List(Of DocScan)
        Dim newName As String
        Dim fileName As String
        Dim DocsToDisplay() As String = {"Settlement Acceptance Form", "Settlement in Full Letter", "Client Stipulation Letter (Signed)", "Restrictive Endorsement Letter", "Settlement Client Stipulation"}

        DocList = LoadDoc(_SettlementId)

        Dim tr As New HtmlTableRow()
        tr.Attributes.Add("class", "entry2")

        If DocList.Count > 0 Then
            For Each doc As DocScan In DocList
                'Create document only if they are settlement related: SAF, SIF, Scanned/recorded SAF
                If DocsToDisplay.Contains(doc.DocumentName) Then
                    fileName = root & doc.FolderName & "\" & doc.FilePath

                    If doc.DocumentName.Trim.ToLower = "settlement recorded call" Then
                        fileName = SettlementMatterHelper.FixSettlementRecordedExtension(fileName)
                    End If

                    If File.Exists(fileName) Then
                        newName = LocalHelper.GetVirtualDocFullPath(fileName)
                        Dim tdImage As New HtmlTableCell()
                        Dim tdDocumentName As New HtmlTableCell()
                        Dim imgDocument As New HtmlImage()

                        tdImage.Attributes.Add("style", "text-align:center;width:20px;")
                        imgDocument.Src = "~/images/16x16_pdf.png"
                        imgDocument.Attributes.Add("style", "border:0px;height:16px;width:16px;")
                        imgDocument.Alt = ""
                        tdImage.Controls.Add(imgDocument)

                        tdDocumentName.Attributes.Add("style", "cursor:hand;overflow-x:hidden;text-align:left;width:auto;")
                        tdDocumentName.Attributes.Add("nowrap", "nowrap")
                        tdDocumentName.Attributes.Add("onclick", "javascript:OpenDocument('" + newName + "');")
                        tdDocumentName.InnerText = doc.DocumentName

                        tr.Controls.Add(tdImage)
                        tr.Controls.Add(tdDocumentName)
                    End If
                End If
            Next
            If tr.Controls.Count > 0 Then
                tblDocuments.Rows.Add(tr)
                tblDocuments.Visible = True
            End If

        End If
    End Sub
    ''' <summary>
    ''' Gets the document information for a Settlement
    ''' </summary>
    ''' <param name="_SettlementId">Integer to uniquely identify a Settlement</param>
    ''' <returns>A list of <see cref="DocScan" /> objects with document information </returns>
    ''' <remarks>This method implements the procedure which returns all client documents and only creditor documents 
    ''' related to the settlement</remarks>
    Private Function LoadDoc(ByVal _SettlementId As Integer) As List(Of DocScan)
        Dim final As New List(Of DocScan)

        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_GetSettlementDocuments"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "SettlementId", _SettlementId)

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim doc As New DocScan(DatabaseHelper.Peel_string(reader, "DocumentName"), DatabaseHelper.Peel_string(reader, "FolderName"), DatabaseHelper.Peel_string(reader, "FilePath"))
                        final.Add(doc)
                    End While
                End Using
            End Using
        End Using

        Return final
    End Function
#End Region
End Class
