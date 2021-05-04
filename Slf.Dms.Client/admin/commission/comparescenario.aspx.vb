
Partial Class admin_commission_comparescenario
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnCompare_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCompare.Click
        Dim obj As New Lexxiom.BusinessServices.Scenario
        obj.format = Lexxiom.BusinessServices.Scenario.ScenarioFormat.PoT
        dScenarios.InnerHtml = obj.LoadScenarios(CInt(ddlCommScen.SelectedItem.Value))
        obj = Nothing
    End Sub
End Class
