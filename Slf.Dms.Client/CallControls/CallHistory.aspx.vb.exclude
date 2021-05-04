Imports ININ.IceLib.Interactions
Imports System.Collections
Imports System.Collections.Generic
Imports System.Collections.ObjectModel

Partial Class CallControls_CallHistory
    Inherits System.Web.UI.Page

    Private _iceSession As ININ.IceLib.Connection.Session
    Private _InteractionsManager As InteractionsManager

    Protected Sub form1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles form1.Load
        _iceSession = Session("IceSession")
        If Not _iceSession Is Nothing AndAlso Not Me.IsPostBack Then
            _InteractionsManager = InteractionsManager.GetInstance(_iceSession)
            Dim hList As New InteractionsHistory(_InteractionsManager)
            If Not hList.IsWatching Then hList.StartWatching()
            Dim ilist As New List(Of HistoryItem)
            For Each itm As HistoryItem In hList.HistoryDataCollection
                ilist.Insert(0, itm)
            Next
            Me.grdInteractions.DataSource = ilist
            Me.grdInteractions.DataBind()
        End If
    End Sub

End Class
