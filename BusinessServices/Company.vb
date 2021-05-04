Option Explicit On

Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers
Imports Drg.Util.Helpers.Base64Helper
Imports Lexxiom.BusinessData

Public Class Company
    Inherits Commission

#Region "Private Variables"
   Private objDAL As CompanyHelper
   Private _CompanyID As Integer
#End Region

#Region "Public Properties"
   Public ReadOnly Property CompanyID() As Integer
      Get
         Return _CompanyID
      End Get
   End Property
#End Region

#Region "New"
   Public Sub New(Optional ByVal CompanyID As Integer = -1)
      MyBase.Init()
      objDAL = New CompanyHelper
      _CompanyID = CompanyID
   End Sub
#End Region

#Region "Company Methods"

#Region "SaveCompany"
    Public Sub SaveCompany( _
                            ByVal strName As String, _
                            ByVal strShortCoName As String, _
                            ByVal intUserID As Integer, _
                            ByVal strContact1 As String, _
                            ByVal lstAddresses As String, _
                            ByVal lstPhoneNumbers As String, _
                            ByVal lstStateBars As String, _
                            Optional ByVal lstBankInfo As String = "", _
                            Optional ByVal lstFTPInfo As String = "", _
                            Optional ByVal lstAttorneys As String = "", _
                            Optional ByVal strContact2 As String = "", _
                            Optional ByVal strBillingMessage As String = "", _
                            Optional ByVal strWebsite As String = "", _
                            Optional ByVal strSigPath As String = "", _
                            Optional ByVal blnIsDefault As Boolean = False)
        objDAL.SaveCompany(strName.Trim, strShortCoName.Trim, intUserID, strContact1.Trim, strContact2.Trim, strBillingMessage.Trim, strWebsite.Trim, strSigPath.Trim, blnIsDefault, _CompanyID)
        SaveStateBars(lstStateBars)
        SaveAddresses(lstAddresses)
        SavePhoneNumbers(lstPhoneNumbers)
        MyBase.SaveBankingInfo(_CompanyID, lstBankInfo, intUserID)
        MyBase.SaveFTPInfo(_CompanyID, lstFTPInfo, intUserID)
        MyBase.SaveEmployedAttorney(_CompanyID, lstAttorneys, intUserID)
    End Sub
#End Region

#Region "CompanyDetail"
    Public Function CompanyDetail() As CompanyDetailDS
        Dim dsCompanyDetail As CompanyDetailDS = objDAL.CompanyDetail(_CompanyID)
        Dim row As CompanyDetailDS.NachaRootRow

        For Each row In dsCompanyDetail.NachaRoot
            row.ftpServer = Base64Decode(row.ftpServer)
            row.ftpUsername = Base64Decode(row.ftpUsername)
            row.ftpPassword = Base64Decode(row.ftpPassword)
            row.Passphrase = Base64Decode(row.Passphrase)
        Next

        Return dsCompanyDetail
    End Function
#End Region

#Region "CompanyList"
    Public Function CompanyList(Optional ByVal blnAddPleaseSelectRow As Boolean = False) As DataTable
        Dim tblCompany As DataTable = objDAL.CompanyList
        Dim row As DataRow

        If blnAddPleaseSelectRow Then
            row = tblCompany.NewRow
            row("CompanyID") = "-1"
            row("ShortCoName") = "Please select"
            row("Name") = "Please select"
            tblCompany.Rows.InsertAt(row, 0)
        End If

        Return tblCompany
    End Function
#End Region

#Region "CompanyStatePrimaryList"
    Public Function CompanyStatePrimaryList(ByVal intCompanyID As Integer) As DataTable
        Return objDAL.CompanyStatePrimaryList(intCompanyID)
    End Function
#End Region

#Region "SaveStatePrimary"
    Public Sub SaveStatePrimary(ByVal intCompanyID As Integer, ByVal strState As String, ByVal intAttorneyID As Integer, ByVal intUserID As Integer)
        objDAL.SaveStatePrimary(intCompanyID, strState, intAttorneyID, intUserID)
    End Sub
#End Region

#Region "RemoveStatePrimary"
    Public Sub RemoveStatePrimary(ByVal intCompanyID As Integer, ByVal strState As String, ByVal intAttorneyID As Integer)
        objDAL.RemoveStatePrimary(intCompanyID, strState, intAttorneyID)
    End Sub
#End Region

#End Region

#Region "Address Methods"

