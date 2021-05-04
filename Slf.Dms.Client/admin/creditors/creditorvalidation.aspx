<%@ Page Title="Creditor Validation" Language="VB" MasterPageFile="~/site.master"
    AutoEventWireup="false" CodeFile="creditorvalidation.aspx.vb" Inherits="admin_creditors_creditorvalidation"
    EnableEventValidation="false" %>

<%@ Register Assembly="obout_Flyout2_NET" Namespace="OboutInc.Flyout2" TagPrefix="cc1" %>
<asp:Content ID="cphMenu" ContentPlaceHolderID="cphMenu" runat="Server">
    <link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%= ResolveUrl("~/jscript/domain.js") %>"></script>
    <script language="javascript" type="text/javascript">
        function FindCreditor() {
            var url = '<%= ResolveUrl("~/util/pop/findcreditorgroup.aspx?&creditor=&street=&street2=&city=&stateid=&zipcode=") %>';
            window.dialogArguments = new Array(window, null, "CreditorFinderReturn");
            currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
            title: "Find Creditor",
                dialogArguments: window,
                resizable: false,
                scrollable: false,
                height: 700, width: 650
            });  
        }
        function CreditorFinderReturn(btn, creditorid, name, street, street2, city, stateid, statename, stateabbreviation, zipcode, creditorgroupid, validated) {
            // do nothing
        }
    </script>
    <table cellpadding="0" cellspacing="0" class="menuTable" onselectstart="return false">
        <tr>
            <td>
                <img width="8" height="28" src="~/images/spacer.gif" runat="server" />
            </td>
            <td nowrap="nowrap">
                <a class="menuButton" href="../">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_admin.png" alt="Admin Home" />Admin Home</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a class="menuButton" href="javascript:ValidateWithChanges();" runat="server">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_check.png" />Validate
                    Creditor</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a class="menuButton" href="javascript:Approve();" runat="server">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage" src="~/images/16x16_thumb_up.png" />Approve
                    Creditor</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a class="menuButton" runat="server" href="validationstats.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_chart_bar.png" />Creditor Stats</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="true">
                <a class="menuButton" runat="server" href="useractivity.aspx">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_person.png" />User Activity</a>
            </td>
            <td class="menuSeparator">
                |
            </td>
            <td nowrap="nowrap">
                <a class="menuButton" href="javascript:FindCreditor();">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_find.png" alt="Creditor Lookup" />Creditor Lookup</a>
            </td>
            <td style="width: 100%;">
                &nbsp;
            </td>
            <td nowrap="nowrap" style="padding-right:15px">
                <a ID="lnkInstructions" runat="server" class="menuButton" href="#">
                    <img runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_note3.png" />Instructions</a>
            </td>
        </tr>
    </table>
    <cc1:Flyout ID="Flyout1" runat="server" AttachTo="lnkInstructions" Align="RIGHT"
        Position="BOTTOM_CENTER">
        <div style="width: 500px; height: 100px; border: solid 1px #70A8D1; background-color: #F0F5FB;
            padding:10px;">
            <table class="iboxTable2" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="iboxHeaderCell">
                        INSTRUCTIONS:
                    </td>
                </tr>
                <tr>
                    <td class="iboxMessageCell">
                        <ol>
                            <li>Select a creditor from the Pending Validations list. A list of potential matches
                                will be displayed.</li>
                            <li>There are several ways to then validate this creditor:
                                <ul>
                                    <li>It's a duplicate. If the creditor information already exists, select the existing
                                        creditor from the list. Select a <span style="background-color: #D2FFD2">validated</span>
                                        creditor whenever possible.</li>
                                    <li>It's a valid new creditor after I make a few corrections. Make corrections as needed,
                                        then click Validate Creditor under Common Tasks.</li>
                                    <li>It's a valid new creditor as is. Click Validate Creditor under Common Tasks or select
                                        it from the list.</li>
                                </ul>
                            </li>
                        </ol>
                    </td>
                </tr>
            </table>
        </div>
    </cc1:Flyout>
