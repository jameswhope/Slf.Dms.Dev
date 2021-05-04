Option Explicit On

Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers
Imports Drg.Util.Helpers.Base64Helper
Imports Lexxiom.BusinessData

Public Class Agency
   Inherits Commission

#Region "Private Variables"
   Private objDAL As AgencyHelper
   Private _AgencyID As Integer
   Private _UserID As Integer
#End Region

#Region "Public Properties"
   Public ReadOnly Property AgencyID() As Integer
      Get
         Return _AgencyID
      End Get
   End Property

   Public ReadOnly Property UserID() As Integer
      Get
         Return _UserID
      End Get
   End Property
#End Region

#Region "New"
   Public Sub New(Optional ByVal AgencyID As Integer = -1)
      MyBase.Init()
      objDAL = New AgencyHelper
        _AgencyID = AgencyID
    End Sub
#End Region

#Region "Agency Methods"

#Region "SaveAgency"
    Public Sub SaveAgency( _
                            ByVal strName As String, _
                            ByVal strShortCoName As String, _
                            ByVal intIsCommRec As Integer, _
                            ByVal intAgencyUserID As Integer, _
                            ByVal intUserID As Integer, _
                            ByVal strContact1 As String, _
                            ByVal lstAddresses As String, _
                            ByVal lstPhoneNumbers As String, _
                            ByVal lstAgencys As String, _
                            Optional ByVal lstBankInfo As String = "", _
                            Optional ByVal lstAgents As String = "", _
                            Optional ByVal strContact2 As String = "")
        _UserID = intUserID
        objDAL.SaveAgency(strName.Trim, strShortCoName.Trim, intAgencyUserID, intUserID, strContact1.Trim, strContact2.Trim, intIsCommRec, _AgencyID)
        SaveChildAgencys(lstAgencys)
        SaveAgents(lstAgents)
        SaveAgencyAddresses(lstAddresses)
        SaveAgencyPhoneNumbers(lstPhoneNumbers)
        MyBase.SaveAgencyBankingInfo(_AgencyID, lstBankInfo, intUserID)

    End Sub
#End Region


#Region "DeleteAgency"
    Public Sub DeleteAgency()
        objDAL.DeleteAgency(_AgencyID)
    End Sub
#End Region

#Region "Save Agents"
    Protected Sub SaveAgents(ByVal lstAgents As String)
        Dim Agents() As String
        Dim Parts() As String
        Dim intAgentId As Integer
        Dim strDeleteFlag As String
        Dim strFirstName As String
        Dim strLastName As String

        If _AgencyID > 0 AndAlso lstAgents.Trim <> "" Then
            Agents = lstAgents.Split("|")
            Dim DALAgent As New AgentHelper

            For Each Agent As String In Agents
                Parts = Agent.Split(",")

                intAgentId = CType(Parts(0), Integer)
                strDeleteFlag = Parts(1)
                strFirstName = Parts(2)
                strLastName = Parts(3)

                If intAgentId > 0 Then
                    If strDeleteFlag = "Y" Then 'This record has been marked for deletion
                        objDAL.DeleteAgencyAgent(_AgencyID, intAgentId)
                    Else
                        DALAgent.UpdateAgent(intAgentId, strFirstName, strLastName, _UserID)
                        'Insert Agency-Agent relationship
                        objDAL.InsertAgencyAgent(_AgencyID, intAgentId, _UserID)
                    End If
                Else 'New record
                    intAgentId = DALAgent.InsertAgent(strFirstName, strLastName, _UserID)
                    objDAL.InsertAgencyAgent(_AgencyID, intAgentId, _UserID)
                End If

            Next
        End If

    End Sub
#End Region


#Region "AgencyDetail"
    Public Function AgencyDetail() As AgencyDetail
        Return objDAL.AgencyDetail(_AgencyID)
    End Function

    Public Function AgencyCommissionDetail() As AgencyCommissionDetail
        Return objDAL.AgencyCommissionDetail(_AgencyID)
    End Function
#End Region

#Region "AgencyChildList"
    Public Function AgencyChildList() As DataTable
        Return objDAL.GetAgencyChildList(_AgencyID)
    End Function
#End Region

#Region "AgencyAgentList"
    Public Function AgentList() As DataTable
        Return objDAL.AgentList(_AgencyID)
    End Function
#End Region

#End Region

#Region "Address Methods"

#Region "SaveAgencyAddresses"
    Private Sub SaveAgencyAddresses(ByVal lstAddresses As String)
        Dim arAddresses() As String
        Dim arParts() As String
        Dim intAddressTypeID As Integer

        If _AgencyID > 0 Then
            DeleteAgencyAddresses()

            If lstAddresses.Length > 0 Then
                arAddresses = lstAddresses.Split("|")

                For Each Address As String In arAddresses
                    arParts = Address.Split(",")
                    intAddressTypeID = Nothing 'CType(arParts(0), Integer)
                    InsertAgencyAddress(intAddressTypeID, arParts(0), arParts(1), arParts(2), arParts(3), arParts(4))
                Next
            End If
        End If

    End Sub
#End Region

