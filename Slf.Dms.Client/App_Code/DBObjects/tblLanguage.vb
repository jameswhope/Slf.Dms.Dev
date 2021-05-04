Option Explicit On

Imports Drg.Util.DataAccess

Namespace DBObjects

    Public Class tblLanguage

#Region "Constants"

        Const Table As String = "tblLanguage"
        Const KeyField As String = "LanguageID"

#End Region

#Region "Variables"

        Private _languageid As Integer

#End Region

#Region "Properties"

        Property LanguageID() As Integer
            Get
                Return _languageid
            End Get
            Set(ByVal value As Integer)
                _languageid = value
            End Set
        End Property
        ReadOnly Property Criteria() As String
            Get
                Return KeyField & " = " & LanguageID
            End Get
        End Property

#End Region

        Public Sub New(ByVal LanguageID As Integer)
            _languageid = LanguageID
        End Sub

        Public Sub AfterInsert()
            EnsureDefault()
        End Sub

        Public Sub AfterUpdate()
            EnsureDefault()
        End Sub

        Public Sub AfterDelete()
            EnsureDefault()
        End Sub

        Private Sub EnsureDefault()

            Dim IsDefault As Boolean = DataHelper.Nz_bool(DataHelper.FieldLookup(Table, "Default", Criteria))

            If IsDefault Then
                DataHelper.FieldUpdate(Table, "Default", False, "NOT " & Criteria)
            Else

                'make sure something has the default
                Dim NumDefaults As Integer = DataHelper.Nz_int(DataHelper.FieldCount(Table, "LanguageID", "[Default] = 1"))

                If NumDefaults = 0 Then 'none are default

                    'set the last modified language to be the default
                    Dim LastLanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldTop1(Table, "LanguageID", _
                        "NOT " & Criteria, "LastModified DESC"))

                    DataHelper.FieldUpdate(Table, "Default", True, "LanguageID = " & LastLanguageID)

                End If

            End If

        End Sub

    End Class

End Namespace