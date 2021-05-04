Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Collections.Generic
Imports Drg.Utilities

Partial Class util_pop_timeout
    Inherits System.Web.UI.Page

#Region "Variables"

    Public ApplicationTimeoutCountdown As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ApplicationTimeoutCountdown = CType(StringHelper.ParseDouble(PropertyHelper.Value("ApplicationTimeoutCountdown"), 0), Integer)
    End Sub
End Class