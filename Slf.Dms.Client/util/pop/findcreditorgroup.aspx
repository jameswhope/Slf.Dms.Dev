<%@ Page Language="VB" AutoEventWireup="false" CodeFile="findcreditorgroup.aspx.vb"
    Inherits="util_pop_findcreditorgroup" EnableEventValidation="false" %>

<%@ Register Assembly="Infragistics2.WebUI.Misc.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.Misc" TagPrefix="igmisc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Find Creditor</title>
    <link runat="server" href="~/css/default.css" type="text/css" rel="stylesheet" />

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
        }
        td.headItem3
        {
            background-color: #f0f0f0;
            border-bottom: solid 2px #d3d3d3;
        }
    </style>

    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script type="text/javascript" language="javascript">
        
        if (window.parent.currentModalDialog) {
            window.close = function() { window.parent.currentModalDialog.modaldialog("close"); };
        } 
        
        function selectCreditor(creditorgroupid, creditorid, name, street, street2, city, stateid, zipcode, validated)
        {
            var win = window.parent.dialogArguments[0];
            var btn = window.parent.dialogArguments[1];
            var fun = window.parent.dialogArguments[2];

            // if these fields are needed for display purposes, pass them in
            var statename = ''; 
            var stateabbreviation = '';

            eval("win." + fun + "(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)");

            window.close();
        }
        
        function addCreditorGroup() 
        {
            // adds a new creditor group and creditor (address)
            var txtCreditor = document.getElementById("<%= txtCreditor.ClientID() %>");
            addCreditor(-1, -1, txtCreditor.value, 1);
        }

        function addCreditor(creditorgroupid, creditorid, name, type)
        {
            var txtCreditor = document.getElementById("<%= txtCreditor.ClientID() %>");
            var txtStreet = document.getElementById("<%= txtStreet.ClientID() %>");
            var txtStreet2 = document.getElementById("<%= txtStreet2.ClientID() %>");
            var txtCity = document.getElementById("<%= txtCity.ClientID() %>");
            var txtZipCode = document.getElementById("<%= txtZipCode.ClientID() %>");
            var cboStateID = document.getElementById("<%= cboStateID.ClientID() %>");
            var isValid = true;
            var validated = 0;
            var r;
            
            if (name.length == 0) {
                AddBorder(txtCreditor); isValid = false; }
            else
                RemoveBorder(txtCreditor);
                
            if (txtStreet.value.length == 0) {
                AddBorder(txtStreet); isValid = false; }
            else
                RemoveBorder(txtStreet);
                
            if (txtCity.value.length == 0) {
                AddBorder(txtCity); isValid = false; }
            else
                RemoveBorder(txtCity);       
                
            if (txtZipCode.value.length == 0) {
                AddBorder(txtZipCode); isValid = false; }
            else
                RemoveBorder(txtZipCode);     
            
            if (cboStateID.selectedIndex == 0) {
                AddBorder(cboStateID); isValid = false; }
            else
                RemoveBorder(cboStateID);
                
            if (isValid)
            {
                if (type == 1)
                    r = confirm('Note: This actions requires manager approval. Please double-check the existing creditor list for a \nmatch before submitting a new creditor. Click OK to submit a new creditor.');
                else
                    r = confirm('Note: This actions requires manager approval. Please double-check the existing creditor list for a \nmatch before submitting a new creditor address. Click OK to submit a new creditor address.');
                
                if (r)
                {
                    var win = window.parent.dialogArguments[0];
                    var btn = window.parent.dialogArguments[1];
                    var fun = window.parent.dialogArguments[2];

                    var street = txtStreet.value;
                    var street2 = txtStreet2.value;
                    var city = txtCity.value;
                    var stateid = cboStateID.options[cboStateID.selectedIndex].value;
                    var statename; 
                    var stateabbreviation = cboStateID[cboStateID.selectedIndex].innerHTML;
                    var zipcode = txtZipCode.value;

                    eval("win." + fun + "(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated)");

                    window.close(); 
                }
            }
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
                        Type in as much information as you know about the creditor in the boxes below. Then
                        select one of the matches that is returned. Select a <span style="background-color: #D2FFD2">
                            validated</span> creditor whenever possible. <b>Tip:</b> Save time by hitting the enter key instead of clicking on "find".
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
                                        <td class="headItem">
                                            Creditor&nbsp;
                                            <asp:LinkButton ID="lnkClear" runat="server"><img runat="server" src="~/images/16x16_clear.png" style="vertical-align:middle" border="0" title="Clear Address & Find Creditors"></asp:LinkButton>
                                        </td>
                                        <td class="headItem" style="width: 142px;">
                                            Street
                                        </td>
                                        <td class="headItem" style="width: 117px;">
                                            City
                                        </td>
                                        <td class="headItem" style="width: 60px;">
                                            State
                                        </td>
                                        <td class="headItem" style="width: 71px;">
                                            Zip Code
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="headItem3">
                                            <asp:TextBox CssClass="entry2" runat="server" ID="txtCreditor" Width="150px" AutoPostBack="false" TabIndex="1"></asp:TextBox>
                                        </td>
                                        <td valign="top" class="headItem3">
                                            <asp:TextBox CssClass="entry2" runat="server" ID="txtStreet" Width="140px" AutoPostBack="false" TabIndex="2"></asp:TextBox><br />
                                            <asp:TextBox CssClass="entry2" runat="server" ID="txtStreet2" Width="140px" AutoPostBack="false" TabIndex="3"></asp:TextBox>
                                        </td>
                                        <td valign="top" class="headItem3">
                                            <asp:TextBox CssClass="entry2" runat="server" ID="txtCity" Width="115px" AutoPostBack="false" TabIndex="4"></asp:TextBox>
                                        </td>
                                        <td valign="top" class="headItem3">
                                            <asp:DropDownList CssClass="entry2" runat="server" ID="cboStateID" Width="60px" AutoPostBack="false" TabIndex="5">
                                            </asp:DropDownList>
                                        </td>
                                        <td valign="top" class="headItem3">
                                            <asp:TextBox CssClass="entry2" runat="server" ID="txtZipCode" Width="55px" TabIndex="6"></asp:TextBox>
                                            <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/images/16x16_find.png" ToolTip="Find creditors" TabIndex="7" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div style="height: 310px; overflow: auto">
                                <ajaxToolkit:Accordion ID="Accordion1" runat="server" SuppressHeaderPostbacks="true"
                                    FadeTransitions="false" TransitionDuration="10" FramesPerSecond="80" RequireOpenedPane="false">
                                    <HeaderTemplate>
                                        <div class="credgroups">
                                            <asp:LinkButton ID="lnkCreditorGroup" runat="server" Text="<%# Bind('CreditorGroup') %>"></asp:LinkButton>
                                            (<asp:LinkButton ID="lnkCreditorCount" runat="server" Text='<%# Bind("NoCreditors") %>'></asp:LinkButton>)
                                        </div>
                                    </HeaderTemplate>
                                    <ContentTemplate>
                                        <asp:GridView ID="gvCreditors" runat="server" DataKeyNames="CreditorID" AutoGenerateColumns="false"
                                            DataSource='<%# Container.DataItem.CreateChildView("Relation1") %>' CellPadding="5"
                                            Width="100%" GridLines="None" ShowHeader="False" BorderStyle="None" Visible="true"
                                            OnRowDataBound="gvCreditors_RowDataBound">
                                            <Columns>
                                                <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                                    <ItemTemplate>
                                                        <img runat="server" src="~/images/16x16_dataentry.png" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="validated" Visible="false" />
                                                <asp:BoundField DataField="street" ItemStyle-CssClass="creditor-item" />
                                                <asp:BoundField DataField="street2" ItemStyle-CssClass="creditor-item" />
                                                <asp:BoundField DataField="city" ItemStyle-CssClass="creditor-item" />
                                                <asp:BoundField DataField="state" ItemStyle-CssClass="creditor-item" />
                                                <asp:BoundField DataField="zipcode" ItemStyle-CssClass="creditor-item" />
                                            </Columns>
                                        </asp:GridView>
                                    </ContentTemplate>
                                </ajaxToolkit:Accordion>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 6px 0 6px 0;">
                        <div style="float: left;">
                            <asp:Label ID="lblNoCreditors" runat="server"></asp:Label>
                        </div>
                        <div style="float: right;">
                            <a id="lnkAddCreditorGroup" runat="server" style="color: black" class="lnk"
                                href="javascript:addCreditorGroup();" visible="false">+ New Creditor</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="border-top: solid 2px rgb(149,180,234); padding: 6px 0 6px 0;">
                        <div style="float: left;">
                            <a style="color: black" class="lnk" href="javascript:window.close();">
                                <img style="margin-right: 6px;" runat="server" src="~/images/16x16_close.png" border="0"
                                    align="absMiddle" />Cancel and Close</a>
                        </div>
                        <div style="float: right;">
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upCreditorGroup"
                                DisplayAfter="0">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                    Finding creditors..
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
</body>
</html>
