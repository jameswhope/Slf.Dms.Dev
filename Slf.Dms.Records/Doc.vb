Option Explicit On

Imports Drg.Util.Helpers

Imports System.Web.HttpContext

Public Class Doc

#Region "Variables"

    Private _docid As Integer
    Private _name As String
    Private _docfolderid As Integer
    Private _docfoldername As String
    Private _size As Long
    Private _type As String
    Private _fileid As Integer

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _approot As String

#End Region

#Region "Properties"

    ReadOnly Property DocID() As Integer
        Get
            Return _docid
        End Get
    End Property
    ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
    ReadOnly Property DocFolderID() As Integer
        Get
            Return _docfolderid
        End Get
    End Property
    ReadOnly Property DocFolderName() As String
        Get
            Return _docfoldername
        End Get
    End Property
    ReadOnly Property Size() As Long
        Get
            Return _size
        End Get
    End Property
    ReadOnly Property SizeFormatted() As String
        Get
            Return FileHelper.FormatBytes(_size)
        End Get
    End Property
    ReadOnly Property Type() As String
        Get
            Return _type
        End Get
    End Property
    ReadOnly Property FileID() As Integer
        Get
            Return _fileid
        End Get
    End Property
    ReadOnly Property Created() As DateTime
        Get
            Return _created
        End Get
    End Property
    ReadOnly Property CreatedBy() As Integer
        Get
            Return _createdby
        End Get
    End Property
    ReadOnly Property CreatedByName() As String
        Get
            Return _createdbyname
        End Get
    End Property
    ReadOnly Property LastModified() As DateTime
        Get
            Return _lastmodified
        End Get
    End Property
    ReadOnly Property LastModifiedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property
    ReadOnly Property Icon() As String
        Get

            If _fileid = 0 Then
                Return _approot & "images/icons/xxx.png"
            Else

                Try

                    'build the right icon for this file
                    Dim _icon As String = New IO.FileInfo(_name).Extension.Trim(New Char() {",", "."})

                    If IO.File.Exists(Current.Server.MapPath(_approot & "images/icons/" & _icon & ".png")) Then
                        Return _approot & "images/icons/" & _icon & ".png"
                    Else
                        Return _approot & "images/icons/xxx.png"
                    End If

                Catch ex As Exception
                    Return _approot & "images/icons/xxx.png"
                End Try

            End If

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal DocID As Integer, ByVal Name As String, ByVal DocFolderID As Integer, _
        ByVal DocFolderName As String, ByVal Size As Long, ByVal Type As String, ByVal FileID As Integer, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String, _
        ByVal AppRoot As String)

        _docid = DocID
        _name = Name
        _docfolderid = DocFolderID
        _docfoldername = DocFolderName
        _size = Size
        _type = Type
        _fileid = FileID

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

        _approot = AppRoot

    End Sub

#End Region

End Class