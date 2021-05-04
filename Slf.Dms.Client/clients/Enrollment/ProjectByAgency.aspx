<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ProjectByAgency.aspx.vb" Inherits="Clients_Enrollment_BoydMockup" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMenu" Runat="Server">
<link href='<%= ResolveUrl(GlobalFiles.JQuery.CSS) %>' rel="stylesheet" type="text/css" />
<link type="text/css" href="<%= ResolveUrl("~/css/default.css")%>" rel="stylesheet" />
<link type="text/css" href="<%= ResolveUrl("~/mobile/css/mobile.css")%>" rel="stylesheet"  />
    <style type="text/css"  >
        .headitem5 {background-color: #C0C0C0 !Important; width: 60px; }
        .footitem  {background-color: #C0C0C0 !Important; font-weight: bold; width: 60px; padding: 7 0 7 0;}
        .sortasc {background-image:  url(../../images/sort-asc.png); background-position: 90%; background-repeat:no-repeat;}
        .sortdesc {background-image:  url(../../images/sort-desc.png); background-position: 90%; background-repeat:no-repeat;}
        .headitem5 a { font-weight: bold !Important;}
        .griditemalt { background-color: #DCDCDC; }
        .griditem2 {width: 60px;}
        .emptyrow td{
            text-align: center;
            font-size: 1.1em;
            font-weight: bold;
            padding: 20px 0 20px 0;
            background-color: #FFFFCC;
        }
        .dvFilter{ margin: 20px 0 3px 5px; font-size: 11px; font-weight: bold;}
    </style>
     <script type="text/javascript">
     
        //initial jquery stuff
        var sURL = unescape(window.location.pathname);
        
        function SetDates(ddl) {
            var txtDate1 = document.getElementById("<%=txtDate1.ClientId %>");
            var txtDate2 = document.getElementById("<%=txtDate2.ClientId %>");
            var imgDate1 = document.getElementById("<%=imgDate1.ClientId %>");
            var imgDate2 = document.getElementById("<%=imgDate2.ClientId %>");
            var ddlMonthYear1 = document.getElementById("<%=ddlMonthYear1.ClientId %>");
            var ddlMonthYear2 = document.getElementById("<%=ddlMonthYear2.ClientId  %>");
            
            var str = ddl.value;
            if (str != "Custom") {
                var parts = str.split(",");
                txtDate1.value = parts[0];
                txtDate2.value = parts[1];
            }
                     
            if (ddl.options[ddl.selectedIndex].text == "By Month") {
                txtDate1.style.display = "none";
                txtDate2.style.display = "none";
                imgDate1.style.display = "none";
                imgDate2.style.display = "none";
                ddlMonthYear1.style.display = "inline";
                ddlMonthYear2.style.display = "inline";
            }else{
                txtDate1.style.display = "inline";
                txtDate2.style.display = "inline";
                imgDate1.style.display = "inline";
                imgDate2.style.display = "inline";
                ddlMonthYear1.style.display = "none";
                ddlMonthYear2.style.display = "none";
            }
            
        }

        function pageLoad() {
            docReady();
        }
        function docReady() {
            $(document).ready(function() {
                $(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
			        .find(".portlet-header")
				        .addClass("ui-widget-header ui-corner-all")
				        .end()
			        .find(".portlet-content");
                $(".jqFilterButton").button();
                $(".jqExportButton").button();
                $(".jqExportButton").click(function(){Export();});
                
                if ($("#<%= hdnNoTab.ClientId%>").val() == "1"){
                    $(".tabMainHolder").closest('tbody').prepend('<tr><td style="height: 26px;"><div class="toolbar"><a href="<%=ResolveUrl("~/mobile/")%>home.aspx" class="backButton">back</a></div></td></tr>');
                    $(".menuTable").closest('td').css('height','0px');
                    $(".menuTable").closest('tr').css('height','0px');
                    $(".tabMainHolder, .tabTxtHolder").closest('tr').remove();
                    $(".menuTable").remove();
               }
            });
        } 
        
        function Export(){
            <%= Page.ClientScript.GetPostBackEventReference(lnkExport, Nothing) %>;
            return false;
        }
        
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="~/jquery/jquery-1.7.2.min.js" />
            <asp:ScriptReference Path="~/jquery/jquery-ui-1.9.0.custom.min.js" />
        </Scripts>
    </asp:ScriptManager>
    <table cellpadding="0" cellspacing="0" class="menuTable">
        <tr>
            <td>
                <img id="Img1" runat="server" width="8" height="1" src="~/images/spacer.gif" />
            </td>
            <td style="height: 28px; white-space: nowrap">
                <a id="A1" runat="server" class="menuButton" href="default.aspx">
                    <img id="Img2" runat="server" align="absmiddle" border="0" class="menuButtonImage"
                        src="~/images/16x16_back.png" />Reports</a>
            </td>
            <td style="width: 100%">
                &nbsp;
            </td>
        </tr>
    </table>
    <input id="hdnNotab" name="hdnnotab" type="hidden" value="" runat="server" /> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
     <asp:UpdatePanel ID="upPage" runat="server">
        <ContentTemplate>
            <div style="float: left; margin: 5 0 0 5; color: #808080;">
                <h4>Revenue By Agency</h4>
            </div>
            <div style="float: right; padding: 0px 3px 3px 3px">
                <table>
                    <tr>
                        <td>
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upPage">
                                <ProgressTemplate>
                                    <img id="Img1" src="~/images/loading.gif" alt="Loading.." runat="server" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </td>
<%--                        <td>
                            <asp:CheckBox ID="chkExcludeReferals" runat="server" Text="Exclude CID" AutoPostBack="True" /> 
                        </td> --%>                       
                        <td>
                            <asp:DropDownList ID="ddlQuickPickDate" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td style="white-space: nowrap">
                            <asp:TextBox ID="txtDate1" runat="server" Size="8" MaxLength="10"></asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate1" ImageUrl="~/images/16x16_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><asp:CalendarExtender ID="CalendarExtender1" runat="server"
                                    TargetControlID="txtDate1" 
                                    PopupButtonID="imgDate1" /><asp:DropDownList ID="ddlMonthYear1" runat="server">
                                    </asp:DropDownList>&nbsp;-&nbsp;<asp:TextBox ID="txtDate2" runat="server" MaxLength="10" Size="8">
                                    </asp:TextBox><asp:ImageButton
                                runat="Server" ID="imgDate2" ImageUrl="~/images/16x16_calendar.png" AlternateText=""
                                ImageAlign="AbsMiddle" /><asp:CalendarExtender ID="CalendarExtender2" runat="server"
                                    TargetControlID="txtDate2" 
                                    PopupButtonID="imgDate2" /><asp:DropDownList ID="ddlMonthYear2" runat="server">
                                    </asp:DropDownList>&nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlAgency" runat="server" OnSelectedIndexChanged="ddlAgency_SelectedIndexChanged" AutoPostBack="True">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlUser" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                             <small>
                                <asp:Button ID="btnFilter" runat="server" Text="Filter" Font-Size="8pt" CssClass="jqFilterButton" />
                                <asp:Button ID="btnExport" runat="server" Text="Export" Font-Size="8pt" CssClass="jqExportButton"  />
                            </small>
                        </td>                      
                    </tr>
                </table> 
            </div>
            <div style="clear: both">
            </div>
            <div class="portlet">                
                    <div class="portlet-content">
                        <asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="False" 
                        Width="100%" BorderStyle="None" BorderWidth="0px" CellPadding="3" CellSpacing="0" ForeColor="Black"
                        GridLines="None" AllowSorting="True" AlternatingRowStyle-CssClass="griditemalt" EmptyDataText="No Data Found" EmptyDataRowStyle-CssClass="emptyrow"  ShowFooter="True">
                        <Columns>
                            <asp:BoundField DataField="Sub-Servicer" HeaderText="Sub-Servicer" HtmlEncode="false">
                                <HeaderStyle HorizontalAlign="left" CssClass="headitem5" Width="200px"/>
                                <ItemStyle HorizontalAlign="left" CssClass="griditem" Width="200px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 1" HeaderText="Month 1" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 2" HeaderText="Month 2" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 3" HeaderText="Month 3" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 4" HeaderText="Month 4" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 5" HeaderText="Month 5" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 6" HeaderText="Month 6" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 7" HeaderText="Month 7" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 8" HeaderText="Month 8" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" /> 
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 9" HeaderText="Month 9" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 10" HeaderText="Month 10" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                             
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 11" HeaderText="Month 11" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                          
                            </asp:BoundField>
                            <asp:BoundField DataField="Month 12" HeaderText="Month 12" HtmlEncode="false" dataformatstring="{0:c}">
                                <HeaderStyle HorizontalAlign="right" CssClass="headitem5" Width="120px" />
                                <ItemStyle HorizontalAlign="right" CssClass="griditem" Width="120px" />
                                <FooterStyle CssClass="footitem" />                          
                            </asp:BoundField>                            
                        </Columns>
                    </asp:GridView>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID ="lnkExport"/>
        </Triggers> 
    </asp:UpdatePanel>
     <asp:LinkButton ID="lnkExport" runat="server"></asp:LinkButton>
     <asp:HiddenField id="hdnAgencies" runat="server"/>
     <asp:HiddenField id="hdnUsers" runat="server"/>
</asp:Content>

