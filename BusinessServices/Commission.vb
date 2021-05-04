Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers
Imports Drg.Util.Helpers.Base64Helper

Public Class Commission
    Inherits Attorney

#Region "Varibale Declarations"
    Private objDAL As CommissionHelper
#End Region

#Region "New"
    Public Sub New()
        MyBase.New()
        objDAL = New CommissionHelper
    End Sub
#End Region

#Region "Enum CommRecType"
    Public Enum CommRecType As Integer
        All = -1
        Attorney = 1
        Processor = 2
        Agency = 3
        Mediator = 4
    End Enum
#End Region

#Region "Enum AccountType"
    Public Enum AccountType As Integer
        GCA = 1
        Trust = 2
        OA = 3
    End Enum
#End Region

#Region "SaveBankingInfo"
    Protected Sub SaveBankingInfo(ByVal intCompanyID As Integer, ByVal lstBankInfo As String, ByVal intUserID As Integer)
        Dim Banks() As String
        Dim Parts() As String
        Dim blnIsACH As Boolean
        Dim blnIsChecking As Boolean
        Dim blnIsCommercial As Boolean = True 'default, can setup to override if needed
        Dim intAccountTypeID As Integer
        Dim intCommRecID As Integer
        Dim intCommRecAddressID As Integer
        Dim intCommRecPhoneID As Integer
        Dim strDeleteFlag As String

        If intCompanyID > 0 AndAlso lstBankInfo.Trim <> "" Then
            Banks = lstBankInfo.Split("|")

            For Each Bank As String In Banks
                Parts = Bank.Split(",")

                intCommRecID = CType(Parts(13), Integer)
                intAccountTypeID = CType(Parts(7), Integer)
                blnIsChecking = CType(Parts(11), Boolean) 'type
                blnIsACH = CType(Parts(12), Boolean) 'method
                strDeleteFlag = Parts(14)
                intCommRecAddressID = CType(Parts(15), Integer)
                intCommRecPhoneID = CType(Parts(16), Integer)

                If intCommRecID > 0 Then
                    If strDeleteFlag = "Y" Then 'This record has been marked for deletion
                        DeleteRecipient(intCommRecID)
                    Else
                        UpdateRecipient(intCommRecID, blnIsCommercial, blnIsACH, Parts(0), Parts(9), Parts(10), blnIsChecking, intUserID, intCompanyID, intAccountTypeID)
                        UpdateRecipientAddress(intCommRecAddressID, Parts(1), Parts(2), Parts(3), Parts(4), Parts(5), Parts(8), intUserID)
                        UpdateRecipientPhoneNumber(intCommRecPhoneID, Parts(6), intUserID)
                    End If
                Else 'New record
                    intCommRecID = InsertRecipient(blnIsCommercial, blnIsACH, Parts(0), Parts(9), Parts(10), blnIsChecking, intUserID, intCompanyID, intAccountTypeID)
                    If intCommRecID > 0 Then
                        InsertRecipientAddress(intCommRecID, Parts(1), Parts(2), Parts(3), Parts(4), Parts(5), Parts(8), intUserID)
                        InsertRecipientPhoneNumber(intCommRecID, Parts(6), intUserID)
                    End If
                End If
            Next
        End If

    End Sub
#End Region

#Region "SaveAgencyBankingInfo"
    Protected Sub SaveAgencyBankingInfo(ByVal intAgencyID As Integer, ByVal lstBankInfo As String, ByVal intUserID As Integer)
        Dim Banks() As String
        Dim Parts() As String
        Dim blnIsACH As Boolean
        Dim blnIsChecking As Boolean
        Dim blnIsCommercial As Boolean = True 'default, can setup to override if needed
        Dim intCommRecID As Integer
        Dim intCommRecAddressID As Integer
        Dim intCommRecPhoneID As Integer
        Dim strDeleteFlag As String
        Dim strAbbrev As String
        Dim strDisplay As String

        If intAgencyID > 0 AndAlso lstBankInfo.Trim <> "" Then
            Banks = lstBankInfo.Split("|")

            For Each Bank As String In Banks
                Parts = Bank.Split(",")

                intCommRecID = CType(Parts(13), Integer)
                strAbbrev = Parts(7)
                blnIsChecking = CType(Parts(11), Boolean) 'type
                blnIsACH = CType(Parts(12), Boolean) 'method
                strDeleteFlag = Parts(14)
                intCommRecAddressID = CType(Parts(15), Integer)
                intCommRecPhoneID = CType(Parts(16), Integer)
                strDisplay = Parts(17)

                If intCommRecID > 0 Then
                    If strDeleteFlag = "Y" Then 'This record has been marked for deletion
                        DeleteRecipient(intCommRecID)
                    Else
                        UpdateRecipientAgency(intCommRecID, strAbbrev, strDisplay, blnIsCommercial, blnIsACH, Parts(0), Parts(9), Parts(10), blnIsChecking, intAgencyID, intUserID)
                        UpdateRecipientAddress(intCommRecAddressID, Parts(1), Parts(2), Parts(3), Parts(4), Parts(5), Parts(8), intUserID)
                    End If
                Else 'New record
                    intCommRecID = InsertRecipientAgency(blnIsCommercial, blnIsACH, Parts(0), Parts(9), Parts(10), blnIsChecking, intAgencyID, strAbbrev, strDisplay, intUserID)
                    If intCommRecID > 0 Then
                        InsertRecipientAddress(intCommRecID, Parts(1), Parts(2), Parts(3), Parts(4), Parts(5), Parts(8), intUserID)
                        InsertRecipientPhoneNumber(intCommRecID, Parts(6), intUserID)
                    End If
                End If
            Next
        End If

    End Sub
