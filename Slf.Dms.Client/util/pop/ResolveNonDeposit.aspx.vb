
Partial Class util_pop_ResolveNonDeposit
    Inherits System.Web.UI.Page

    Protected Sub NonDepositMatterResolve1_OptionChanged(ByVal OptionId As Integer) Handles NonDepositMatterResolve1.OptionChanged
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "resizewin", String.Format("ResizeWin('{0}');", OptionId), True)
    End Sub

End Class
