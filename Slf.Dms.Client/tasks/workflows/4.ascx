<%@ Control Language="VB" AutoEventWireup="false" CodeFile="4.ascx.vb" Inherits="tasks_workflows_4" %>
<%@ Reference Page="~/tasks/task/resolve.aspx" %>

<table style="font-family:tahoma;font-size:11;" cellpadding="0" cellspacing="15" border="0">
    <tr>
        <td>
            Below is the contact information for&nbsp;<img runat="server" src="~/images/16x16_person.png" 
            style="margin:0 3 0 3;" border="0" align="absmiddle" /><a class="lnk" runat="server" 
            ID="lnkClientName"></a>.
            <br />
            <br />
            <br />
            <br />
            <div style="text-align:center;">
            <table onselectstart="return false;" style="font-size:11px;font-family:tahoma;" cellspacing="0" cellpadding="3" border="0">
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
                            <td style="padding:6 10 0 5;" class="listItem" valign="top">
                                <%#DataBinder.Eval(Container.DataItem, "Relationship")%>
                            </td>
                            <td style="padding:6 10 0 5;" class="listItem" valign="top">
                                <%#DataBinder.Eval(Container.DataItem, "FirstName")%>
                            </td>
                            <td style="padding:6 10 0 5;" class="listItem" valign="top">
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
            </div>
            <br />
            <br />
            <br />
            Call this client and conduct a welcome interview.  Use this welcome 
            interview to completely fill out all required information in the <a class="lnk" runat="server" 
            ID="lnkUnderwritingWorksheet">verification worksheet</a>. If you can only get part of 
            the information, use the Save For Later option on the worksheet and schedule another phone 
            appointment with the client to get the rest.
        </td>
    </tr>
</table>

<asp:DropDownList runat="server" ID="cboTaskResolutionID" style="display:none;"></asp:DropDownList>

<!-- The following linkbutton controls are only on the page so that the client script (above)
        can call a postback event handled by one of these controls.  They have no inner value
        so they will not be visibly displayed on the page -->

<asp:LinkButton runat="server" ID="lnkSave"></asp:LinkButton>