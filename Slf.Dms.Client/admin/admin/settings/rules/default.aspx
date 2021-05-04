<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="admin_settings_rules_default" title="DMP - Admin Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;Rules</td>
        </tr>
        <tr id="trInfoBox" runat="server">
            <td>
                <div class="iboxDiv">
                    <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                        <tr>
                            <td valign="top" style="width:16;"><img id="Img1" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                            <td>
                                <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="iboxHeaderCell">INFORMATION:</td>
                                        <td class="iboxCloseCell" valign="top" align="right"><!--<asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img2" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>--></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            The entities below are called rule categories. Each category is a
                                            set of specified criteria which will determine the behavior of a
                                            certain section of the system.  Some rules affect the aesthetics of 
                                            system displays, while others define logical behaviors of system
                                            functions.
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Negotiation</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="A3" runat="server" class="lnk" href="~/admin/settings/rules/negotiation/selection.aspx"><img id="Img3" style="margin-right:5;" src="~/images/16x16_icon.png" runat="server" border="0" align="absmiddle"/>Client Selection</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="A4" runat="server" class="lnk" href="~/admin/settings/rules/negotiation/assignment.aspx"><img id="Img4" style="margin-right:5;" src="~/images/16x16_icon.png" runat="server" border="0" align="absmiddle"/>Auto Assignment</a></td>
                    </tr>
                    <tr><td style="height:16;">&nbsp;</td></tr>
                </table>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Display</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="A5" runat="server" class="lnk" href="~/admin/settings/rules/commcolors.aspx"><img id="Img5" style="margin-right:5;" src="~/images/16x16_icon.png" runat="server" border="0" align="absmiddle"/>Communication Colors</a></td>
                    </tr>
                    <tr><td style="height:16;">&nbsp;</td></tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>

