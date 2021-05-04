Option Explicit On

Imports Drg.Util.DataAccess
Imports Lexxiom.BusinessData
Imports System.Data.SqlClient

Public Class CompanyHelper
    Inherits CommissionHelper

#Region "Insert[old method]"
   Public Overloads Function Insert(ByVal Name As String, ByVal UserID As Integer) As Integer
      Dim intCompanyID As Integer = -1
      SaveCompany(Name, "", "", "", UserID, "", "", "", False, intCompanyID)
      Return intCompanyID
   End Function
#End Region

#Region "Company Methods"

#Region "SaveCompany"
    Public Sub SaveCompany( _
                                    ByVal strName As String, _
                                    ByVal strShortCoName As String, _
                                    ByVal intUserID As Integer, _
                                    ByVal strContact1 As String, _
                                    ByVal strContact2 As String, _
                                    ByVal strBillingMessage As String, _
                                    ByVal strWebsite As String, _
                                    ByVal strSigPath As String, _
                                    ByVal blnIsDefault As Boolean, _
                                    ByRef intCompanyID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "Name", strName)
        DatabaseHelper.AddParameter(cmd, "ShortCoName", strShortCoName)
        DatabaseHelper.AddParameter(cmd, "Contact1", strContact1)
        DatabaseHelper.AddParameter(cmd, "Contact2", DataHelper.Zn(strContact2))
        DatabaseHelper.AddParameter(cmd, "BillingMessage", DataHelper.Zn(strBillingMessage))
        DatabaseHelper.AddParameter(cmd, "Website", DataHelper.Zn(strWebsite))
        If strSigPath.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "SigPath", DataHelper.Zn(strSigPath))
        End If
        DatabaseHelper.AddParameter(cmd, "Default", IIf(blnIsDefault, 1, 0))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserID)

        If intCompanyID < 1 Then
            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", intUserID)
            DatabaseHelper.BuildInsertCommandText(cmd, "tblCompany", "CompanyID", SqlDbType.Int)
        Else
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblCompany", "CompanyID = " & intCompanyID.ToString)
        End If

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If intCompanyID < 1 Then
            intCompanyID = DataHelper.Nz_int(cmd.Parameters("@CompanyID").Value)
        End If
    End Sub
#End Region

#Region "CompanyDetail"
    Public Function CompanyDetail(ByVal intCompanyID As Integer) As CompanyDetailDS ', ByVal strPassphrase As String) As CompanyDetailDS
        Dim cmd As IDbCommand
        Dim dataAdapter As SqlDataAdapter
        Dim typedDS As New CompanyDetailDS

        cmd = ConnectionFactory.CreateCommand("stp_GetCompanyDetail")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        'DatabaseHelper.AddParameter(cmd, "Passphrase", strPassphrase)

        Try
            dataAdapter = New SqlDataAdapter(cmd)
            dataAdapter.TableMappings.Add("Table", "Company")
            dataAdapter.TableMappings.Add("Table1", "Address")
            dataAdapter.TableMappings.Add("Table2", "Phone")
            dataAdapter.TableMappings.Add("Table3", "StateBar")
            dataAdapter.TableMappings.Add("Table4", "CommRec")
            dataAdapter.TableMappings.Add("Table5", "CommRecAddress")
            dataAdapter.TableMappings.Add("Table6", "CommRecPhone")
            dataAdapter.TableMappings.Add("Table7", "NachaRoot")
            dataAdapter.TableMappings.Add("Table8", "Attorney")
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

#Region "CompanyList"
    Public Function CompanyList() As DataTable
        Return MyBase.ExecuteQuery("SELECT CompanyID, ShortCoName, [Name] FROM tblCompany ORDER BY CompanyID ASC")
    End Function
#End Region

