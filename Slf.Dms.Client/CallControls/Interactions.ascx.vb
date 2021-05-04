﻿Imports ININ.IceLib.Interactions

Partial Class CallControls_Interactions
    Inherits System.Web.UI.UserControl

    Private _intQueue As ININ.IceLib.Interactions.InteractionQueue = Nothing

    Public ReadOnly Property intQueue() As ININ.IceLib.Interactions.InteractionQueue
        Get
            Return _intQueue
        End Get
    End Property

    Public Delegate Sub InteractionAddedDelegate(ByVal intCurrent As Object, ByVal sInteractionId As String)
    Public Event InteractionAddedEvent As InteractionAddedDelegate

    Public Delegate Sub InteractionChangedDelegate(ByVal intCurrent As Object, ByVal sInteractionId As String)
    Public Event InteractionChangedEvent As InteractionChangedDelegate

    Public Delegate Sub InteractionRemovedDelegate(ByVal intCurrent As Object, ByVal sInteractionId As String)
    Public Event InteractionRemovedEvent As InteractionRemovedDelegate

    Public Sub SetInteractionQueue(ByVal interactionQueue As ININ.IceLib.Interactions.InteractionQueue)
        DisconnectFromQueue()
        _intQueue = interactionQueue
        ConnectToQueue()
    End Sub

    Private Sub DisconnectFromQueue()
        'lblInteractions.Enabled = false;

        If _intQueue IsNot Nothing Then
            _intQueue.StopWatching()
            RemoveHandler _intQueue.InteractionAdded, AddressOf InteractionQueue_InteractionAdded
            RemoveHandler _intQueue.InteractionChanged, AddressOf InteractionQueue_InteractionChanged
            RemoveHandler _intQueue.InteractionRemoved, AddressOf InteractionQueue_InteractionRemoved
            _intQueue = Nothing
        End If
    End Sub

    Private Sub ConnectToQueue()
        If _intQueue IsNot Nothing Then
            AddHandler _intQueue.InteractionsManager.InteractionAutoAnswered, AddressOf InteractionsManager_InteractionAutoAnswered
            AddHandler _intQueue.InteractionAdded, AddressOf InteractionQueue_InteractionAdded
            AddHandler _intQueue.InteractionChanged, AddressOf InteractionQueue_InteractionChanged
            AddHandler _intQueue.InteractionRemoved, AddressOf InteractionQueue_InteractionRemoved
            AddHandler _intQueue.ConferenceInteractionAdded, AddressOf InteractionQueue_ConferenceInteractionAdded
            AddHandler _intQueue.ConferenceInteractionChanged, AddressOf InteractionQueue_ConferenceInteractionChanged
            AddHandler _intQueue.ConferenceInteractionRemoved, AddressOf InteractionQueue_ConferenceInteractionRemoved

            'Start watching the interaction queue

            If Not _intQueue.IsWatching() Then
                _intQueue.StartWatching(CallConstants._NecessaryAttributes)
                'lblInteractions.Enabled = true;
            End If
        Else
            'lblInteractions.Enabled = false;
        End If
    End Sub

    Private Sub InteractionsManager_InteractionAutoAnswered(ByVal sender As Object, ByVal e As InteractionEventArgs)
        'lblInteractions.Text = e.Interaction.InteractionId + " Auto-answered.";
    End Sub

    Private Sub InteractionQueue_InteractionAdded(ByVal sender As Object, ByVal e As InteractionAttributesEventArgs)
        If e.Interaction.[GetType]().ToString() <> "ININ.IceLib.Interactions.RecorderInteraction" Then
            RaiseEvent InteractionAddedEvent(e.Interaction, e.Interaction.InteractionId.ToString())
        End If
    End Sub

    Private Sub InteractionQueue_InteractionChanged(ByVal sender As Object, ByVal e As InteractionAttributesEventArgs)
        'lblInteractions.Text = e.Interaction.InteractionId + " changed.";
        RaiseEvent InteractionChangedEvent(e.Interaction, e.Interaction.InteractionId.ToString())
    End Sub

    Private Sub InteractionQueue_InteractionRemoved(ByVal sender As Object, ByVal e As InteractionEventArgs)
        RaiseEvent InteractionRemovedEvent(e.Interaction, e.Interaction.InteractionId.ToString())
    End Sub

    Private Sub InteractionQueue_ConferenceInteractionAdded(ByVal sender As Object, ByVal e As ConferenceInteractionAttributesEventArgs)
        'lblInteractions.Text = e.ConferenceId + " (Conference) added.";
    End Sub

    Private Sub InteractionQueue_ConferenceInteractionChanged(ByVal sender As Object, ByVal e As ConferenceInteractionAttributesEventArgs)
        'lblInteractions.Text = e.ConferenceId + " (Conference) Interaction changed.";
    End Sub

    Private Sub InteractionQueue_ConferenceInteractionRemoved(ByVal sender As Object, ByVal e As ConferenceInteractionEventArgs)
        'lblInteractions.Text = e.ConferenceId + " (Conference) Interaction removed.";
    End Sub

End Class
