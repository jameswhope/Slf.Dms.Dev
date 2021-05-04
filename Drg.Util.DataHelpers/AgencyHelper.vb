Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports Lexxiom.BusinessData

Public Class AgencyHelper
    Inherits DataHelperBase

#Region "Insert[old method]"
   Public Shared Function Insert(ByVal Name As String, ByVal UserID As Integer) As Integer

      Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

         DatabaseHelper.AddParameter(cmd, "Name", Name)
         DatabaseHelper.AddParameter(cmd, "Created", Now)
         DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
         DatabaseHelper.AddParameter(cmd, "LastModified", Now)
         DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

         DatabaseHelper.BuildInsertCommandText(cmd, "tblAgency", "AgencyID", SqlDbType.Int)

         Using cmd.Connection

            cmd.Connection.Open()
            cmd.ExecuteNonQuery()

            Return DataHelper.Nz_int(cmd.Parameters("@AgencyID").Value)

         End Using
      End Using

   End Function
#End Region

#Region "Agency Methods"

#Region "SaveAgency"
    Public Sub SaveAgency( _
                                    ByVal strName As String, _
                                    ByVal strShortCoName As String, _
                                    ByVal intAgencyUserID As Integer, _
                                    ByVal intUserID As Integer, _
                                    ByVal strContact1 As String, _
                                    ByVal strContact2 As String, _
                                    ByVal intIsCommRec As Integer, _
                                    ByRef intAgencyID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "Name", strName)
        DatabaseHelper.AddParameter(cmd, "Code", strShortCoName)
        DatabaseHelper.AddParameter(cmd, "ImportAbbr", strShortCoName)
        DatabaseHelper.AddParameter(cmd, "Contact1", strContact1)
        DatabaseHelper.AddParameter(cmd, "Contact2", DataHelper.Zn(strContact2))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "IsCommRec", intIsCommRec)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserID)
        If intAgencyUserID = 0 Then
            DatabaseHelper.AddParameter(cmd, "UserID", Nothing)
        Else
            DatabaseHelper.AddParameter(cmd, "UserID", intAgencyUserID)
        End If

        If intAgencyID < 1 Then
            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", intUserID)
            DatabaseHelper.BuildInsertCommandText(cmd, "tblAgency", "AgencyID", SqlDbType.Int)
        Else
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblAgency", "AgencyID = " & intAgencyID.ToString)
        End If

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If intAgencyID < 1 Then
            intAgencyID = DataHelper.Nz_int(cmd.Parameters("@AgencyID").Value)
        End If
    End Sub
#End Region

#Region "AgencyDetail"
    Public Function AgencyDetail(ByVal intAgencyID As Integer) As AgencyDetail
        Dim cmd As IDbCommand
        Dim dataAdapter As SqlDataAdapter
        Dim typedDS As New AgencyDetail

        cmd = ConnectionFactory.CreateCommand("stp_GetAgencyDetail")
        DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyID)

        Try
            dataAdapter = New SqlDataAdapter(cmd)
            dataAdapter.TableMappings.Add("Table", "Agency")
            dataAdapter.TableMappings.Add("Table1", "AgencyAddresses")
            dataAdapter.TableMappings.Add("Table2", "AgencyPhone")
            dataAdapter.TableMappings.Add("Table3", "Phone")
            dataAdapter.TableMappings.Add("Table4", "ChildAgency")
            dataAdapter.TableMappings.Add("Table5", "CommRec")
            dataAdapter.TableMappings.Add("Table6", "CommRecAddress")
            dataAdapter.TableMappings.Add("Table7", "CommRecPhone")
            dataAdapter.TableMappings.Add("Table8", "Agent")
            dataAdapter.TableMappings.Add("Table9", "AgentPhone")
            dataAdapter.Fill(typedDS)
        Catch ex As Exception
            Throw ex
        Finally
            If (Not dataAdapter Is Nothing) Then
                dataAdapter.Dispose()
            End If
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return typedDS
    End Function
#End Region

#Region "AgencyCommissionDetail"
    Public Function AgencyCommissionDetail(ByVal intAgencyID As Integer) As AgencyCommissionDetail
        Dim cmd As IDbCommand
        Dim dataAdapter As SqlDataAdapter
        Dim typedDS As New AgencyCommissionDetail

        cmd = ConnectionFactory.CreateCommand("stp_GetAgencyCommissionDetail")
        DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyID)

        Try
            dataAdapter = New SqlDataAdapter(cmd)
            dataAdapter.TableMappings.Add("Table", "AgencyCommStruct")
            dataAdapter.TableMappings.Add("Table1", "Fees")
            dataAdapter.Fill(typedDS)
        Catch ex As Exception
            Throw ex
        Finally
            If (Not dataAdapter Is Nothing) Then
                dataAdapter.Dispose()
            End If
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return typedDS
    End Function
#End Region

#Region "AgentList"
    Public Function AgentList(ByVal intAgencyID As Integer) As DataTable
        Dim dalAgent As New AgentHelper
        Return dalAgent.GetAgents(intAgencyID)
    End Function
#End Region

#Region "Agency Address Methods"

#Region "InsertAgencyAddress"
    Public Sub InsertAgencyAddress( _
                                ByVal intAgencyID As Integer, _
                                ByVal intAddressTypeID As Integer, _
                                ByVal strAddress1 As String, _
                                ByVal strAddress2 As String, _
                                ByVal strCity As String, _
                                ByVal strState As String, _
                                ByVal strZipcode As String, _
                                ByVal UserId As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "AddressTypeID", intAddressTypeID)
        DatabaseHelper.AddParameter(cmd, "Address1", strAddress1)
        DatabaseHelper.AddParameter(cmd, "Address2", strAddress2)
        DatabaseHelper.AddParameter(cmd, "City", strCity)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "Zipcode", strZipcode)
        DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyID)
        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserId)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserId)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblAgencyAddress")

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
#End Region

