<%@ Page Language="VB" AutoEventWireup="false" CodeFile="addressbook.aspx.vb" Inherits="util_pop_addressbook" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DMP - Address Book</title>
    <base target="_self" />
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript">
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <table style="margin-left:7;font-family:tahoma;font-size:11px;width:100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    The following contacts are associated with this client.  Select one of the phone numbers
                    from the contact that is relevant to this operation.<br /><br />
                </td>
            </tr>
            <tr>
                <td style="background-color:#f3f3f3;padding: 5 5 5 5;">
                    <table style="font-family:tahoma;font-size:11px;width:100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="color:rgb(50,112,163);">Contacts</td>
                            <td align="right"><a runat="server" href="javascript:window.print();"><img runat="server" src="~/images/16x16_print.png" border="0" align="absmiddle"/></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" width="100%" border="0">
                        <tr>
                            <td class="headItem" style="width:22;" align="center"><img runat="server" src="~/images/16x16_lock.png" border="0" align="absmiddle"/></td>
                            <td class="headItem">Type</td>
                            <td class="headItem">First Name</td>
                            <td class="headItem">Last Name</td>
                            <td class="headItem" style="width:75;">Contact Type</td>
                            <td class="headItem" style="width:120;">Number</td>
                        </tr>
                        <asp:repeater id="rpApplicants" runat="server">
                            <itemtemplate>
	                            <tr>
	                                <td style="padding-top:6;width:22;" class="listItem" valign="top" align="center">
	                                    <img title="Can Authorize" src="<%= ResolveUrl("~/images/") %><%#DataBinder.Eval(Container.DataItem, "IconCheck")%>" border="0"/>
	                                </td>
	                                <td style="padding-top:6;" class="listItem" valign="top">
	                                    <%#DataBinder.Eval(Container.DataItem, "Relationship")%>
	                                </td>
	                                <td style="padding-top:6;" class="listItem" valign="top">
	                                    <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
	                                </td>
	                                <td style="padding-top:6;" class="listItem" valign="top">
	                                    <%#DataBinder.Eval(Container.DataItem, "LastName")%>
	                                </td>
		                            <td style="padding-top:5;" class="listItem" colspan="2" valign="top">
		                                <asp:label runat="server" id="lblPhones"></asp:label>
		                            </td>
	                            </tr>
                            </itemtemplate>
                        </asp:repeater>
                    </table>
                    <asp:panel runat="server" id="pnlNoApplicants" style="text-align:center;font-style:italic;padding: 10 5 5 5;">This client has no applicants</asp:panel>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>