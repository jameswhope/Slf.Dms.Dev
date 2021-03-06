<%@ Page Language="VB" AutoEventWireup="false" CodeFile="findduplicatephone.aspx.vb" Inherits="util_pop_findduplicatephone" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Find Duplicate Leads</title>
    <link id="Link1" runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>

    <style type="text/css">
        .credgroups
        {
            padding: 5px;
            border-bottom: solid 1px #d3d3d3;
            cursor: pointer;
            background-color: #f1f1f1;
        }
        .credgroups a
        {
            color: Black;
            text-decoration: none;
        }
        .credgroups a:hover
        {
            color: Black;
            text-decoration: none;
        }
        .creditor-item
        {
            border-bottom: dotted 1px #d3d3d3;
            white-space: nowrap;
            width: 78px;
        }
        td.headItem3
        {
            background-color: #f0f0f0;
            border-bottom: solid 2px #d3d3d3;
        }
    </style>
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript">

        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        } 
        
        function redirectToLead(leadapplicantid) {
            var url = "http://" + window.location.host + "/clients/enrollment/newenrollment2.aspx?id=" + leadapplicantid
            if (window.parent.currentModalDialog) {
                window.parent.currentModalDialog.modaldialog("returnValue", url);
            } else {
                window.returnValue = url;
            }
            window.close();
        }
    </script>

</head>
<body style="background-image: url(<%= ResolveUrl("~/images/back.bmp") %>); background-position: left top;
    background-repeat: repeat-x;">
    <form id="form1" runat="server">
    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="180">
        <Scripts>
            <asp:ScriptReference Path="~/jscript/focus.js" />
        </Scripts>
    </ajaxToolkit:ToolkitScriptManager>
    <asp:UpdatePanel ID="upCreditorGroup" runat="server">
        <ContentTemplate>
            <table border="0" cellpadding="0" cellspacing="0" class="entry2">
                <tr>
                    <td>
                        This window popped up because the phone number you just entered matches a phone number already in the system.
                        <span style="background-color: #D2FFD2">To continue</span> select <b>one of the leads</b> displayed below or <b>close this box</b> and continue entering data as normal.
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="border: solid 1px #d3d3d3;">
                            <div>
                                <table style="width: 100%;" cellspacing="0" cellpadding="4" border="0">
                                    <tr>
                                        <td class="headItem" style="width: 78px;">
                                            First Name
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Last Name
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Lead Phone
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Home Phone
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Cell Phone 
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Business Phone
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Agent
                                        </td>
                                        <td class="headItem" style="width: 78px;">
                                            Last Modified
                                        </td>
                                    </tr>                                  
                                </table>
                            </div>
                            <div style="height: 310px; overflow: auto">
                                <asp:GridView ID="gvDuplicateLeads" runat="server" DataKeyNames="LeadApplicantId" AutoGenerateColumns="false"
                                    CellPadding="5" Width="100%" GridLines="None" ShowHeader="False" BorderStyle="None"
                                    Visible="true" OnRowDataBound="gvDuplicateLeads_RowDataBound">
                                    <Columns>
<%--                                        <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                            <ItemTemplate>
                                                <img id="Img2" runat="server" src="~/images/16x16_dataentry.png" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="validated" Visible="false" />--%>
                                        <asp:BoundField DataField="FirstName" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="LastName" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="LeadPhone" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="HomePhone" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="CellPhone" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="BusinessPhone" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="Agent" ItemStyle-CssClass="creditor-item" />
                                        <asp:BoundField DataField="LastModified" ItemStyle-CssClass="creditor-item" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="border-top: solid 2px rgb(149,180,234); padding: 6px 0 6px 0;">
                        <div style="float: left;">
                            <a style="color: black" class="lnk" href="javascript:window.close();">
                                <img id="Img3" style="margin-right: 6px;" runat="server" src="~/images/16x16_close.png" border="0"
                                    align="absMiddle" />Cancel and Close</a>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
