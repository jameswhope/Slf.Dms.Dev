Imports Drg.Util.DataAccess

Imports System.Data.SqlClient

Public Class TreeTrackHelper

#Region "Enumerations"
    Public Enum TreeTrackIDType
        Settlement = 1
    End Enum

    Public Enum TreeTrackType
        Engaged = 1
        Working = 2
        Arguing = 3
        Settled = 4
    End Enum

    Public Enum TreeTrackImage
        None
        Indent
        DownIndent
    End Enum
#End Region

#Region "Structures"
    Public Structure TreeTrackNode
        Public ID As Integer
        Public Name As String
        Public ParentID As Integer
        Public Created As DateTime
        Public Image As TreeTrackImage

        Public Sub New(ByVal _ID As Integer, ByVal _Name As String, ByVal _ParentID As Integer, ByVal _Created As DateTime)
            Me.ID = _ID
            Me.Name = _Name
            Me.ParentID = _ParentID
            Me.Created = _Created
        End Sub

        Public Sub SetImage(ByVal _Image As TreeTrackImage)
            Me.Image = _Image
        End Sub
    End Structure

    Public Structure TreeTrack
        Public Nodes As Dictionary(Of Integer, TreeTrackNode)

        Public Sub Add(ByVal _ID As Integer, ByVal _Name As String, ByVal _ParentID As Integer, ByVal _Created As DateTime)
            Nodes.Add(_ID, New TreeTrackNode(_ID, _Name, _ParentID, _Created))
        End Sub
    End Structure
#End Region

#Region "Utilities"
    Public Shared Function InsertNode(ByVal id As Integer, ByVal idType As TreeTrackIDType, ByVal type As TreeTrackType, ByVal userID As Integer) As Integer
        Dim parentType As Integer
        Dim parentTreeTrackID As Integer = -1

        Using cmd As New SqlCommand("SELECT isnull(ParentTreeTrackTypeID, -1) FROM tblTreeTrackType WHERE TreeTrackTypeID = " & type, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                parentType = Integer.Parse(cmd.ExecuteScalar())

                If Not parentType = -1 Then
                    cmd.CommandText = "SELECT TreeTrackID FROM tblTreeTrack WHERE ID = " & id & " and TreeTrackIDTypeID = " & idType & " and TreeTrackTypeID = " & parentType

                    Integer.TryParse(cmd.ExecuteScalar(), parentTreeTrackID)
                End If

                cmd.CommandText = "INSERT INTO tblTreeTrack (ID, TreeTrackIDTypeID, ParentTreeTrackID, TreeTrackTypeID, Created, CreatedBy, LastModified, LastModifiedBy) VALUES (" & id & ", " & idType & ", " & IIf(parentTreeTrackID = -1, "null", parentTreeTrackID) & ", " & type & ", getdate(), " & userID & ", getdate(), " & userID & ") SELECT scope_identity()"

                Return Integer.Parse(cmd.ExecuteScalar())
            End Using
        End Using
    End Function

    Public Shared Sub DeleteNode(ByVal treeTrackID As Integer)
        Using cmd As New SqlCommand("DELETE tblTreeTrack WHERE TreeTrackID = " & treeTrackID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function GetTree(ByVal id As Integer, ByVal idType As TreeTrackIDType) As TreeTrack
        Dim ret As New TreeTrack()

        Using cmd As New SqlCommand("SELECT tt.TreeTrackID, ty.Name, isnull(tt.ParentTreeTrackID, -1) as ParentTreeTrackID, tt.Created FROM tblTreeTrack as tt inner join tblTreeTrackType as ty on ty.TreeTrackTypeID = tt.TreeTrackTypeID WHERE tt.ID = " & id & " and tt.TreeTrackIDTypeID = " & idType & " ORDER BY tt.Created", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ret.Add(Integer.Parse(reader("TreeTrackID")), reader("Name"), Integer.Parse(reader("ParentTreeTrackID")), DateTime.Parse(reader("Created")))
                    End While
                End Using
            End Using
        End Using

        For Each nodeID As Integer In ret.Nodes.Keys
            ret.Nodes(nodeID).SetImage(GetImage(nodeID, ret.Nodes))
        Next

        Return ret
    End Function

    Private Shared Function GetImage(ByVal id As Integer, ByVal nodes As Dictionary(Of Integer, TreeTrackNode)) As TreeTrackImage
        Dim down As Boolean = False

        If nodes(id).ParentID = -1 Then
            Return TreeTrackImage.None
        End If

        For Each node As TreeTrackNode In nodes.Values
            If node.ParentID = nodes(id).ParentID And node.Created > nodes(id).Created Then
                Return TreeTrackImage.DownIndent

                Exit For
            End If
        Next

        Return TreeTrackImage.Indent
    End Function
#End Region

End Class