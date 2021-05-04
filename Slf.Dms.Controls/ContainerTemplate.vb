Imports System
Imports System.ComponentModel
Imports System.Security.Permissions
Imports System.Web
Imports System.Web.UI


<ToolboxItem(False)> _
<AspNetHostingPermission(SecurityAction.LinkDemand, Level:=AspNetHostingPermissionLevel.Minimal)> _
<AspNetHostingPermission(SecurityAction.InheritanceDemand, Level:=AspNetHostingPermissionLevel.Minimal)> _
Class ContainerTemplate
    Inherits Control
    Implements INamingContainer
    Public Sub New()

    End Sub
    Public Sub AddControl(ByVal c As Control)
        Me.Controls.Add(c)
    End Sub
End Class

