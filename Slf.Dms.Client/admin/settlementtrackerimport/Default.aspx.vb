Imports System.Collections.Generic
Imports System.Data
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.IO

Imports Drg.Util.DataAccess

Imports Microsoft.Office.Interop

Partial Class admin_settlementtrackerimport_Default
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private BatchID As String
    Private UserID As Integer

    #End Region 'Fields

    #Region "Enumerations"

    Public Enum TypeOfMessage
        ErrorMsg = 0
        SuccessMsg = 1
        WarningMsg = 2
    End Enum

    #End Region 'Enumerations

    #Region "Methods"

    Protected Sub admin_settlementtrackerimport_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Try
            Dim userGroup As Integer = -1
            Dim bIsManager As Boolean = False
            Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select usergroupid, manager from tbluser where userid = {0}", UserID), CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    userGroup = dr("usergroupid")
                    bIsManager = dr("manager")
                Next
            End Using
            If userGroup = 11 OrElse bIsManager Then
                A7.Visible = True
            Else
                A7.Visible = False
            End If
        Catch ex As Exception
            A7.Visible = False
        End Try
      
        
    End Sub

    #End Region 'Methods

End Class