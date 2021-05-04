Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Public Class Attorney
    Inherits BusinessServicesBase

    Private objDAL As AttorneyHelper

    Public Sub New()
        objDAL = New AttorneyHelper
    End Sub

    Public Sub SaveEmployedAttorney(ByVal intCompanyID As Integer, ByVal lstAttorneys As String, ByVal intUserID As Integer)
        Dim Attorneys() As String
        Dim Parts() As String
        Dim intAttorneyID As Integer
        Dim strDeleteFlag As String
        Dim strRelation As String
        Dim strState As String

        If intCompanyID > 0 AndAlso lstAttorneys.Trim <> "" Then
            Attorneys = lstAttorneys.Split("|")

            For Each Attorney As String In Attorneys
                Parts = Attorney.Split(",")

                intAttorneyID = CType(Parts(0), Integer)
                strDeleteFlag = Parts(1)
                strState = Parts(5)

                If CBool(Parts(7)) Then 'is principle?
                    strRelation = "Principle"
                Else
                    strRelation = "Associate"
                End If

                If intAttorneyID > 0 Then
                    If strDeleteFlag = "Y" Then 'This record has been marked for deletion
                        RemoveAttorneyRelation(intAttorneyID, intCompanyID)
                    Else
                        UpdateAttorney(intAttorneyID, Parts(2), Parts(3), Parts(4), intUserID)
                        AddUpdateAttorneyState(intAttorneyID, strState, Parts(6))
                        AddUpdateAttorneyRelation(intAttorneyID, intCompanyID, strRelation, intUserID, strState)
                    End If
                Else 'New record
                    intAttorneyID = InsertAttorney(Parts(2), Parts(3), Parts(4), intUserID)
                    AddUpdateAttorneyRelation(intAttorneyID, intCompanyID, strRelation, intUserID, strState)
                    AddUpdateAttorneyState(intAttorneyID, strState, Parts(6))
                End If
            Next
        End If

    End Sub

    Public Function InsertAttorney( _
                                    ByVal strFirstName As String, _
                                    ByVal strLastName As String, _
                                    ByVal strMiddleName As String, _
                                    ByVal intCreatedBy As Integer, _
                                    Optional ByVal strSuffix As String = "", _
                                    Optional ByVal strAddress1 As String = "", _
                                    Optional ByVal strAddress2 As String = "", _
                                    Optional ByVal strCity As String = "", _
                                    Optional ByVal strState As String = "", _
                                    Optional ByVal strZip As String = "", _
                                    Optional ByVal strPhone1 As String = "", _
                                    Optional ByVal strPhone2 As String = "", _
                                    Optional ByVal strFax As String = "") As Integer

        strPhone1 = StringHelper.ApplyFilter(strPhone1, StringHelper.Filter.NumericOnly)
        strPhone2 = StringHelper.ApplyFilter(strPhone2, StringHelper.Filter.NumericOnly)
        strFax = StringHelper.ApplyFilter(strFax, StringHelper.Filter.NumericOnly)
        strZip = StringHelper.ApplyFilter(strZip, StringHelper.Filter.NumericOnly)

        Return objDAL.InsertAttorney(strFirstName.Trim, strLastName.Trim, strMiddleName.Trim, intCreatedBy, strSuffix, strAddress1, strAddress2, strCity, strState, strZip, strPhone1, strPhone2, strFax)
    End Function

    Public Sub UpdateAttorney( _
                                    ByVal intAttorneyID As Integer, _
                                    ByVal strFirstName As String, _
                                    ByVal strLastName As String, _
                                    ByVal strMiddleName As String, _
                                    ByVal intLastModifiedBy As Integer, _
                                    Optional ByVal strSuffix As String = "", _
                                    Optional ByVal strAddress1 As String = "", _
                                    Optional ByVal strAddress2 As String = "", _
                                    Optional ByVal strCity As String = "", _
                                    Optional ByVal strState As String = "", _
                                    Optional ByVal strZip As String = "", _
                                    Optional ByVal strPhone1 As String = "", _
                                    Optional ByVal strPhone2 As String = "", _
                                    Optional ByVal strFax As String = "")

        strPhone1 = StringHelper.ApplyFilter(strPhone1, StringHelper.Filter.NumericOnly)
        strPhone2 = StringHelper.ApplyFilter(strPhone2, StringHelper.Filter.NumericOnly)
        strFax = StringHelper.ApplyFilter(strFax, StringHelper.Filter.NumericOnly)
        strZip = StringHelper.ApplyFilter(strZip, StringHelper.Filter.NumericOnly)

        objDAL.UpdateAttorney(intAttorneyID, strFirstName.Trim, strLastName.Trim, strMiddleName.Trim, intLastModifiedBy, strSuffix, strAddress1, strAddress2, strCity, strState, strZip, strPhone1, strPhone2, strFax)
    End Sub

    Public Function AttorneyDetail(ByVal intAttorneyID As Integer) As DataSet
        Return objDAL.AttorneyDetail(intAttorneyID)
    End Function

    'Public Sub DeleteAttorney(ByVal intAttorneyID As Integer)
    '    objDAL.DeleteAttorney(intAttorneyID)
    'End Sub

    Public Sub AddUpdateAttorneyRelation(ByVal intAttorneyID As Integer, ByVal intCompanyID As Integer, ByVal strRelation As String, ByVal intUserID As Integer, Optional ByVal strEmployedState As String = "")
        'Adds new relation or updates the relation type if exists
        objDAL.AddUpdateAttorneyRelation(intAttorneyID, intCompanyID, strRelation, intUserID, strEmployedState)
    End Sub

    Public Sub RemoveAttorneyRelation(ByVal intAttorneyID As Integer, ByVal intCompanyID As Integer)
        objDAL.RemoveAttorneyRelation(intAttorneyID, intCompanyID)
    End Sub

    Public Sub AddUpdateAttorneyState(ByVal intAttorneyID As Integer, ByVal strState As String, ByVal strStateBarNum As String)
        'Adds new licensed state or updates the state bar num if exists
        objDAL.AddUpdateAttorneyState(intAttorneyID, strState, strStateBarNum)
    End Sub

    Public Overloads Sub RemoveAttorneyState(ByVal intAttorneyID As Integer, ByVal strState As String)
        objDAL.RemoveAttorneyState(intAttorneyID, strState)
    End Sub

    Public Overloads Sub RemoveAttorneyState(ByVal intAttyStateID As Integer)
        objDAL.RemoveAttorneyState(intAttyStateID)
    End Sub

    Public Function GetAttorneyRelationTypes(Optional ByVal blnAddEmptyRow As Boolean = False) As DataTable
        Dim tblTypes As DataTable = objDAL.GetAttorneyRelationTypes
        Dim row As DataRow

        If blnAddEmptyRow Then
            row = tblTypes.NewRow
            row("AttorneyTypeID") = -1
            row("Type") = " "
            tblTypes.Rows.InsertAt(row, 0)
        End If

        Return tblTypes
    End Function

    Public Function GetAttorneyListing(ByVal intCompanyID As Integer, Optional ByVal strSearchCriteria As String = "") As DataTable
        Dim Values() As String = StringHelper.SplitQuoted(strSearchCriteria, " ", """").ToArray(GetType(String))
        Dim strWhere As String
        Dim Section As String = String.Empty
        Dim Sections As New List(Of String)

        For Each Value As String In Values
            If Value.ToLower = "and" Then
                'add section to sections
                If Section.Length > 0 Then
                    Sections.Add("(" & Section & ")")
                End If

                'reset section
                Section = String.Empty
            Else
                If Section.Length > 0 Then
                    Section += " OR "
                End If

                Section += "[FirstName] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR [MiddleName] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR [LastName] LIKE '%" & Value.Replace("'", "''") & "%'"
            End If
        Next

        'add section to sections
        If Section.Length > 0 Then
            Sections.Add("(" & Section & ")")
        End If

        If Sections.Count > 0 Then
            strWhere = "WHERE " & String.Join(" AND ", Sections.ToArray())
        Else
            strWhere = ""
        End If

        Return objDAL.GetAttorneyListing(intCompanyID, strWhere)
    End Function

    Public Function GetAttorneyStateLic(ByVal intAttorneyID As Integer, Optional ByVal intCompanyID As Integer = -1) As DataTable
        'Passing in CompanyID will also return which state(s) the attorney is the primary for.
        Return objDAL.GetAttorneyStateLic(intAttorneyID, intCompanyID)
    End Function

    Public Function GetAttorneysByState(ByVal strState As String, ByVal intCompanyID As Integer) As DataTable
        Dim tblAttorney As DataTable = objDAL.GetAttorneysByState(strState, intCompanyID)
        Dim row As DataRow

        row = tblAttorney.NewRow
        row("AttorneyID") = "-1"
        row("Name") = " "
        tblAttorney.Rows.InsertAt(row, 0)

        Return tblAttorney
    End Function

    Public Sub CopyRelationships(ByVal intSourceCompanyID As Integer, ByVal intDestCompanyID As Integer, ByVal intUserID As Integer, ByVal blnCopyPrimaries As Boolean)
        objDAL.CopyRelationships(intSourceCompanyID, intDestCompanyID, intUserID, blnCopyPrimaries)
    End Sub

End Class
