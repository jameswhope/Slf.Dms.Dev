<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ClientInfoControl.ascx.vb" Inherits="negotiation_webparts_ClientInfoControl" %>
<style type="text/css">
    .cellLeft
    {
        text-align: left;
    }
    .cellRight
    {
        text-align: right;
    }
    .client
    {
        border-collapse: collapse;
        width: 100%;
    }
    .client td
    {
        line-height: 17px;
    }
    .client td input, td img
    {
        padding-right: 3px;
    }
    .client tr.detail
    {
        /*background-color: #c9c9c9;*/
        vertical-align: top;
    }
    .expand
    {
        cursor: pointer;
        border: none;
    }
</style>

<script language="javascript" type="text/javascript">
    function SwapImage(obj) {
        var src;

        if (obj.children.length > 0) {
            src = obj.children(0).src;
            obj = obj.children(0);
        }
        else {
            if (obj.src != null) {
                src = obj.src;
            }
            else {
                return;
            }
        }

        if (src.indexOf('_off') == -1) {
            obj.src = src.replace('_over', '_off');
        }
        else {
            obj.src = src.replace('_off', '_over');
        }
    }

    function ShowHide(img, id) {
        var tr = document.getElementById(id);

        if (tr.style.display == 'none') {
            tr.style.display = ''; // show
            img.src = '../images/minus.png';
        }
        else {
            tr.style.display = 'none'; // hide
            img.src = '../images/plus.png';
        }
    }

    function OpenDocument(path) {
        window.open(path);
    }

    function SelectDocument(obj, path) {
        var hdnCurrentDoc = document.getElementById('<%=hdnCurrentDoc.ClientID %>');

        if (obj.checked) {
            hdnCurrentDoc.value += path + '|';
        }
        else {
            hdnCurrentDoc.value = hdnCurrentDoc.value.replace(path + '|', '');
        }
    }

    function LoadDocuments() {
        var accordion = document.getElementById('<%=accDocuments.ClientID %>');

        if (accordion != null) {
            accordion.style.height = '275px';

            var panes = accordion.getElementsByTagName('div');

            if (panes != null) {
                for (i = 0; i < panes.length; i++) {
                    if (panes[i].className == 'documentContent') {
                        panes[i].style.height = 'auto';
                    }
                }
            }
        }
    }
</script>

<style type="text/css">
    .documentContent
    {
        margin-top: 5px;
    }
    .documentHeader
    {
        border-bottom: 1px solid #BEDCE6;
        cursor: hand;
        font-weight: normal;
        margin-top: 5px;
    }
    .documentHeaderSelected
    {
        border-bottom: 1px solid #006699;
        cursor: hand;
        font-weight: bold;
        margin-top: 5px;
    }
    .style1
    {
        width: 170px;
    }
