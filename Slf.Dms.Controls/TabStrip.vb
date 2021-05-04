Option Explicit On

Imports Slf.Dms.Records

Imports System.Web.UI
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility

Public Class TabPages
    Inherits List(Of TabPage)

    Private _container As TabStrip

    Friend Property Container() As TabStrip
        Get
            Return _container
        End Get
        Set(ByVal value As TabStrip)
            _container = value
        End Set
    End Property

    Public Overloads Sub Add(ByVal item As Slf.Dms.Controls.TabPage)

        item.Container = _container
        item._index = MyBase.Count

        MyBase.Add(item)

    End Sub

    Public Sub New()

    End Sub

End Class

<ToolboxData("<{0}:TabStrip runat=server></{0}:TabStrip>")> _
Public Class TabStrip
    Inherits Control

#Region "Variables"

    Private _tabpages As TabPages

#End Region

#Region "Properties"

    <Browsable(False)> _
    ReadOnly Property TabPages() As TabPages
        Get

            If _tabpages Is Nothing Then

                Dim tps As New TabPages()

                tps.Container = Me

                _tabpages = tps

            End If

            Return _tabpages

        End Get
    End Property

    <Browsable(False)> _
    Property SelectedIndex() As Integer
        Get
            Return ViewState("SelectedIndex")
        End Get
        Set(ByVal value As Integer)

            ViewState("SelectedIndex") = value

            ResetSelection()

        End Set
    End Property

#End Region

#Region "Constructor"

    Public Sub New()

    End Sub

#End Region

    Private Sub ResetSelection()

        For Each tp As TabPage In TabPages

            Dim [Set] As Boolean = tp.Index = SelectedIndex

            If Not tp.Selected = [Set] Then
                tp.Selected = [Set]
            End If

        Next

    End Sub
    Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)

        'make sure something is selected
        ResetSelection()

        output.Write("<table tabcount=""" & TabPages.Count & """ id=""" & ClientID & """ onselectstart=""return false;"" class=""tabXPTable"" border=""0"" cellpadding=""0"" cellspacing=""0"">")
        output.Write("  <tr>")
        output.Write("      <td istab=""false"" nowrap=""true"" class=""tabXPHolderBack"" style=""width:15;"">&nbsp;</td>")

        For Each tp As TabPage In TabPages

            Dim [End] As String = IIf(tp.Selected, "Sel", "Uns")

            output.Write("      <td istab=""true"" nowrap=""true"" class=""tabXPHolder" & [End] & """ valign=""bottom"">")

            output.Write("          <table page=""" & tp.PageClientID & """ index=""" & tp.Index & """ onclick=""XPTabStrip_OnClick(this);"" onmouseover=""XPTabStrip_OnMouseOver(this);"" onmouseout=""XPTabStrip_OnMouseOut(this);"" selected=""" & tp.Selected.ToString.ToLower & """ class=""tabXPHolderTable" & [End] & """" & IIf(String.IsNullOrEmpty(tp.Redirect), String.Empty, " redirect=""" & tp.Redirect & """") & " border=""0"" cellpadding=""0"" cellspacing=""0"">")
            output.Write("              <tr>")
            output.Write("                  <td class=""tabXPCellTopLeft" & [End] & """><div style=""width:2;height:2;font-size:2;"">&nbsp;</div></td>")
            output.Write("                  <td class=""tabXPCellTop" & [End] & """><div style=""width:2;height:2;font-size:2;"">&nbsp;</div></td>")
            output.Write("                  <td class=""tabXPCellTopRight" & [End] & """><div style=""width:2;height:2;font-size:2;"">&nbsp;</div></td>")
            output.Write("              </tr>")
            output.Write("              <tr>")
            output.Write("                  <td class=""tabXPCellMidLeft" & [End] & """><div style=""width:2;height:2;font-size:2;"">&nbsp;</div></td>")
            output.Write("                  <td class=""tabXPCellMid" & [End] & """>" & tp.Caption & "</td>")
            output.Write("                  <td class=""tabXPCellMidRight" & [End] & """><div style=""width:2;height:2;font-size:2;"">&nbsp;</div></td>")
            output.Write("              </tr>")
            output.Write("          </table>")
            output.Write("      </td>")

        Next

        output.Write("      <td istab=""false"" class=""tabXPHolderBack"">&nbsp;</td>")
        output.Write("  </tr>")

        For Each tp As TabPage In TabPages
            output.Write("  <tr style=""display:" & IIf(tp.Selected, "inline", "none") & ";""><td colspan=""" & TabPages.Count + 2 & """></td></tr>")
        Next

        output.Write("</table><input type=""hidden"" name=""" & ClientID & "Selected"" id=""" & ClientID & "Selected"" value=""" & SelectedIndex & """ />")

    End Sub
    Private Sub TabStrip_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'get and reset selectedindex
        Dim Value As String = Page.Request.Form(ClientID & "Selected")

        If Not Value Is Nothing AndAlso Value.Length > 0 Then

            Try
                SelectedIndex = Integer.Parse(Value)
            Catch ex As Exception
                SelectedIndex = 0
            End Try

        End If

    End Sub
End Class