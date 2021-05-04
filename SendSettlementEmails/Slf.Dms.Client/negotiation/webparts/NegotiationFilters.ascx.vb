Imports Drg.Util.DataAccess

Imports LexxiomWebPartsControls

Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class negotiation_webparts_NegotiationFilters
    Inherits System.Web.UI.UserControl
    Implements wNegotiationFilters

#Region "Variables"
    Private TruncateLength As Integer
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        TruncateLength = 100
    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadFilters(ByVal entityIDs As List(Of String))
        Using cmd As New SqlCommand("SELECT AggregateClause, [Description] FROM tblNegotiationFilters WHERE FilterID in (" & GetFilters(String.Join(", ", entityIDs.ToArray())) & ") ORDER BY [Description], FilterID", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    chkFilters.DataTextField = "Description"
                    chkFilters.DataValueField = "AggregateClause"
                    chkFilters.DataSource = reader
                    chkFilters.DataBind()
                End Using
            End Using
        End Using

        For Each item As ListItem In chkFilters.Items
            If item.Text.Length > TruncateLength Then
                item.Attributes.Add("title", item.Text)

                item.Text = item.Text.Substring(0, TruncateLength - 3) & "..."
            End If
        Next
    End Sub

    Private Function GetFilters(ByVal entityID As String) As String
        Dim list As New List(Of String)()

        list.Add("-1")

        Using cmd As New SqlCommand("SELECT isnull(FilterID, 0) as FilterID FROM tblNegotiationFilterXref WHERE Deleted = 0 and EntityID in (" & entityID & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        list.Add(reader("FilterID"))
                    End While
                End Using
            End Using
        End Using

        AddChildFiltersRec(list, entityID)

        Return String.Join(",", list.ToArray())
    End Function

    Private Sub AddChildFiltersRec(ByRef list As List(Of String), ByVal entityID As String)
        Dim ids As New List(Of String)

        Using cmd As New SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE ParentNegotiationEntityID in (" & entityID & ")", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ids.Add(reader("NegotiationEntityID"))
                    End While
                End Using
            End Using
        End Using

        If ids.Count > 0 Then
            Using cmd As New SqlCommand("SELECT isnull(xr.FilterID, 0) as FilterID FROM tblNegotiationFilterXref as xr inner join tblNegotiationFilters as nf on nf.FilterID = xr.FilterID WHERE xr.Deleted = 0 and nf.Deleted = 0 and nf.FilterType = 'leaf' and xr.EntityID in (" & String.Join(", ", ids.ToArray()) & ")", New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            If Not list.Contains(reader("FilterID")) Then
                                list.Add(reader("FilterID"))
                            End If
                        End While
                    End Using
                End Using
            End Using

            For Each id As Integer In ids
                AddChildFiltersRec(list, id)
            Next
        End If
    End Sub
#End Region

#Region "WebPart Connections"
    <ConnectionProvider("Negotiation Filters Provider", "NegotiationFiltersProvider")> _
    Public Function ProvideNegotiationFilters() As wNegotiationFilters
        Return Me
    End Function

    Public ReadOnly Property chkFiltersProp() As CheckBoxList Implements wNegotiationFilters.chkFilters
        Get
            Return Me.chkFilters
        End Get
    End Property

    <ConnectionConsumer("Entity Filters Consumer", "EntityFiltersConsumer")> _
    Public Sub ConsumeEntityIDs(ByVal entityIDs As wEntityFilters)
        chkFilters.DataSource = Nothing
        chkFilters.DataBind()

        If Not entityIDs.EntityIDs Is Nothing AndAlso entityIDs.EntityIDs.Count > 0 Then
            LoadFilters(entityIDs.EntityIDs)
        End If
    End Sub
#End Region

End Class