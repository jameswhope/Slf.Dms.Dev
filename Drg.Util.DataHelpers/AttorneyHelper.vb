Option Strict On
Option Explicit On

Imports Drg.Util.DataAccess

Public Class AttorneyHelper
    Inherits DataHelperBase

    Public Function InsertAttorney( _
                                    ByVal strFirstName As String, _
                                    ByVal strLastName As String, _
                                    ByVal strMiddleName As String, _
                                    ByVal intCreatedBy As Integer, _
                                    ByVal strSuffix As String, _
                                    ByVal strAddress1 As String, _
                                    ByVal strAddress2 As String, _
                                    ByVal strCity As String, _
                                    ByVal strState As String, _
                                    ByVal strZip As String, _
                                    ByVal strPhone1 As String, _
                                    ByVal strPhone2 As String, _
                                    ByVal strFax As String) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertAttorney")

        DatabaseHelper.AddParameter(cmd, "FirstName", strFirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", strLastName)
        DatabaseHelper.AddParameter(cmd, "MiddleName", strMiddleName)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", intCreatedBy)
        DatabaseHelper.AddParameter(cmd, "Suffix", strSuffix)
        DatabaseHelper.AddParameter(cmd, "Address1", strAddress1)
        DatabaseHelper.AddParameter(cmd, "Address2", strAddress2)
        DatabaseHelper.AddParameter(cmd, "City", strCity)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "Zip", strZip)
        DatabaseHelper.AddParameter(cmd, "Phone1", strPhone1)
        DatabaseHelper.AddParameter(cmd, "Phone2", strPhone2)
        DatabaseHelper.AddParameter(cmd, "Fax", strFax)

        Return CType(MyBase.ExecuteScalar(cmd), Integer)
    End Function

    Public Sub UpdateAttorney( _
                                ByVal intAttorneyID As Integer, _
                                ByVal strFirstName As String, _
                                ByVal strLastName As String, _
                                ByVal strMiddleName As String, _
                                ByVal intLastModifiedBy As Integer, _
                                ByVal strSuffix As String, _
                                ByVal strAddress1 As String, _
                                ByVal strAddress2 As String, _
                                ByVal strCity As String, _
                                ByVal strState As String, _
                                ByVal strZip As String, _
                                ByVal strPhone1 As String, _
                                ByVal strPhone2 As String, _
                                ByVal strFax As String)

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UpdateAttorney")

        DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)
        DatabaseHelper.AddParameter(cmd, "FirstName", strFirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", strLastName)
        DatabaseHelper.AddParameter(cmd, "MiddleName", strMiddleName)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", intLastModifiedBy)
        DatabaseHelper.AddParameter(cmd, "Suffix", strSuffix)
        DatabaseHelper.AddParameter(cmd, "Address1", strAddress1)
        DatabaseHelper.AddParameter(cmd, "Address2", strAddress2)
        DatabaseHelper.AddParameter(cmd, "City", strCity)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "Zip", strZip)
        DatabaseHelper.AddParameter(cmd, "Phone1", strPhone1)
        DatabaseHelper.AddParameter(cmd, "Phone2", strPhone2)
        DatabaseHelper.AddParameter(cmd, "Fax", strFax)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

    'Public Sub DeleteAttorney(ByVal intAttorneyID As Integer)
    '    Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeleteAttorney")

    '    DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)

    '    MyBase.ExecuteNonQuery(cmd)
    'End Sub

    Public Function AttorneyDetail(ByVal intAttorneyID As Integer) As DataSet
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AttorneyDetail")

        DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)

        Return MyBase.ExecuteDataSet(cmd)
    End Function

    Public Sub AddUpdateAttorneyRelation(ByVal intAttorneyID As Integer, ByVal intCompanyID As Integer, ByVal strRelation As String, ByVal intUserID As Integer, ByVal strEmployedState As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AddAttorneyRelation")

        DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "AttyRelation", strRelation)
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
        DatabaseHelper.AddParameter(cmd, "EmployedState", strEmployedState)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

    Public Sub RemoveAttorneyRelation(ByVal intAttorneyID As Integer, ByVal intCompanyID As Integer)
        MyBase.ExecuteNonQuery("delete from tblAttyRelation where AttorneyID = " & intAttorneyID.ToString & " and CompanyID = " & intCompanyID.ToString)
    End Sub

    Public Sub AddUpdateAttorneyState(ByVal intAttorneyID As Integer, ByVal strState As String, ByVal strStateBarNum As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AddAttorneyState")

        DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)
        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "StateBarNum", strStateBarNum)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

    Public Overloads Sub RemoveAttorneyState(ByVal intAttorneyID As Integer, ByVal strState As String)
        MyBase.ExecuteNonQuery("delete from tblAttyStates where AttorneyID = " & intAttorneyID.ToString & " and State = '" & strState & "'")
    End Sub

    Public Overloads Sub RemoveAttorneyState(ByVal intAttyStateID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_RemoveAttorneyStateLic")

        DatabaseHelper.AddParameter(cmd, "AttyStateID", intAttyStateID)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

    Public Function GetAttorneyRelationTypes() As DataTable
        Return MyBase.ExecuteQuery("select AttorneyTypeID, [Type] from tblAttorneyType order by [Type]")
    End Function

    Public Function GetAttorneyListing(ByVal intCompanyID As Integer, ByVal strWhere As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AttorneyListing")

        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)
        DatabaseHelper.AddParameter(cmd, "Where", strWhere)

        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Function GetAttorneyStateLic(ByVal intAttorneyID As Integer, ByVal intCompanyID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AttorneyStateLic")

        DatabaseHelper.AddParameter(cmd, "AttorneyID", intAttorneyID)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)

        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Function GetAttorneysByState(ByVal strState As String, ByVal intCompanyID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AttorneysByState")

        DatabaseHelper.AddParameter(cmd, "State", strState)
        DatabaseHelper.AddParameter(cmd, "CompanyID", intCompanyID)

        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Sub CopyRelationships(ByVal intSourceCompanyID As Integer, ByVal intDestCompanyID As Integer, ByVal intUserID As Integer, ByVal blnCopyPrimaries As Boolean)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_CopyAttyRelationships")

        DatabaseHelper.AddParameter(cmd, "SourceCompanyID", intSourceCompanyID)
        DatabaseHelper.AddParameter(cmd, "DestCompanyID", intDestCompanyID)
        DatabaseHelper.AddParameter(cmd, "CopyPrimaries", IIf(blnCopyPrimaries, 1, 0))
        DatabaseHelper.AddParameter(cmd, "UserID", intUserID)

        MyBase.ExecuteNonQuery(cmd)
    End Sub

End Class
