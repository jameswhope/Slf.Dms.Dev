<%@ Page Title="" Language="VB" MasterPageFile="~/research/tools/tools.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="research_tools_Default" %>
<%@ MasterType TypeName="ToolsMaster" %>
<%-- Add content controls here --%>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="server">

<table runat="server" id="tblBody" style="font-family: tahoma; font-size: 11px; width: 100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;">
                <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/research/tools">
                    Research</a>&nbsp;>&nbsp;tools
            </td>
        </tr>
        <tr>
            <td>
             <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblDemographics" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Tools</td>
                    </tr>
                    <tr id="trFindPoa" runat="server">
                        <td style="padding-left:20;"><a id="A3" runat="server" class="lnk" href="~/research/tools/documents"><img id="Img1" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Documents</a></td>
                    </tr>
                    <tr id="tr1" runat="server">
                        <td style="padding-left:20;"><a id="A2" runat="server" class="lnk" href="~/research/tools/harassment"><img id="Img2" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>Harassment Management</a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>