#Region "InsertAgencyAddress"
    Private Sub InsertAgencyAddress( _
                            ByVal intAddressTypeID As Integer, _
                            ByVal strAddress1 As String, _
                            ByVal strAddress2 As String, _
                            ByVal strCity As String, _
                            ByVal strState As String, _
                            ByVal strZipcode As String)
        objDAL.InsertAgencyAddress(_AgencyID, intAddressTypeID, strAddress1.Trim, strAddress2.Trim, strCity.Trim, strState.Trim, strZipcode.Trim, _UserID)
    End Sub
#End Region

#Region "DeleteAgencyAddresses"
    Private Sub DeleteAgencyAddresses()
        objDAL.DeleteAgencyAddresses(_AgencyID)
    End Sub
#End Region

#Region "DeleteAgencyAddress"
    Public Sub DeleteAgencyAddress(ByVal intAgencyAddressID As Integer)
        objDAL.DeleteAgencyAddress(intAgencyAddressID)
    End Sub
#End Region

#End Region

#Region "Agency Phone Number Methods"

#Region "SaveAgencyPhoneNumbers"
    Private Sub SaveAgencyPhoneNumbers(ByVal lstPhoneNumbers As String)
        Dim Phones() As String
        Dim Parts() As String
        Dim intPhoneTypeID As Integer
        Dim strNumber As String

        If _AgencyID > 0 Then
            DeleteAgencyPhones()

            If lstPhoneNumbers.Length > 0 Then
                Phones = lstPhoneNumbers.Split("|")

                For Each Phone As String In Phones
                    Parts = Phone.Split(",")
                    intPhoneTypeID = CType(Parts(0), Integer)
                    strNumber = StringHelper.ApplyFilter(Parts(1), StringHelper.Filter.NumericOnly)
                    InsertAgencyPhone(intPhoneTypeID, strNumber)
                Next
            End If
        End If

    End Sub
#End Region

#Region "InsertAgencyPhone"
    Private Sub InsertAgencyPhone(ByVal intPhoneTypeID As Integer, ByVal strPhoneNum As String)
        objDAL.InsertAgencyPhone(_AgencyID, intPhoneTypeID, strPhoneNum, _UserID)
    End Sub
#End Region

#Region "DeleteAgencyPhones"
    Private Sub DeleteAgencyPhones()
        objDAL.DeleteAgencyPhones(_AgencyID)
    End Sub
#End Region

#Region "DeleteAgencyPhone"
    Public Sub DeleteAgencyPhone(ByVal intAgencyPhoneID As Integer)
        objDAL.DeleteAgencyPhone(intAgencyPhoneID)
    End Sub
#End Region

#End Region

#Region "Linked Agencys Methods"

#Region "SaveChildAgencys"
    Private Sub SaveChildAgencys(ByVal lstAgencys As String)
        Dim arChildAgencys() As String

        If _AgencyID > 0 Then
            DeleteChildAgencys()

            If lstAgencys.Length > 0 Then
                arChildAgencys = lstAgencys.Split("|")

                For Each Agency As String In arChildAgencys
                    InsertChildAgency(CType(Agency, Integer))
                Next
            End If
        End If

    End Sub
#End Region

#Region "InsertChildAgency"
    Public Sub InsertChildAgency(ByVal AgencyId As Integer)
        objDAL.InsertChildAgency(AgencyId, _AgencyID, _UserID)
    End Sub
#End Region

#Region "DeleteChildAgencys"
    Private Sub DeleteChildAgencys()
        objDAL.DeleteChildAgencys(_AgencyID)
    End Sub
#End Region

#End Region

#Region "GetAgencyList"
    Public Function GetAgencyList(Optional ByVal intCompanyID As Integer = -1) As DataTable
        Return objDAL.GetAgencyList(intCompanyID)
    End Function
#End Region

    Public Function GetAgencyTypeUsers() As DataTable
        Return objDAL.GetAgencyTypeUsers
    End Function

    Public Function GetAllAgencies() As DataTable
        Return objDAL.GetAgencies()
    End Function

    Public Function GetAllAgents() As DataTable
        Dim objAgentDAL As New AgentHelper
        Return objAgentDAL.GetAgents()
    End Function

    'Checks if adding a Child Agency would create a circular reference
    Public Function IsCircularReference(ByVal ChildAgencyId As Integer) As Boolean
        If _AgencyID = ChildAgencyId Then
            Return True
        Else
            Dim dt As DataTable = objDAL.GetAgencyChildList(ChildAgencyId)
            For Each dr As DataRow In dt.Rows
                If IsCircularReference(Int32.Parse(dr("AgencyId"))) Then
                    Return True
                End If
            Next
        End If
        Return False
    End Function

    Private Function GetAgencyParents(ByVal dt As DataTable, ByVal Master As DataTable) As DataTable
        Dim dt1 As DataTable
        For Each dr As DataRow In dt.Rows
            dt1 = objDAL.GetAgencyParentList(Int32.Parse(dr("AgencyID")))
            If dt1.Rows.Count > 0 Then GetAgencyParents(dt1, Master)
            'Add only if not in list yet
            If Master.Select("AgencyId = " & dr("AgencyId").ToString).Length = 0 Then Master.ImportRow(dr)
        Next
        Return dt
    End Function

    Public Function GetParents() As DataTable
        Dim dt As DataTable = objDAL.GetAgencyParentList(_AgencyID)
        Dim Master As DataTable = dt.Clone()
        'Look grandparents
        If dt.Rows.Count > 0 Then
            GetAgencyParents(dt, Master)
        End If
        Return Master
    End Function

End Class
