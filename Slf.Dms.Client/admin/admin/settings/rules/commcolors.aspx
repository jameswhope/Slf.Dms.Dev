<%@ Page Language="VB" MasterPageFile="~/admin/settings/settings.master" AutoEventWireup="false" CodeFile="commcolors.aspx.vb" Inherits="admin_settings_negotiation_commcolors" title="DMP - Admin Settings - Rules" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls" TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>

<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder ID="pnlBody" runat="server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/functoids/date.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/isvalid.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
<script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>

<script type="text/javascript">
 function Record_DeleteConfirm(obj)
{
    if (!document.getElementById("<%= lnkDeleteConfirm.ClientID() %>").disabled)
    {
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Rules&m=Are you sure you want to delete this selection of Communication Color Rules?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Rules",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 350, width: 400, scrollable: false});
    }
}
function Record_Delete()
{
    // postback to delete
    <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
}
function Record_AddRule()
{
    window.location="commcolor.aspx?a=a";
}
</script>
<style type="text/css">
    thead th{
	    position:relative; 
	    top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
    }
</style>
<body scroll="no">
<table style="font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="15">
    <tr>
        <td style="color: #666666;">
            <a id="A1" runat="server" class="lnk" style="color: #666666;" href="~/admin">Admin</a>&nbsp;>&nbsp;<a id="A2" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings">Settings</a>&nbsp;>&nbsp;<a id="A3" runat="server" class="lnk" style="color: #666666;" href="~/admin/settings/rules/">Rules</a>&nbsp;>&nbsp;Communication Colors</td>
    </tr>
    <tr id="trInfoBox" runat="server">
        <td>
            <div class="iboxDiv">
                <table class="iboxTable" border="0" cellpadding="7" cellspacing="0">
                    <tr>
                        <td valign="top" style="width:16;"><img id="Img3" runat="server" border="0" src="~/images/16x16_note3.png"/></td>
                        <td>
                            <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="iboxHeaderCell">INFORMATION:</td>
                                    <td class="iboxCloseCell" valign="top" align="right"><!--<asp:LinkButton runat="server" id="lnkCloseInformation"><img id="Img4" border="0" src="~/images/16x16_close.png" runat="server" /></asp:LinkButton>--></td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="iboxMessageCell">
                                        These rules force communications to be displayed in a certain 
                                        color when related to a certain type of item, or created by a
                                        a specified User, member of a User Types or Groups.  If a communication 
                                        falls under more than one specified category, the displayed color will be 
                                        chosen using the following order: Relation Type, User, Group, User Type.
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    <tr runat="server" id="dvError" style="display:none;">
        <td valign="top">
            <div >
                <table style="BORDER-RIGHT: #969696 1px solid; BORDER-TOP: #969696 1px solid; FONT-SIZE: 11px; BORDER-LEFT: #969696 1px solid; COLOR: red; BORDER-BOTTOM: #969696 1px solid; FONT-FAMILY: Tahoma; BACKGROUND-COLOR: #ffffda" cellspacing="10" cellpadding="0" width="100%" border="0">
		            <tr>
			            <td valign="top" width="20"><img id="Img1" runat="server" src="~/images/message.png" align="absmiddle" border="0"></TD>
			            <td runat="server" id="tdError"></TD>
		            </TR>
	            </table>
	        </div>
        </td>
    </tr>
    <tr>
        <td>
            <table style="margin-top:15;background-color:#f3f3f3;font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td style="padding:5 7 5 7;color:rgb(50,112,163);">Communication Color Rules</td>
                    <td style="padding-right:7;" align="right"><a class="lnk" id="lnkDeleteConfirm" disabled="true" runat="server" href="#" onmouseup="javascript:Record_DeleteConfirm(this);">Delete</a></td>
                </tr>
            </table>
            <table onmouseover="Grid_RowHover(this, true)" onmouseout="Grid_RowHover(this,false)" class="list" style="font-family:tahoma;font-size:11px;width:100%;" cellspacing="0" cellpadding="3">
                <colgroup>
                    <col />
                    <col align="Center"/>
                    <col align="left"/>
                    <col align="left"/>
                    <col align="left"/>
                    <col align="left"/>
                </colgroup>
                <thead>
                    <tr>
                        <td align="center" style="width:20;" class="headItem"><img onmouseup="this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);" style="cursor:pointer;" title="Check All" runat="server" src="~/images/11x11_checkall.png" border="0" /><img id="Img5" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);" style="cursor:pointer;display:none;" title="Uncheck All" runat="server" src="~/images/11x11_uncheckall.png" border="0" /></td>
                        <th style="width: 25;" align="center">
                            <img id="Img2" runat="server" src="~/images/16x16_icon.png" border="0" align="absmiddle" />
                        </th>
                        <th>Type</th>
                        <th>Entity</th>
                        <th>Back Color</th>
                        <th>Text Color</th>
                    </tr>
                </thead>
                <tbody>
                <asp:repeater runat="server" id="rpColors">
                    <itemtemplate>
                        <a href="<%#ResolveURL("~/admin/settings/rules/commcolor.aspx?ccid=" & DataBinder.Eval(Container.DataItem, "RuleCommColorID"))  %>"
                        <tr>
                            <td style="width:20;" align="center"><img id="Img6" onmouseup="this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;" runat="server" src="~/images/13x13_check_cold.png" border="0" align="absmiddle" /><img id="Img7" onmouseup="this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;" style="display:none;" runat="server" src="~/images/13x13_check_hot.png" border="0" align="absmiddle" /><input onpropertychange="Grid_CheckOrUncheck(this, <%#DataBinder.Eval(Container.DataItem, "RuleCommColorID") %>);" style="display:none;" type="checkbox" /></td>
                            <td ><img src="<%#ResolveURL("~/images/12x12_flag_yellow.png")%>" border="0"/></td>
                            <td>
                                <%#DataBinder.Eval(Container.DataItem, "EntityType") %>
                            </td>
                            <td>
                                <%#DataBinder.Eval(Container.DataItem, "EntityName") %>
                            </td>
                            <td >
                                <%#GetColorField(DataBinder.Eval(Container.DataItem, "Color"))%>
                            </td>
                            <td >
                                <%#GetColorField(DataBinder.Eval(Container.DataItem, "TextColor"))%>
                            </td>
                        </tr>
                        </a>
                    </itemtemplate>
                </asp:repeater>
                </tbody>
            </table><input type="hidden" runat="server" id="txtSelectedIDs"/><input type="hidden" value="<%= lnkDeleteConfirm.ClientId%>"/>
        </td>
    </tr>
</table>
</body>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
</asp:PlaceHolder></asp:Content>