#Region "CompanyStatePrimaryList"
    Public Function CompanyStatePrimaryList(ByVal intCompanyID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_CompanyStatePrimaryList")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)

        Return MyBase.ExecuteQuery(cmd)
    End Function
#End Region

#Region "SaveStatePrimary"
    Public Sub SaveStatePrimary(ByVal intCompanyID As Integer, ByVal strState As String, ByVal intAttorneyID As Integer, ByVal intUserID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveStatePrimary")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        MyBase.ExecuteNonQuery(cmd)
    End Sub
#End Region

#Region "RemoveStatePrimary"
    Public Sub RemoveStatePrimary(ByVal intCompanyID As Integer, ByVal strState As String, ByVal intAttorneyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblCompanyStatePrimary where CompanyID = " & intCompanyID.ToString & " and AttorneyID = " & intAttorneyID.ToString & " and State = '" & strState & "'")
    End Sub
#End Region

#End Region

#Region "Address Methods"

#Region "InsertAddress"
   Public Sub InsertAddress( _
                               ByVal intCompanyID As Integer, _
                               ByVal intAddressTypeID As Integer, _
                               ByVal strAddress1 As String, _
                               ByVal strAddress2 As String, _
                               ByVal strCity As String, _
                               ByVal strState As String, _
                               ByVal strZipcode As String)

      Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

      DatabaseHelper.AddParameter(cmd, "AddressTypeID", intAddressTypeID)
      DatabaseHelper.AddParameter(cmd, "Address1", strAddress1)
      DatabaseHelper.AddParameter(cmd, "Address2", strAddress2)
      DatabaseHelper.AddParameter(cmd, "City", strCity)
      DatabaseHelper.AddParameter(cmd, "State", strState)
      DatabaseHelper.AddParameter(cmd, "Zipcode", strZipcode)
      DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
      DatabaseHelper.AddParameter(cmd, "date_created", Now)

      DatabaseHelper.BuildInsertCommandText(cmd, "tblCompanyAddresses")

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

#Region "DeleteCompanyAddresses"
   Public Sub DeleteCompanyAddresses(ByVal intCompanyID As Integer)
      MyBase.ExecuteNonQuery("delete from tblCompanyAddresses where CompanyID = " & intCompanyID.ToString)
   End Sub
#End Region

#Region "DeleteAddress"
   Public Sub DeleteAddress(ByVal intCompanyAddressID As Integer)
      MyBase.ExecuteNonQuery("delete from tblCompanyAddresses where CompanyAddressID = " & intCompanyAddressID.ToString)
   End Sub
#End Region

#Region "CompanyAddressTypes"
   Public Function CompanyAddressTypes() As DataTable
      Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
      Dim da As New SqlDataAdapter(cmd)
      Dim ds As New DataSet

      cmd.CommandText = "select AddressTypeID, AddressTypeName from tblCompanyAddressTypes order by AddressTypeName"

      Try
         da.Fill(ds)
      Catch ex As Exception
         Throw ex
      Finally
         DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
         da.Dispose()
      End Try

      Return ds.Tables(0)
   End Function
#End Region

#End Region

#Region "Phone Methods"

#Region "InsertPhone"
    Public Sub InsertPhone(ByVal intCompanyID As Integer, ByVal intPhoneTypeID As Integer, ByVal strPhoneNum As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertCompanyPhone")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "PhoneType", intPhoneTypeID)
        DatabaseHelper.AddParameter(cmd, "PhoneNumber", strPhoneNum)

        Try
            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
#End Region

#Region "DeleteCompanyPhones"
    Public Sub DeleteCompanyPhones(ByVal intCompanyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblCompanyPhones where CompanyID = " & intCompanyID.ToString)
    End Sub
#End Region

#Region "DeletePhone"
    Public Sub DeletePhone(ByVal intCompanyPhoneID As Integer)
        MyBase.ExecuteNonQuery("delete from tblCompanyPhones where CompanyPhoneID = " & intCompanyPhoneID.ToString)
    End Sub
#End Region

#End Region

#Region "State Bar Methods"

#Region "InsertStateBar"
    Public Sub InsertStateBar(ByVal intCompanyID As Integer, ByVal strState As String, ByVal strStateBarNum As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "StateBarNum", strStateBarNum)
        DatabaseHelper.AddParameter(cmd, "Created", Now)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblCompanyStateBar")

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

#Region "DeleteCompanyStateBars"
    Public Sub DeleteCompanyStateBars(ByVal intCompanyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblCompanyStateBar where CompanyID = " & intCompanyID.ToString)
    End Sub
#End Region

#End Region

End Class