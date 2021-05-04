<%@ Page Language="VB" MasterPageFile="~/admin/users/user/user.master" AutoEventWireup="false" CodeFile="visit.aspx.vb" Inherits="admin_users_user_history_visit" title="DMP - Admin - User History" %>

<asp:Content ID="cphBody" ContentPlaceHolderID="cphBody" Runat="Server"><asp:PlaceHolder runat="server" ID="pnlBody">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<body id="bodMain" runat="server">
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.JQuery) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl(GlobalFiles.JQuery.UI) %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jquery/jquery.modaldialog.js") %>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <style type="text/css">
        .entry { font-family:tahoma;font-size:11px;width:100%; }
        .entrycell {  }
        .entrytitlecell { height:23;width:100; }
    </style>

    <script type="text/javascript">

    function Record_CancelAndClose()
    {
        // postback to cancel and close
        <%= ClientScript.GetPostBackEventReference(lnkCancelAndClose, Nothing) %>;
    }
	function Record_DeleteConfirm()
	{
        window.dialogArguments = window;
        var url = '<%= ResolveUrl("~/util/pop/confirm.aspx")%>?f=Record_Delete&t=Delete Visit&m=Are you sure you want to delete this visit?';
        currentModalDialog = $('<div/>').appendTo("body").modaldialog({url: url,
                           title: "Delete Visit",
                           dialogArguments: window,
                           resizable: false,
                           scrollable: false,
                           height: 300, width: 400, scrollable: false});
	}
    function Record_Delete()
    {
        // postback to delete
        <%= ClientScript.GetPostBackEventReference(lnkDelete, Nothing) %>;
    }
    function Record_ExecuteVisit()
    {
        // postback to execute search
        <%= ClientScript.GetPostBackEventReference(lnkExecuteVisit, Nothing) %>;
    }

    </script>

    <table style="font-family:tahoma;font-size:11px;width:100%;height:100%;" border="0" cellpadding="0" cellspacing="15">
        <tr><td style="color: #666666;"><a runat="server" class="lnk" style="color: #666666;" href="~/admin/users">Users</a>&nbsp;>&nbsp;<a id="lnkUser" runat="server" style="color: #666666;" class="lnk"></a>&nbsp;>&nbsp;<a runat="server" id="lnkUserHistory" class="lnk" style="color: #666666;">History</a></td></tr>
        <tr>
            <td style="height:100%;" valign="top">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top">
                            <table style="margin:0 20 20 0;font-family:tahoma;font-size:11px;width:300;" border="0" cellpadding="0" cellspacing="5">
                                <tr>
                                    <td style="padding:5 5 5 5;background-color:#f1f1f1;" colspan="2">General Information</td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Visited:</td>
                                    <td><asp:Label cssclass="entry" runat="server" id="lblVisit"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Type:</td>
                                    <td><asp:Label cssclass="entry" runat="server" id="lblType"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td class="entrytitlecell">Entity:</td>
                                    <td><asp:Label cssclass="entry" runat="server" id="lblDisplay"></asp:Label></td>
                                </tr>
                            </table>
                        </td>
                   </tr>
                </table>
            </td>
        </tr>
    </table>

    <!-- The following linkbutton controls are only on the page so that the client script (above)
            can call a postback event handled by one of these controls.  They have not inner value
            so they will not be visibly displayed on the page -->

    <asp:LinkButton runat="server" ID="lnkCancelAndClose"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkDelete"></asp:LinkButton>
    <asp:LinkButton runat="server" ID="lnkExecuteVisit"></asp:LinkButton>

</body>

</asp:PlaceHolder></asp:Content>