Option Strict On
Option Explicit On

Imports Drg.Util.DataAccess

Public Class CommissionHelper
    Inherits DataHelperBase

    Public Function InsertRecipientAgency( _
                                    ByVal intRecTypeID As Integer, _
                                    ByVal intIsCommercial As Integer, _
                                    ByVal intIsLocked As Integer, _
                                    ByVal strMethod As String, _
                                    ByVal strBankName As String, _
                                    ByVal strRoutingNum As String, _
                                    ByVal strAccountNum As String, _
                                    ByVal strType As String, _
                                    ByVal intAgencyID As Integer, _
                                    ByVal strAbbrev As String, _
                                    ByVal strDisplay As String, _
                                    ByVal intUserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertCommRecAgency")
        Dim intCommRecID As Integer = -1

        DatabaseHelper.AddParameter(cmd, "CommRecTypeID", intRecTypeID)
        DatabaseHelper.AddParameter(cmd, "IsCommercial", intIsCommercial)
        DatabaseHelper.AddParameter(cmd, "IsLocked", intIsLocked)
        DatabaseHelper.AddParameter(cmd, "Method", strMethod)
        DatabaseHelper.AddParameter(cmd, "BankName", strBankName)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", strRoutingNum)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", strAccountNum)
        DatabaseHelper.AddParameter(cmd, "Type", strType)
        DatabaseHelper.AddParameter(cmd, "AgencyID", DataHelper.Zn(intAgencyID))
        DatabaseHelper.AddParameter(cmd, "Abbreviation", strAbbrev)
        DatabaseHelper.AddParameter(cmd, "Display", strDisplay)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        Try
            intCommRecID = CType(DatabaseHelper.ExecuteScalar(cmd), Integer)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return intCommRecID
    End Function

    Public Function InsertRecipient( _
                                    ByVal intRecTypeID As Integer, _
                                    ByVal intIsCommercial As Integer, _
                                    ByVal intIsLocked As Integer, _
                                    ByVal strMethod As String, _
                                    ByVal strBankName As String, _
                                    ByVal strRoutingNum As String, _
                                    ByVal strAccountNum As String, _
                                    ByVal strType As String, _
                                    ByVal intUserID As Integer, _
                                    ByVal intCompanyID As Integer, _
                                    ByVal intAccountTypeID As Integer, _
                                    ByVal intAgencyID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertCommRec")
        Dim intCommRecID As Integer = -1

        DatabaseHelper.AddParameter(cmd, "CommRecTypeID", intRecTypeID)
        DatabaseHelper.AddParameter(cmd, "IsCommercial", intIsCommercial)
        DatabaseHelper.AddParameter(cmd, "IsLocked", intIsLocked)
        DatabaseHelper.AddParameter(cmd, "Method", strMethod)
        DatabaseHelper.AddParameter(cmd, "BankName", strBankName)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", strRoutingNum)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", strAccountNum)
        DatabaseHelper.AddParameter(cmd, "Type", strType)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "AccountTypeID", intAccountTypeID)
        DatabaseHelper.AddParameter(cmd, "AgencyID", DataHelper.Zn(intAgencyID))

        Try
            intCommRecID = CType(DatabaseHelper.ExecuteScalar(cmd), Integer)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return intCommRecID
    End Function

    Public Sub UpdateRecipient( _
                                ByVal intCommRecID As Integer, _
                                ByVal intRecTypeID As Integer, _
                                ByVal intIsCommercial As Integer, _
                                ByVal intIsLocked As Integer, _
                                ByVal strMethod As String, _
                                ByVal strBankName As String, _
                                ByVal strRoutingNum As String, _
                                ByVal strAccountNum As String, _
                                ByVal strType As String, _
                                ByVal intUserID As Integer, _
                                ByVal intCompanyID As Integer, _
                                ByVal intAccountTypeID As Integer, _
                                ByVal intAgencyID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UpdateCommRec")

        DatabaseHelper.AddParameter(cmd, "CommRecID", intCommRecID)
        DatabaseHelper.AddParameter(cmd, "CommRecTypeID", intRecTypeID)
        DatabaseHelper.AddParameter(cmd, "IsCommercial", intIsCommercial)
        DatabaseHelper.AddParameter(cmd, "IsLocked", intIsLocked)
        DatabaseHelper.AddParameter(cmd, "Method", strMethod)
        DatabaseHelper.AddParameter(cmd, "BankName", strBankName)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", strRoutingNum)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", strAccountNum)
        DatabaseHelper.AddParameter(cmd, "Type", strType)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "AccountTypeID", intAccountTypeID)
        DatabaseHelper.AddParameter(cmd, "AgencyID", DataHelper.Zn(intAgencyID))

        Try
            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Public Sub UpdateRecipientAgency( _
                                ByVal intCommRecID As Integer, _
                                ByVal intRecTypeID As Integer, _
                                ByVal strAbbrev As String, _
                                ByVal strDisplay As String, _
                                ByVal intIsCommercial As Integer, _
                                ByVal intIsLocked As Integer, _
                                ByVal strMethod As String, _
                                ByVal strBankName As String, _
                                ByVal strRoutingNum As String, _
                                ByVal strAccountNum As String, _
                                ByVal strType As String, _
                                ByVal intAgencyID As Integer, _
                                ByVal intUserID As Integer _
                                )

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UpdateCommRecAgency")

        DatabaseHelper.AddParameter(cmd, "CommRecID", intCommRecID)
        DatabaseHelper.AddParameter(cmd, "Abbreviation", strAbbrev)
        DatabaseHelper.AddParameter(cmd, "Display", strDisplay)
        DatabaseHelper.AddParameter(cmd, "CommRecTypeID", intRecTypeID)
        DatabaseHelper.AddParameter(cmd, "IsCommercial", intIsCommercial)
        DatabaseHelper.AddParameter(cmd, "IsLocked", intIsLocked)
        DatabaseHelper.AddParameter(cmd, "Method", strMethod)
        DatabaseHelper.AddParameter(cmd, "BankName", strBankName)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", strRoutingNum)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", strAccountNum)
        DatabaseHelper.AddParameter(cmd, "Type", strType)
        DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyID)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        Try
            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Public Sub DeleteRecipient(ByVal intCommRecID As Integer)
        MyBase.ExecuteNonQuery("delete from tblCommRec where CommRecID = " & intCommRecID.ToString)
    End Sub

    Public Sub InsertFtpInfo( _
                                ByVal intCompanyID As Integer, _
                                ByVal ftpServer As String, _
                                ByVal ftpUsername As String, _
                                ByVal ftpPassword As String, _
                                ByVal ftpFolder As String, _
                                ByVal ftpPort As String, _
                                ByVal strPassphrase As String, _
                                ByVal strPublicKeyring As String, _
                                ByVal strPrivateKeyring As String, _
                                ByVal strFileLoc As String, _
                                ByVal strLogPath As String, _
                                ByVal strLogFile As String, _
                                ByVal intUserID As Integer, _
                                ByVal strOriginTaxID As String)

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertNachaRoot")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "OriginTaxID", strOriginTaxID)
        DatabaseHelper.AddParameter(cmd, "ftpServer", ftpServer)
        DatabaseHelper.AddParameter(cmd, "ftpUsername", ftpUsername)
        DatabaseHelper.AddParameter(cmd, "ftpPassword", ftpPassword)
        DatabaseHelper.AddParameter(cmd, "ftpFolder", ftpFolder)
        DatabaseHelper.AddParameter(cmd, "ftpPort", ftpPort)
        DatabaseHelper.AddParameter(cmd, "Passphrase", strPassphrase)
        DatabaseHelper.AddParameter(cmd, "PublicKeyring", strPublicKeyring)
        DatabaseHelper.AddParameter(cmd, "PrivateKeyring", strPrivateKeyring)
        DatabaseHelper.AddParameter(cmd, "FileLocation", strFileLoc)
        DatabaseHelper.AddParameter(cmd, "LogPath", strLogPath)
        DatabaseHelper.AddParameter(cmd, "LogFile", strLogFile)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

    Public Sub UpdateFtpInfo( _
                                ByVal intNachaRootID As Integer, _
                                ByVal ftpServer As String, _
                                ByVal ftpUsername As String, _
                                ByVal ftpPassword As String, _
                                ByVal ftpFolder As String, _
                                ByVal ftpPort As String, _
                                ByVal strPassphrase As String, _
                                ByVal strPublicKeyring As String, _
                                ByVal strPrivateKeyring As String, _
                                ByVal strFileLoc As String, _
                                ByVal strLogPath As String, _
                                ByVal strLogFile As String, _
                                ByVal intUserID As Integer, _
                                ByVal strOriginTaxID As String)

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UpdateNachaRoot")

        DatabaseHelper.AddParameter(cmd, "NachaRootID", intNachaRootID)
        DatabaseHelper.AddParameter(cmd, "OriginTaxID", strOriginTaxID)
        DatabaseHelper.AddParameter(cmd, "ftpServer", ftpServer)
        DatabaseHelper.AddParameter(cmd, "ftpUsername", ftpUsername)
        DatabaseHelper.AddParameter(cmd, "ftpPassword", ftpPassword)
        DatabaseHelper.AddParameter(cmd, "ftpFolder", ftpFolder)
        DatabaseHelper.AddParameter(cmd, "ftpPort", ftpPort)
        DatabaseHelper.AddParameter(cmd, "Passphrase", strPassphrase)
        DatabaseHelper.AddParameter(cmd, "PublicKeyring", strPublicKeyring)
        DatabaseHelper.AddParameter(cmd, "PrivateKeyring", strPrivateKeyring)
        DatabaseHelper.AddParameter(cmd, "FileLocation", strFileLoc)
        DatabaseHelper.AddParameter(cmd, "LogPath", strLogPath)
        DatabaseHelper.AddParameter(cmd, "LogFile", strLogFile)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

    Public Sub DeleteFtpInfo(ByVal intNachaRootID As Integer)
        MyBase.ExecuteNonQuery("delete from tblNachaRoot where tblNachaRoot = " & intNachaRootID.ToString)
    End Sub

    Public Sub InsertRecipientAddress( _
                                        ByVal intCommRecID As Integer, _
                                        ByVal strAddress1 As String, _
                                        ByVal strAddress2 As String, _
                                        ByVal strCity As String, _
                                        ByVal strState As String, _
                                        ByVal strZip As String, _
                                        ByVal strContact1 As String, _
                                        ByVal strContact2 As String, _
                                        ByVal intUserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "CommRecID", intCommRecID)
        DatabaseHelper.AddParameter(cmd, "Address1", strAddress1)
        DatabaseHelper.AddParameter(cmd, "Address2", strAddress2)
        DatabaseHelper.AddParameter(cmd, "City", strCity)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "Zipcode", strZip)
        DatabaseHelper.AddParameter(cmd, "Contact1", strContact1)
        DatabaseHelper.AddParameter(cmd, "Contact2", strContact2)
        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", intUserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblCommRecAddress")

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Sub UpdateRecipientAddress( _
                                        ByVal intCommRecAddressID As Integer, _
                                        ByVal strAddress1 As String, _
                                        ByVal strAddress2 As String, _
                                        ByVal strCity As String, _
                                        ByVal strState As String, _
                                        ByVal strZip As String, _
                                        ByVal strContact1 As String, _
                                        ByVal strContact2 As String, _
                                        ByVal intUserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "Address1", strAddress1)
        DatabaseHelper.AddParameter(cmd, "Address2", strAddress2)
        DatabaseHelper.AddParameter(cmd, "City", strCity)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "Zipcode", strZip)
        DatabaseHelper.AddParameter(cmd, "Contact1", strContact1)
        DatabaseHelper.AddParameter(cmd, "Contact2", strContact2)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblCommRecAddress", "CommRecAddressID = " & intCommRecAddressID.ToString)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Sub InsertRecipientPhoneNumber(ByVal intCommRecID As Integer, ByVal strPhoneNumber As String, ByVal intUserID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "CommRecID", intCommRecID)
        DatabaseHelper.AddParameter(cmd, "PhoneNumber", strPhoneNumber)
        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", intUserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblCommRecPhone")

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Sub UpdateRecipientPhoneNumber(ByVal intCommRecPhoneID As Integer, ByVal strPhoneNumber As String, ByVal intUserID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "PhoneNumber", strPhoneNumber)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intUserID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblCommRecPhone", "CommRecPhoneID = " & intCommRecPhoneID.ToString)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Function EntryTypeList() As DataTable
        Return MyBase.ExecuteQuery("select EntryTypeID, DisplayName from tblEntryType where Fee = 1 order by DisplayName")
    End Function

    Public Function CommRecTypes() As DataTable
        Return MyBase.ExecuteQuery("select CommRecTypeID, [Name] from tblCommRecType order by [Name]")
    End Function

    Public Function GetCommRecs(ByVal intCommRecTypeID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommRecs")

        If intCommRecTypeID > 0 Then
            DatabaseHelper.AddParameter(cmd, "CommRecTypeID", intCommRecTypeID)
        End If

        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Function GetCommRec(ByVal intCompanyID As Integer, ByVal intAccountTypeID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommRec")

        DatabaseHelper.AddParameter(cmd, "AccountTypeID", intAccountTypeID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)

        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Function AccountTypeList(Optional ByVal sqlWhere As String = "") As DataTable
        Return MyBase.ExecuteQuery("select AccountTypeID, AccountType, Abbreviation from tblAccountType " & sqlWhere & " order by AccountType")
    End Function

    Public Function HasDependencies(ByVal TableName As String, ByVal CommRecId As Integer) As Boolean
        Return (Drg.Util.DataAccess.DataHelper.FieldCount(TableName, "CommRecId", "CommRecId = " & CommRecId) > 0)
    End Function

#Region "Commission Scenarios"

#Region "LoadScenario"
    Public Function LoadScenario(ByVal intCommScenID As Integer, ByVal intCompanyID As Integer) As DataSet
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_LoadScenario")

        DatabaseHelper.AddParameter(cmd, "CommScenID", intCommScenID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)

        Return MyBase.ExecuteDataSet(cmd)
    End Function
#End Region

#Region "SaveCommScen"
    Public Function SaveCommScen(ByVal intAgencyID As Integer, ByVal intCompanyID As Integer, ByVal startDate As Date, ByVal endDate As Date, ByVal retFrom As Integer, ByVal retTo As Integer, ByVal intUserID As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveCommScen")
        Dim intCommScenID As Integer

        DatabaseHelper.AddParameter(cmd, "AgencyID", intAgencyID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
        DatabaseHelper.AddParameter(cmd, "StartDate", startDate)
        If endDate > CType("1/1/1900", Date) Then
            DatabaseHelper.AddParameter(cmd, "EndDate", endDate)
        End If
        DatabaseHelper.AddParameter(cmd, "RetFrom", retFrom)
        DatabaseHelper.AddParameter(cmd, "RetTo", retTo)

        intCommScenID = CType(MyBase.ExecuteScalar(cmd), Integer)

        Return intCommScenID
    End Function
#End Region

#Region "SaveCommStruct"
    Public Function SaveCommStruct(ByVal intCommScenID As Integer, ByVal intCommRecID As Integer, ByVal intParentCommRecID As Integer, ByVal intOrder As Integer, ByVal intUserID As Integer, ByVal intCompanyID As Integer, ByVal intParentCommStructID As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveCommStruct")
        Dim intCommStructID As Integer

        DatabaseHelper.AddParameter(cmd, "CommScenID", intCommScenID)
        DatabaseHelper.AddParameter(cmd, "CommRecID", intCommRecID)
        DatabaseHelper.AddParameter(cmd, "ParentCommRecID", intParentCommRecID)
        DatabaseHelper.AddParameter(cmd, "Order", intOrder)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        If intParentCommStructID > 0 Then
            DatabaseHelper.AddParameter(cmd, "ParentCommStructID", intParentCommStructID)
        End If

        intCommStructID = CType(MyBase.ExecuteScalar(cmd), Integer)

        Return intCommStructID
    End Function
#End Region

#Region "SaveCommFee"
    Public Sub SaveCommFee(ByVal intCommStructID As Integer, ByVal intEntryTypeID As Integer, ByVal dblPercent As Double, ByVal isPercent As Integer, ByVal intUserID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveCommFee")

        DatabaseHelper.AddParameter(cmd, "CommStructID", intCommStructID)
        DatabaseHelper.AddParameter(cmd, "EntryTypeID", intEntryTypeID)
        DatabaseHelper.AddParameter(cmd, "Percent", dblPercent)
        DatabaseHelper.AddParameter(cmd, "IsPercent", isPercent)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        MyBase.ExecuteNonQuery(cmd)
    End Sub
#End Region

#End Region

End Class