</style>
<ajaxToolkit:TabContainer ID="tcClientInformation" CssClass="tabContainer" Height="305px"
    ActiveTabIndex="0" ScrollBars="auto" runat="server">
    <ajaxToolkit:TabPanel ID="tpClientInfo" runat="server" HeaderText="Client Info">
        <ContentTemplate>
            <asp:UpdatePanel ID="upClientInfo" UpdateMode="Conditional" runat="server">
                <ContentTemplate>
                    <table class="client">
                        <tr style="font-weight: bold; background-color: #E0EEF7;">
                            <td>
                            </td>
                            <td align="left" colspan="3">
                                <asp:Label ID="lblSettAtty" runat="server" Text="" Font-Size="small"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <img alt="" id="img1" class="expand" onclick="ShowHide(this,'trClientDetail')" src="../images/minus.png" />
                            </td>
                            <td align="left" class="style1">
                                <asp:Label ID="lblHeader" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Client:"></asp:Label>
                                <asp:Label ID="FirstNameLabel" runat="server" Text=""></asp:Label>
                                <asp:Label ID="LastNameLabel" runat="server" Text=""></asp:Label>
                            </td>
                            <td align="right" nowrap="nowrap" style="width: 50px">
                                <asp:Label ID="Label7" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Acct #:" />
                            </td>
                            <td nowrap="nowrap" align="left">
                                <asp:Label ID="lblClientAcctNum" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr id="trClientDetail" class="detail" style="display: block;">
                            <td>
                                &nbsp;
                            </td>
                            <td align="left" class="style1">
                                <asp:Label ID="Label6" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Street:" />
                                <asp:Label ID="lblClientStreet" runat="server" Text="" /><br />
                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="tahoma" Text="City:" />
                                <asp:Label ID="lblClientCity" runat="server" Text="" /><br />
                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Font-Names="tahoma" Text="State: " />
                                <asp:Label ID="stateabbreviationLabel" runat="server" Text="" />
                                <asp:Label ID="Label9" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Zip: " />
                                <asp:Label ID="lblZipCode" runat="server" Text="" />
                            </td>
                            <td align="right" nowrap="nowrap" style="width: 50px">
                                <asp:Label ID="Label11" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Status:" /><br />
                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Names="tahoma" Text="SSN:" /><br />
                                <asp:Label ID="Label10" runat="server" Font-Bold="True" Font-Names="tahoma" Text="DOB:" /><br />
                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Age:" /><br />
                                &nbsp;
                            </td>
                            <td align="left" nowrap="nowrap">
                                <asp:Label ID="lblClientStatus" runat="server" Text=""></asp:Label><br />
                                <asp:Label ID="SSNLabel" runat="server" Text=""></asp:Label>                        
                                &nbsp;<asp:Image id="ImgDialSSN" runat="server" ImageUrl="~/images/p_dialpad.png" style="cursor: hand;" ToolTip="Dial SSN"  /><br />
                                <asp:Label ID="lblDOB" runat="server" Text=""></asp:Label><br />
                                <asp:Label ID="lblClientAge" runat="server" Text=""></asp:Label><br />
                                &nbsp;
                            </td>
                        </tr>
                        <tr id="coAppRow1" class="clientHdrRow" runat="server">
                            <td>
                                <img alt="" id="img2" class="expand" onclick="ShowHide(this,'coAppRow2')" src="../images/plus.png" />
                            </td>
                            <td align="left" nowrap="nowrap" class="style1">
                                <asp:Label ID="lblCoAppHdr" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Co-Applicant:"></asp:Label>
                                <asp:Label ID="lblCoAppFirst" runat="server" Text=""></asp:Label>
                                <asp:Label ID="lblCoAppLast" runat="server" Text=""></asp:Label>
                            </td>
                            <td align="right" nowrap="nowrap" style="width: 50px">
                            </td>
                            <td nowrap="nowrap" align="left">
                            </td>
                        </tr>
                        <tr id="coAppRow2" class="detail clientHdrContent" style="display: none">
                            <td>
                                &nbsp;
                            </td>
                            <td class="style1">
                                <asp:Label ID="Label16" runat="server" Font-Bold="True" Font-Names="tahoma" 
                                    Text="Street:" />
                                <asp:Label ID="lblCoappClientStreet" runat="server" Text="" /><br />
                                <asp:Label ID="Label17" runat="server" Font-Bold="True" Font-Names="tahoma" 
                                    Text="City:" />
                                <asp:Label ID="lblCoappClientCity" runat="server" Text="" /><br />
                                <asp:Label ID="Label18" runat="server" Font-Bold="True" Font-Names="tahoma" 
                                    Text="State: " />
                                <asp:Label ID="CoappstateabbreviationLabel" runat="server" Text="" />
                                <asp:Label ID="Label19" runat="server" Font-Bold="True" Font-Names="tahoma" 
                                    Text="Zip: " />
                                <asp:Label ID="lblCoappZipCode" runat="server" Text="" />
                            </td>
                            <td align="right" nowrap="nowrap" style="width: 50px">
                                <asp:Label ID="Label8" runat="server" Font-Bold="True" Font-Names="tahoma" Text="SSN:"></asp:Label><br />
                                <asp:Label ID="Label15" runat="server" Font-Bold="True" Font-Names="tahoma" 
                                    Text="DOB:" />
                                <br />
                                <asp:Label ID="Label12" runat="server" Font-Bold="True" Font-Names="tahoma" Text="Age:"></asp:Label><br />
                            </td>
                            <td align="left" nowrap="nowrap">
                                <asp:Label ID="lblCoAppSSN" runat="server" Text=""></asp:Label><br />
                                <asp:Label ID="lblCoappDOB" runat="server"></asp:Label>
                                <br />
                                <asp:Label ID="lblCoAppAge" runat="server" Text=""></asp:Label><br />
                            </td>
                        </tr>
                        <tr style="height: 75px; vertical-align: bottom;">
                            <td colspan="4">
                                <asp:Panel ID="pnlHardShip" runat="server" Style="padding: 3px;" Width="95%" Height="50px"
                                    BackColor="#E3E3F0">
                                    <asp:Label ID="Label5" runat="server" Text="Hardships:" />
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr style="display: none;">
                            <td>
                            </td>
                            <td colspan="3">
                                <asp:ImageButton onmouseout="SwapImage(this);" onmouseover="SwapImage(this);" ID="ibtnEditCoApp"
                                    Style="float: right;" CommandName="Edit" runat="server" ImageUrl="~/negotiation/images/edit_off.png" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="tpAccountSummary" runat="server" HeaderText="Account Summary">
        <ContentTemplate>
            <asp:UpdatePanel ID="updAccountSummary" UpdateMode="Conditional" runat="server">
                <ContentTemplate>
                    <asp:GridView DataKeyNames="AccountStatusCode" Width="100%" ID="gvSummary" runat="server"
                        AutoGenerateColumns="False" AllowSorting="true" GridLines="None">
                        <RowStyle CssClass="GridRowStyle" />
                        <AlternatingRowStyle CssClass="GridAlternatingRowStyle" />
                        <PagerStyle CssClass="GridPagerStyle" />
                        <HeaderStyle CssClass="webpartgridhdrstyle" />
                        <EmptyDataTemplate>
                            <div>
                                No records to display.</div>
                        </EmptyDataTemplate>
                        <Columns>
                            <asp:BoundField DataField="CurrentCreditorName" HeaderText="Name" SortExpression="CurrentCreditorName">
                                <HeaderStyle HorizontalAlign="left" />
                                <ItemStyle HorizontalAlign="left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CurrentAccountNumber" HeaderText="Acct #" SortExpression="CurrentAccountNumber">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AccountStatusCode" HeaderText="Status" SortExpression="AccountStatusCode">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CurrentAmount" HtmlEncode="false" DataFormatString="{0:c}"
                                HeaderText="Amt" SortExpression="CurrentAmount">
                                <HeaderStyle HorizontalAlign="right" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                    <div style="padding:3px">
                    <table class="entry2" style="border: 1px solid black;" cellpadding="0" cellspacing="0">
                        <tr style="padding: 3px;">
                            <td style="background-color: #C8F5C8; width: 15px">
                                &nbsp;
                            </td>
                            <td>
                                Settled
                            </td>
                            <td style="background-color: #CEECF5; width: 15px">
                                &nbsp;
                            </td>
                            <td style="white-space:nowrap">
                                P.A.
                           </td>
                            <td style="background-color: #F5C8C8; width: 15px">
                                &nbsp;
                            </td>
                            <td>
                                Removed
                            </td>
                            <td style="background-color: #F5F58F; width: 15px">
                                &nbsp;
                            </td>
                            <td>
                                Unverified
                            </td>
                        </tr>
                    </table>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="tpDocuments" runat="server" HeaderText="Documents" OnClientClick="LoadDocuments">
        <ContentTemplate>
            <asp:UpdatePanel ID="updDocuments" UpdateMode="Conditional" runat="server">
                <ContentTemplate>
                    <asp:Panel ID="pnlDocuments" runat="server">
                        <table style="height: 300px; vertical-align: top; width: 100%;" border="0" cellpadding="0"
                            cellspacing="0">
                            <tr id="trDelete" style="height: 25px;" runat="server">
                                <td>
                                    <asp:LinkButton ID="lnkDeleteDocument" runat="server"><img src="<%=ResolveUrl("~/negotiation/images/delete_off.png") %>" style="border:none;cursor:hand;float:right;" onmouseout="this.src='<%=ResolveUrl("~/negotiation/images/delete_off.png") %>';" onmouseover="this.src='<%=ResolveUrl("~/negotiation/images/delete_on.png") %>';" alt="Delete" /></asp:LinkButton>
                                </td>
                            </tr>
                            <tr style="width: 100%;">
                                <td style="height: 275px; vertical-align: top; width: 100%;">
                                    <ajaxToolkit:Accordion ID="accDocuments" ContentCssClass="documentContent" Height="275px"
                                        HeaderCssClass="documentHeader" HeaderSelectedCssClass="documentHeaderSelected"
                                        RequireOpenedPane="false" TransitionDuration="50" Width="100%" runat="server" AutoSize="Limit" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlNoDocuments" runat="server">
                        <div style="text-align: center; color: #A1A1A1; padding: 5px 5px 5px 5px;">
                            No Directory</div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
</ajaxToolkit:TabContainer>
<asp:HiddenField ID="hiddenIDs" runat="server" EnableViewState="true" />
<asp:HiddenField ID="hdnCurrentDoc" runat="server" />
