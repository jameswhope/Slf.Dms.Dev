Imports System.Collections.Generic
Imports System.Data
Imports Drg.Util.DataAccess

Partial Class mobile_global_roadmap
    Inherits System.Web.UI.Page

    Public AgencyId As Integer = -1
    Public AttorneyID As Integer = -1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadGlobalRoadmap()
        End If
    End Sub

    Protected Function GetGRImg(ByVal b As Roadmap) As String
        Dim result As String = ""
        Dim parent As Roadmap = b.Parent

        While Not parent Is Nothing
            If parent.Parent IsNot Nothing Then
                If Not parent.IsLast Then
                    result = "&nbsp;&nbsp;" & result
                Else
                    result = "&nbsp;&nbsp;" & result
                End If
            End If
            parent = parent.Parent
        End While

        If b.ParentClientStatusId.HasValue Then
            result += "&nbsp;&nbsp;"
        End If

        Return result
    End Function

    Protected Class Roadmap
        Private _ClientStatusId As Integer
        Private _ParentClientStatusId As Nullable(Of Integer)
        Private _Name As String
        Private _Children As New List(Of Roadmap)
        Private _Level As Integer
        Private _IsLast As Boolean
        Private _Count As Integer
        Private _parent As Roadmap

        Public Property Parent() As Roadmap
            Get
                Return _parent
            End Get
            Set(ByVal value As Roadmap)
                _parent = value
            End Set
        End Property
        Public Property Count() As Integer
            Get
                Return _Count
            End Get
            Set(ByVal value As Integer)
                _Count = value
            End Set
        End Property
        Public Property IsLast() As Boolean
            Get
                Return _IsLast
            End Get
            Set(ByVal value As Boolean)
                _IsLast = value
            End Set
        End Property
        Public Property Level() As Integer
            Get
                Return _Level
            End Get
            Set(ByVal value As Integer)
                _Level = value
            End Set
        End Property
        Public Property ClientStatusId() As Integer
            Get
                Return _ClientStatusId
            End Get
            Set(ByVal value As Integer)
                _ClientStatusId = value
            End Set
        End Property
        Public Property ParentClientStatusId() As Nullable(Of Integer)
            Get
                Return _ParentClientStatusId
            End Get
            Set(ByVal value As Nullable(Of Integer))
                _ParentClientStatusId = value
            End Set
        End Property
        Public Property Name() As String
            Get
                Return _Name
            End Get
            Set(ByVal value As String)
                _Name = value
            End Set
        End Property
        Public Property Children() As List(Of Roadmap)
            Get
                Return _Children
            End Get
            Set(ByVal value As List(Of Roadmap))
                _Children = value
            End Set
        End Property
    End Class

    Private Sub LoadGlobalRoadmap()
        Dim All As New Dictionary(Of Integer, Roadmap)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetGlobalRoadmap")
            Using cmd.Connection

                If Not AgencyId = -1 Then DatabaseHelper.AddParameter(cmd, "AgencyId", AgencyId)
                If Not AttorneyID = -1 Then DatabaseHelper.AddParameter(cmd, "attorneyid", AttorneyID)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim b As New Roadmap
                        b.ClientStatusId = DatabaseHelper.Peel_int(rd, "ClientStatusID")
                        b.ParentClientStatusId = DatabaseHelper.Peel_nint(rd, "ParentClientStatusId")
                        b.Name = DatabaseHelper.Peel_string(rd, "ClientStatusName").Replace(" and ", "/")
                        b.Count = DatabaseHelper.Peel_int(rd, "Total")

                        All.Add(b.ClientStatusId, b)

                    End While
                End Using
            End Using
        End Using

        Dim ToRemove As New List(Of Integer)

        'link up transfers to their parents
        For Each i As Integer In All.Keys
            Dim b As Roadmap = All(i)
            If b.ParentClientStatusId.HasValue Then
                Dim ParentClientStatusId As Integer = b.ParentClientStatusId.Value
                If All.ContainsKey(ParentClientStatusId) Then
                    Dim Parent As Roadmap = All(ParentClientStatusId)
                    Parent.Children.Add(b)
                    b.Parent = Parent
                    ToRemove.Add(i)
                End If
            End If
        Next

        'remove those now under their parents
        For Each i As Integer In ToRemove
            All.Remove(i)
        Next

        Dim Ordered As New List(Of Roadmap)
        For Each b As Roadmap In All.Values
            AddRecursive(b, Ordered, 0)
        Next

        Repeater1.DataSource = Ordered
        Repeater1.DataBind()
    End Sub

    Private Sub AddRecursive(ByVal b As Roadmap, ByVal lst As List(Of Roadmap), ByVal Level As Integer)
        lst.Add(b)
        b.Level = Level
        If b.Children.Count > 0 Then
            For Each child As Roadmap In b.Children

                AddRecursive(child, lst, Level + 1)
                b.Count += child.Count
            Next
            b.Children(b.Children.Count - 1).IsLast = True
        End If
    End Sub

End Class
