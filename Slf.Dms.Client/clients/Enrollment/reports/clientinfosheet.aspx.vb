
Partial Class portals_attorney_reports_clientinfosheet
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim rpt As New LexxiomLetterTemplates.LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim rDoc As New GrapeCity.ActiveReports.Document.SectionDocument
        Dim memStream As New System.IO.MemoryStream()
        Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport

        rDoc = rpt.ViewApplicantInformationSheet_Mossler_20150427(CInt(Request.QueryString("id")))
        pdf.Export(rDoc, memStream)

        memStream.Seek(0, IO.SeekOrigin.Begin)

        Response.ContentType = "application/pdf"
        Response.BinaryWrite(memStream.ToArray)
    End Sub
End Class
