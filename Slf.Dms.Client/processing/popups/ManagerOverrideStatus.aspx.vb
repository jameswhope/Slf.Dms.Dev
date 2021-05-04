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
Partial Class processing_popups_ManagerOverrideStatus
    Inherits System.Web.UI.Page
#Region "Declaration"
    Public SettlementID As Integer = 0
    Public UserID As Integer = 0
    Private Information As SettlementMatterHelper.SettlementInformation
    Private _AccountNumber As String
#End Region

#Region "Events"
    ''' <summary>
    ''' Loads The content of the page
    ''' </summary>
    ''' <remarks>sid is the SettlementId passed from ~/Default.aspx
    '''          type indicates which link was chosen in Payments Override tab on ~/Default.aspx</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Request.QueryString("sid") Is Nothing Then
            SettlementID = Integer.Parse(Request.QueryString("sid"))
        End If
        If Not IsPostBack Then
            If Not IsNothing(Request.QueryString("type")) Then
                If Convert.ToString(Request.QueryString("type")) = "0" Then
                    radReject.Checked = True
                ElseIf Convert.ToString(Request.QueryString("type")) = "1" Then
                    radAccept.Checked = True
                End If
            End If
        End If
    End Sub
#End Region

#Region "Other Events"
    ''' <summary>
    ''' ROutine called when the Save link button is clicked
    ''' </summary>
    ''' <remarks>stp_ResolveManagerOverride - Inserts Note and adds the note relations to Matter, Client and Creditor
    '''                                       Updates Task as Completed
    '''                                       Marks Settlement as Active/InActive depending on IsApprpoved
    '''          stp_InsertTaskForSettlement - Creates a Task for Process Settlement Amount</remarks>
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
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
            End If
        End Using
    End Sub
#End Region
End Class
