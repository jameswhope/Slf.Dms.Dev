
Partial Class Clients_Enrollment_creditpackage_coverPage
    Inherits System.Web.UI.Page

    Protected Sub Clients_Enrollment_creditpackage_coverPage_PreLoad(sender As Object, e As System.EventArgs) Handles Me.PreLoad
        Dim applicant As New Applicant(Request.QueryString("aid"))
        clientsname.Text = applicant.Prefix + " " + applicant.FirstName + " " + applicant.LastName
    End Sub
End Class