#End Region

#Region "SaveFTPInfo"
    Protected Sub SaveFTPInfo(ByVal intCompanyID As Integer, ByVal lstFTPInfo As String, ByVal intUserID As Integer)
        Dim FTPAccounts() As String
        Dim Parts() As String
        Dim intNachaRootID As Integer
        Dim strDeleteFlag As String

        If intCompanyID > 0 AndAlso lstFTPInfo.Trim <> "" Then
            FTPAccounts = lstFTPInfo.Split("|")

            For Each FTPAccount As String In FTPAccounts
                Parts = FTPAccount.Split(",")

                intNachaRootID = CType(Parts(10), Integer)
                strDeleteFlag = Parts(11)

                If intNachaRootID > 0 Then
                    If strDeleteFlag = "Y" Then 'This record has been marked for deletion
                        DeleteFtpInfo(intNachaRootID)
                    Else
                        UpdateFtpInfo(intNachaRootID, Parts(0), Parts(1), Parts(2), Parts(3), Val(Parts(4)).ToString, Parts(5), Parts(6), Parts(7), Parts(8), Parts(9), intUserID)
                    End If
                Else 'New record
                    InsertFtpInfo(intCompanyID, Parts(0), Parts(1), Parts(2), Parts(3), Val(Parts(4)).ToString, Parts(5), Parts(6), Parts(7), Parts(8), Parts(9), intUserID)
                End If
            Next
        End If

    End Sub
#End Region

#Region "InsertRecipient"
    Private Function InsertRecipient( _
                                    ByVal blnIsCommercial As Boolean, _
                                    ByVal blnIsACH As Boolean, _
                                    ByVal strBankName As String, _
                                    ByVal strRoutingNum As String, _
                                    ByVal strAccountNum As String, _
                                    ByVal blnIsChecking As Boolean, _
                                    ByVal intUserID As Integer, _
                                    ByVal intCompanyID As Integer, _
                                    ByVal intAccountTypeID As Integer, _
                                    Optional ByVal intAgencyID As Integer = 0) As Integer

        Dim strMethod As String = "ACH" 'default
        Dim strType As String = "C" 'checking
        Dim intIsCommercial As Integer = "1" 'true
        Dim intIsLocked As Integer = 0 'default, false
        Dim intCommRecID As Integer = -1

        If Not blnIsACH Then
            strMethod = "Check"
        End If
        If Not blnIsChecking Then
            strType = "S" 'savings
        End If
        If Not blnIsCommercial Then
            intIsCommercial = 0
        End If

        If strBankName.Trim.Length > 0 Then
            intCommRecID = objDAL.InsertRecipient(CommRecType.Attorney, intIsCommercial, intIsLocked, strMethod, strBankName, strRoutingNum, strAccountNum, strType, intUserID, intCompanyID, intAccountTypeID, intAgencyID)
        End If

        Return intCommRecID
    End Function

    Private Function InsertRecipientAgency( _
                                   ByVal blnIsCommercial As Boolean, _
                                   ByVal blnIsACH As Boolean, _
                                   ByVal strBankName As String, _
                                   ByVal strRoutingNum As String, _
                                   ByVal strAccountNum As String, _
                                   ByVal blnIsChecking As Boolean, _
                                   ByVal intAgencyID As Integer, _
                                   ByVal strAbbrev As String, _
                                   ByVal strDisplay As String, _
                                   ByVal intUserID As Integer) As Integer

        Dim strMethod As String = "ACH" 'default
        Dim strType As String = "C" 'checking
        Dim intIsCommercial As Integer = "1" 'true
        Dim intIsLocked As Integer = 0 'default, false
        Dim intCommRecID As Integer = -1

        If Not blnIsACH Then
            strMethod = "Check"
        End If
        If Not blnIsChecking Then
            strType = "S" 'savings
        End If
        If Not blnIsCommercial Then
            intIsCommercial = 0
        End If

        If strBankName.Trim.Length > 0 Then
            intCommRecID = objDAL.InsertRecipientAgency(CommRecType.Agency, intIsCommercial, intIsLocked, strMethod, strBankName, strRoutingNum, strAccountNum, strType, intAgencyID, strAbbrev, strDisplay, intUserID)
        End If

        Return intCommRecID
    End Function
