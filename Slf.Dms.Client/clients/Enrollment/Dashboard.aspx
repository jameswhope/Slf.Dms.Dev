<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="Dashboard.aspx.vb" Inherits="Clients_Enrollment_Dashboard" %>

<%@ Register Assembly="Infragistics2.WebUI.UltraWebGrid.v8.2, Version=8.2.20082.1000, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
   
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet"  />
    <!--#include file="mgrtoolbar.inc"-->
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css")%>" rel="stylesheet" />

    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jscript/validation/IsValid.js" />
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">
        
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $("#<%=txtFromDate.ClientID %>").datepicker();
                $("#<%=txtToDate.ClientID %>").datepicker();
                $("#<%=btnFilter.ClientID %>").unbind("click").click(function() {
                    return ValidateDates();
                });
                $("#<%=btnClear.ClientID %>").unbind("click").click(function(event) {
                    event.preventDefault();
                    return ClearDates();
                });
                if ($("#<%= hdnNoTab.ClientId%>").val() == "1") {
                    $(".tabMainHolder").closest("tbody").prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                    $(".menuTable").closest("td").css('height', '0px');
                    $(".menuTable").closest("tr").css('height', '0px');
                    $(".tabMainHolder, .tabTxtHolder").closest("tr").remove();
                    $(".menuTable").remove();
                }
            });
        }

        function IsValidDate(Date) {
            return RegexValidate(Date, "(?=\\d)^(?:(?!(?:10\\D(?:0?[5-9]|1[0-4])\\D(?:1582))|(?:0?9\\D(?:0?[3-9]|1[0-3])\\D(?:1752)))((?:0?[13578]|1[02])|(?:0?[469]|11)(?!\\/31)(?!-31)(?!\\.31)|(?:0?2(?=.?(?:(?:29.(?!000[04]|(?:(?:1[^0-6]|[2468][^048]|[3579][^26])00))(?:(?:(?:\\d\\d)(?:[02468][048]|[13579][26])(?!\\x20BC))|(?:00(?:42|3[0369]|2[147]|1[258]|09)\\x20BC))))))|(?:0?2(?=.(?:(?:\\d\\D)|(?:[01]\\d)|(?:2[0-8])))))([-.\\/])(0?[1-9]|[12]\\d|3[01])\\2(?!0000)((?=(?:00(?:4[0-5]|[0-3]?\\d)\\x20BC)|(?:\\d{4}(?!\\x20BC)))\\d{4}(?:\\x20BC)?)(?:$|(?=\\x20\\d)\\x20))?((?:(?:0?[1-9]|1[012])(?::[0-5]\\d){0,2}(?:\\x20[aApP][mM]))|(?:[01]\\d|2[0-3])(?::[0-5]\\d){1,2})?$");
        }

        function Alert(message, title) {
            $("#jAlert").dialog({
                autoOpen: false,
                modal: true,
                resizable: false,
                title: title,
                buttons: {
                    Ok: function() {
                        $(this).dialog("close");
                    }
                }
            });
            $("#jAlert").empty().append('<ul><li>' + message + '</li></ul>').dialog("open");           
        }

        function ValidateDates() {

            var date1 = $("#<%=txtFromDate.ClientID %>").val();
            var date2 = $("#<%=txtToDate.ClientID %>").val();

            if ((date1.length == 0) && (date2.length == 0)) {
                return true;
            }
            
            if (!IsValidDate(date1)) {
                Alert("Please enter a valid start date.", "Invalid Date");
                return false;
            };         
            
            if (!IsValidDate(date2)) {
                Alert("Please enter a valid end date.", "Invalid Date");
                return false;
            };

            if (date1 > date2) {
                Alert("The end date must be greater or equal to the start date.", "Invalid Date")
                return false;
            }
            return true;
        }
        function ClearDates() {
            $("#<%=txtFromDate.ClientID %>").val("");
            $("#<%=txtToDate.ClientID %>").val("");
        }

        function showModalPopup(dates, statusgroup, category, vendor, productdesc, affiliatecode) {
            $get("<%=hdnDates.ClientID %>").value = dates;
            $get("<%=hdnCategory.ClientID %>").value = category;
            $get("<%=hdnStatusGroup.ClientID %>").value = statusgroup;
            $get("<%=hdnVendor.ClientID %>").value = vendor;
            $get("<%=hdnProductDesc.ClientID %>").value = productdesc;
            $get("<%=hdnAffiliateCode.ClientID %>").value = affiliatecode;
            document.getElementById("<%=lnkLoadLeads.ClientID %>").click();
            $find("<%=ModalPopupExtender1.ClientID %>").show();
        }

        function checkAll() {
            document.getElementById("<%=lnkCheckAll.ClientID %>").click();
        }

        function ToggleFilter() {
            var lnk = $get("<%=lnkFilter.ClientID %>");
            var dvFilter = $get("<%=dvFilter.ClientID %>");
            var hdnFilter = $get("<%=hdnFilter.ClientID %>");
            if (hdnFilter.value == '0') {
                dvFilter.style.display = "inline";
                lnk.innerHTML = 'Remove  Filter';
                hdnFilter.value = '1';
            } else {
                dvFilter.style.display = "none";
                lnk.innerHTML = 'Add Filter';
                hdnFilter.value = '0';
                $get("<%=btnFilter.ClientID %>").click();
            }
            
            return false;
        }
    
    </script>

    <style type="text/css">
        .ui-widget 
        {
       	font-size: 11px;
       	}

        .modalBackgroundTracker
        {
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }
        .modalPopupTracker
        {
            background-color: #ffffff;
            border-width: 3px;
            border-style: solid;
            border-color: Gray;
            padding: 3px;
            width: 97%;
            height: 600px;
            overflow: auto;
        }
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
            white-space: nowrap; 
        }
        .headItem a
        {
            font-family: Tahoma;
            font-size: 11px;
            font-weight: normal;
            text-align: left;
            color: #000000;
            text-decoration: none; 
        }
        .sortHeader
        {
        	background-image: url(<%= ResolveUrl("~/jquery/css/redmond/images/ui-icons_217bc0_256x240.png") %>);
        	background-repeat: no-repeat;
        	width: 16px; 
        	height: 16px;
        	display: inline;
        }
        
        .sortHeaderAsc
        {
        	background-position: 0 0;
        }
        
        .sortHeaderDesc
        {
            background-position: -64px 0;
        }
        .ui-dialog .ui-dialog-buttonpane { text-align: center; border: 0;}
        .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset  { float: none; }
        
        #jAlert ul 
        {
            list-style: none;
        }
        
        #jAlert li 
        {
            margin: 20 0 20 0;
            padding: 3% 0 17 0;
            padding-left: 40px;
            background-image: url(<%= ResolveUrl("~/images/error.png") %>);
            background-repeat: no-repeat;
            background-position: left 0;  
            font-size: 11px;
        }
               
    </style>
    <div id="jAlert" style="display:none;" ></div>
    <div style="margin: 5px">
       <div style="padding:5px; margin: 5px;">
            <div id="dvFilter" style="padding:5px; border: solid 1px #C0C0C0; margin: 5px; display: none;" runat="server"  >
            <asp:Label ID="lblFromDate" runat="server" Text="From:" /> 
            <asp:TextBox ID="txtFromDate" runat="server" CssClass="entry2" style="width: 60px;" />          
            <asp:Label ID="lblToDate" runat="server" Text="To:" /> 
            <asp:TextBox ID="txtToDate" runat="server" CssClass="entry2" style="width: 60px;"/>
            <asp:Button ID="btnFilter" Text="Apply" runat="server" />
            <asp:Button ID="btnClear" Text="Clear" runat="server" />
        </div>
        <asp:LinkButton ID="lnkFilter" runat="server" Text="Add Filter" onClientClick = " return ToggleFilter();" Visible="False"/>
        <asp:HiddenField ID="hdnFilter" Value="1" runat="server" />
     </div>
        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server">
            <Bands>
                <igtbl:UltraGridBand>
                    <AddNewRow View="NotSet" Visible="NotSet">
                    </AddNewRow>
                </igtbl:UltraGridBand>
            </Bands>
            <DisplayLayout AllowSortingDefault="No" AllowColSizingDefault="NotSet" AllowColumnMovingDefault="None"
                AllowDeleteDefault="No" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                HeaderClickActionDefault="Select" Name="UltraWebGrid1" RowHeightDefault="20px"
                RowSelectorsDefault="No" SelectTypeRowDefault="Extended" StationaryMargins="Header"
                StationaryMarginsOutlookGroupBy="True" TableLayout="Fixed" Version="4.00" ViewType="OutlookGroupBy">
                <FrameStyle BackColor="Window" BorderColor="InactiveCaption" BorderStyle="Solid"
                    BorderWidth="0px" Font-Names="Tahoma" Font-Size="11px" Height="600px" Width="1230px">
                </FrameStyle>
                <HeaderStyleDefault BackColor="LightGray" BorderStyle="Solid" HorizontalAlign="Left">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </HeaderStyleDefault>
                <RowStyleDefault BackColor="Window" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                    Font-Names="Tahoma" Font-Size="11px">
                    <Padding Left="3px" />
                    <BorderDetails ColorLeft="Window" ColorTop="Window" />
                </RowStyleDefault>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
    </div>
    
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalPopupTracker">
        <table width="100%">
            <tr>
                <td>
                    <asp:LinkButton ID="btnClose" runat="server" CssClass="lnk"><img src='../../images/16x16_close.png' align='absmiddle' border='0'> Close</asp:LinkButton>&nbsp;|&nbsp;
                    <asp:LinkButton ID="lnkExport" runat="server" CssClass="lnk"><img src='../../images/16x16_file_new.png' align='absmiddle' border='0'> Export</asp:LinkButton>
                </td>
            </tr>
        </table>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <table width="100%">
                    <tr>
                        <td>
                            <asp:Label ID="lblFilters" runat="server" CssClass="entry2"></asp:Label>
                        </td>
                        <td align="right" class="entry2">
                            Refund
                            <asp:TextBox ID="txtRefundCount" runat="server" Text="0" CssClass="entry2" MaxLength="3"
                                Width="30px"></asp:TextBox> of these leads. <asp:LinkButton ID="lnkRefund" runat="server" CssClass="lnk">Refund</asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField ID="hdnSortField" runat="server" Value=""/>
                            <asp:HiddenField ID="hdnSortDirection" runat="server" Value=""/> 
                            <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="false" CellPadding="3"
                                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                                DataKeyNames="leadapplicantid" >
                                <Columns>
                                    <asp:TemplateField ItemStyle-Width="16px">
                                        <HeaderTemplate>
                                            <a href="javascript:checkAll();">
                                                <img id="imgCheckAll" runat="server" src="~/images/11x11_uncheckall.png" border="0" />
                                            </a>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkLead" runat="server" CssClass="entry2" Checked="true" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="headItem" />
                                        <ItemStyle CssClass="creditor-item" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Lead ID" DataField="rgrid" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" />
                                    <asp:TemplateField HeaderText="Lead" SortExpression="fullname"  >
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortFullName" CommandName="Sort" CommandArgument="FullName" runat="server" Text="Lead"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("fullname")%>
                                        </ItemTemplate>
                                    </asp:TemplateField> 
                                    <asp:TemplateField HeaderText="Phone" SortExpression="leadphone"  >
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortleadphone" CommandName="Sort" CommandArgument="leadphone" runat="server" Text="Phone"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("leadphone")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Email" SortExpression="Email"  >
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortEmail" CommandName="Sort" CommandArgument="Email" runat="server" Text="Email"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("Email")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>       
                                    <asp:TemplateField HeaderText="Product" SortExpression="productcode">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortproductcode" CommandName="Sort" CommandArgument="productcode" runat="server" Text="Product"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("productcode")%>
                                        </ItemTemplate>
                                    </asp:TemplateField> 
                                    <asp:TemplateField HeaderText="Affiliate" SortExpression="affiliatecode">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortaffiliatecode" CommandName="Sort" CommandArgument="affiliatecode" runat="server" Text="Affiliate"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("affiliatecode")%>
                                        </ItemTemplate>
                                    </asp:TemplateField> 
                                    <asp:TemplateField HeaderText="Status" SortExpression="status">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortStatus" CommandName="Sort" CommandArgument="Status" runat="server" Text="Status"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("status")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Reason" SortExpression="Reason">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortReason" CommandName="Sort" CommandArgument="Reason" runat="server" Text="Reason"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("Reason")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Rep" SortExpression="Rep">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortRep" CommandName="Sort" CommandArgument="Rep" runat="server" Text="Rep"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("Rep")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="IP" SortExpression="remoteaddr">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortremoteaddr" CommandName="Sort" CommandArgument="remoteaddr" runat="server" Text="IP"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("remoteaddr")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Created" SortExpression="Created">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortCreated" CommandName="Sort" CommandArgument="Created" runat="server" Text="Created"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("created")%>
                                        </ItemTemplate>
                                    </asp:TemplateField> 
                                    <asp:TemplateField HeaderText="First Call Attempt" SortExpression="firstcallmade">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortfirstcallmade" CommandName="Sort" CommandArgument="firstcallmade" runat="server" Text="First Call Attempt"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("firstcallmade")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>     
                                    <asp:TemplateField HeaderText="Timespan" SortExpression="minutes">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortminutes" CommandName="Sort" CommandArgument="minutes" runat="server" Text="Timespan"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("minutes")%>
                                        </ItemTemplate>
                                    </asp:TemplateField> 
                                    <asp:TemplateField HeaderText="Calls Made" SortExpression="callsmade">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" HorizontalAlign="center" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortcallsmade" CommandName="Sort" CommandArgument="callsmade" runat="server" Text="Calls Made"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("callsmade")%>
                                        </ItemTemplate>
                                    </asp:TemplateField> 
                                    <asp:BoundField HeaderText="Last Note" DataField="lastnote" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" ItemStyle-Wrap="true" ItemStyle-Width="200px" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    <asp:Button ID="dummyButton" runat="server" Text="Button" Style="display: none" />
    <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="dummyButton"
        PopupControlID="pnlPopup" CancelControlID="btnClose" BackgroundCssClass="modalBackgroundTracker"
        RepositionMode="RepositionOnWindowResize">
    </ajaxToolkit:ModalPopupExtender>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <asp:LinkButton ID="lnkLoadLeads" runat="server"></asp:LinkButton>
            <asp:LinkButton ID="lnkCheckAll" runat="server"></asp:LinkButton>
            <asp:HiddenField ID="hdnDates" runat="server" />
            <asp:HiddenField ID="hdnCategory" runat="server" />
            <asp:HiddenField ID="hdnStatusGroup" runat="server" />
            <asp:HiddenField ID="hdnVendor" runat="server" />
            <asp:HiddenField ID="hdnProductDesc" runat="server" />
            <asp:HiddenField ID="hdnAffiliateCode" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
