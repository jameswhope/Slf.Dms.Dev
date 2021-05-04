﻿<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false"
    CodeFile="DashboardAgencyWC.aspx.vb" Inherits="Clients_Enrollment_DashboardAgencyJQ" %>
   
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet"  />
    <!--#include file="mgrtoolbar.inc"-->
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="Server">
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/redmond/jquery-ui-1.9.0.custom.css")%>" rel="stylesheet" />
    <link type="text/css" href="<%= ResolveUrl("~/jquery/css/jquery.treetable.css")%>" rel="stylesheet"  />
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jscript/validation/IsValid.js" />
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery.treetable.js" />  
        </Scripts>
    </asp:ScriptManager>

    <script type="text/javascript">
        
        function pageLoad() {
            docReady();
        }

        function docReady() {
            $(document).ready(function() {
                $("#progressbar").show();

                $("#tbtree").treetable({ expandable: true });
                $("#tbtree").removeClass("rawtb").addClass("jqtb");

                $("#<%=txtFromDate.ClientID %>").datepicker();
                $("#<%=txtToDate.ClientID %>").datepicker();
                $("#<%=btnFilter.ClientID %>").button();
                $("#<%=btnClear.ClientID %>").button();
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

                $("#progressbar").hide();

                $("#dvPopup").dialog({ autoOpen: false, 
                    width: "95%", height: "600",
                    open: function(type, data) { $(this).parent().appendTo("form"); },
                    position: { my: "center top", at: "center top", of: $("#dvFilter") },
                    modal: true,
                    resizable: false,
                    title: $("#<%=lblFilters.ClientID %>").val()
                });
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
                        $(this).dialog("close");                    }
                }
            });
            
            $("#jAlert").empty().append('<ul><li>' + message + '</li></ul>').dialog("open");           
        }

        function ValidateDates() {

            var date1 = $("#<%=txtFromDate.ClientID %>").val();
            var date2 = $("#<%=txtToDate.ClientID %>").val();

            if ((date1.length == 0) && (date2.length == 0)) {
                $("#progressbar").show();
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

            $("#progressbar").show();
            return true;
        }
        function ClearDates() {
            $("#<%=txtFromDate.ClientID %>").val("");
            $("#<%=txtToDate.ClientID %>").val("");
        }

        function showModalPopup(dates, statusgroup, vendor, rep) {
            $("#<%=hdnDates.ClientID %>").val(dates);
            $("#<%=hdnStatusGroup.ClientID %>").val(statusgroup);
            $("#<%=hdnVendor.ClientID %>").val(vendor);
            $("#<%=hdnRep.ClientID %>").val(rep);
            document.getElementById("<%=lnkLoadLeads.ClientID %>").click();
            $("#progressbar").show();
        }

        function ModalPopupCompleted() { 
            $("#dvPopup").dialog("open");
            $("#progressbar").hide();
        }
        
    
    </script>

    <style type="text/css">
        .ui-widget
        {
            font-size: 11px;
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
        .ui-dialog .ui-dialog-buttonpane
        {
            text-align: center;
            border: 0;
        }
        .ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset
        {
            float: none;
        }
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
        input.ui-button
        {
            filter: chroma(color=#000000);
        }
        fieldset
        {
            padding: 5px;
            width: 300px;
            white-space: nowrap;
        }
        fieldset legend
        {
            color: #777777;
        }
        fieldset input
        {
            vertical-align: middle;
        }
        #progressbar
        {
            position: absolute;
            padding: 5px; 
        }
        .rawtb { display: none; }
        .jqtb { display: block; }
        .modalPopupTracker
        {
            width: 99%;
            height: 600px;
            overflow: auto;
            padding-right: 10px; 
        }
        #dvPopup{overflow: hidden;}
    </style>
    <div id="jAlert" style="display:none;" ></div>
     <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div>
                 <div id="dvFilter" style="padding:5px; margin-left: 5px;">
                    <fieldset>
                        <legend>Filter</legend>
                        <asp:Label ID="lblFromDate" runat="server" Text="From:" /> 
                        <asp:TextBox ID="txtFromDate" runat="server" CssClass="entry2" style="width: 62px;" />          
                        <asp:Label ID="lblToDate" runat="server" Text="To:" /> 
                        <asp:TextBox ID="txtToDate" runat="server" CssClass="entry2" style="width: 62px;"/>&nbsp;
                        <asp:Button ID="btnFilter" Text="Apply" runat="server" />
                        <asp:Button ID="btnClear" Text="Clear" runat="server" />
                        <asp:HiddenField ID="hdnFilter" Value="1" runat="server" />
                    </fieldset>
                     <div id="progressbar">
                        <img src="<%=ResolveUrl("~/images/ajax-loader.gif") %>" />
                     </div>
                 </div>
                 <div id="dvTree" style="width: 100%; margin-right: 20px; padding-right: 20px;">
                    <asp:Literal ID="ltrTree" runat="server"></asp:Literal>
                 </div>
            </div>
            <asp:HiddenField ID="hdnDates" runat="server" />
            <asp:HiddenField ID="hdnStatusGroup" runat="server" />
            <asp:HiddenField ID="hdnVendor" runat="server" />
            <asp:HiddenField ID="hdnRep" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
        <div id="dvPopup" >
            <div class="modalPopupTracker" >
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" >
            <ContentTemplate>
                
                <table width="100%">
                    <tr>
                        <td>
                            <asp:LinkButton ID="lnkExport" runat="server" CssClass="lnk" ><img src='../../images/16x16_file_new.png' align='absmiddle' border='0'> Export</asp:LinkButton>
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <asp:HiddenField id="lblFilters" runat="server" />
                            <asp:LinkButton ID="lnkLoadLeads" runat="server"></asp:LinkButton>
                            <input id="hdnSortField" type="hidden" runat="server"/> 
                            <input id="hdnSortDirection" type="hidden" runat="server"/>
                            <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="false" CellPadding="3"
                                Width="100%" GridLines="None" ShowHeader="True" BorderStyle="None" Visible="true"
                                DataKeyNames="leadapplicantid" >
                                <Columns>
                                    <asp:BoundField HeaderText="Lead ID" DataField="rgrid" ItemStyle-CssClass="creditor-item"
                                        HeaderStyle-CssClass="headItem" Visible="false" />
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
                                    <asp:TemplateField HeaderText="First Deposit" SortExpression="FirstDepositDate">
                                        <HeaderStyle CssClass="headItem" /> 
                                        <ItemStyle CssClass="creditor-item" /> 
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="dvSortFirstDepositDate" CommandName="Sort" CommandArgument="FirstDepositDate" runat="server" Text="First Deposit"></asp:LinkButton>   
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("firstdepositdate", "{0:d}")%>
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
            <Triggers>
                <asp:PostBackTrigger ControlID ="lnkExport" />
            </Triggers> 
            </asp:UpdatePanel>
        </div>
        </div>
  
</asp:Content>