#End Region

#Region "UpdateRecipient"
    Private Sub UpdateRecipient( _
                                    ByVal intCommRecID As Integer, _
                                    ByVal blnIsCommercial As Boolean, _
                                    ByVal blnIsACH As Boolean, _
                                    ByVal strBankName As String, _
                                    ByVal strRoutingNum As String, _
                                    ByVal strAccountNum As String, _
                                    ByVal blnIsChecking As Boolean, _
                                    ByVal intUserID As Integer, _
                                    ByVal intCompanyID As Integer, _
                                    ByVal intAccountTypeID As Integer, _
                                    Optional ByVal intAgencyID As Integer = 0)

        Dim strMethod As String = "ACH" 'default
        Dim strType As String = "C" 'checking
        Dim intIsCommercial As Integer = "1" 'true
        Dim intIsLocked As Integer = 0 'default, false

        If Not blnIsACH Then
            strMethod = "Check"
        End If
        If Not blnIsChecking Then
            strType = "S" 'savings
        End If
        If Not blnIsCommercial Then
            intIsCommercial = 0
        End If

        objDAL.UpdateRecipient(intCommRecID, CommRecType.Attorney, intIsCommercial, intIsLocked, strMethod, strBankName, strRoutingNum, strAccountNum, strType, intUserID, intCompanyID, intAccountTypeID, intAgencyID)
    End Sub

    Private Sub UpdateRecipientAgency( _
                                   ByVal intCommRecID As Integer, _
                                   ByVal strAbbrev As String, _
                                   ByVal strDisplay As String, _
                                   ByVal blnIsCommercial As Boolean, _
                                   ByVal blnIsACH As Boolean, _
                                   ByVal strBankName As String, _
                                   ByVal strRoutingNum As String, _
                                   ByVal strAccountNum As String, _
                                   ByVal blnIsChecking As Boolean, _
                                   ByVal intAgencyID As Integer, _
                                   ByVal intUserID As Integer)

        Dim strMethod As String = "ACH" 'default
        Dim strType As String = "C" 'checking
        Dim intIsCommercial As Integer = "1" 'true
        Dim intIsLocked As Integer = 0 'default, false

        If Not blnIsACH Then
            strMethod = "Check"
        End If
        If Not blnIsChecking Then
            strType = "S" 'savings
        End If
        If Not blnIsCommercial Then
            intIsCommercial = 0
        End If

        objDAL.UpdateRecipientAgency(intCommRecID, CommRecType.Agency, strAbbrev, strDisplay, intIsCommercial, intIsLocked, strMethod, strBankName, strRoutingNum, strAccountNum, strType, intAgencyID, intUserID)
    End Sub
#End Region

#Region "DeleteRecipient"
    Private Sub DeleteRecipient(ByVal intCommRecID As Integer)
        objDAL.DeleteRecipient(intCommRecID)
    End Sub
#End Region

