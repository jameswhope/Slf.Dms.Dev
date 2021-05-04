<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Settlement.aspx.vb" Inherits="Settlement" %>

<%@ Register Src="SettlementControl.ascx" TagName="SettlementControl" TagPrefix="uc1" %>
<%@ Reference Control="SettlementControl.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DMP - Settlement Calculator</title>
    <link href="preview.css" rel="stylesheet" type="text/css" />
   </head>
<body>
    <form id="form1" runat="server">
        <div>
            <ajaxToolkit:ToolkitScriptManager ID="smp1" runat="server" />
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true" AssociatedUpdatePanelID="upd1">
                <ProgressTemplate>
                    <div class="AjaxProgressMessage">
                        <br />
                        <img id="Img2" alt="" src="../../../images/loading.gif" runat="server" /><asp:Label
                            ID="ajaxLabel" name="ajaxLabel" runat="server" Text="Saving Data..." />
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>
            <asp:UpdatePanel ID="upd1" runat="server">
                <ContentTemplate>
                    <uc1:SettlementControl ID="sc" runat="server" />
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="sc" EventName="PostBack" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