</asp:Content>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:Panel runat="server" ID="pnlMain" Style="width: 100%; height: 100%; padding: 15px;">
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
                font-family: Tahoma;
                font-size: 11px;
            }
            .headItem
            {
                font-family: Tahoma;
                font-size: 11px;
                font-weight: normal;
                text-align: left;
            }
            td.headItem3
            {
                background-color: #c1c1c1;
                border-bottom: solid 2px #d3d3d3;
            }
        </style>

        <script language="javascript" type="text/javascript">
            function ChooseCreditor(existingGroupID,existingCreditorID) {     
                var pendingCreditorID = document.getElementById('<%=hdnPendingCreditorID.ClientID %>').value;
                var pendingCreditorGroupID = document.getElementById('<%=hdnPendingCreditorGroupID.ClientID %>').value;

                if (pendingCreditorID > 0 && existingCreditorID > 0) {
                    var url = '<%= ResolveUrl("~/util/pop/choosecreditor.aspx") %>?existingCreditorID='+existingCreditorID+"&existingGroupID="+existingGroupID+"&pendingCreditorID="+pendingCreditorID+"&pendingGroupID="+pendingCreditorGroupID+'&rand='+Math.floor(Math.random()*99999);
                    window.dialogArguments = new Array(window, null, "CreditorFinderReturn");
                    currentModalDialog = $('<div/>').appendTo("body").modaldialog({ url: url,
                    title: "Find Creditor",
                        dialogArguments: window,
                        resizable: false,
                        scrollable: true,
                        height: 450, width: 900,
                        onClose: function(){
                            document.getElementById("<%=btnRefresh.ClientID() %>").click();
                        }
                    });  
                }
                else {
                    alert('No pending validation selected.');
                }
            }
            
            function ValidateWithChanges() {
                if (document.getElementById('<%=hdnPendingCreditorID.ClientID %>').value > 0) {
                    if (isValid()) {
                        if (confirm("Click OK to validate this creditor. Please double-check the list for a possible match.")) {
                            <%=Page.ClientScript.GetPostBackEventReference(lnkValidateWithChanges, Nothing) %>;
                        }
                    }
                }
                else {
                    alert('No pending validation selected.');
                }
            }
            
            function Approve() {
                if (document.getElementById('<%=hdnPendingCreditorID.ClientID %>').value > 0) {
                    if (isValid()) {
                        if (confirm("Click OK to approve this creditor. Please double-check the list for a possible match.")) {
                            <%=Page.ClientScript.GetPostBackEventReference(lnkApprove, Nothing) %>;
                        }
                    }
                }
                else {
                    alert('No pending validation selected.');
                }
            }
            
            function isValid() {
                var txtStreet = document.getElementById("<%= txtStreet.ClientID() %>");
                var txtStreet2 = document.getElementById("<%= txtStreet2.ClientID() %>");
                var txtCity = document.getElementById("<%= txtCity.ClientID() %>");
                var txtZipCode = document.getElementById("<%= txtZipCode.ClientID() %>");
                var cboStateID = document.getElementById("<%= cboStateID.ClientID() %>");
                var isValid = true;
                    
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
                    
                return isValid;
            }
        </script>

        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/display.js") %>"></script>

        <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <table style="font-family: tahoma; font-size: 11px; width: 100%;" border="0" cellpadding="0"
                    cellspacing="0">
                    <tr>
                        <td style="padding-bottom: 7px;">
                            <div style="border: solid 1px #d3d3d3;">
                                <div>
                                    <table style="width: 100%;" cellspacing="0" cellpadding="5" border="0">
                                        <tr>
                                            <td class="headItem">
                                                Creditor&nbsp;
                                                <asp:LinkButton ID="lnkClear" runat="server"><img id="Img1" runat="server" src="~/images/16x16_clear.png" style="vertical-align:middle" border="0" title="Clear"></asp:LinkButton>
                                            </td>
                                            <td class="headItem">
                                                Street
                                            </td>
                                            <td class="headItem">
                                                City
                                            </td>
                                            <td class="headItem">
                                                State
                                            </td>
                                            <td class="headItem">
                                                Zip Code
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="headItem3">
                                                <asp:DropDownList CssClass="entry" runat="server" ID="ddlCreditorGroup" AutoPostBack="true">
                                                </asp:DropDownList>
                                                <div style="margin:1 0">
                                                <asp:TextBox CssClass="entry" runat="server" ID="txtCreditorGroup"></asp:TextBox>
                                                </div>
                                            </td>
                                            <td valign="top" class="headItem3">
                                                <asp:TextBox CssClass="entry" runat="server" ID="txtStreet"></asp:TextBox><br />
                                                <asp:TextBox CssClass="entry" runat="server" ID="txtStreet2"></asp:TextBox>
                                            </td>
                                            <td valign="top" class="headItem3">
                                                <asp:TextBox CssClass="entry" runat="server" ID="txtCity"></asp:TextBox>
                                            </td>
                                            <td valign="top" class="headItem3">
                                                <asp:DropDownList CssClass="entry" runat="server" ID="cboStateID">
                                                </asp:DropDownList>
                                            </td>
                                            <td valign="top" class="headItem3">
                                                <asp:TextBox CssClass="entry2" runat="server" ID="txtZipCode"></asp:TextBox>
                                                <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/images/16x16_find.png" ToolTip="Find creditors" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div style="height: 250px; overflow: auto">
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
                                                    <asp:BoundField DataField="created" ItemStyle-CssClass="creditor-item" />
                                                    <asp:BoundField DataField="createdby" ItemStyle-CssClass="creditor-item" />
                                                    <asp:BoundField DataField="dept" ItemStyle-CssClass="creditor-item" />
                                                </Columns>
                                            </asp:GridView>
                                        </ContentTemplate>
                                    </ajaxToolkit:Accordion>
                                </div>
                            </div>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                DisplayAfter="0">
                                <ProgressTemplate>
                                    <img src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                    <font class="entry2">Loading...</font>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-bottom: 7px;">
                            <hr />
                            <asp:Label ID="lblPending" runat="server">Pending Validations</asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="gvPending" runat="server" DataKeyNames="CreditorGroupID,CreditorID"
                                AutoGenerateColumns="false" CellPadding="5" Width="100%" GridLines="None" ShowHeader="True"
                                BorderStyle="None" Visible="true" OnRowDataBound="gvPending_RowDataBound">
                                <Columns>
                                    <asp:TemplateField ItemStyle-CssClass="creditor-item" ItemStyle-Width="16px">
                                        <HeaderTemplate>
                                            <img runat="server" src="~/images/16x16_icon.png" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <img runat="server" src="~/images/16x16_dataentry.png" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="creditor-item" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="ID" DataField="CreditorID" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Creditor" DataField="name" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Street" DataField="street" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Street 2" DataField="street2" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="City" DataField="city" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="State" DataField="abbreviation" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Zipcode" DataField="zipcode" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Added" DataField="created" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Added By" DataField="createdby" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:BoundField HeaderText="Dept" DataField="dept" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:TemplateField>
                                        <HeaderStyle CssClass="headItem" HorizontalAlign="Left" />
                                        <ItemStyle CssClass="creditor-item" />
                                        <HeaderTemplate>
                                            Accounts
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#GetAccounts(Eval("CreditorID"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>                                       
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <asp:HiddenField ID="hdnPendingCreditorID" runat="server" Value="-1" />
                <asp:HiddenField ID="hdnPendingCreditorGroupID" runat="server" />
                <asp:HiddenField ID="hdnExistingCreditorID" runat="server" />
                <asp:HiddenField ID="hdnExistingCreditorGroupID" runat="server" />
                <asp:LinkButton ID="lnkValidateCreditor" runat="server"></asp:LinkButton>
                <asp:LinkButton ID="lnkValidateWithChanges" runat="server"></asp:LinkButton>
                <asp:LinkButton ID="lnkApprove" runat="server"></asp:LinkButton>
                <asp:LinkButton ID="btnRefresh" runat="server"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
</asp:Content>
