Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomWebPartsControls

Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class negotiation_webparts_NegotiationEntities
    Inherits System.Web.UI.UserControl
    Implements wEntityFilters

#Region "Variables"
    Private _entityIDs As List(Of String)

    Private UserID As Integer
    Private IsAdministrator As Boolean
#End Region

#Region "Page Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        IsAdministrator = NegotiationHelper.IsAdministrator(UserID)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not IsPostBack Then
            _entityIDs = New List(Of String)

            hdnScrollTop.Value = "0"

            GetEntityList(GetFunctionalIDs())
        End If
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lstEntity_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstEntity.SelectedIndexChanged
        _entityIDs = New List(Of String)

        For Each item As ListItem In lstEntity.Items
            If item.Selected Then
                _entityIDs.Add(item.Value)
            End If
        Next
    End Sub
#End Region

#Region "Utilities"
    Private Function GetFunctionalIDs() As List(Of String)
        Dim ids As New List(Of String)()
        Dim hasChildren As Boolean = True

        ids.Add("-1")

        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                While hasChildren
                    hasChildren = False

                    If IsAdministrator Then
                        cmd.CommandText = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0"
                    Else
                        cmd.CommandText = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and (UserID = " & UserID & " or ParentNegotiationEntityID in (" & String.Join(", ", ids.ToArray()) & "))"
                    End If

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            If Not ids.Contains(reader("NegotiationEntityID")) Then
                                ids.Add(reader("NegotiationEntityID"))

                                hasChildren = True
                            End If
                        End While
                    End Using
                End While
            End Using
        End Using

        Return ids
    End Function

    Private Sub GetEntityList(ByVal entityIDs As List(Of String))
        Using cmd As New SqlCommand("SELECT NegotiationEntityID, [Name] FROM tblNegotiationEntity WHERE NegotiationEntityID in (" & String.Join(", ", entityIDs.ToArray()) & ") ORDER BY [Name], NegotiationEntityID", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    lstEntity.DataTextField = "Name"
                    lstEntity.DataValueField = "NegotiationEntityID"
                    lstEntity.DataSource = reader
                    lstEntity.DataBind()
                End Using
            End Using
        End Using
    End Sub
#End Region

#Region "WebPart Connections"
    <ConnectionProvider("Entity Filters Provider", "EntityFiltersProvider")> _
    Public Function ProvideEntityIDs() As wEntityFilters
        Return Me
    End Function

    Public ReadOnly Property EntityIDs() As List(Of String) Implements wEntityFilters.EntityIDs
        Get
            Return Me._entityIDs
        End Get
    End Property
#End Region

End Class