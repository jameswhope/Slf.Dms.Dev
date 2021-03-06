<%@ Page Language="VB" MasterPageFile="~/research/queries/financial/servicefees/servicefees.master"
    AutoEventWireup="false" CodeFile="allmatters.aspx.vb" Inherits="research_queries_financial_servicefees_allmatters"
    Title="DMP - Matter Queries" %>
<%@ Register Assembly="AssistedSolutions.WebControls.InputMask" Namespace="AssistedSolutions.WebControls"
    TagPrefix="cc1" %>
<%@ Register TagPrefix="asi" Namespace="Slf.Dms.Controls" Assembly="Slf.Dms.Controls" %>
<asp:Content ID="cntBody" ContentPlaceHolderID="cphBody" runat="Server">
    <asp:PlaceHolder ID="pnlBody" runat="server">
        <link href="<%= ResolveUrl("~/css/grid.css") %>" type="text/css" rel="stylesheet" />

        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/controls/grid.js") %>"></script>
        <script type="text/javascript" src="<%= ResolveUrl("~/jscript/validation/allow.js") %>"></script>
        <script type="text/javascript">
function printReport()
{
    window.open("<%=ResolveUrl("~/reports/interface/frame.aspx")%>?rpt=" + "query_servicefee_all_payments", "winrptservicefeereport", "width=850,height=600,left=75,top=50,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
    var txtdate1 =  null;
    var txtdate2 =  null;
function validateDate()
{
    txtdate1 =  document.getElementById("<%= txtMatterDate1.ClientID %>");
    txtdate2 =  document.getElementById("<%= txtMatterDate2.ClientID %>");
   if (txtdate1.value.length != 0)
    {  
         if (!RegexValidate(txtdate1.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
        {
            alert("Enter valid from date");
            txtdate1.focus();
            return false;
        }
    }
    if (txtdate2.value.length != 0)
    {
        if (!RegexValidate(txtdate2.value, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$"))
        {
            alert("Enter valid to date");
            txtdate2.focus();
            return false;
        }
    }
}
	function RegexValidate(Value, Pattern)
	{
        //check to see if supposed to validate value
        if (Pattern != null && Pattern.length > 0)
        {
            var re = new RegExp(Pattern);

            return Value.match(re);
        }
        else
        {
            return false;
        }
	}
        </script>

        <style>
            thead th
            {
                position: relative;
                top: expression(this.parentElement.parentElement.parentElement.parentElement.scrollTop);
            }
        </style>
        <body scroll="yes">
            <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%" border="0"
                cellpadding="0" cellspacing="0">
                <tr>
                    <td valign="top" id="tdFilter" runat="server">
                        <div style="padding: 15 15 15 15; overflow: auto; height: 100%; width: 200;">
                            <table style="font-family: tahoma; font-size: 11px; width: 100%" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:RadioButtonList CssClass="entry" CellPadding="0" CellSpacing="0" runat="server"
                                            ID="optClientChoice">
                                            <asp:ListItem Value="0" Text="Only exclude clients" />
                                            <asp:ListItem Value="1" Text="Only include clients" Selected="true" />
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;"
                                            SelectorStyle="font-family:tahoma;font-size:11px;width:100%;" runat="server"
                                            ID="csClientID" SelectedRows="5">
                                        </asi:SmartCriteriaSelector>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButtonList CssClass="entry" CellPadding="0" CellSpacing="0" runat="server"
                                            ID="optAttorneyChoice">
                                            <asp:ListItem Value="0" Text="Only exclude Local Counsel" />
                                            <asp:ListItem Value="1" Text="Only include Local Counsel" Selected="true" />
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;"
                                            SelectorStyle="font-family:tahoma;font-size:11px;width:100%;" runat="server"
                                            ID="csAttorneyID" SelectedRows="5">
                                        </asi:SmartCriteriaSelector>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButtonList CssClass="entry" CellPadding="0" CellSpacing="0" runat="server"
                                            ID="optMatterStatus">
                                            <asp:ListItem Value="0" Text="Only exclude Matter Status" />
                                            <asp:ListItem Value="1" Text="Only include Matter Status" Selected="true" />
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;"
                                            SelectorStyle="font-family:tahoma;font-size:11px;width:100%;" runat="server"
                                            ID="csMatterStatus" SelectedRows="5">
                                        </asi:SmartCriteriaSelector>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButtonList CssClass="entry" CellPadding="0" CellSpacing="0" runat="server"
                                            ID="optLCState">
                                            <asp:ListItem Value="0" Text="Only exclude Local Counsel State" />
                                            <asp:ListItem Value="1" Text="Only include Local Counsel State" Selected="true" />
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;"
                                            SelectorStyle="font-family:tahoma;font-size:11px;width:100%;" runat="server"
                                            ID="csLCState" SelectedRows="5">
                                        </asi:SmartCriteriaSelector>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButtonList CssClass="entry" CellPadding="0" CellSpacing="0" runat="server"
                                            ID="optLCCity">
                                            <asp:ListItem Value="0" Text="Only exclude Local Counsel City" />
                                            <asp:ListItem Value="1" Text="Only include Local Counsel City" Selected="true" />
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asi:SmartCriteriaSelector TableStyle="width:100%;" SelectedStyle="font-family:tahoma;font-size:11px;width:100%;"
                                            SelectorStyle="font-family:tahoma;font-size:11px;width:100%;" runat="server"
                                            ID="csLCCity" SelectedRows="5">
                                        </asi:SmartCriteriaSelector>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-bottom: 10;">
                                        <b>Matter Date Period</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="width: 100%; font-family: tahoma; font-size: 11;" cellpadding="0" border="0"
                                            cellspacing="0">
                                            <tr>
                                                <td nowrap="true" style="width: 15;">
                                                    1:
                                                </td>
                                                <td nowrap="true" style="width: 50%; padding-right: 5;">
                                                    <cc1:InputMask class="entry" runat="server" ID="txtMatterDate1" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                                <td nowrap="true" style="width: 15;">
                                                    2:
                                                </td>
                                                <td nowrap="true" style="width: 50%; padding-right: 5;">
                                                    <cc1:InputMask class="entry" runat="server" ID="txtMatterDate2" Mask="nn/nn/nnnn"></cc1:InputMask>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td valign="top" style="width: 100%; height: 100%; border-left: solid 1px rgb(172,168,153);">
                        <div>
                            <table style="font-family: tahoma; font-size: 11px; width: 100%; height: 100%; table-layout: fixed"
                                border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="background-color: rgb(244,242,232);">
                                        <table style="color: rgb(80,80,80); width: 100%; font-size: 11px; font-family: tahoma;"
                                            border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <img id="Img1" runat="server" src="~/images/grid_top_left.png" border="0" />
                                                </td>
                                                <td style="width: 100%;">
                                                    <table style="height: 25; background-image: url(<%= ResolveUrl("~/images/grid_top_back.bmp") %>);
                                                        background-repeat: repeat-x; background-position: left top; background-color: rgb(232,227,218);
                                                        font-family: tahoma; font-size: 11px; width: 100%;" cellpadding="0" cellspacing="0"
                                                        border="0">
                                                        <tr>
                                                            <td nowrap="true">
                                                                <asp:LinkButton ID="lnkShowFilter" class="gridButtonSel" runat="server"><img id="Img2" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_funnel.png" /></asp:LinkButton>
                                                            </td>
                                                            <td nowrap="true">
                                                                <img id="Img3" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                            </td>
                                                            <td nowrap="true">
                                                                <asp:LinkButton ID="lnkRequery" OnClientClick="javascript: return  validateDate();"
                                                                    runat="server" class="gridButton"><img id="Img4" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_exclamationpoint.png"   />Requery</asp:LinkButton>
                                                            </td>
                                                            <td nowrap="true">
                                                                <img id="Img5" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                            </td>
                                                            <td nowrap="true">
                                                                <asp:LinkButton ID="lnkClear" runat="server" class="gridButton"><img id="Img6" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_clear.png" />Clear Criteria</asp:LinkButton>
                                                            </td>
                                                            <td nowrap="true" style="width: 100%;">
                                                                &nbsp;
                                                            </td>
                                                            <td nowrap="true">
                                                                <img id="Img7" style="margin: 0 3 0 3;" runat="server" src="~/images/grid_top_separator.bmp" />
                                                            </td>
                                                            <td nowrap="true">
                                                                <asp:LinkButton ID="lnkExport" runat="server" class="gridButton">
                                                                    <img id="Img8" runat="server" align="absmiddle" border="0" class="gridButtonImage"
                                                                        src="~/images/icons/xls.png" /></asp:LinkButton>
                                                            </td>
                                                            <td nowrap="true">
                                                                <a id="A1" runat="server" class="gridButton" href="javascript:printReport()">
                                                                    <img id="Img18" runat="server" align="absmiddle" border="0" class="gridButtonImage" src="~/images/16x16_print.png" /></a>
                                                            </td>
                                                            <td nowrap="true" style="width: 10;">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <div class="grid" style="overflow-y: hidden; overflow: auto; width: 100%; height: 700px">
                                           <asp:Panel runat="server" Visible="false"   ID="pnlNoTasks" Style="text-align: center; font-style: italic;
                                            padding: 10 5 5 5;">
                                            No Matters to display</asp:Panel>
                                           <asp:GridView  ID="gvResults" runat="server" AutoGenerateColumns="false"
                                                AllowPaging="True" AllowSorting="True" CssClass="datatable" CellPadding="0" BorderWidth="0px" PageSize="25" 
                                                GridLines="None">
                                                <AlternatingRowStyle BackColor="White" />
                                                <RowStyle BackColor="#f1f1f1" CssClass="row" />
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <HeaderTemplate>
                                                            <img runat="server" src="~/images/16x16_icon.png" border="0" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <img runat="server" src="~/images/matter_16x16.jpg" border="0" />
                                                        </ItemTemplate>
                                                        <ItemStyle />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="MatterNumber" HeaderText="Matter&nbsp;Number" SortExpression="MatterNumber">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="MatterDate" SortExpression="MatterDate" HeaderText="Matter&nbsp;Date"
                                                        DataFormatString="{0:dd MMM, yyyy}">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ClientAccountNumber" HeaderText="Client Acct&nbsp;#" SortExpression="ClientAccountNumber">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ClientPrimaryApplicantName" HeaderText="Primary Client" SortExpression="ClientPrimaryApplicantName">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="AttorneyName" SortExpression="AttorneyName" HeaderText="Attorney">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="State" SortExpression="State" HeaderText="State">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="City" SortExpression="City" HeaderText=" City">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Creditor Account Status" SortExpression="Creditor Account Status"
                                                        HeaderText="Creditor&nbsp;Account&nbsp;Status">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="MatterStatus" SortExpression="MatterStatus" HeaderText=" Matter&nbsp;Status">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="MatterSubStatus" SortExpression="MatterSubStatus"
                                                        HeaderText="Matter&nbsp;Sub&nbsp;Status">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="CompanyName" SortExpression="CompanyName" HeaderText="Firm">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="MatterMemo" SortExpression="MatterMemo" HeaderText="Matter&nbsp;Memo">
                                                        <ItemStyle Font-Names="tahoma" Wrap="false" />
                                                        <HeaderStyle Font-Bold="false" HorizontalAlign="Left" />
                                                    </asp:BoundField>
                                                    
                                                </Columns>
                                                <PagerSettings Visible="true"  />
                                                <PagerStyle CssClass="pagerstyle"  /> 
                                            </asp:GridView>
                                        
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </body>
        <asp:LinkButton runat="server" ID="lnkDelete" Style="display: none;"></asp:LinkButton>
    </asp:PlaceHolder>
</asp:Content>
