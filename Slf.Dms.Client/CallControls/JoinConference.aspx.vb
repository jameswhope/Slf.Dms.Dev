Imports ININ.IceLib.Interactions
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.ObjectModel

Partial Class CallControls_JoinConference
    Inherits System.Web.UI.Page

    Private _currentInteraction As Interaction
    Private _interactionList As Dictionary(Of String, Interaction)

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        _currentInteraction = Session("CurrentInteraction")
        _interactionList = CType(Session("InteractionList"), Dictionary(Of String, Interaction))

    End Sub

    Private Sub LoadHeldInteractions()
        Dim interactions As New List(Of Interaction)

        If Not _currentInteraction Is Nothing Then
            For Each inter As Interaction In _interactionList.Values
                Try
                    If inter.IsHeld Then interactions.Add(inter)
                Catch ex As Exception

                End Try
            Next

        End If

        grdInteractions.DataSource = interactions
        grdInteractions.DataBind()

        interactions = Nothing
    End Sub

    Protected Sub Timer1_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        'Do Nothing
        LoadHeldInteractions()
    End Sub

End Class
