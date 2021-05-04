Imports System.Xml

Partial Class admin_crosscheck
    Inherits System.Web.UI.Page

    Protected Sub admin_crosscheck_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim path As String = String.Concat(Server.MapPath(""), "\crosscheck-jhernandez@identifyle.com.xml")
        Dim xmlDoc As New XmlDocument
        Dim groups, items As XmlNodeList
        Dim group, item As XmlNode
        Dim html As New Text.StringBuilder
        Dim created As Date

        created = IO.File.GetLastWriteTime(path)
        html.AppendFormat("<div style='float:right'><i>Last Updated {0}</i></div>", FormatDateTime(created, DateFormat.LongDate))

        xmlDoc.Load(path)
        groups = xmlDoc.SelectNodes("crosscheck/group")
        html.Append("<div style='clear:both'>")
        For Each group In groups
            items = group.SelectNodes("items/item")
            html.AppendFormat("<h2>{0} ({1})</h2>", group("name").InnerText, items.Count)
            html.Append("<ul>")
            For Each item In items
                html.AppendFormat("<li style='padding-bottom:10px'>{0}</li>", item("content").InnerText)
            Next
            html.Append("</ul>")
        Next
        html.Append("</div>")

        phTasks.Controls.Add(New LiteralControl(html.ToString))
    End Sub

End Class