#Region "DeleteAgencyAddresses"
    Public Sub DeleteAgencyAddresses(ByVal intAgencyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblAgencyAddress where AgencyID = " & intAgencyID.ToString)
    End Sub
#End Region

#Region "DeleteAgencyAddress"
    Public Sub DeleteAgencyAddress(ByVal intAgencyAddressID As Integer)
        MyBase.ExecuteNonQuery("delete from tblAgencyAddress where AgencyAddressID = " & intAgencyAddressID.ToString)
    End Sub
#End Region

#End Region

#Region "ChildAgencys Methods"

#Region "InsertChildAgency"
    Public Function AgencyRelationExists(ByVal intAgencyId As Integer, ByVal intParentAgencyId As Integer)
        Return DataHelper.RecordExists("tblChildAgency", String.Format("AgencyId = {0} and ParentAgencyId = {1}", intAgencyId, intParentAgencyId))
    End Function

    Public Sub InsertChildAgency(ByVal intAgencyId As Integer, ByVal intParentAgencyId As Integer, ByVal UserId As Integer)
        If Not AgencyRelationExists(intAgencyId, intParentAgencyId) Then

            Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

            DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyId)
            DatabaseHelper.AddParameter(cmd, "ParentAgencyId", intParentAgencyId)
            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserId)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserId)


            DatabaseHelper.BuildInsertCommandText(cmd, "tblChildAgency")

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw ex
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        End If
    End Sub
#End Region

#Region "DeleteChildAgencys"
    Public Sub DeleteChildAgencys(ByVal intParentAgencyId As Integer)
        MyBase.ExecuteNonQuery("Delete from tblChildAgency where ParentAgencyID = " & intParentAgencyId.ToString)
    End Sub
#End Region

#End Region

#Region "Agency Phone Methods"

#Region "InsertAgencyPhone"
    Public Sub InsertAgencyPhone(ByVal intAgencyID As Integer, ByVal intPhoneTypeID As Integer, ByVal strPhoneNum As String, ByVal intUserId As Integer)
        Dim AreaCode As String = strPhoneNum.Substring(0, 3)
        Dim PhoneNum As String = strPhoneNum.Substring(3)
        Dim PhoneId As Integer = PhoneHelper.InsertPhone(intPhoneTypeID, AreaCode, PhoneNum, String.Empty, intUserId)

        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand


        DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyID)
        DatabaseHelper.AddParameter(cmd, "PhoneId", PhoneId)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", intUserId)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserId)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblAgencyPhone", "@AgencyPhoneId", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
#End Region

#Region "DeleteAgencyPhones"
    Public Sub DeleteAgencyPhones(ByVal intAgencyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblAgencyPhone where AgencyID = " & intAgencyID.ToString)
    End Sub
#End Region

#Region "DeleteAgency"
    Public Sub DeleteAgency(ByVal intAgencyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblAgency  where AgencyID = " & intAgencyID.ToString)
    End Sub
#End Region

#Region "DeleteAgencyPhone"
    Public Sub DeleteAgencyPhone(ByVal intAgencyPhoneID As Integer)
        MyBase.ExecuteNonQuery("delete from tblAgencyPhone where AgencyPhoneID = " & intAgencyPhoneID.ToString)
    End Sub
#End Region

#End Region

#End Region

    Public Function GetAgencyList(ByVal intCompanyID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAgencyList")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)

        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Function GetAgencies() As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAgencies")
        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Function GetAgencyParentList(ByVal AgencyID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAgencyParentList")

        DatabaseHelper.AddParameter(cmd, "AgencyID", AgencyID)

        Return MyBase.ExecuteQuery(cmd)
    End Function


    Public Function GetAgencyChildList(ByVal AgencyID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetChildAgencyList")
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet

        da.Fill(ds)

        Return ds.Tables(0)
    End Function

    Public Function GetAgencyTypeUsers() As DataTable
         Return MyBase.ExecuteQuery("Select UserId, FirstName + ' ' +  LastName  AS UserFullName From tblUser Where UserTypeId = 2 Order By 2")
    End Function

#Region "Agency Agent"
    Public Sub DeleteAgencyAgent(ByVal AgencyId As Integer, ByVal AgentId As Integer)
        MyBase.ExecuteNonQuery(String.Format("Delete From tblAgencyAgent Where AgencyId = {0} and AgentId = {1}", AgencyId, AgentId))
    End Sub

    Public Function AgencyAgentRelationExists(ByVal AgencyId As Integer, ByVal AgentId As Integer)
        Return DataHelper.RecordExists("tblAgencyAgent", String.Format("AgencyId = {0} and AgentId={1}", AgencyId, AgentId))
    End Function

    Public Function InsertAgencyAgent(ByVal AgencyId As Integer, ByVal AgentId As Integer, ByVal UserId As Integer) As Integer
        If Not AgencyAgentRelationExists(AgencyId, AgentId) Then
            Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

            DatabaseHelper.AddParameter(cmd, "AgencyID", AgencyId)
            DatabaseHelper.AddParameter(cmd, "AgentID", AgentId)
            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserId)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserId)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblAgencyAgent", "AgencyAgentId", SqlDbType.Int)

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Catch ex As Exception
                Throw ex
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            Return DataHelper.Nz_int(cmd.Parameters("@AgencyAgentId").Value)
        End If
    End Function
#End Region

End Class
