<%@ Page Title="" Language="VB" MasterPageFile="~/research/tools/tools.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="research_tools_harassment_Default" %>

<%@ Register src="../../../../CustomTools/UserControls/CreditorHarassmentFormSearchControl.ascx" tagname="CreditorHarassmentFormSearchControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">
                    Research</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;"
                        href="~/research/tools">Tools</a>&nbsp;>&nbsp;Harassment
            </td>
        </tr>
        <tr>
            <td>
                <uc1:CreditorHarassmentFormSearchControl ID="CreditorHarassmentFormSearchControl1" 
                    runat="server" />
                            </td>
        </tr>
    </table>
</asp:Content>