#Region "InsertFtpInfo"
    Private Sub InsertFtpInfo( _
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
                                ByVal intUserID As Integer, _
                                Optional ByVal strOriginTaxID As String = "-1")

        Dim Path() As String = strLogPath.Split("\")
        Dim strLogFile As String = Path(Path.Length - 1) & "_"

        objDAL.InsertFtpInfo(intCompanyID, Base64Encode(ftpServer), Base64Encode(ftpUsername), Base64Encode(ftpPassword), ftpFolder.Trim, ftpPort.Trim, Base64Encode(strPassphrase), strPublicKeyring.Trim, strPrivateKeyring.Trim, strFileLoc.Trim, strLogPath.Trim, strLogFile.Trim, intUserID, Base64Encode(strOriginTaxID))
    End Sub
#End Region

#Region "UpdateFtpInfo"
    Private Sub UpdateFtpInfo( _
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
                                ByVal intUserID As Integer, _
                                Optional ByVal strOriginTaxID As String = "-1")

        Dim Path() As String = strLogPath.Split("\")
        Dim strLogFile As String = Path(Path.Length - 1) & "_"

        objDAL.UpdateFtpInfo(intNachaRootID, Base64Encode(ftpServer), Base64Encode(ftpUsername), Base64Encode(ftpPassword), ftpFolder.Trim, ftpPort.Trim, Base64Encode(strPassphrase), strPublicKeyring.Trim, strPrivateKeyring.Trim, strFileLoc.Trim, strLogPath.Trim, strLogFile.Trim, intUserID, Base64Encode(strOriginTaxID))
    End Sub
#End Region

#Region "DeleteFtpInfo"
    Private Sub DeleteFtpInfo(ByVal intNachaRootID As Integer)
        objDAL.DeleteFtpInfo(intNachaRootID)
    End Sub
#End Region

#Region "InsertRecipientAddress"
    Private Sub InsertRecipientAddress( _
                                        ByVal intCommRecID As Integer, _
                                        ByVal strAddress1 As String, _
                                        ByVal strAddress2 As String, _
                                        ByVal strCity As String, _
                                        ByVal strState As String, _
                                        ByVal strZip As String, _
                                        ByVal strContact1 As String, _
                                        ByVal intUserID As Integer, _
                                        Optional ByVal strContact2 As String = "")
        strZip = StringHelper.ApplyFilter(strZip, StringHelper.Filter.NumericOnly)
        objDAL.InsertRecipientAddress(intCommRecID, strAddress1.Trim, strAddress2.Trim, strCity.Trim, strState.Trim, strZip.Trim, strContact1.Trim, strContact2.Trim, intUserID)
    End Sub
#End Region

#Region "UpdateRecipientAddress"
    Private Sub UpdateRecipientAddress( _
                                        ByVal intCommRecAddressID As Integer, _
                                        ByVal strAddress1 As String, _
                                        ByVal strAddress2 As String, _
                                        ByVal strCity As String, _
                                        ByVal strState As String, _
                                        ByVal strZip As String, _
                                        ByVal strContact1 As String, _
                                        ByVal intUserID As Integer, _
                                        Optional ByVal strContact2 As String = "")
        objDAL.UpdateRecipientAddress(intCommRecAddressID, strAddress1.Trim, strAddress2.Trim, strCity.Trim, strState.Trim, strZip.Trim, strContact1.Trim, strContact2.Trim, intUserID)
    End Sub
#End Region

#Region "InsertRecipientPhoneNumber"
    Private Sub InsertRecipientPhoneNumber(ByVal intCommRecID As Integer, ByVal strPhoneNumber As String, ByVal intUserID As Integer)
        strPhoneNumber = StringHelper.ApplyFilter(strPhoneNumber, StringHelper.Filter.NumericOnly)
        objDAL.InsertRecipientPhoneNumber(intCommRecID, strPhoneNumber, intUserID)
    End Sub
#End Region

#Region "UpdateRecipientPhoneNumber"
    Private Sub UpdateRecipientPhoneNumber(ByVal intCommRecPhoneID As Integer, ByVal strPhoneNumber As String, ByVal intUserID As Integer)
        strPhoneNumber = StringHelper.ApplyFilter(strPhoneNumber, StringHelper.Filter.NumericOnly)
        objDAL.UpdateRecipientPhoneNumber(intCommRecPhoneID, strPhoneNumber, intUserID)
    End Sub
#End Region

#Region "EntryTypeList"
    Public Function EntryTypeList(Optional ByVal blnAddPleaseSelect As Boolean = True) As DataTable
        Dim tblEntryTypes As DataTable = objDAL.EntryTypeList
        Dim row As DataRow

        If blnAddPleaseSelect Then
            row = tblEntryTypes.NewRow
            row(0) = "-1"
            row(1) = "Please select"
            tblEntryTypes.Rows.InsertAt(row, 0)
        End If

        Return tblEntryTypes
    End Function
#End Region

#Region "GetCommRec"
    Public Function GetCommRec(ByVal intCompanyID As Integer, ByVal intAccountType As AccountType) As DataTable
        Return objDAL.GetCommRec(intCompanyID, intAccountType)
    End Function
#End Region

#Region "AccountTypeList"
    Public Function AccountTypeList() As DataTable
        Return objDAL.AccountTypeList
    End Function
#End Region

#Region "Check dependencies in other tables"
    Public Function CommissionDependencies(ByVal CommRecId As Integer) As Boolean
        Dim ATables As String() = {"tblCommStruct"}
        For Each TableName As String In ATables
            If objDAL.HasDependencies(TableName, CommRecId) Then Return True
        Next
        Return False
    End Function
#End Region

End Class
