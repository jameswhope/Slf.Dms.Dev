<%@ Page Title="" Language="VB" MasterPageFile="~/research/tools/tools.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="research_tools_documents_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research">
                    Research</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;"
                        href="~/research/tools">Tools</a>&nbsp;>&nbsp;Documents
            </td>
        </tr>
        <tr>
            <td>
             <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblDemographics" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Documents</td>
                    </tr>
                    <tr id="trFindPoa" runat="server">
                        <td style="padding-left:20;"><a id="A3" runat="server" class="lnk" href="~/research/tools/documents/findpoa.aspx"><img id="Img1" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Find POA's</a></td>
                    </tr>

                </table>
            
            
            </td>
        </tr>
    </table>
</asp:Content>
