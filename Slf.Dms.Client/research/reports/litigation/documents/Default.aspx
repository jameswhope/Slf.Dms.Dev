<%@ Page Title="" Language="VB" MasterPageFile="~/research/research.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="research_reports_litigation_documents_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphBody" runat="Server">
    <style type="text/css">
        .creditor-item
        {
            border-bottom: solid 1px #d3d3d3;
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
        .headItem a
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            color: #000000;
            text-decoration: underline;
        }
        .filter
        {
            background-color: #6CA6CD;
        }
        .filter th, .results
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #fff;
            text-align: left;
        }
        .analysis
        {
            border: solid 3px #d3d3d3;
            padding: 10px;
            background-color: #E8E8E8;
        }
        .analysis th
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-decoration: underline;
            color: #000;
            padding: 5px;
            text-align: left;
        }
        .analysis td
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            color: #000;
            text-align: left;
        }
        .altrow
        {
            background-color: #dcdcdc;
        }
    </style>

    <script language="javascript" type="text/javascript">
        function SetDates(ddl) {
            var txtTransDate1 = document.getElementById("<%=txtTransDate1.ClientId %>");
            var txtTransDate2 = document.getElementById("<%=txtTransDate2.ClientId %>");

            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            }
        }

        function SetDatesGeneric(ddl, txtStart, txtEnd) {
            var txtTransDate1 = document.getElementById(txtStart);
            var txtTransDate2 = document.getElementById(txtEnd);
            var str = ddl.value;
            if (str != "Custom" && str != "-1") {
                var parts = str.split(",");
                txtTransDate1.value = parts[0];
                txtTransDate2.value = parts[1];
            } else {
                txtTransDate1.value = "";
                txtTransDate2.value = "";
            }

        }
        function OpenDocument(path) {
            window.open(path);
        }
    </script>

    <ajaxToolkit:ToolkitScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="updatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td class="filter">
                        <table class="entry" border="0">
                            <tr>
                                <th style="width: 20%;">
                                    Document Type:
                                </th>
                                <th style="width: 15%;">
                                    Firm:
                                </th>
                                <th style="width: 20%;">
                                    Created By:
                                </th>
                                <th>
                                    Date Filter(s)
                                </th>
                                <th>
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    <asp:ListBox ID="lbDocumentType" runat="server" DataSourceID="ds_DocumentType" DataTextField="displayname"
                                        DataValueField="typeid" CssClass="entry" SelectionMode="Multiple" Rows="8"></asp:ListBox>
                                    <asp:SqlDataSource ID="ds_DocumentType" runat="server" ConnectionString="<%$ AppSettings:connectionstring %>"
                                        SelectCommand="SELECT  TypeID,DisplayName+'-'+TypeId as DisplayName, 1 [seq] FROM tblDocumentType where typeId LIKE '%M%' union select '-1', 'All', 0 order by seq,DisplayName"
                                        SelectCommandType="Text"></asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbCompany" runat="server" DataSourceID="ds_Company" DataTextField="shortconame"
                                        DataValueField="companyid" CssClass="entry" SelectionMode="Multiple" Rows="8">
                                    </asp:ListBox>
                                    <asp:SqlDataSource ID="ds_Company" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select companyid, shortconame, 1 [seq] from tblcompany union select -1, 'All', 0 order by seq, shortconame">
                                    </asp:SqlDataSource>
                                </td>
                                <td>
                                    <asp:ListBox ID="lbCreatedBy" runat="server" DataSourceID="ds_CreatedBy" DataTextField="createdby"
                                        DataValueField="userid" CssClass="entry" SelectionMode="Multiple" Rows="8"></asp:ListBox>
                                    <asp:SqlDataSource ID="ds_CreatedBy" runat="server" ConnectionString="<%$ appSettings:connectionstring %>"
                                        SelectCommandType="Text" SelectCommand="select userid,[CreatedBy] = firstname + ' ' + lastname,  1 [seq]  from tbluser where usergroupid in (select usergroupid from tblusergroup where name like '%litigation%' or usergroupid in(11,35,39,40)) and locked <> 1 union select -1, 'All', 0 order by seq, [CreatedBy]">
                                    </asp:SqlDataSource>
                                </td>
                                <td valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" class="entry2" style="color: White;">
                                        <tr style="white-space: nowrap;">
                                            <td align="right">
                                                Created:
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlQuickPickDate" runat="server" CssClass="entry2">
                                                </asp:DropDownList>
                                            </td>
                                            <td style="width: 5px;">
                                                &nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox class="entry" runat="server" ID="txtTransDate1" Width="75px">__/__/____</asp:TextBox>
                                                <ajaxToolkit:MaskedEditExtender ID="txtTransDate1_MaskedEditExtender" runat="server"
                                                    CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                                    CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                                    CultureTimePlaceholder="" Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtTransDate1">
                                                </ajaxToolkit:MaskedEditExtender>
                                            </td>
                                            <td style="width: 20px; text-align: center;">
                                                To
                                            </td>
                                            <td>
                                                <asp:TextBox class="entry" runat="server" ID="txtTransDate2" Width="75px" />
                                                <ajaxToolkit:MaskedEditExtender ID="txtTransDate2_MaskedEditExtender1" runat="server"
                                                    CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" CultureDateFormat=""
                                                    CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                                    CultureTimePlaceholder="" Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtTransDate2">
                                                </ajaxToolkit:MaskedEditExtender>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label ID="lblResults" runat="server" CssClass="results" />
                                                <br />
                                                <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                                    DisplayAfter="0">
                                                    <ProgressTemplate>
                                                        <img id="Img1" src="~/images/loading.gif" runat="server" style="vertical-align: middle" />
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>
                                <td valign="top" style="width:150px;">
                                    <table border="0" cellpadding="0" cellspacing="0" class="entry">
                                        <tr>
                                            <td>
                                                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="entry"  />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Button ID="btnExport" runat="server" Text="Export to Excel" CssClass="entry"
                                                     />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Button ID="btnZipDocs" runat="server" Text="Zip Report Documents" CssClass="entry"
                                                    />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="analysis">
                        <asp:GridView ID="gvResults" runat="server" AutoGenerateColumns="False" CellPadding="5"
                            GridLines="None" BorderStyle="None" AllowPaging="True" AllowSorting="True" DataSourceID="dsResults"
                            CssClass="entry" PageSize="15">
                            <Columns>
                                <asp:BoundField DataField="matter" SortExpression="matter" HeaderText="Matter" HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" />
                                    <HeaderStyle CssClass="headItem5" Width="50" />
                                </asp:BoundField>
                                <asp:BoundField DataField="document type" SortExpression="document type" HeaderText="Document Type"
                                    HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" Width="350" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" Width="350" />
                                </asp:BoundField>
                                <asp:BoundField DataField="createdate" SortExpression="createdate" HeaderText="Date Created"
                                    HtmlEncode="false" DataFormatString="{0:d}">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Client account number" SortExpression="Client account number"
                                    HeaderText="Client Account #" HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Creditor last 4" SortExpression="Creditor last 4" HtmlEncode="false"
                                    HeaderText="Creditor Last 4">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="creditor name" SortExpression="creditor name" HeaderText="Creditor Name"
                                    HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="state" SortExpression="state" HeaderText="State" HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="firm" SortExpression="firm" HeaderText="Firm" HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                                <asp:BoundField DataField="created by" SortExpression="created by" HeaderText="Created By"
                                    HtmlEncode="false">
                                    <ItemStyle CssClass="listItem" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="headItem5" HorizontalAlign="Left" />
                                </asp:BoundField>
                            </Columns>
                            <EmptyDataTemplate>
                                No Data.
                            </EmptyDataTemplate>
                            <PagerTemplate>
                                <div id="pager" style="background-color: #DCDCDC">
                                    <table class="entry">
                                        <tr class="entry2">
                                            <td style="padding-left: 10px;">
                                                Page
                                                <asp:DropDownList ID="ddlPageSelector" runat="server" AutoPostBack="true" CssClass="entry2" />
                                                of
                                                <asp:Label ID="lblNumber" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-right: 10px; text-align: right;">
                                                <asp:LinkButton Text="First" CommandName="Page" CommandArgument="First" runat="server"
                                                    ID="btnFirst" />
                                                <asp:LinkButton Text="Previous" CommandName="Page" CommandArgument="Prev" runat="server"
                                                    ID="btnPrevious" />
                                                -
                                                <asp:LinkButton Text="Next" CommandName="Page" CommandArgument="Next" runat="server"
                                                    ID="btnNext" />
                                                <asp:LinkButton Text="Last" CommandName="Page" CommandArgument="Last" runat="server"
                                                    ID="btnLast" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </PagerTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="dsResults" ConnectionString="<%$ AppSettings:connectionstring %>"
                            runat="server" ProviderName="System.Data.SqlClient" SelectCommand="stp_Matters_DocumentsReport"
                            SelectCommandType="StoredProcedure" CancelSelectOnNullParameter="false">
                            <SelectParameters>
                                <asp:Parameter Name="criteria" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:GridView ID="gvExport" runat="server" />
</asp:Content>
