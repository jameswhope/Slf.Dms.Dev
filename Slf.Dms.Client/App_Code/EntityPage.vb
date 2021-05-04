Imports Microsoft.VisualBasic
Imports Drg.Util.DataAccess
Imports System.Data
Public Interface IEntityPage
    ReadOnly Property IsAdd() As Boolean
    ReadOnly Property RelationID() As Integer
    ReadOnly Property RelationTypeID() As Integer
    ReadOnly Property EntityName() As String
End Interface
Public Interface IEntityPageOverrideSync
End Interface
Public MustInherit Class EntityPage
    Inherits PermissionPage
    Implements IEntityPage

    Public MustOverride ReadOnly Property BaseTable() As String
    Public MustOverride ReadOnly Property BaseQueryString() As String

    Public ReadOnly Property EntityName() As String Implements IEntityPage.EntityName
        Get
            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_getentitydisplay")
                Using cmd.Connection
                    DatabaseHelper.AddParameter(cmd, "relationtypeid", RelationTypeID)
                    DatabaseHelper.AddParameter(cmd, "relationid", RelationID)

                    cmd.Connection.Open()
                    Dim s As String = DataHelper.Nz_string(cmd.ExecuteScalar)

                    Return s
                End Using
            End Using
        End Get
    End Property
    Public ReadOnly Property RelationID() As Integer Implements IEntityPage.RelationID
        Get
            If Not Request.QueryString(BaseQueryString) Is Nothing Then
                Return Request.QueryString(BaseQueryString)
            Else
                Return -1
            End If
        End Get
    End Property
    Public ReadOnly Property RelationTypeID() As Integer Implements IEntityPage.RelationTypeID
        Get
            Return DataHelper.Nz_int(DataHelper.FieldLookup("tblRelationType", "RelationTypeID", "[Table]='" & BaseTable & "'"), -1)
        End Get
    End Property
    Public ReadOnly Property IsAdd() As Boolean Implements IEntityPage.IsAdd
        Get
            If Request.QueryString("a") Is Nothing Then
                Return False
            Else
                Return Request.QueryString("a").ToLower = "a"
            End If
        End Get
    End Property

End Class