<%@ Page Language="VB" MasterPageFile="~/admin/Processes/Processes.master"AutoEventWireup="false" CodeFile="Default.aspx.vb" 
Inherits="admin_Processes_ProcessClients_Default" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
<script type="text/javascript">
function Record_DeleteConfirm()
    {
        if (!document.getElementById("<%= lnkDeleteConfirm.ClientID() %>").disabled)
        {
             var url = '<%= ResolveUrl("~/util/pop/DelClient.aspx") %>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Delete Client",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 500, width: 500});       
        }
    }
   
 function RebalanceClient()
{
     if (!document.getElementById("<%= lnkRebalanceClient.ClientID() %>").disabled)
        {
            var url = '<%= ResolveUrl("~/util/pop/RebalClient.aspx") %>';
             window.dialogArguments = window;
             currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                       title: "Rebalance Client",
                       dialogArguments: window,
                       resizable: false,
                       scrollable: false,
                       height: 500, width: 500});       
        }
}  

function RunStatements()
{
     if (!document.getElementById("<%= lnkRunStatements.ClientID() %>").disabled)
        {
            var url = '<%= ResolveUrl("~/util/pop/ReRunStmts.aspx") %>';
            window.dialogArguments = window;
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                title: "Rerun Statements",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 500, width: 500
            });  
        }
}  
</script>

    <table runat="server" id="tblBody" style="font-family:tahoma;font-size:11px;width:100%;"
        border="0" cellpadding="0" cellspacing="15">
        <tr>
            <td style="color: #666666;"><a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/Processes/default.aspx">Processes</a>&nbsp;>&nbsp;Client Processes</td>
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
                                        <td class="iboxCloseCell" valign="top" align="right"><asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img2" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="iboxMessageCell">
                                            The Client Processes below are catagorized by type of task or process.  Each
                                            of these processes can be run manually or set to run at a specific time,  
                                            day or date. 
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
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Client Statements</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="lnkRunStatements" runat="server" class="lnk" href="javascript:RunStatements();"><img id="Img7" style="margin-right:5;" src="~/images/redo.png" runat="server" border="0" align="absmiddle"/>Re-run Statements</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="A3" runat="server" class="lnk" href="~/admin/Processes/ProcessClients/Scheduling.aspx"><img id="Img3" style="margin-right:5;" src="~/images/Calendar_add.png" runat="server" border="0" align="absmiddle"/>Manage Schedule</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="A4" runat="server" class="lnk" href="~/admin/Processes/ProcessClients/Statements/default.aspx?rpt=Exception"><img id="Img4" style="margin-right:5;" src="~/images/New_Page.png" runat="server" border="0" align="absmiddle"/>Exception Reporting</a></td>
                    </tr>
                 </table>
                 <table style="margin-bottom:10;margin-right:15;float:left;font-family:tahoma;font-size:11px;width:175;" border="0" cellpadding="0" cellspacing="5">
                    <tr>
                        <td style="padding:0 0 5 5;font-size:13px;border-bottom:solid 1px rgb(200,200,200);font-weight:bold;">Client Maintenance</td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="lnkDeleteConfirm" runat="server" class="lnk" href="javascript:Record_DeleteConfirm();"><img id="Img5" style="margin-right:5;" src="~/images/user_remove.png" runat="server" border="0" align="absmiddle"/>Delete Client</a></td>
                    </tr>
                    <tr>
                        <td style="padding-left:20;"><a id="lnkRebalanceClient" runat="server" class="lnk" href="javascript:RebalanceClient();"><img id="Img6" style="margin-right:5;" src="~/images/refresh.png" runat="server" border="0" align="absmiddle"/>Rebalance Client</a></td>
                    </tr>
                    </table>
            </td>
        </tr>
    </table>
   
       <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
       <asp:LinkButton runat="server" ID="lnkRebalance"></asp:LinkButton>
</asp:Content>
