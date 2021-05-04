﻿Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.IO
Imports System.Collections.Generic
Imports System.Data

Partial Class processing_webparts_ClientDocuments
    Inherits System.Web.UI.UserControl

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

#Region "Public Functions"
    ''' <summary>
    ''' Loads the Document Accordion Pane
    ''' </summary>
    ''' <param name="_SettlementId">Integer to uniquely identify a settlement</param>
    ''' <remarks>Loads the Document Accordion Pane with two tables 1)CLient Documents - containing all the client documents
    '''          2) Creditor Documents - Containing only the document related to the Settlement</remarks>
    Public Sub BuildDocumentPanes(ByVal _SettlementId As Integer)
        If Not _SettlementId = 0 Then
            Dim _ClientID As Integer = SettlementMatterHelper.GetSettlementInformation(_SettlementId).ClientID
            Dim AccountNumber As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & _ClientID)
            Dim root As String = "\\" & DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " & _ClientID) + "\" & _
                DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " & _ClientID) & "\" & _
                AccountNumber & "\"

            Dim clientDocs As AccordionPane = Nothing
            Dim creditorDocs As AccordionPane = Nothing

            Dim DocList As List(Of DocScan)
            Dim newName As String
            Dim fileName As String
            Dim creditorTable As HtmlTable
            Dim clientTable As HtmlTable

            'Populate the document info for the settlement
            DocList = LoadDoc(_SettlementId)

            creditorTable = Me.CreateTable()
            clientTable = Me.CreateTable()

            accDocuments.Panes.Clear()
            clientDocs = New AccordionPane()
            creditorDocs = New AccordionPane()

            If DocList.Count > 0 Then
                For Each doc As DocScan In DocList
                    fileName = root & doc.FolderName & "\" & doc.FilePath

                    If doc.DocumentName.Trim.ToLower = "settlement recorded call" Then
                        fileName = SettlementMatterHelper.FixSettlementRecordedExtension(fileName)
                    End If

                    If File.Exists(fileName) Then
                        newName = LocalHelper.GetVirtualDocFullPath(fileName)
                        Dim tr As New HtmlTableRow()
                        Dim tdCheckbox As New HtmlTableCell()
                        Dim tdImage As New HtmlTableCell()
                        Dim tdDocumentName As New HtmlTableCell()
                        Dim imgDocument As New HtmlImage()

                        tr.Attributes.Add("style", "width:100%;")
                        tr.Attributes.Add("class", "entryFormat")

                        tdCheckbox.Attributes.Add("style", "width:20px;")
                        tdCheckbox.Attributes.Add("nowrap", "nowrap")
                        tdCheckbox.Visible = False

                        tdImage.Attributes.Add("style", "text-align:center;width:20px;color:black;font-family:tahoma:font-size:11px;")

                        imgDocument.Src = "~/negotiation/images/16x16_file.png"
                        imgDocument.Attributes.Add("style", "border:0px;height:16px;width:16px;color:black;font-family:tahoma:font-size:11px;")
                        imgDocument.Alt = ""
                        tdImage.Controls.Add(imgDocument)

                        tdDocumentName.Attributes.Add("style", "cursor:hand;overflow-x:hidden;text-align:left;width:auto;color:black;font-family:tahoma:font-size:11px;")
                        tdDocumentName.Attributes.Add("nowrap", "nowrap")
                        tdDocumentName.Attributes.Add("onclick", "javascript:OpenDocument('" + newName + "');")
                        tdDocumentName.InnerText = doc.DocumentName

                        tr.Controls.Add(tdCheckbox)
                        tr.Controls.Add(tdImage)
                        tr.Controls.Add(tdDocumentName)

                        If doc.FolderName.Equals("ClientDocs") Then
                            clientTable.Controls.Add(tr)
                        Else
                            creditorTable.Controls.Add(tr)
                        End If
                    End If
                Next

                If creditorTable.Rows.Count > 0 Then
                    Dim creditorHeader As New Literal()

                    creditorHeader.Text = "Current Creditor Documents(" & creditorTable.Rows.Count.ToString() & ")"
                    creditorDocs.HeaderContainer.Controls.Add(creditorHeader)
                    creditorDocs.HeaderContainer.Attributes.Add("style", "background-color:#DCDCDC;")
                    creditorDocs.ContentContainer.Controls.Add(creditorTable)

                    accDocuments.Panes.Add(creditorDocs)
                    accDocuments.SelectedIndex = accDocuments.Panes.IndexOf(creditorDocs)
                End If

                If clientTable.Rows.Count > 0 Then
                    Dim clientHeader As New Literal()

                    clientHeader.Text = "Client Documents(" & clientTable.Rows.Count.ToString() & ")"
                    clientDocs.HeaderContainer.Controls.Add(clientHeader)
                    clientDocs.HeaderContainer.Attributes.Add("style", "background-color:#DCDCDC;")
                    clientDocs.ContentContainer.Controls.Add(clientTable)

                    accDocuments.Panes.Add(clientDocs)
                End If
            End If

            pnlDocuments.Visible = Not clientTable.Rows.Count = 0 Or Not creditorTable.Rows.Count = 0
            pnlNoDocuments.Visible = Not pnlDocuments.Visible
        End If
    End Sub
#End Region

#Region "Private Functions"
    ''' <summary>
    ''' Creates a <see cref="HtmlTable" /> object with styling
    ''' </summary>
    ''' <returns><see cref="HtmlTable" /> object</returns>
    Private Function CreateTable() As HtmlTable
        Dim genericTable As New HtmlTable()

        genericTable.Attributes.Add("style", "margin:0px;overflow-x:hidden;padding:0px;table-layout:fixed;width:90%;")
        genericTable.Attributes.Add("cellpadding", "0")
        genericTable.Attributes.Add("cellspacing", "0")
        genericTable.Attributes.Add("nowrap", "nowrap")
        genericTable.Attributes.Add("class", "entryFormat")

        Return genericTable
    End Function
    ''' <summary>
    ''' Gets the document information for a Settlement
    ''' </summary>
    ''' <param name="_SettlementId">Integer to uniquely identify a Settlement</param>
    ''' <returns>A list of <see cref="DocScan" /> objects with document information </returns>
    ''' <remarks>This method implements the procedure which returns all client documents and only creditor documents 
    ''' related to the settlement</remarks>
    Private Function LoadDoc(ByVal _SettlementId As Integer) As List(Of DocScan)
        Dim final As New List(Of DocScan)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("settlementid", _SettlementId))
        Using dt As DataTable = SqlHelper.GetDataTable("stp_GetSettlementDocuments", CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                Dim doc As New DocScan(dr("DocumentName").ToString, dr("FolderName").ToString, dr("FilePath").ToString)
                final.Add(doc)
            Next
        End Using

        'Using connection As IDbConnection = ConnectionFactory.Create()
        '    connection.Open()

        '    Using cmd As IDbCommand = connection.CreateCommand()
        '        cmd.CommandText = "stp_GetSettlementDocuments"
        '        cmd.CommandType = CommandType.StoredProcedure
        '        cmd.CommandTimeout = 90
        '        DatabaseHelper.AddParameter(cmd, "SettlementId", _SettlementId)

        '        Using reader As SqlDataReader = cmd.ExecuteReader()
        '            While reader.Read()
        '                Dim doc As New DocScan(DatabaseHelper.Peel_string(reader, "DocumentName"), DatabaseHelper.Peel_string(reader, "FolderName"), DatabaseHelper.Peel_string(reader, "FilePath"))
        '                final.Add(doc)
        '            End While
        '        End Using
        '    End Using
        'End Using

        Return final
    End Function
#End Region
End Class