#Region "SaveAddresses"
   Private Sub SaveAddresses(ByVal lstAddresses As String)
      Dim arAddresses() As String
      Dim arParts() As String
      Dim intAddressTypeID As Integer

      If _CompanyID > 0 Then
         DeleteCompanyAddresses()

         If lstAddresses.Length > 0 Then
            arAddresses = lstAddresses.Split("|")

            For Each Address As String In arAddresses
               arParts = Address.Split(",")
               intAddressTypeID = CType(arParts(0), Integer)
               InsertCompanyAddress(intAddressTypeID, arParts(1), arParts(2), arParts(3), arParts(4), arParts(5))
            Next
         End If
      End If

   End Sub
#End Region

#Region "InsertCompanyAddress"
   Private Sub InsertCompanyAddress( _
                           ByVal intAddressTypeID As Integer, _
                           ByVal strAddress1 As String, _
                           ByVal strAddress2 As String, _
                           ByVal strCity As String, _
                           ByVal strState As String, _
                           ByVal strZipcode As String)
      objDAL.InsertAddress(_CompanyID, intAddressTypeID, strAddress1.Trim, strAddress2.Trim, strCity.Trim, strState.Trim, strZipcode.Trim)
   End Sub
#End Region

#Region "DeleteCompanyAddresses"
   Private Sub DeleteCompanyAddresses()
      objDAL.DeleteCompanyAddresses(_CompanyID)
   End Sub
#End Region

#Region "DeleteAddress"
   Public Sub DeleteAddress(ByVal intCompanyAddressID As Integer)
      objDAL.DeleteAddress(intCompanyAddressID)
   End Sub
#End Region

#Region "CompanyAddressTypes"
   Public Function CompanyAddressTypes() As DataTable
      Return objDAL.CompanyAddressTypes
   End Function
#End Region

#End Region

#Region "Phone Number Methods"

#Region "SavePhoneNumbers"
    Private Sub SavePhoneNumbers(ByVal lstPhoneNumbers As String)
        Dim Phones() As String
        Dim Parts() As String
        Dim intPhoneTypeID As Integer
        Dim strNumber As String

        If _CompanyID > 0 Then
            DeleteCompanyPhones()

            If lstPhoneNumbers.Length > 0 Then
                Phones = lstPhoneNumbers.Split("|")

                For Each Phone As String In Phones
                    Parts = Phone.Split(",")
                    intPhoneTypeID = CType(Parts(0), Integer)
                    strNumber = StringHelper.ApplyFilter(Parts(1), StringHelper.Filter.NumericOnly)
                    InsertPhone(intPhoneTypeID, strNumber)
                Next
            End If
        End If

    End Sub
#End Region

#Region "InsertPhone"
    Private Sub InsertPhone(ByVal intPhoneTypeID As Integer, ByVal strPhoneNum As String)
        objDAL.InsertPhone(_CompanyID, intPhoneTypeID, strPhoneNum)
    End Sub
#End Region

#Region "DeleteCompanyPhones"
    Private Sub DeleteCompanyPhones()
        objDAL.DeleteCompanyPhones(_CompanyID)
    End Sub
#End Region

#Region "DeletePhone"
    Public Sub DeletePhone(ByVal intCompanyPhoneID As Integer)
        objDAL.DeletePhone(intCompanyPhoneID)
    End Sub
#End Region

#End Region

#Region "State Bar Methods"

#Region "SaveStateBars"
    Private Sub SaveStateBars(ByVal lstStateBars As String)
        Dim arStateBars() As String
        Dim arParts() As String

        If _CompanyID > 0 Then
            DeleteCompanyStateBars()

            If lstStateBars.Length > 0 Then
                arStateBars = lstStateBars.Split("|") 'CA,123456|NV,987655|..

                For Each StateBar As String In arStateBars
                    arParts = StateBar.Split(",")
                    InsertStateBar(arParts(0), arParts(1))
                Next
            End If
        End If

    End Sub
#End Region

#Region "InsertStateBar"
    Public Sub InsertStateBar(ByVal strState As String, ByVal strStateBarNum As String)
        objDAL.InsertStateBar(_CompanyID, strState.Trim, strStateBarNum.Trim)
    End Sub
#End Region

#Region "DeleteCompanyStateBars"
    Private Sub DeleteCompanyStateBars()
        objDAL.DeleteCompanyStateBars(_CompanyID)
    End Sub
#End Region

#End Region

End Class
