<%@ Page Language="VB" MasterPageFile="~/research/queries/queries.master" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="research_queries_matter_default" title="DMP - Research" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/research">Research</a>&nbsp;>&nbsp;<a runat="server" class="lnk" style="color: #666666;" href="~/research/queries">Queries</a>&nbsp;>&nbsp;Litigation</td>
        </tr>
        <tr>
            <td>
                <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5" id="tblMatters" runat="server">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Matters</td>
                    </tr>
                    
                    <tr id="trAllMatters" runat="server">
                        <td style="padding-left:20;"><a id="A4" runat="server" class="lnk" href="~/research/queries/litigation/allmatters.aspx"><img id="Img4" style="margin-right:5;" src="~/images/16x16_query.png" runat="server" border="0" align="absmiddle"/>All Matters</a></td>
                    </tr>
                </table>
                
            
            </td>
        </tr>
    </table>
</asp:Content>

